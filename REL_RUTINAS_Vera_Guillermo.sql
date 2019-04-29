delimiter //

drop function if exists esPrimo//
drop procedure if exists generarPrimos//
drop function if exists sucesion//
drop function if exists sumaN//
drop procedure if exists actualizarPuntos//
drop function if exists reverse2//
drop function if exists esPalindromo//
drop function if exists maxTres//
drop function if exists diaSemana//

create function diaSemana(numero smallint) returns varchar(30) deterministic
comment '1. Crear una función llamada diaSemana(n) que reciba un número entero del
1 al 7 y devuelva la cadena que representa dicho día (lunes, martes,
...domingo)'
begin
CASE numero
    WHEN 1 THEN 
    	return 'Lunes'; 
    WHEN 2 THEN 
    	return 'Martes'; 
    WHEN 3 THEN 
    	return 'Miércoles'; 
    WHEN 4 THEN 
    	return 'Jueves'; 
    WHEN 5 THEN 
    	return 'Viernes'; 
    WHEN 6 THEN 
    	return 'Sábado'; 
    WHEN 7 THEN 
    	return 'Domingo'; 
    ELSE 
    	return 'Día de la semana incorrecto.';
END CASE;
end//

create function maxTres(n1 int, n2 int, n3 int) returns int deterministic
comment '2. Crear funcion que devuelva el mayor de los tres números introducidos.'
begin
	return (select GREATEST(n1, n2, n3));
end//

create function esPalindromo(palabreja varchar(255)) returns tinyint(1) deterministic
comment '3. Función que devuelve si la cadena de texto pasada es palíndromo'
begin
	IF UPPER(REVERSE(palabreja)) = UPPER(palabreja) THEN
		return 1;
	ELSE
		return 0;
	END IF;
end//

create function reverse2(cadena varchar(255)) returns varchar(255) deterministic
comment '3.1 Función que devuelve una cadena inversa.'
begin
	declare resultado varchar(255) default '';
	declare contador int default length(cadena);

	WHILE contador > 0 do
		set resultado = CONCAT(resultado, substring(cadena, contador, 1));
		set contador = contador - 1;
	end WHILE;

	return resultado;
end// 

create procedure actualizarPuntos()
comment '4. Procedicimiento actualizar puntos'
begin
	declare puntosLocal int default 0;
	declare puntosVisit int default 0;
	declare contador int default 1;
	declare numMaxEquipo int default 0;
	declare puntosSuma int default 0;

	set numMaxEquipo = (select max(id) from equipo);
	
	WHILE (contador <= numMaxEquipo) DO
		set puntosLocal = (select ifnull(sum(substring_index(resultado,'-',1)), 0) from partido where elocal = contador);
		set puntosVisit = (select ifnull(sum(substring_index(resultado,'-',-1)), 0) from partido where evisitante = contador);

		IF (puntosLocal is null) THEN
			set puntosSuma = puntosVisit;
		ELSEIF (puntosVisit is null) THEN
			set puntosSuma = puntosLocal;
		ELSE
			set puntosSuma = puntosLocal+PuntosVisit;
		END IF;

		update equipo set puntos=puntosSuma where id=contador;

		set contador = contador + 1;
	END WHILE;
	select id,nombre,ciudad,puntos from equipo;
end//

create function sumaN(numerete int) returns bigint deterministic
comment '5. Función que devuelve la suma de los n primeros números'
begin
declare contador int default 0;
declare suma bigint default 0;

	WHILE (contador <= numerete) DO
		set suma = suma + contador;
		set contador =  contador + 1;
	END WHILE;

	return suma;
end//

create function sucesion(m int) returns decimal(20, 19) deterministic
comment '6. Función que devuelve la sucesión de 1/n numeros'
begin
	declare suma decimal(20, 19) default 0;
	WHILE (m > 1) DO
		set suma = suma + 1 / m;
		set m = m - 1;
	END WHILE;
	return suma;
end//

create function esPrimo(numerete int) returns tinyint(1) deterministic
comment '7. Función que devuelve si el número pasado es primo'
begin
declare contador int default 2;

	IF (numerete = 0) THEN
		return 0;
	ELSEIF (numerete = 1) THEN
		return 0;
	ELSE
		WHILE (contador <= SQRT(numerete)) DO
			IF (MOD(numerete, contador) = 0) THEN
				return 0;
			END IF;

			set contador = contador + 1;
		END WHILE;

		return 1;
	END IF;
end//


create table if not exists prueba.primos (numero int)//
create procedure generarPrimos(m int, out salida int)
comment '8. muestra m numeros primos, y salida muestra el numero total mostrado'
begin
	declare numSeguidos int default 2;
	declare numDePrimos int default 0;

	while numSeguidos <= m do

		IF select esPrimo(numSeguidos) THEN
			insert into prueba.primos (numero) values (numSeguidos);
			set numDePrimos = numDePrimos+1;
		END IF;
		set numSeguidos = numSeguidos+1;

	END WHILE;
	set salida = numDePrimos;
end//



create procedure encriptar(cadena varchar(255))
comment '9. Procedicimiento que devuelve la cadena de texto encriptada'
begin
	declare numeroChar int default 0;
	declare longitudCadena int default 0;
	declare contador int default 1;
	declare caracter char(1) default ' ';
	declare cadenaFinal varchar(255) default '';

	set longitudCadena = CHAR_LENGTH(cadena);

	WHILE (contador <= longitudCadena) DO
		set caracter = SUBSTR(cadena, contador, 1);
		set numeroChar = ASCII(caracter);
		set cadenaFinal = CONCAT(cadenaFinal, CHAR(numeroChar + 1));

		set contador = contador + 1;
	END WHILE;

	select cadenaFinal;
end//

delimiter ;