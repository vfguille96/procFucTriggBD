delimiter //

drop procedure if exists contarFilas//

create procedure contarFilas(OUT numeroFilas INT)
	sql security invoker
	comment 'Primer ejemplo de una PA'
	begin
		set numeroFilas = (select count(*) from jugador);
	end//

drop procedure if exists listarJugadores//

create procedure listarJugadores()
	sql security invoker
	comment 'Lista jugadores'
	begin
		select * from jugador;
	end//

drop procedure if exists nJugadores//

create procedure nJugadores(in eq int, out n int)
	sql security definer
	comment 'Cuantos jugadores hay en el equipo dado'
	begin
		set n = (select count(*) from jugador where equipo = eq);
	end//


drop function if exists fnJugadores//

create function fnJugadores(eq int) returns int deterministic
	comment 'Funcion que devuelve el numero de jugadores dado un equipo' 
	begin
		 return (select count(*) from jugador where equipo = eq);
	end//

drop function if exists holaMundo//

create function holaMundo() returns varchar(200) deterministic
	comment 'Hola MUndo'
	begin
		return '¡Hola Mundo!';
	end//

drop procedure if exists fechaAlea//

create procedure fechaAlea() not deterministic
	comment 'Devuelve la fecha actual del sistema y un número aleatorio'
	begin
		select now() as hoy, rand() as aleatorio;
	end//

drop function if exists estado//

create function estado(estado char(1)) returns varchar(20) deterministic
comment 'estado = P -> caducado, estado = 0 -> activo, estado = N -> nuevo'
begin
	declare resultado varchar(20);
	declare miEstado char(1);

	set miEstado = (upper(estado));

	if miEstado = 'P' then
		set resultado = 'caducado';
	elseif miEstado = '0' then
		set resultado = 'activia';
	elseif miEstado = 'N' then
		set resultado = 'nuevo';
	end if;
	return resultado;
end//

delimiter ;

