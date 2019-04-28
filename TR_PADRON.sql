delimiter //

/*create trigger bi_habitante before insert on habitante
for each row
begin
	if (select ) then
		SIGNAL SQLSTATE '45000' set MESSAGE_TEXT = 'El habitante sólo puede estar empadronado en una ciudad.';
	end if;
end//*/


--Controla que todo municipio tenga al menos alguien empadronado
drop trigger if exists bd_empadronado//
create trigger bd_empadronado before delete on habitante for each row

begin
	
	if (select count(*) from habitante where empadronadoEn = old.empadronadoEN) = 1 then
		signal sqlstate '05002' set message_text = 'Todo municipio debe tener al menos una persona empadronada en él';
	end if;

end//

--Controla que todo municiopio tenga al menos una vivienda, en caso de ser la última no se puede borrar.
drop trigger if exists bd_vivienda//
create trigger bd_vivienda before delete on vivienda for each row
begin
	
	if (select count(*) from vivienda where municipio = old.municipio) = 1 then
		signal sqlstate '05001' set message_text = 'Todo municipio debe tener al menos una vivienda';
	end if;

end//

--Controla que toda propiedad tenga al menos un propietario, en caso de ser la última no se puede borrar.
create trigger bd_propiedad before delete on propiedad for each row
begin
	
	if (select count(*) from propiedad where propietario = old.propietario) = 1 then
		signal sqlstate '05001' set message_text = 'Toda vivienda debe tener al menos un propietario';
	end if;

end//

--Controla que toda propiedad tenga al menos un propietario
create trigger bi_propiedad before insert on propiedad for each row
begin
	
	if (select count(*) from propiedad where propietario = old.propietario) = 5 then
		signal sqlstate '05001' set message_text = 'Toda vivienda debe tener como máximo 5 propietarios';
	end if;

end//



delimiter ;