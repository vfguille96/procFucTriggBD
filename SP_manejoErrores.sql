delimiter //

drop procedure if exists insertarJugador//

create procedure insertarJugador(unNombre varchar(50), 
								unApellido varchar(50), 
								unaAltura decimal(3, 2), 
								unPuesto varchar(15), 
								unEquipo smallint
)
comment 'Inserta un nuevo jugador en la tabla liga.jugador con gestión de excepciones'
begin
	DECLARE errno SMALLINT UNSIGNED DEFAULT 9180;
	declare unID smallint;
	declare unCapitan smallint;


	declare exit handler for 1265
	begin
		select concat('ERROR: El jugador ', unNombre, ' ', unApellido, ' no tiene un puesto válido.') as Warning;
	end;

	declare exit handler for 1452
	begin
		select concat('ERROR: El jugador ', unNombre, ' ', unApellido, ' está asignado a un equipo no válido.') as Warning;
	end;

	declare exit handler for 4025
	begin
		select concat('ERROR: El jugador ', unNombre, ' ', unApellido, ' no tiene una altura válida.') as Warning;
	end;

	set unID = (select ifnull(max(id) + 1, 1) from jugador); 

	if (select unNombre not rlike '^[A-z]*$A-z]*$') then
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = errno, MESSAGE_TEXT = 'Nombre incorrectamente formado.';
	end if;

/*
	if unaAltura > 2.72 then
		signal sqlstate '22003' set mysql_errno = 1264, message_text = 'Altura maxima superada';
	end if;
	*/

	set unCapitan =(select capitan from equipo where id = unEquipo);


	insert into jugador(id, nombre, apellido, altura, puesto, fecha_alta, equipo, capitan) 
		values (unID, unNombre, unApellido, unaAltura, unPuesto, date(now()), unEquipo, unCapitan);

	

end//

delimiter ;