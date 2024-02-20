import logging
import csv

from django import forms
# from django.contrib.auth.mixins import LoginRequiredMixin
from django.db.models import Q  # Sum, Count, F,
# from django.db.models.functions import Extract
from django.db.models.functions.datetime import ExtractMonth, ExtractYear
from django.http import HttpResponse
# from django.views import generic
from django.views.generic.edit import FormMixin
from django.views.generic.list import ListView

from .models import Planta, Activo  # , Movimiento, ActivoDepreciacion
# from .forms import PlantaForm

logger = logging.getLogger(__name__)


class ActivoFilterForm(forms.Form):
    data = [(None, 'Todas')]
    for r in Planta.objects.all().order_by('nombre'):
        data.append((r.id, r.nombre + ' ' + r.ubicacion.split(',')[-1] + ', ' +
                     r.region.nombre))
    planta = forms.ChoiceField(
        choices=data,
        label='Planta',
        required=False,
        widget=forms.Select(attrs={'class': 'form-select'}))

    data = [(None, 'Todos')]
    for r in Activo.objects.annotate(
            year=ExtractYear('fecha_ingreso')).annotate(
                mes=ExtractMonth('fecha_ingreso')).values(
                    'year', 'mes').order_by('year', 'mes').distinct().order_by(
                        '-year', '-mes'):
        cPeriodo = str(r['year']) + '-' + str(r['mes']).zfill(2)
        data.append((cPeriodo, cPeriodo))
    periodo = forms.ChoiceField(
        choices=data,
        label='Periodo',
        required=False,
        widget=forms.Select(attrs={'class': 'form-select'}))

    class Meta:
        fields = ['planta', 'periodo']


class ActivoListView(FormMixin, ListView):
    model = Activo
    template_name = 'afijo/activoList.html'
    paginate_by = 50
    form_class = ActivoFilterForm
    context_object_name = 'activo_list'

    def dispatch(self, request, *args, **kwargs):
        # if not request.user.has_perm('derivado.indicador_list'):
        #    return redirect(reverse_lazy('home'))
        return super(ActivoListView, self).dispatch(request, *args, **kwargs)

    def get_context_data(self, **kwargs):
        context = super(ActivoListView, self).get_context_data(**kwargs)
        context['form'] = ActivoFilterForm(self.request.GET)
        return context

    def querysetWrap(self, prmPlanta, prmPeriodo):
        # prepare filters to apply to queryset
        filters = {}
        if prmPlanta:
            filters['planta'] = Planta.objects.get(id=int(prmPlanta))
        if prmPeriodo:
            filters['fecha_ingreso__year'] = prmPeriodo[:4]
            filters['fecha_ingreso__month'] = prmPeriodo[-2:]

        if len(filters) == 0:
            # Genera una salida vacía, se debe seleccionar planta
            return Activo.objects.filter(fecha_ingreso__year=1900)

        return Activo.objects.filter(Q(**filters)).order_by(
            '-fecha_ingreso', 'tipoActivo')

    def get_queryset(self):
        return self.querysetWrap(self.request.GET.get('planta'),
                                 self.request.GET.get('periodo'))

    def toCSV(request):
        qrySet = ActivoListView.querysetWrap(None, request.GET.get('planta'),
                                             request.GET.get('periodo'))
        # Create the HttpResponse object with the appropriate CSV header.
        response = HttpResponse(content_type='text/csv')
        response[
            'Content-Disposition'] = 'attachment; filename="deprec_plantas.csv"'

        writer = csv.writer(response, delimiter=';')
        writer.writerow([
            'Planta', 'Tipo', 'Nombre', 'Nro', 'Ubicacion', 'Factura',
            'Fecha Ingreso', 'Fecha Inicio', 'Fecha Termino', 'Vida Util',
            'Valor de Origen'
        ])

        for activo in qrySet:
            writer.writerow([
                activo.planta.nombre,
                activo.getTipoActivo(),
                activo.nombre,
                activo.numero_interno,
                activo.ubicacion,
                activo.proveedor,
                activo.fecha_ingreso,
                activo.fecha_inicio,
                activo.fecha_termino,
                activo.duracion_maxima,
                activo.valor,
            ])
        return response
