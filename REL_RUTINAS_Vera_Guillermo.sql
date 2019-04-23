delimiter //

drop function if exists esPrimo//
drop function if exists sumaN//
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

create function esPalindromo(palabreja varchar(150)) returns tinyint(1) deterministic
comment '3. Función que devuelve si la cadena de texto pasada es palíndromo'
begin
	IF UPPER(REVERSE(palabreja)) = UPPER(palabreja) THEN
		return 1;
	ELSE
		return 0;
	END IF;
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

delimiter ;

create function esPrimo(numerete int) returns tinyint(1) deterministic
comment '7. Función que devuelve si el número pasado es primo'
begin
declare contador int default 2;

	IF numerete = 0 THEN
		return 0;
	ELSEIF numerete = 1 THEN
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

