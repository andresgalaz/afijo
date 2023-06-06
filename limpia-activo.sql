truncate table public.afijo_activodepreciacion;
truncate table public.afijo_activo cascade;
ALTER SEQUENCE public.afijo_activo_id_seq RESTART WITH 1;
ALTER sequence public.afijo_activodepreciacion_id_seq RESTART WITH 1;