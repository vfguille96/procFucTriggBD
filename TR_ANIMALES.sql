drop table if exists animal_count;
drop table if exists animal;

create table animal(
	id int auto_increment primary key,
	nombre varchar(10) not null
);

create table animal_count(numero int default 0);
insert into animal_count values (0);

delimiter //

create trigger bi_animal before insert on animal
for each row
begin
	if (length(new.nombre) > 8) then
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 9123, MESSAGE_TEXT = 'Nombre demasiado largo.';
	end if;

	if (new.nombre is null) then
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 9124, MESSAGE_TEXT = 'Nombre no asignado.';
	end if;

	if (select numero from animal_count) > 9 then
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 9125, MESSAGE_TEXT = 'Límite de animales superado.';
	end if;
end//

create trigger ai_animal after insert on animal
for each row
begin
	update animal_count set numero = numero + 1;
end//

create trigger bu_animal before update on animal
for each row
begin
	if (length(new.nombre) > 8) then
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 9123, MESSAGE_TEXT = 'Nombre demasiado largo.';
	end if;

	if (new.nombre is null) then
		SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO = 9124, MESSAGE_TEXT = 'Nombre no asignado.';
	end if;
end//

create trigger ad_animal after delete on animal
for each row
begin
	update animal_count set numero = numero -1;
end//


delimiter ;

-- insert into animal(nombre) values ('Tortuga'), ('Pavana'), ('Cebrasa'), ('Ornitorrinco'), ('Ñu'), ('Perraso'), ('Cigüeñasa'), ('Er Bila'), ('Pato'), ('Rata'), ('Rana');