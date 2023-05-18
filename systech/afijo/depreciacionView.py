import logging
import csv

from datetime import datetime
from dateutil.relativedelta import relativedelta

from django import forms
from django.contrib.auth.mixins import LoginRequiredMixin
from django.db.models import Sum, Count, Min, Max, F, Q, Value, CharField
from django.db.models.functions import Extract
from django.db.models.functions.datetime import ExtractMonth, ExtractYear
from django.db.models.query import QuerySet
from django.http import HttpResponse
from django.views import generic
from django.views.generic.edit import FormMixin
from django.views.generic.list import ListView

from .models import Activo, Planta, ActivoDepreciacion
from .forms import PlantaForm

logger = logging.getLogger(__name__)


class DateInput(forms.DateInput):
    input_type = 'date'


class DepreciacionFilterForm(forms.Form):
    periodo = forms.DateField(label='Periodo',
                              required=True,
                              widget=forms.DateInput(attrs={
                                  'type': 'date',
                                  'class': 'form-select'
                              }))

    data = [(None, 'Todas')]
    for r in Planta.objects.all().order_by('nombre'):
        data.append((r.id, r.nombre + ' ' + r.ubicacion.split(',')[-1] + ', ' +
                     r.region.nombre))
    planta = forms.ChoiceField(
        choices=data,
        label='Planta',
        required=True,
        widget=forms.Select(attrs={'class': 'form-select'}))

    listFull = forms.BooleanField(
        label='Completo',
        required=False,
        widget=forms.CheckboxInput(attrs={'class': 'form-select'}))

    class Meta:
        fields = [
            'periodo',
            'planta',
            'listFull',
        ]


class DepreciacionAcumFilterForm(forms.Form):
    data = [(None, 'Todas')]
    for r in Planta.objects.all().order_by('nombre'):
        data.append((r.id, r.nombre + ' ' + r.ubicacion.split(',')[-1] + ', ' +
                     r.region.nombre))
    planta = forms.ChoiceField(
        choices=data,
        label='Planta',
        required=False,
        widget=forms.Select(attrs={'class': 'form-select'}))

    data = []
    for r in ActivoDepreciacion.objects.annotate(
            year=ExtractYear('periodo')).annotate(
                mes=ExtractMonth('periodo')).values('year', 'mes').order_by(
                    'year', 'mes').distinct().order_by('-year', '-mes'):
        cPeriodo = str(r['year']) + '-' + str(r['mes']).zfill(2)
        data.append((cPeriodo, cPeriodo))
    periodo = forms.ChoiceField(
        choices=data,
        label='Periodo',
        required=True,
        widget=forms.Select(attrs={'class': 'form-select'}))

    class Meta:
        fields = [
            'periodo',
            'planta',
        ]


class DepreciacionAcumView(FormMixin, ListView):
    model = ActivoDepreciacion
    template_name = 'afijo/depreciacionAcum.html'
    paginate_by = 50
    form_class = DepreciacionAcumFilterForm
    context_object_name = 'depreciacion_list'

    def dispatch(self, request, *args, **kwargs):
        # if not request.user.has_perm('derivado.indicador_list'):
        #    return redirect(reverse_lazy('home'))
        return super(DepreciacionAcumView,
                     self).dispatch(request, *args, **kwargs)

    def get_context_data(self, **kwargs):
        context = super(DepreciacionAcumView, self).get_context_data(**kwargs)
        context['form'] = DepreciacionAcumFilterForm(self.request.GET)
        return context

    def querysetWrap(self, prmPlanta, prmPeriodo):
        print('querysetWrap v2', prmPlanta, '-', prmPeriodo)
        # prepare filters to apply to queryset
        filters = {}
        if prmPlanta:
            filters['planta'] = Planta.objects.get(id=int(prmPlanta))
        if prmPeriodo:
            dPeriodo = datetime.strptime(prmPeriodo, '%Y-%m').date()
            # filters['periodo__lt'] = dPeriodo + relativedelta(months=1)
            filters['periodo__lt'] = dPeriodo + relativedelta(months=1)
            print('querySetWrap periodo__lt', dPeriodo, filters['periodo__lt'])

        if len(filters) == 0:
            # Genera una salida vacía, se debe seleccionar planta
            return ActivoDepreciacion.objects.filter(periodo__year=1900)

        resp = ActivoDepreciacion.objects.filter(Q(**filters)) \
            .values('planta__nombre','planta__ubicacion','planta__fecha_inicio', 'planta__fecha_termino', \
                    'activo__tipoActivo','activo__id','activo__nombre','activo__numero_factura', \
                    'activo__proveedor','activo__fecha_ingreso','planta__fecha_depreciacion','activo__valor', \
                    'valor_depreciacion', 'acum_total', 'acum_anual','duracion_real' \
                    ) \
            .annotate( visible=Value('1',output_field=CharField()), \
                      dep_acum = F('acum_total') - F('acum_anual'), \
                      neto = F('activo__valor') - F('acum_total'), \
                      ) \
            .order_by('activo__id','-periodo')

        # Solo deja el primer registro de cada activo__id
        i = 0
        while i < len(resp):
            activoId = resp[i]['activo__id']
            i += 1
            while i < len(resp) and activoId == resp[i]['activo__id']:
                resp[i]['visible'] = '0'
                i += 1

        respUniqe = [s for s in resp if s['visible'] == '1']
        print('respUniqe:', len(respUniqe))
        return respUniqe

    def get_queryset(self):
        print('get_queryset')
        return self.querysetWrap(self.request.GET.get('planta'),
                                 self.request.GET.get('periodo'))

    def toCSV(request):
        qrySet = DepreciacionAcumView.querysetWrap(None,
                                                   request.GET.get('planta'),
                                                   request.GET.get('periodo'))
        # Create the HttpResponse object with the appropriate CSV header.
        response = HttpResponse(content_type='text/csv')
        response[
            'Content-Disposition'] = 'attachment; filename="deprec_plantas.csv"'

        writer = csv.writer(response, delimiter=';')
        writer.writerow([
            'Id.Activo',
            'Rubro',
            'Descripción',
            'Proveedor',
            'Factura',
            'Planta ID',
            'Planta Nombre',
            'Fecha Compra',
            'Fecha Adj. Concesión',
            'Fecha Dep. Definitiva',
            'Fecha Termino Dep.',
            'Vida Útil Proy.',
            'Valor Adquisición',
            'Dep. Acumulada',
            'Dep. Ejercicio',
            'Dep. Total',
            'Neto',
        ])
        for fila in qrySet:
            writer.writerow([
                fila['activo__id'],
                dict(Activo.TipoActivo)[fila['activo__tipoActivo']],
                fila['activo__nombre'].replace('\n', ' '),
                fila['activo__proveedor'].replace('\n', ' '),
                fila['activo__numero_factura'].replace('\n', ' '),
                fila['planta__nombre'],
                fila['planta__ubicacion'],
                fila['activo__fecha_ingreso'],
                fila['planta__fecha_inicio'],
                fila['planta__fecha_depreciacion'],
                fila['planta__fecha_termino'],
                fila['duracion_real'],
                fila['activo__valor'],
                fila['dep_acum'],
                fila['acum_anual'],
                fila['acum_total'],
                fila['neto'],
            ])
        return response


class DepreciacionListView(FormMixin, ListView):
    model = ActivoDepreciacion
    template_name = 'afijo/depreciacionList.html'
    paginate_by = 50
    form_class = DepreciacionFilterForm
    context_object_name = 'depreciacion_list'

    def dispatch(self, request, *args, **kwargs):
        # if not request.user.has_perm('derivado.indicador_list'):
        #    return redirect(reverse_lazy('home'))
        return super(DepreciacionListView,
                     self).dispatch(request, *args, **kwargs)

    def get_context_data(self, **kwargs):
        context = super(DepreciacionListView, self).get_context_data(**kwargs)
        context['form'] = DepreciacionFilterForm(self.request.GET)
        return context

    def querysetWrap(self, prmPlanta, prmPeriodo):
        # prepare filters to apply to queryset
        filters = {}
        if prmPlanta:
            filters['planta'] = Planta.objects.get(id=int(prmPlanta))
        if prmPeriodo:
            filters['periodo__year'] = prmPeriodo[:4]
            filters['periodo__month'] = prmPeriodo[-2:]

        if len(filters) == 0:
            # Genera una salida vacía, se debe seleccionar planta
            return ActivoDepreciacion.objects.filter(periodo__year=1900)

        return ActivoDepreciacion.objects.filter(Q(**filters)).order_by(
            '-activo__fecha_ingreso', 'activo__tipoActivo')

    def get_queryset(self):
        return self.querysetWrap(self.request.GET.get('planta'),
                                 self.request.GET.get('periodo'))

    def toCSV(request):
        qrySet = DepreciacionListView.querysetWrap(None,
                                                   request.GET.get('planta'),
                                                   request.GET.get('periodo'))
        # Create the HttpResponse object with the appropriate CSV header.
        response = HttpResponse(content_type='text/csv')
        response[
            'Content-Disposition'] = 'attachment; filename="deprec_plantas.csv"'

        writer = csv.writer(response, delimiter=';')
        writer.writerow([
            'Tipo', 'Nombre', 'Nro', 'Ubicacion', 'Factura', 'Fecha Ingreso',
            'Fecha Inicio', 'Fecha Termino', 'Clase Vida', 'Vida Util',
            'Valor de Origen', 'Valor Contable', 'Depreciacion'
        ])

        for fila in qrySet:
            writer.writerow([
                fila.activo.getTipoActivo(),
                fila.activo.nombre,
                fila.activo.numero_interno,
                fila.activo.ubicacion,
                fila.activo.proveedor,
                fila.activo.fecha_ingreso,
                fila.planta.fecha_depreciacion,
                fila.planta.fecha_termino,
                fila.activo.duracion_clase,
                fila.duracion_real,
                fila.activo.valor,
                fila.valor_contable,
                fila.valor_depreciacion,
            ])
        return response
