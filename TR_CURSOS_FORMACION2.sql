delimiter //

drop trigger if exists ai_empleado//
create trigger ai_empleado after insert on empleado for each row
begin
	if (new.capacitado = 'S') then
		insert into capacitado (codEmp) values (new.codEmp);			
	end if;
end//

drop trigger if exists au_empleado//
create trigger au_empleado after update on empleado for each row
begin
	if (old.capacitado = 'N' and new.capacitado = 'S') then
		insert into capacitado (codEmp) values (new.codEmp);			
	end if;
	if (old.capacitado = 'S' and new.capacitado = 'N') then
		delete from capacitado (codEmp) where old.codEmp = codEmp;		
	end if;
end//

drop trigger if exists bu_edicion//
create trigger bu_edicion before update on edicion for each row
begin
	if (new.profesor is not null) and (old.profesor <> new.profesor) then
		if exists (select * from matricula where fecha = new.fecha and curso = new.codCurso and empleado = new.profesor) then
			signal sqlstate '45000' set mysql_errno = 5005, message_text = 'El profesor ya está asignado como alumno';
		end if;
	end if;
end//

delimiter ;