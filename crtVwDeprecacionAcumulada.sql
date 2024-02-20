drop view afijo_v_deprec_acum ;
drop view afijo_v_deprec_max ;
drop view afijo_v_deprec_min ;


create view afijo_v_deprec_acum as
select
	activo.id activo_id, tpActivo.descripcion activo_tipo, activo.nombre activo_nombre, activo.numero_factura, activo.proveedor, activo.fecha_ingreso activo_fecha_compra, activo.valor activo_valor,
    planta.nombre planta_nombre, planta.alias planta_ubicacion, planta.fecha_inicio, planta.fecha_termino, planta.fecha_depreciacion,
	dep.valor_depreciacion, dep.acum_total, dep.acum_anual, dep.duracion_real,
	dep.acum_total - dep.acum_anual dep_acum, activo.valor - dep.acum_total neto,
	dep.periodo, dep.planta_id
from afijo_activodepreciacion dep
inner join afijo_activo activo on activo.id = dep.activo_id
inner join afijo_planta planta  on planta.id = dep.planta_id
left outer join afijo_tipo_activo tpActivo on tpActivo.codigo = activo."tipoActivo";


create view afijo_v_deprec_max as
select 	
    activo.id activo_id, tpActivo.descripcion activo_tipo, activo.nombre activo_nombre, activo.numero_factura, activo.proveedor, activo.fecha_ingreso activo_fecha_compra, activo.valor activo_valor,
    planta.nombre planta_nombre, planta.alias planta_ubicacion, planta.fecha_inicio, planta.fecha_termino, planta.fecha_depreciacion,
	dep.valor_depreciacion, dep.acum_total, dep.acum_anual, dep.duracion_real,
	dep.acum_total dep_acum, activo.valor - dep.acum_total neto, dep.periodo, activo.planta_id
from afijo_activo activo
inner join afijo_planta planta          on planta.id = activo.planta_id
inner join ( select activo_id, max(periodo) periodo
			 from afijo_activodepreciacion
			group by activo_id ) depMax on depMax.activo_id = activo.id 
inner join afijo_activodepreciacion dep on depMax.activo_id = dep.activo_id and depMax.periodo = dep.periodo
left outer join afijo_tipo_activo tpActivo on tpActivo.codigo = activo."tipoActivo" 
;


create view afijo_v_deprec_min as
select 	
    activo.id activo_id, tpActivo.descripcion activo_tipo, activo.nombre activo_nombre, activo.numero_factura, activo.proveedor, activo.fecha_ingreso activo_fecha_compra, activo.valor activo_valor,
    planta.nombre planta_nombre, planta.alias planta_ubicacion, planta.fecha_inicio, planta.fecha_termino, planta.fecha_depreciacion,
	dep.valor_depreciacion, 0 acum_total, 0 acum_anual, dep.duracion_real,
	0 dep_acum, activo.valor neto, dep.periodo, activo.planta_id
from afijo_activo activo
inner join afijo_planta planta          on planta.id = activo.planta_id
inner join ( select activo_id, min(periodo) periodo
			 from afijo_activodepreciacion
			group by activo_id ) depMin on depMin.activo_id = activo.id 
inner join afijo_activodepreciacion dep on depMin.activo_id = dep.activo_id and depMin.periodo = dep.periodo
left outer join afijo_tipo_activo tpActivo on tpActivo.codigo = activo."tipoActivo" 
order by periodo     
;
