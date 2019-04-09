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

drop function if exists estadoRef//

create function estadoRef(estado char(1)) returns varchar(20) deterministic
comment 'estado = P -> caducado, estado = 0 -> activo, estado = N -> nuevo'
begin
	declare resultado varchar(20);

	case upper(estado)
	when 'P' then
		set resultado = 'caducado';
	when '0' then
		set resultado = 'activia';
	when 'N' then
		set resultado = 'nuevo';
	else set resultado = 'desconocido';
	end case;
	return resultado;
end//

drop function if exists parImpar//

create function parImpar(numero int) returns varchar(5) deterministic
comment 'Comprueba si el número entero es par o impar'
begin
	declare resultado varchar(5);

	case (mod(numero, 2) = 0)
	when 1 then
		set resultado = 'PAR';
	when 0 then
		set resultado = 'IMPAR';
	end case;
	return resultado;
end//

drop procedure if exists parImparProc//

create procedure parImparProc(numero int)
comment 'Comprueba si el número entero es par o impar'
begin
	select parImpar(numero) as pariedad;
end//


drop function if exists hipotenusa//

create function hipotenusa(a double, b double) returns decimal(5, 2) deterministic
comment 'Cálculo de la hipotenusa a partir de sus lados'
begin
	return (sqrt((a * a)) + (b * b));
end//

drop function if exists totalPuntos//

create function totalPuntos(fechaPartido date) returns int deterministic
comment 'Devuelve la suma total de puntos de un partido dado una fecha.'
begin
	return ((select cast(substring_index(resultado, '-', 1) as int) from partido where fecha = fechaPartido) + 
		(select cast(substring_index(resultado, '-', -1) as int) from partido where fecha = fechaPartido));
end//


drop procedure if exists totalPuntosProc//

create procedure totalPuntosProc(in fechaPartido date, in local smallint(6), in visitante smallint(6), 
	out acumuladoPuntos smallint, out estado tinyint)
comment 'Devuelve la suma total de puntos de un partido dado una fecha, equipo local, visitantes y devuelve también el estado: 0, 1, 2'
begin
	declare marcador char(7);

	if not exists (select * from partido where fecha = fechaPartido and elocal = local and evisitante = visitante) then
		set estado = 2;
	else 
		set marcador = (select resultado from liga.partido where fecha = fechaPartido and elocal = local and evisitante = visitante);

		if marcador is null then
			set estado = 1;
		else 
			set estado = 0;
			set acumuladoPuntos = cast(substring_index(marcador, '-', 1) as int) + cast(substring_index(marcador, '-', -1) as int);
		end if;
	end if;
end//

drop function if exists palindromo//

create function palindromo(palabreja varchar(255)) returns tinyint(1) deterministic
comment 'Función que comprueba si una palabra es palíndromo.'
begin
	return (select lower(replace(reverse(palabreja), ' ', ''))) = replace(lower(palabreja), ' ', '');
end//


drop function if exists movimiento//

create function movimiento(idC int, fechaT date, cantidadB decimal(8, 2)) returns smallint deterministic
comment 'Comprueba si una transacción en una cuenta bancaria se lleva a cabo. 0 -> OK, -1 -> Descubierto, -2 -> fecha futuro, -3 -> idCuenta no existe'
begin
	declare idACalcular int;
	declare saldoB decimal(10, 2);

	if fechaT > date(now()) then
		return -2;
	end if;

	if idC not in (select id from cuenta) then
		return -3;
	end if;

	set saldoB = (select saldo from cuenta where id = idC);

	if (saldo + cantidadB < 0) then
		return -1;
	end if;

	set idACalcular = ((select max(id) from movimiento where fecha = fechaT) + 1);
	insert into movimiento(fecha, id, cuenta, cantidad) values (fechaT, idACalcular, idC, cantidad);
	update cuenta set saldo = saldoB + cantidadB where id = idC;

	return 0;
end//


delimiter ;

