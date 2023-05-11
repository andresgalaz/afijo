import logging
import csv

from datetime import datetime

from django import forms
from django.contrib.auth.mixins import LoginRequiredMixin
from django.db.models import Sum, Count, Min, Max, F, Q
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
            filters['periodo__lt'] = datetime.strptime(prmPeriodo,
                                                       '%Y-%m').date()
            # filters['periodo__month'] = prmPeriodo[-2:]
            print('querysetWrap v2', prmPeriodo,
                  datetime.strptime(prmPeriodo, '%Y-%m').date())

        if len(filters) == 0:
            # Genera una salida vacía, se debe seleccionar planta
            return ActivoDepreciacion.objects.filter(periodo__year=1900)

        resp=  ActivoDepreciacion.objects.filter(Q(**filters)) \
            .values('planta__nombre','planta__ubicacion','activo__tipoActivo','activo__id','activo__nombre' \
                    , 'activo__proveedor','activo__fecha_ingreso','planta__fecha_depreciacion', 'planta__fecha_termino','activo__valor') \
            .annotate(periodo=Max('periodo'), duracion_real=Min('duracion_real'),valor_depreciacion=Sum('valor_depreciacion'),valor_contable=Min('valor_contable')) \
            .order_by('-activo__fecha_ingreso', 'activo__tipoActivo')
        print('Count:', len(resp))
        return resp

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
            'Planta ID', 'PLanta Nombre', 'Activo', 'Tipo', 'Proveedor',
            'Fecha Ingreso', 'Fecha Depreciación', 'Fecha Termino', 'Duración',
            'Valor de Origen', 'Valor Contable', 'Depreciacion Mensual'
        ])

        for fila in qrySet:
            writer.writerow([
                fila['planta__nombre'],
                fila['planta__ubicacion'],
                fila['activo__nombre'],
                fila['activo__tipoActivo'],
                fila['activo__proveedor'],
                fila['activo__fecha_ingreso'],
                fila['planta__fecha_depreciacion'],
                fila['planta__fecha_termino'],
                fila['duracion_real'],
                fila['activo__valor'],
                fila['valor_contable'],
                fila['valor_depreciacion'],
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
