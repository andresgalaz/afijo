import logging

from django import forms
from django.http import HttpResponseRedirect

from .models import Planta

logger = logging.getLogger(__name__)


class PlantaForm(forms.Form):
    # Note that it is not inheriting from forms.ModelForm
    planta = forms.ModelChoiceField(
        queryset=Planta.objects.all().order_by('nombre'),
        label='Seleccione planta',
        widget=forms.Select(attrs={"onChange": 'submit()'}))
    year = forms.CharField(label='Año', widget=forms.HiddenInput)

    def cambioPlanta(request):
        form = PlantaForm(request.POST or None)
        if request.method == 'POST' and form.is_valid():
            plantaSelect = form.cleaned_data['planta']
            return HttpResponseRedirect('/plantaDepreciacion/' +
                                        form['year'].value() + '/' +
                                        str(plantaSelect.id))
