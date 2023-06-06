drop TABLE public.afijo_tipo_activo;
CREATE TABLE public.afijo_tipo_activo (
	codigo varchar(2) NULL,
	descripcion varchar(30) NULL
);
insert into afijo_tipo_activo (codigo, descripcion) values ('A', 'Acondicionamiento');
insert into afijo_tipo_activo (codigo, descripcion) values ('E', 'Edificio');
insert into afijo_tipo_activo (codigo, descripcion) values ('O', 'Obras en curso');
insert into afijo_tipo_activo (codigo, descripcion) values ('M', 'Maquinaria');
insert into afijo_tipo_activo (codigo, descripcion) values ('C', 'Equipos de computación');
insert into afijo_tipo_activo (codigo, descripcion) values ('S', 'Software');
insert into afijo_tipo_activo (codigo, descripcion) values ('U', 'Muebles y Utiles');
