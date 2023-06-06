drop view afijo_v_deprec_acum ;

create view afijo_v_deprec_acum as
select
	activo.id activo_id, tpActivo.descripcion activo_tipo, activo.nombre activo_nombre, activo.numero_factura, activo.proveedor, activo.fecha_ingreso activo_fecha_compra, activo.valor activo_valor,
    planta.nombre planta_nombre, planta.ubicacion planta_ubicacion, planta.fecha_inicio, planta.fecha_termino, planta.fecha_depreciacion,
	dep.valor_depreciacion, dep.acum_total, dep.acum_anual, dep.duracion_real,
	dep.acum_total - dep.acum_anual dep_acum, activo.valor - dep.acum_total neto,
	dep.periodo
from afijo_activodepreciacion dep
inner join afijo_activo activo on activo.id = dep.activo_id
inner join afijo_planta planta  on planta.id = dep.planta_id
left outer join afijo_tipo_activo tpActivo on tpActivo.codigo = activo."tipoActivo";
/*
union 
select
	activo.id, tpActivo.descripcion activo_tipo,activo.nombre cActivo, activo.numero_factura, activo.proveedor, activo.fecha_ingreso, activo.valor,
    planta.nombre, planta.ubicacion, planta.fecha_inicio, planta.fecha_termino, planta.fecha_depreciacion,
	dep.valor_depreciacion, 0 acum_total, 0 acum_anual, dep.duracion_real,
	0 dep_acum, activo.valor neto,
	dep.periodo + interval '-1 month' periodo
from afijo_activo activo
inner join afijo_planta planta  on planta.id = activo.planta_id
inner join afijo_activodepreciacion dep 
                    on   dep.activo_id = activo.id 
--     			   and   substring(cast( dep.periodo + interval '-1 month' as varchar),1,7) = substring(cast(activo.fecha_ingreso as varchar),1,7)
     			   and   dep.periodo >= activo.fecha_ingreso 
left outer join afijo_tipo_activo tpActivo on tpActivo.codigo = activo."tipoActivo" 
where not exists ( select '1' 
     			   from   afijo_activodepreciacion dep_x
     			   where  dep_x.activo_id = activo.id 
    			   and    substring(cast(dep_x.periodo as varchar),1,7) = substring(cast(activo.fecha_ingreso as varchar),1,7)
    			 ) 
; 
*/  
select 
	activo.id, tpActivo.descripcion activo_tipo,activo.nombre cActivo, activo.numero_factura, activo.proveedor, activo.fecha_ingreso, activo.valor,
    planta.nombre, planta.ubicacion, planta.fecha_inicio, planta.fecha_termino, planta.fecha_depreciacion,
	dep.valor_depreciacion, 0 acum_total, 0 acum_anual, dep.duracion_real,
	0 dep_acum, activo.valor neto,
	dep.periodo + interval '-1 month' periodo
from afijo_activo activo
inner join afijo_planta planta  on planta.id = activo.planta_id

inner join afijo_activodepreciacion dep 
                    on   dep.activo_id = activo.id 
     			   and   substring(cast( dep.periodo + interval '-1 month' as varchar),1,7) = substring(cast(activo.fecha_ingreso as varchar),1,7)
left outer join afijo_tipo_activo tpActivo on tpActivo.codigo = activo."tipoActivo" 
where not exists ( select '1' 
     			   from   afijo_activodepreciacion dep_x
     			   where  dep_x.activo_id = activo.id 
    			   and    substring(cast(dep_x.periodo as varchar),1,7) = substring(cast(activo.fecha_ingreso as varchar),1,7)
    			 ) 
;

select * from afijo_v_deprec_acum 
where activo_id = 32074
order by periodo desc
;

select dep.activo_id , , , 
from afijo_activodepreciacion dep 
where activo_id = 32074
group by dep.activo_id 
;


drop view afijo_v_deprec_max ;

create view afijo_v_deprec_max as
select 	
    activo.id activo_id, tpActivo.descripcion activo_tipo, activo.nombre activo_nombre, activo.numero_factura, activo.proveedor, activo.fecha_ingreso activo_fecha_compra, activo.valor activo_valor,
    planta.nombre planta_nombre, planta.ubicacion planta_ubicacion, planta.fecha_inicio, planta.fecha_termino, planta.fecha_depreciacion,
	dep.valor_depreciacion, dep.acum_total, dep.acum_anual, dep.duracion_real,
	dep.acum_total dep_acum, activo.valor neto, dep.periodo
from afijo_activo activo
inner join afijo_planta planta          on planta.id = activo.planta_id
inner join ( select activo_id, max(periodo) periodo
			 from afijo_activodepreciacion
			group by activo_id ) depMax on depMax.activo_id = activo.id 
inner join afijo_activodepreciacion dep on depMax.activo_id = dep.activo_id and depMax.periodo = dep.periodo
left outer join afijo_tipo_activo tpActivo on tpActivo.codigo = activo."tipoActivo" 
;

drop view afijo_v_deprec_min ;

create view afijo_v_deprec_min as
select 	
    activo.id activo_id, tpActivo.descripcion activo_tipo, activo.nombre activo_nombre, activo.numero_factura, activo.proveedor, activo.fecha_ingreso activo_fecha_compra, activo.valor activo_valor,
    planta.nombre planta_nombre, planta.ubicacion planta_ubicacion, planta.fecha_inicio, planta.fecha_termino, planta.fecha_depreciacion,
	dep.valor_depreciacion, 0 acum_total, 0 acum_anual, dep.duracion_real,
	0 dep_acum, activo.valor neto, dep.periodo
from afijo_activo activo
inner join afijo_planta planta          on planta.id = activo.planta_id
inner join ( select activo_id, min(periodo) periodo
			 from afijo_activodepreciacion
			group by activo_id ) depMin on depMin.activo_id = activo.id 
inner join afijo_activodepreciacion dep on depMin.activo_id = dep.activo_id and depMin.periodo = dep.periodo
left outer join afijo_tipo_activo tpActivo on tpActivo.codigo = activo."tipoActivo" 
order by periodo     
;
