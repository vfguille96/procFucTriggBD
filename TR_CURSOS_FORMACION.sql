delimiter //

drop trigger if exists bi_edicion//
create trigger bi_edicion before insert on edicion for each row
begin
	if not exists (select * from empleado where capacitado and new.profesor=idEmpleado) then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El profesor asignado no está capacitado';			
	end if;
	if (new.fecha < curdate()) then 
		SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Rango de fecha incorrecto.';
	
	if exists (select * from asistente where new.profesor = empleado and new.curso = cursoEd and new.fecha = fechaEd) then
		SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El profesor no puede ser alumno a la vez.';
end//


drop trigger if exists bu_edicion:
create trigger bu_edicion before update on edicion for each row
begin
	if not exists (select * from empleado where new.profesor=idEmpleado and capacitado) then
		SIGNAL SQLSTATE '45003' SET MESSAGE_TEXT = 'La edición está en el pasado';			
	end if;
end//


drop trigger if exists bi_asistente:
create trigger bi_asistente before insert on asistente for each row
begin
	if exists (select * from edicion where profesor = new.empleado and curso = new.cursoEd and fecha = new.fechaEd) then
		SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El profesor no puede ser alumno a la vez.';			
	end if;
end//

delimiter ;