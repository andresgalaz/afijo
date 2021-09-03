import logging

from django import forms
from django.contrib import admin
from django.conf.locale.es import formats as es_formats
from django.core import serializers
from .models import Estado, Planta, Activo, Movimiento, Region, TipoDepreciacion, TipoFamilia

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


class ActivoAdmin(admin.ModelAdmin):
    list_display = ('nombre', 'fecha_inicio', 'fecha_termino',
                    'valor', 'estado', 'planta')
    # form = ActivoAdminForm


class MovimientoAdmin(admin.ModelAdmin):
    fields = ('activo', 'planta_destino', 'fecha_cambio')
    list_display = ('activo', 'get_origen', 'get_destino',
                    'fecha_cambio', 'ts_movim')
    # form = MovimForm

    def get_origen(self, obj):
        return obj.planta_origen.nombre
    get_origen.short_description = "Planta Origen"

    def get_destino(self, obj):
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
admin.site.register(Movimiento, MovimientoAdmin)
admin.site.register(Planta, PlantaAdminForm)
admin.site.register(Region, SoloLectura)
admin.site.register(TipoDepreciacion, SoloLectura)
admin.site.register(TipoFamilia, SoloLectura)
