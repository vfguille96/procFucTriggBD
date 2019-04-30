delimiter //

drop trigger if exists ai_empleado//
create trigger ai_empleado after insert on empleado for each row
begin
	if (new.capacitado = 'S') then
		insert into capacitado value (new.codEmp);			
	end if;
end//

drop trigger if exists au_empleado//
create trigger au_empleado after update on empleado for each row
begin
	if (old.capacitado = 'N' and new.capacitado = 'S') then
		insert into capacitado value (new.codEmp);			
	end if;
	if (old.capacitado = 'S' and new.capacitado = 'N') then
		delete from capacitado where old.codEmp = codEmp;		
	end if;
end//

drop trigger if exists bu_edicion//
create trigger bu_edicion before update on edicion for each row
begin
	if (new.profesor is not null) and (old.profesor <> new.profesor is null or old.profesor <> new.profesor) then
		if exists (select * from matricula where fecha = new.fecha and curso = new.codCurso and empleado = new.profesor) then
			signal sqlstate '45000' set mysql_errno = 5005, message_text = 'El profesor ya está asignado como alumno';
		end if;
	end if;

	if not exists (select * from empleado where new.profesor=codEmp and capacitado = 'S') then
		SIGNAL SQLSTATE '45003' SET MESSAGE_TEXT = 'El profesor asignado no está capacitado';			
	end if;
end//

drop trigger if exists bi_edicion//
create trigger bi_edicion before insert on edicion for each row
begin
	if not exists (select * from empleado where capacitado = 'S' and new.profesor=codEmp) then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El profesor asignado no está capacitado';			
	end if;
	
/*	if exists (select * from matricula where new.profesor = empleado and new.curso = codCurso and new.fecha = fecha) then
		SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El profesor no puede ser alumno a la vez.';
	end if;*/
end//

/*drop trigger if exists bi_matricula//
create trigger bi_matricula before insert on matricula for each row
begin
	declare error_clave_primaria condition for SQLSTATE '21000';
	declare cursoRequerido varchar(15);
	if (select new.curso in (select curso from prerreq p1 where obligatorio and cursoReq not in (select curso from matricula where empleado = new.empleado))) then
		set foreign_key_checks = 0;
		set cursoRequerido = (select curso from prerreq p1 where obligatorio and cursoReq not in (select curso from matricula where empleado = new.empleado));
		SIGNAL error_clave_primaria SET MESSAGE_TEXT = 'El curso a insertar requiere otro curso';
	end if;
end//*/

delimiter ;