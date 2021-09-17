# -*- coding: utf-8 -*-
__author__ = "Andrés Galaz"
__license__ = "LGPL"
__email__ = "andres.galaz@gmail.com"
__version__ = "v1.0"

import csv
import re
from datetime import datetime
from django.core.management import BaseCommand
from django.utils import timezone
from django.db.utils import DataError
from django.db import transaction
from afijo.models import Estado, Planta, Activo, TipoDepreciacion

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
    ('M', 'MAQ Y EQ'),
    ('U', 'MUEBLES Y UTILES'),
    ('U', 'MUEBLE Y UTILES'),
    ('O', 'OBRAS EN CURSO'),
    ('A', 'PREOPERATION EXPENSIVES'),
    ('U', 'VEHICULOS'),
]


def str2date(cFecha):
    try:
        cFecha = cFecha.replace(".", "-").replace("/", "-")
        if re.search(
                "^([1-9]|0[1-9]|1[0-9]|2[0-9]|3[0-1])(\.|-|/)([1-9]|0[1-9]|1[0-2])(\.|-|/)([0-9][0-9]|19[0-9][0-9]|20[0-9][0-9])$",
                cFecha):
            return datetime.strptime(cFecha, '%d-%m-%Y')
        elif re.search(
                "^([0-9][0-9]|19[0-9][0-9]|20[0-9][0-9])(\.|-|/)([1-9]|0[1-9]|1[0-2])(\.|-|/)([1-9]|0[1-9]|1[0-9]|2[0-9]|3[0-1])$",
                cFecha):
            return datetime.strptime(cFecha, '%Y-%m-%d')
    except:
        pass


def str2number(cNum):
    cNum = cNum.replace(".", "")
    try:
        if cNum.find(',') >= 0:
            cNum = cNum.replace(",", ".")
            return float(cNum)
        return int(cNum)
    except:
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
        start_time = timezone.now()
        file_path = options["file_path"]

        # Valores de FK por defecto
        tipoDepreciacion = TipoDepreciacion.objects.get(pk=1)
        estado = Estado.objects.get(pk=1)

        nLinea = 0
        nError = 0

        with open(file_path, "r") as csv_file:
            data = list(csv.reader(csv_file, delimiter=";"))
            # Valida. Si hay errores no procesa nada
            for nPasada in range(2):
                print('Pasada:', nPasada)
                nLinea = 0
                for row in data[1:]:
                    nLinea += 1
                    if isRowEmpty(row): continue

                    csvPlanta = row[0]
                    csvTipoActivo = row[1].strip().upper()
                    csvCorrelativo = row[2]
                    csvFacturaFisica = row[3]
                    csvNombreActivo = row[4].strip()
                    csvProveedor = row[5]
                    csvNumeroFactura = row[6]
                    # 7 Nombre localidad de la planta, no se utiliza
                    csvUbicacion = row[8]
                    # 9 Ubicación en planta no se usa
                    csvFechaCompra = row[10].strip()
                    # 11 Fecha Concesión, se usa la de la planta
                    # 12 Fecha termino Concesion, se usa la de la planta
                    # 13 Fecha comienzo Operaciones, se usa la de la planta
                    # 14 Vida útil desde la concesion no se usa
                    csvVidaUtil = row[15].strip()
                    csvValor = row[16]

                    planta = Planta.objects.all().filter(nombre=csvPlanta)
                    if (len(planta) == 0):
                        nError += 1
                        print(nLinea, 'No existe planta:' + csvPlanta, row)
                        continue

                    tipoActivo = [
                        item for item in LISTA_TIPO_ACTIVO
                        if item[1] == csvTipoActivo
                    ]
                    if (len(tipoActivo) == 0):
                        nError += 1
                        print(nLinea, 'No existe tipo activo:' + csvTipoActivo,
                              row)
                        continue

                    if csvNombreActivo == '': csvNombreActivo = csvProveedor
                    if csvNombreActivo == '':
                        nError += 1
                        print(nLinea, 'No hay nombre de activo', row)
                        continue

                    if (len(csvFechaCompra) == 0):
                        nError += 1
                        print(nLinea, 'Fecha compra está vacía', row)
                        continue
                    fechaIngreso = str2date(csvFechaCompra)
                    if (not fechaIngreso):
                        nError += 1
                        print(nLinea, 'Fecha compra errónea:' + csvFechaCompra,
                              row)
                        continue

                    if csvVidaUtil == '':
                        vidaUtil = -1
                    else:
                        vidaUtil = str2number(csvVidaUtil)
                        if vidaUtil == None:
                            nError += 1
                            print(nLinea,
                                  'Vida útil debe ser numérico:' + csvVidaUtil,
                                  row)
                            continue
                        vidaUtil = int(vidaUtil / 12)

                    valor = str2number(csvValor)
                    if valor == None:
                        nError += 1
                        print(nLinea,
                              'Valor del activo debe ser numérico:' + csvValor,
                              row)
                        continue
                    valor = int(valor)

                    if nPasada == 0:
                        continue

                    # Si es la pasada 1, ya está validado y no hay errores, asi es que se procesa
                    try:
                        print('Procesando línea:', nLinea)
                        Activo.objects.create(
                            tipoDepreciacion=tipoDepreciacion,
                            tipoActivo=tipoActivo[0][0],
                            nombre=csvNombreActivo,
                            planta=planta[0],
                            numero_interno=csvCorrelativo,
                            ubicacion=csvUbicacion,
                            factura_fisica=csvFacturaFisica,
                            proveedor=csvProveedor,
                            numero_factura=csvNumeroFactura,
                            fecha_ingreso=fechaIngreso,
                            duracion_maxima=vidaUtil,
                            valor=valor,
                            cantidad=1,
                            estado=estado)
                    except DataError as e:
                        transaction.set_rollback(True)
                        print(nLinea, 'Error SQL:', tipoDepreciacion,
                              tipoActivo[0][0], csvNombreActivo,
                              csvCorrelativo, csvUbicacion, csvFacturaFisica,
                              csvProveedor, csvNumeroFactura, fechaIngreso,
                              vidaUtil, valor, estado, e)
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
