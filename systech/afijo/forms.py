import logging

from django import forms
from django.http import request, HttpResponseRedirect
from django.shortcuts import render

from .models import Estado, Planta, Activo, Movimiento, TipoDepreciacion
logger = logging.getLogger(__name__)

class PlantaForm(forms.Form): #Note that it is not inheriting from forms.ModelForm
    planta = forms.ModelChoiceField(queryset=Planta.objects.all().order_by('nombre'),
        label='Seleccione planta',
        widget=forms.Select(attrs={"onChange":'submit()'}))
    year = forms.CharField(label='Año',widget=forms.HiddenInput)
    def cambioPlanta(request):
        form = PlantaForm(request.POST or None)
        if request.method == 'POST' and form.is_valid():
            logger.error('planta')
            plantaSelect = form.cleaned_data['planta']
            logger.error(plantaSelect)
            logger.error(plantaSelect.id)
            return HttpResponseRedirect('/plantaDepreciacion/'+form['year'].value()+'/'+str(plantaSelect.id))
