# Levnatar servidor modo desarrollo

```bsh
./manage.py runserver 0:8000
```

# Importación de datos

El comando python se ecneutra en:

```
afijo/managment/commands/importa_csv.py
```

Modo de uso:

```bsh
./manage.py importa_csv archivo.csv
```

## El archivo CSV tiene17 columnas, por ejemplo:

```
Planta;Descripcion;Correlativo;Fact. Física;Descripción Activo;Proveedor o Vendedor;Nro Factura;Planta;Ubicación;Ubicación en Planta;Fecha de compra;Fecha Adj. Concesión;Fecha termino Concesion;Fecha comienzo op;Vida util s/ Concesion;Vida útil tributaria (meses);Valor de Origen
AB0727;MAQUINARIAS Y EQUIPOS;;SI;MOTOR SUSPENSION LV - AM120559;SOCIEDAD DE SERVICIOS Y ELECTRONICA LIMITADA;10645;PARRAL;;;04-12-2020;07-08-2014;07-08-2022;01-02-2017;20;60;-371937
B0542;EDIFICIOS;;;ESTADO DE PAGO Y ADICIONES ;CONSTRUCTORA AMP LIMITADA;3;Viña del Mar;;;15-01-2020;01-09-2017;01-10-2025;01-05-2020;57;120;-133586
AB0541;Maquinaria y equipos;111;SI;AMARRA PLASTICA 100 X 2,5;CIA. DISTRIBUIDORA DE ELECTRONICA Y TELECOMUNICACION;67807;CASABLANCA;;;07-03-2019;01-09-2017;01-08-2025;01-05-2019;76;36;7
```
