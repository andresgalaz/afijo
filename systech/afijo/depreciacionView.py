import logging
import csv

from django import forms
from django.contrib.auth.mixins import LoginRequiredMixin
from django.db.models import Sum, Count, F, Q
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
