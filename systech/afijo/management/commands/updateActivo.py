# -*- coding: utf-8 -*-
__author__ = "Andrés Galaz"
__license__ = "LGPL"
__email__ = "andres.galaz@gmail.com"
__version__ = "v1.0"

from django.core.management.base import BaseCommand
from django.db import transaction
from afijo.models import Estado, Planta, Activo, TipoDepreciacion


class Command(BaseCommand):
    help = 'Recorre todos los activos y los actualiza'

    @transaction.atomic()
    def handle(self, *args, **kwargs):
        lista = Activo.objects.all()
        n = 0
        for r in lista:
            print(n, r.pk, r.nombre, r.fecha_termino)
            r.fecha_termino = None
            r.numero_interno = str(n)
            r.save()
            n += 1
