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

drop function if exists cumpleRequisitios//
create function cumpleRequisitios(fechaReq date, emp char(5), cur char(15)) returns tinyint(1) deterministic
begin
	declare salida tinyint(1) default 0;
	declare cursoRequerido char(15);

	declare cursorMatricula cursor for (select cursoReq from prerreq where curso = cur and obligatorio);
	declare continue handler for not found set salida = 1;

	open cursorMatricula;

	while (not salida) do
		fetch cursorMatricula into cursoRequerido;

		if (salida) then
			close cursorMatricula;
			return 1;
		end if;

		if not exists (select * from matricula where curso = cursoRequerido and fecha < fechaReq and empleado = emp) then
			close cursorMatricula;
			return 0;
		end if;

	end while;
end//

drop trigger if exists bi_matricula//
create trigger bi_matricula before insert on matricula for each row
begin
	if exists (select * from edicion where codCurso = new.curso and fecha = new.fecha and profesor = new.empleado) then
		SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El profesor no puede ser alumno a la vez.';
	end if;

	if exists (select * from prerreq where prerreq.curso = new.curso and obligatorio) then
		if not cumpleRequisitios(new.fecha, new.empleado, new.curso) then
			signal sqlstate '45000' set mysql_errno = 5006, message_text = 'El empleado no cumple los requisitos.';
		end if;
	end if;
end//

drop trigger if exists bu_matricula//
create trigger bu_matricula before update on matricula for each row
begin

-- No se puede modificar nada de matrícula.
signal sqlstate '45000' set mysql_errno = 5007, message_text = 'No se puede modificar nada de matrícula.';

/*	if exists (select * from edicion where curso = new.curso and fecha = new.fecha and profesor = new.empleado) then
		SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El profesor no puede ser alumno a la vez.';
	end if;

	if exists (select * from prerreq where prerreq.curso = new.curso and obligatorio) then
		if not cumpleRequisitios(new.fecha, new.empleado, new.curso) then
			signal sqlstate '45000' set mysql_errno = 5006, message_text = 'El empleado no cumple los requisitos.';
		end if;
	end if;*/
end//

drop trigger if exists ad_matricula//
create trigger ad_matricula before delete on matricula for each row
begin
	insert into matriculasBorradas values (old.fecha, old.curso, old.empleado, user(), current_timestamp());
end//

delimiter ;