import logging

from django import forms
from django.contrib import admin
from django.conf.locale.es import formats as es_formats
from django.core import serializers
from .models import Estado, Planta, Activo, Movimiento, TipoDepreciacion

es_formats.DATETIME_FORMAT = "d M Y H:i:s"
es_formats.DATE_FORMAT = "d/m/Y"
logger = logging.getLogger(__name__)

class SoloLectura(admin.ModelAdmin):
    def has_add_permission(self, request, obj=None):
        return False

    def has_delete_permission(self, request, obj=None):
        return False

    def has_change_permission(self, request, obj=None):
        return False

class PlantaAdminForm(admin.ModelAdmin):
    def has_delete_permission(self, request, obj=None):
        return False

# class ActivoAdminForm(forms.ModelForm):
#     class Meta:
#         model = Activo
#         fields = "__all__"

# class MovimForm(forms.ModelForm):
#     def __init__(self, *args, **kwargs):
#        super(MovimForm, self).__init__(*args, **kwargs)
#        logger.error('MovimForm INIT')
#        x1 = kwargs.pop('activo',None)
#        logger.error(x1)
#        logger.error(self.fields['activo'].initial)
#        activo = Activo.objects.get(id=3)

#        self.fields['activo'].initial = 3
#        logger.error(self.fields['activo'].initial)
#        logger.error(activo)

#     class Meta:
#         model = Movimiento
#         fields = "__all__"
#       fields = ('activo', 'planta_origen','planta_destino','fecha_cambio')

class ActivoAdmin(admin.ModelAdmin):
    list_display = ('nombre', 'fecha_inicio', 'fecha_termino', 'valor', 'estado' , 'planta')
    # form = ActivoAdminForm

class MovimientoAdmin(admin.ModelAdmin):
    fields = ('activo', 'planta_destino', 'fecha_cambio')
    list_display = ('activo', 'get_origen', 'get_destino', 'fecha_cambio', 'ts_movim')
    # form = MovimForm
    def get_origen(self,obj):
        return obj.planta_origen.nombre
    get_origen.short_description = "Planta Origen"
    def get_destino(self,obj):
        return obj.planta_destino.nombre
    get_destino.short_description = "Planta Destino"
    def has_delete_permission(self, request, obj=None):
        return False
    def has_change_permission(self, request, obj=None):
        return False
    # def get_changeform_initial_data(self, request):
    #     return {'activo': 6}

admin.site.register(Activo, ActivoAdmin)
admin.site.register(Estado, SoloLectura)
admin.site.register(Planta, PlantaAdminForm)
admin.site.register(TipoDepreciacion, SoloLectura)
admin.site.register(Movimiento, MovimientoAdmin)
