import logging
import csv

from datetime import datetime
from dateutil.relativedelta import relativedelta

from django import forms
from django.db.models import Q  # Case, When, Sum, Count, Min, Max, F, Value, CharField
from django.db.models.functions.datetime import ExtractMonth, ExtractYear
from django.http import HttpResponse
from django.views.generic.edit import FormMixin
from django.views.generic.list import ListView

from .models import Planta, ActivoDepreciacion, ActivoDepAcum, ActivoDepMax, ActivoDepMin  # Activo,
# from .forms import PlantaForm

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
    model = ActivoDepAcum
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
        # prepare filters to apply to queryset
        filters = {}
        filtersMax = {}
        filtersMin = {}
        if prmPlanta:
            filters['planta_id'] = prmPlanta
            filtersMin['planta_id'] = prmPlanta
            filtersMax['planta_id'] = prmPlanta
        if prmPeriodo:
            dPeriodo = datetime.strptime(prmPeriodo, '%Y-%m').date()
            filters['periodo'] = dPeriodo
            filtersMax['periodo__lt'] = dPeriodo
            filtersMin['periodo__gt'] = dPeriodo
            filtersMin['activo_fecha_compra__lt'] = dPeriodo + relativedelta(
                months=1)
            print("filters['periodo'] = ", filters['periodo'])
            print("filtersMax['periodo__lt'] = ", filtersMax['periodo__lt'])
            print("filtersMin = ", filtersMin)

        if len(filters) == 0:
            # Genera una salida vacía, se debe seleccionar planta
            return ActivoDepAcum.objects.filter(periodo__year=1900)

        qAcum = ActivoDepAcum.objects.filter(Q(**filters)).values('activo_id', 'activo_tipo', 'activo_nombre', \
               'numero_factura', 'proveedor', 'activo_fecha_compra', 'activo_valor', 'planta_nombre', \
               'planta_ubicacion', 'fecha_inicio', 'fecha_termino', 'fecha_depreciacion', 'valor_depreciacion', \
               'acum_total', 'acum_anual', 'duracion_real', 'dep_acum', 'neto', 'periodo' )
        # .order_by('activo_id')
        qMax = ActivoDepMax.objects.filter(Q(**filtersMax)).values('activo_id', 'activo_tipo', 'activo_nombre', \
               'numero_factura', 'proveedor', 'activo_fecha_compra', 'activo_valor', 'planta_nombre', \
               'planta_ubicacion', 'fecha_inicio', 'fecha_termino', 'fecha_depreciacion', 'valor_depreciacion', \
               'acum_total', 'acum_anual', 'duracion_real', 'dep_acum', 'neto', 'periodo' )
        # annotate(acum_anual = Case(When('periodo__year' == dPeriodo.year,then='acum_anual'),default=0))
        qMin = ActivoDepMin.objects.filter(Q(**filtersMin)).values('activo_id', 'activo_tipo', 'activo_nombre', \
               'numero_factura', 'proveedor', 'activo_fecha_compra', 'activo_valor', 'planta_nombre', \
               'planta_ubicacion', 'fecha_inicio', 'fecha_termino', 'fecha_depreciacion', 'valor_depreciacion', \
               'acum_total', 'acum_anual', 'duracion_real', 'dep_acum', 'neto', 'periodo' )
        # .order_by('activo_id')
        print("qAcum:", len(qAcum))
        print("qMax:", len(qMax))
        print("qMin:", len(qMin))
        resp = qAcum.union(qMax).union(qMin).order_by('activo_id')
        i = 0
        while i < len(resp):
            periodo = resp[i]['periodo']
            if periodo.year < dPeriodo.year:
                resp[i]['acum_anual'] = 0
            i += 1
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
            'Content-Disposition'] = 'attachment; filename="deprec_activos_B' + datetime.now().strftime('%Y%m%d%H%M%S') + '.csv"'

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
            if fila['numero_factura'] is None:
                fila['numero_factura'] = ''
            if fila['proveedor'] is None:
                fila['proveedor'] = ''
            writer.writerow([
                fila['activo_id'],
                fila['activo_tipo'],
                fila['activo_nombre'].replace('\n', ' '),
                fila['proveedor'].replace('\n', ' '),
                fila['numero_factura'].replace('\n', ' '),
                fila['planta_nombre'],
                fila['planta_ubicacion'],
                fila['activo_fecha_compra'],
                fila['fecha_inicio'],
                fila['fecha_depreciacion'],
                fila['fecha_termino'],
                fila['duracion_real'],
                fila['activo_valor'],
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
            'Content-Disposition'] = 'attachment; filename="deprec_activos_C' + datetime.now().strftime('%Y%m%d%H%M%S') + '.csv"'

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
