# -*- coding: utf-8 -*-
__author__ = "Andrés Galaz"
__license__ = "LGPL"
__email__ = "andres.galaz@gmail.com"
__version__ = "v1.0"

import csv
import re
# import uuid
from datetime import datetime
from django.core.management import BaseCommand
from django.utils import timezone
from django.db.utils import DataError
from django.db import transaction
from afijo.models import Estado, Planta, Activo, TipoDepreciacion
from afijo.util import diff_meses, dateToPeriodo

LISTA_TIPO_ACTIVO = [
    ('A', 'ACONDICIONAMIENTO'),
    ('A', 'ACONDICIONAMIENTO PRT'),
    ('E', 'EDIFICIO'),
    ('E', 'EDIFICIOS'),
    ('C', 'EQ COMPUTACIONALES'),
    ('C', 'EQUIPOS COMPUTACIONALES'),
    ('M', 'EQUIPOS PRT'),
    ('S', 'INTANGIBLES'),
    ('M', 'MAQUINARIAS Y EQ'),
    ('M', 'MAQUINARIAS Y EQUIPOS'),
    ('M', 'MAQUINARIA Y EQUIPO'),
    ('M', 'MAQUINARIA Y EQUIPOS'),
    ('M', 'MAQUINARIA Y EQ'),
    ('M', 'MAQ Y EQ'),
    ('U', 'MUEBLES Y UTILES'),
    ('U', 'MUEBLE Y UTILES'),
    ('O', 'OBRAS EN CURSO'),
    ('A', 'PREOPERATION EXPENSIVES'),
    ('S', 'SOFTWARE'),
    ('V', 'VEHICULOS'),
]

LISTA_PLANTA = [
    ('AB1507', 'ARICA AB'),
    ('B1508', 'ARICA B'),
    ('B0800', 'BIO BIO'),
    ('AB0541', 'CASABLANCA'),
    ('AB0728', 'CONSTITUCIÓN'),
    ('AB0728', 'CONSTITUCION'),
    ('AB0726', 'CURICÓ'),
    ('AB0726', 'CURICO'),
    ('HQ1300', 'HQ'),
    ('AB1308', 'LAMPA'),
    ('LA1300', 'LATAM'),
    ('AB0801', 'LOS ANGELES'),
    ('AB1307', 'MELIPILLA'),
    ('AB0727', 'PARRAL'),
    ('AB0610', 'RANCAGUA'),
    ('AB0301', 'SPP'),
    ('AB0301', 'SAN PEDRO DE LA PAZ'),
    ('AB0611', 'SVTT'),
    ('B0542', 'VIÑA DEL MAR'),
]


def str2date(cFecha):
    try:
        cFecha = cFecha.replace(".", "-").replace("/", "-")
        if re.search(
                "^([1-9]|0[1-9]|1[0-9]|2[0-9]|3[0-1])(\.|-|/)([1-9]|0[1-9]|1[0-2])(\.|-|/)([0-9][0-9]|19[0-9][0-9]|20[0-9][0-9])$",
                cFecha):
            return datetime.strptime(cFecha, '%d-%m-%Y').date()
        elif re.search(
                "^([0-9][0-9]|19[0-9][0-9]|20[0-9][0-9])(\.|-|/)([1-9]|0[1-9]|1[0-2])(\.|-|/)([1-9]|0[1-9]|1[0-9]|2[0-9]|3[0-1])$",
                cFecha):
            return datetime.strptime(cFecha, '%Y-%m-%d').date()
    except Exception:
        pass


def str2boolean(cBol):
    cBol = cBol.strip().upper()
    if cBol == 'S' or cBol == 'SI' or cBol == 'T' or cBol == 'TRUE' or cBol == '1':
        return True
    if cBol == 'N' or cBol == 'NO' or cBol == 'F' or cBol == 'FALSE' or cBol == '0':
        return False
    return None


def str2number(cNum):
    cNum = cNum.strip().replace(".", "")
    try:
        if cNum.find(',') >= 0:
            cNum = cNum.replace(",", ".")
            return float(cNum)
        return int(cNum)
    except Exception:
        return None


def isRowEmpty(row):
    for r in row:
        if r.strip() != '':
            return False
    return True


class Command(BaseCommand):
    help = "Carga datos desde un archivo CSV."

    def add_arguments(self, parser):
        parser.add_argument("file_path", type=str)

    @transaction.atomic()
    def handle(self, *args, **options):
        FORCED = False
        start_time = timezone.now()
        file_path = options["file_path"]
        fechaSinInicio = datetime(2000, 1, 1).date()
        fechaSinFin = datetime(2099, 1, 1).date()

        # Valores de FK por defecto
        tipoDepreciacion = TipoDepreciacion.objects.get(pk=1)
        estado = Estado.objects.get(pk=1)

        nLinea = 0
        nError = 0

        # encoding = 'cp437'
        with open(file_path, "r", encoding='utf8') as csv_file:
            data = list(csv.reader(csv_file, delimiter=";"))
            # Valida. Si hay errores no procesa nada
            for nPasada in range(0, 2, 1):
                print('Pasada:', nPasada)
                nLinea = 0
                for row in data:  # data[1:]:
                    nLinea += 1
                    if isRowEmpty(row):
                        continue

                    # csvUbicacion = row[6]

                    csvContab = row[0].strip()
                    csvTipoActivo = row[1].strip().upper()
                    csvNombreActivo = row[2].strip()
                    csvProveedor = row[3]
                    csvNumeroFactura = row[4]
                    csvPlanta = row[5].strip().upper()
                    csvFechaCompra = row[6].strip()
                    #  7 Año compra está en el campor anterior
                    #  8 Fecha Concesión, se usa la de la planta
                    #  9 Fecha termino Concesion, se usa la de la planta
                    # 10 Vida Util Concesion, se usa la de la planta
                    # 11 F inicio Depreciacion
                    # 12 Fecha comienzo Operaciones, se usa la de la planta
                    # 13 Año inicio depreciacion
                    # 14 F. especial de inicio (Según fecha de compra
                    # 15 Año inicio de depreciacion especial
                    # 16 Efectivida de inicio de depreciación
                    # 17 Año inicio de depreciacion definitivo                    
                    # 18 Fecha de depreciacion definitiva
                    # 19 Fecha Término Depreciación
                    csvValor = row[20]
                    # 21 Total Meses Amortización - Vida Util Proyecto (Meses), se calcula de la Planta
                    #       ( planta.fecha_termino + 24 ) - planta.fecha_depreciacion
                    csvVidaUtilCompra = row[21]
                    # 22 Vida util Restante(Meses)
                    # 23 - 30: años 2015 - 2023
                    # 31 Amort. Mensual - Usar para verificar cálculo

                    if csvTipoActivo == '' and csvNombreActivo == '' and csvProveedor == '' and csvPlanta == '':
                        continue

                    nombrePlanta = [
                        item for item in LISTA_PLANTA if item[1] == csvPlanta
                    ]
                    if len(nombrePlanta) == 0:
                        nError += 1
                        print(nLinea,
                              'No existe planta en la lista:' + csvTipoActivo,
                              row)
                        continue
                    nombrePlanta = nombrePlanta[0][0]

                    planta = Planta.objects.all().get(nombre=nombrePlanta)
                    if not planta:
                        nError += 1
                        print(
                            nLinea, 'No existe planta en la tabla:' +
                            str(nombrePlanta), row)
                        continue

                    tipoActivo = [
                        item for item in LISTA_TIPO_ACTIVO
                        if item[1] == csvTipoActivo
                    ]
                    if len(tipoActivo) == 0:
                        nError += 1
                        print(nLinea, 'No existe tipo activo:' + csvTipoActivo,
                              row)
                        continue
                    tipoActivo = tipoActivo[0][0]

                    if csvNombreActivo == '':
                        csvNombreActivo = csvProveedor
                    if csvNombreActivo == '':
                        csvNombreActivo = 'No tiene descripción o nombre'
                    # if csvNombreActivo == '':
                    #     nError += 1
                    #     print(nLinea, 'No hay nombre de activo', row)
                    #     continue

                    if len(csvFechaCompra) == 0:
                        nError += 1
                        print(nLinea, 'Fecha compra está vacía', row)
                        continue
                    fechaIngreso = str2date(csvFechaCompra)
                    if not fechaIngreso:
                        nError += 1
                        print(nLinea, 'Fecha compra errónea:' + csvFechaCompra,
                              row)
                        continue

                    valor = str2number(csvValor)
                    if valor is None:
                        nError += 1
                        print(nLinea,
                              'Valor del activo debe ser numérico:' + csvValor,
                              row)
                        continue
                    valor = int(valor)

                    csvVidaUtilCompra = str2number(csvVidaUtilCompra)
                    if planta.fecha_depreciacion >= fechaIngreso:
                        vidaUtilCompra = diff_meses(planta.fecha_depreciacion,
                                                    planta.fecha_termino) + 24
                    elif planta.fecha_termino >= fechaSinFin:
                        vidaUtilCompra = csvVidaUtilCompra
                    else:
                        if fechaIngreso <= planta.fecha_termino:
                            vidaUtilCompra = 24 + diff_meses(fechaIngreso, planta.fecha_termino)
                        else:
                            vidaUtilCompra = 23 + diff_meses(fechaIngreso, planta.fecha_termino)
                        if False and planta.fecha_depreciacion < fechaIngreso:
                            # if fechaIngreso.day > planta.fecha_termino.day and not (fechaIngreso.month == planta.fecha_termino.month
                            #                                                         and fechaIngreso.year == planta.fecha_termino.year):
                            #     v1 = abs(valor-(int((valor/vidaUtilCompra)+.5)*vidaUtilCompra))
                            #     v2 = abs(valor-(int((valor/(vidaUtilCompra+1))+.5)*(vidaUtilCompra+1)))
                            #     p1 = int(v1/int((valor/vidaUtilCompra)+.5)*100)
                            #     if p1 > 50 and v1 > 50 and v2 < v1:
                            #         vidaUtilCompra += 1
                            if False and fechaIngreso.day > planta.fecha_termino.day and not (
                                    fechaIngreso.month == planta.fecha_termino.month
                                    and fechaIngreso.year == planta.fecha_termino.year):
                                vidaUtilCompra += 1

                    if FORCED and vidaUtilCompra != csvVidaUtilCompra:
                        vidaUtilCompra = csvVidaUtilCompra

                    # Verfiicación fechas
                    if (vidaUtilCompra != csvVidaUtilCompra):
                        if planta.fecha_depreciacion == fechaSinInicio:
                            vidaUtilCompra = csvVidaUtilCompra
                        else:
                            nError += 1
                            print(nLinea, 'No coincide la vida util:', vidaUtilCompra, csvVidaUtilCompra, row)

                    if nLinea % 100 == 0:
                        print('Procesando [', nPasada, ']:', nLinea)
                    if nPasada == 0:
                        continue

                    csvCorrelativo = str(nLinea)
                    csvFacturaFisica = None
                    # Si es la pasada 1, ya está validado y no hay errores, asi es que se procesa
                    try:
                        Activo.objects.create(
                            contab=csvContab,
                            tipoDepreciacion=tipoDepreciacion,
                            tipoActivo=tipoActivo,
                            nombre=csvNombreActivo,
                            planta=planta,
                            numero_interno=csvCorrelativo,
                            # ubicacion=csvUbicacion,
                            factura_fisica=csvFacturaFisica,
                            proveedor=csvProveedor,
                            numero_factura=csvNumeroFactura,
                            fecha_ingreso=fechaIngreso,
                            duracion_maxima=vidaUtilCompra,
                            # duracion_clase=claseDuracion,
                            vida_util_compra=True,
                            valor=valor,
                            cantidad=1,
                            estado=estado)

                    except DataError as e:
                        transaction.set_rollback(True)
                        print(nLinea, 'Error SQL:', e, row)
                        exit(-1)

                if nError > 0:
                    break

        end_time = timezone.now()
        self.stdout.write(
            self.style.SUCCESS(f"""
========================================================================
La carga CSV tomó: {(end_time-start_time).total_seconds()} segundos.
Lineas procesadas {nLinea}
Errores encontrados {nError}
========================================================================
"""))
