# import datetime
import logging

from dateutil.relativedelta import relativedelta

from django.core.exceptions import ValidationError
from django.db import models
from django.db.models.signals import post_save, pre_save, pre_delete
from django.utils import timezone

from .util import dateToPeriodo, diff_meses, dump

logger = logging.getLogger(__name__)

# Modelos.


class Estado(models.Model):
    descripcion = models.CharField('Descripción', max_length=40)

    def __str__(self):
        return self.descripcion


class TipoDepreciacion(models.Model):
    descripcion = models.CharField('Descripción', max_length=40)

    class Meta:
        verbose_name = "tipo de depreciación"
        verbose_name_plural = "tipos de depreciación"

    def __str__(self):
        return self.descripcion


class Region(models.Model):
    codigo = models.CharField('Código', max_length=2, unique=True)
    nombre = models.CharField('Nombre', max_length=80, unique=True)

    class Meta:
        verbose_name = "Región"
        verbose_name_plural = "Regiones"
        ordering = ('codigo',)

    def __str__(self):
        return self.codigo + " - "+self.nombre


class Planta(models.Model):
    nombre = models.CharField('Nombre', max_length=80, unique=True)
    region = models.ForeignKey(Region, models.SET_NULL, blank=True, null=True)
    ubicacion = models.CharField('Ubicación', max_length=180)
    fecha_apertura = models.DateField('Fecha Apertura')
    fecha_depreciacion = models.DateField('Fecha Inicio Depreciación')
    fecha_inicio = models.DateField('Fecha Inicio Concesión')
    fecha_termino = models.DateField('Fecha Término Concesión')
    duracion_concesion = models.IntegerField('Duración de la Concesión')

    def __str__(self):
        return self.nombre + '  ' + self.ubicacion + ', ' + self.region.nombre

    def pre_save(sender, instance, **kwargs):
        timeDif = relativedelta(instance.fecha_termino, instance.fecha_inicio)
        if not timeDif is None:
            instance.duracion_concesion = timeDif.years
        planta_prev = Planta.objects.get(id=instance.id)
        if not planta_prev is None and (planta_prev.fecha_depreciacion != instance.fecha_depreciacion or planta_prev.fecha_termino != instance.fecha_termino):
            "Si hay cambios en la fecha de Inicio o Fin se recalculan todos los activos"
            for act in Activo.objects.filter(planta=planta_prev):
                act.planta = instance
                act.calculaDepreciacion()


class TipoFamilia(models.Model):
    codigo = models.CharField('Código', max_length=2, unique=True)
    nombre = models.CharField('Nombre', max_length=80, unique=True)

    class Meta:
        verbose_name = "Tipo y Familia"
        verbose_name_plural = "Tipos y Familias"
        ordering = ('nombre',)

    def __str__(self):
        return self.codigo + " - "+self.nombre


class Activo(models.Model):
    TipoActivo = [
        ('E', 'Edificio'),
        ('M', 'Maquinaria'),
        ('C', 'Equipos de computación'),
        ('S', 'Software'),
    ]
    tipoDepreciacion = models.ForeignKey(
        TipoDepreciacion, default=1, on_delete=models.CASCADE)
    nombre = models.CharField('Nombre', max_length=80)
    modelo = models.CharField('Modelo', max_length=80, null=True, blank=True)
    planta = models.ForeignKey(Planta, models.SET_NULL, blank=True, null=True)
    linea = models.CharField(
        'Línea', max_length=2, default=1)  # , blank=True, null=True)
    familia = models.ForeignKey(
        TipoFamilia, models.SET_NULL, blank=True, null=True)
    numero_interno = models.CharField(
        'Número Interno', max_length=3, default=1)  # , blank=True, null=True)
    codigo_interno = models.CharField(
        'Código Interno', max_length=30, blank=True, null=True)
    serie = models.CharField('Número de Serie', max_length=30, blank=True, null=True)
    fecha_ingreso = models.DateField('Fecha Ingreso')
    fecha_inicio = models.DateField(
        'Fecha Inicio Depreciación', null=True, blank=True)
    duracion_maxima = models.IntegerField(
        'Duración Depreciación [años]', default=5)
    fecha_termino = models.DateField(
        'Fecha Término Depreciación', null=True, blank=True)
    fecha_baja = models.DateField('Fecha Baja', null=True, blank=True)
    valor = models.BigIntegerField('Valor')
    valorResidual = models.BigIntegerField('Valor Residual', default=0)
    cantidad = models.IntegerField('Cantidad', default=1)
    tipoActivo = models.CharField(
        max_length=1, choices=TipoActivo, default='M')
    estado = models.ForeignKey(Estado, on_delete=models.CASCADE)

    def __str__(self):
        return self.nombre

    def calculaDepreciacion(self):
        self.__dict__
        self.pre_delete(instance=self)
        "Borra el activo de la tabla de calculo"
        ActivoDepreciacion.objects.filter(activo=self).delete()
        # Periodo Inicio (aaaa-mm)
        periodoIni = dateToPeriodo(self.fecha_inicio if self.fecha_inicio >
                                   self.planta.fecha_depreciacion else self.planta.fecha_depreciacion)
        # OLD yearIni = self.fecha_inicio.year if self.fecha_inicio.year > self.planta.fecha_depreciacion.year else self.planta.fecha_depreciacion.year
        # OLD yearFin = self.planta.fecha_termino.year
        "Duración Planta en meses"
        periodoFin = dateToPeriodo(self.planta.fecha_termino)
        duracionPlanta = diff_meses(periodoIni, periodoFin)

        "Duración Activo en meses"
        duracionActivo = self.duracion_maxima * 12

        "Depreciación mensual"
        valorContable = self.valor
        valorDep = (valorContable - self.valorResidual) / duracionActivo

        "Baja Activo"
        periodoBaja = dateToPeriodo(self.fecha_baja)
        if periodoBaja == None:
            periodoBaja = periodoFin

        "Recalcula depreciación por año hasta duración máxima, termino de la planta o baja del activo"
        i = 0
        while i < duracionPlanta and i < duracionActivo and periodoIni <= periodoBaja and valorContable > 0:
            valorContable -= valorDep
            actDep = ActivoDepreciacion(
                activo=self,
                planta=self.planta,
                periodo=periodoIni,
                valor_contable=valorContable,
                valor_depreciacion=valorDep)
            actDep.save()
            i += 1
            periodoIni = periodoIni + relativedelta(months=1)

    def pre_save(sender, instance, **kwargs):
        try:
            instance.codigo_interno = "-".join([instance.planta.nombre[-4:3], instance.planta.nombre[-2:],
                                                instance.linea, instance.familia.codigo, str(instance.numero_interno).zfill(3), ])
        except:
            pass
        "Actualiza fecha de inicio si es nula por la fecha de inicio depreciación de la planta"
        if instance.fecha_inicio is None:
            instance.fecha_inicio = instance.planta.fecha_depreciacion
        "Actualiza fecha de término si es nula"
        if not instance.fecha_inicio is None and instance.fecha_termino is None:
            instance.fecha_termino = instance.fecha_inicio + \
                relativedelta(years=instance.duracion_maxima)

    def post_save(sender, instance, **kwargs):
        instance.calculaDepreciacion()

    def pre_delete(sender, instance, **kwargs):
        ActivoDepreciacion.objects.filter(activo=instance).delete()


class Movimiento(models.Model):
    "Por ahora solo se utiliza para movimento de Activos entre plantas"
    activo = models.ForeignKey(Activo, on_delete=models.CASCADE)
    planta_origen = models.ForeignKey(
        Planta, related_name='plantaOrigen', on_delete=models.CASCADE)
    planta_destino = models.ForeignKey(
        Planta, related_name='plantaDestino', on_delete=models.CASCADE)
    ts_movim = models.DateTimeField(
        'Fecha Registro', default=timezone.now, editable=False)
    fecha_cambio = models.DateField('Fecha Cambio')

    def clean(self):
        logger.info('CLEAN Movimiento')
        if self.activo.planta == self.planta_destino:
            raise ValidationError('No se puede mover a la misma planta')

    def pre_save(sender, instance, **kwargs):
        instance.planta_origen = instance.activo.planta

    def post_save(sender, instance, created, **kwargs):
        logger.info('Movimiento  post_save')
        periodoBaja = dateToPeriodo(instance.fecha_cambio)
        try:
            actDep = ActivoDepreciacion.objects.get(
                activo=instance.activo, periodo=periodoBaja)
        except:
            actDep = None

        if actDep != None:
            "Quiere decir que ha comenzado a depreciar"
            activoNuevo = Activo.objects.get(id=instance.activo.id)
            activoNuevo.id = None
            activoNuevo.fecha_ingreso = instance.fecha_cambio
            activoNuevo.fecha_inicio = instance.fecha_cambio
            activoNuevo.fecha_baja = None
            activoNuevo.valor = actDep.valor_contable + activoNuevo.valorResidual
            activoNuevo.duracion_maxima = activoNuevo.duracion_maxima - \
                diff_meses(dateToPeriodo(
                    activoNuevo.fecha_inicio), periodoBaja)
            activoNuevo.save()
        else:
            pass
        activoOld = Activo.objects.get(id=instance.activo.id)
        activoOld.planta = instance.planta_destino
        activoOld.fecha_baja = instance.fecha_cambio
        activoOld.save()


class ActivoDepreciacion(models.Model):
    activo = models.ForeignKey(Activo, on_delete=models.CASCADE)
    planta = models.ForeignKey(Planta, on_delete=models.CASCADE)
    "Solo se usa Año y Mes"
    periodo = models.DateField('Periodo', blank=False, null=False)
    valor_depreciacion = models.BigIntegerField('Valor Depreciación')
    valor_contable = models.BigIntegerField('Valor Contable', default=0)

    class Meta:
        unique_together = [['activo', 'planta', 'periodo']]


# Funciones de señales para save o delete
pre_save.connect(Planta.pre_save, Planta, dispatch_uid=__file__)
pre_save.connect(Activo.pre_save, Activo, dispatch_uid=__file__)
pre_save.connect(Movimiento.pre_save, Movimiento, dispatch_uid=__file__)
post_save.connect(Activo.post_save, Activo, dispatch_uid=__file__)
post_save.connect(Movimiento.post_save, Movimiento, dispatch_uid=__file__)
pre_delete.connect(Activo.pre_delete, Activo, dispatch_uid=__file__)
