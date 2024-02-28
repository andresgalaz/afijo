import logging
import csv

from datetime import datetime
from django.contrib.auth.mixins import LoginRequiredMixin
from django.db.models import Sum, Count
from django.db.models.functions.datetime import ExtractYear
from django.http import HttpResponse
from django.views import generic

from .models import Planta, Activo, ActivoDepreciacion
from .forms import PlantaForm

logger = logging.getLogger(__name__)


class HomeView(LoginRequiredMixin, generic.TemplateView):
    template_name = 'home.html'


class PlantaList(generic.ListView):
    model = Planta
    template_name = 'afijo/plantaList.html'

    # context_object_name = 'planta_list'
    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['planta_list'] = Planta.objects \
            .values('id', 'nombre', 'ubicacion', 'fecha_apertura') \
            .annotate(cantidad=Count('activo__id')) \
            .order_by('nombre')
        return context


class PlantaDepreciacion(generic.ListView):
    model = Planta
    template_name = 'afijo/depreciacion.html'
    context_object_name = 'planta_list'

    def toCSV(request):
        # Create the HttpResponse object with the appropriate CSV header.
        response = HttpResponse(content_type='text/csv')
        response[
            'Content-Disposition'] = 'attachment; filename="deprec_activos_D' + datetime.now().strftime('%Y%m%d%H%M%S') + '.csv"'

        writer = csv.writer(response, delimiter=';')
        writer.writerow(
            ['Planta', 'Periodo', 'Depreciacion', 'Valor Contable'])
        for fila in ActivoDepreciacion.objects \
                .values('planta__nombre', 'periodo') \
                .annotate(depreciacion=Sum('valor_depreciacion'), contable=Sum('valor_contable')) \
                .order_by('planta__nombre', 'periodo'):
            writer.writerow([
                fila['planta__nombre'], fila['periodo'], fila['depreciacion'],
                fila['contable']
            ])
        return response


class PlantaDetail(generic.DetailView):
    model = Planta
    template_name = 'afijo/plantaDetail.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['activo_list'] = Activo.objects.filter(
            planta=super().get_object().id)
        return context


class PlantaDepreciacionAnual(generic.DetailView):
    model = Planta
    template_name = 'afijo/depreciacionAnual.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['periodo_list'] = ActivoDepreciacion.objects.filter(planta=super().get_object().id) \
            .annotate(year=ExtractYear('periodo')) \
            .values('year') \
            .annotate(depreciacion=Sum('valor_depreciacion'), contable=Sum('valor_contable')) \
            .order_by('year')
        return context


class PlantaDepreciacionMensual(generic.DetailView):
    model = Planta
    template_name = 'afijo/depreciacionMensual.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['form'] = PlantaForm(initial={'year': self.kwargs['year']})
        context['year'] = self.kwargs['year']
        # .annotate(mes=ExtractMonth('periodo'),nombre='periodo') \
        context['periodo_list'] = ActivoDepreciacion.objects.filter(planta=super().get_object().id, periodo__year=self.kwargs['year']) \
            .values('periodo') \
            .annotate(depreciacion=Sum('valor_depreciacion'), contable=Sum('valor_contable')) \
            .order_by('periodo')
        return context


class ActivoList(generic.ListView):
    queryset = Activo.objects.all()
    context_object_name = 'activo_list'
    template_name = 'afijo/activoList.html'


class ActivoDetail(generic.DetailView):
    model = Activo
    context_object_name = 'activo'
    queryset = Activo.objects.all()
