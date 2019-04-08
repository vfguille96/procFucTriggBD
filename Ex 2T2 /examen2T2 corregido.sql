1- 
Si deja hacer el sistema, sudo mysql -u root 


sudo mysqld_secure_installation 
matar el proceso: sudo service mysql stop
sudo mysqld_safe --skip-grant-tables
update mysql.user set password = password('123') where user = 'root';

borrar el plugin, cierro y reiniciar el servicio



2- 
	drop table if exists dvd;
	drop table if exists pais;

	create table pais(
		nombre varchar(100) not null,
		name varchar(100) not null,
		nom varchar(100) not null,
		iso2 char(2) primary key,
		iso3 char(3) unique not null,
		phoneCode varchar(5) not null
	);

	create table dvd(
		codigo int primary key,
		titulo varchar(150) not null,
		artista varchar(100) not null,
		pais char(2) not null,
		compania varchar(100) not null,
		precio decimal(4, 2) null,
		anio char(4) null,

		foreign key (pais) references pais(iso2) on update cascade on delete restrict
	);


3- 
load data infile '/tmp/pais.csv' into table pais character set latin1 fields terminated by '*' ignore 6 lines;
load data infile '/tmp/dvd.csv' into table dvd fields terminated by ';' ignore 5 lines;

4-
CREATE USER 'operador'@'%' IDENTIFIED BY 'op123';
grant select, update, delete, alter on exdvd.* to 'operador'@'%' identified by 'op123';

5-
grant file on *.* to 'operador'@'%' identified by 'op123';

6-
revoke delete on exdvd.* from 'operador'@'%';

7-
create table t1(id int, nombre char(100), fNac date, sueldo decimal(8,2))engine=innodb;
grant select(id, nombre) on exdvd.t1 to 'operador'@'%' identified by 'op123';

8-
set password for 'operador'@'%' = password('op2019');

9-
revoke all, grant option from 'vendedor'@'%';

10-
show grants;

11-
-Sesión a:
begin;
select * from t1 where sueldo between 500 and 1000 for update;
update t1 set suueldo = sueldo * 1.10 where sueldo between 500 and 1000;

-Sesión b:
begin;
select * from t1 where sueldo between 300 and 499 lock in share mode;


Hay bloqueo porque el motor necesita un índice único, no puede haber dos filas con el mismo sueldo para bloquear a nivel de fila. 
Si los índices no son bloqueantes (o no hay), se bloquea la tabla entera.


12-
-Sesión root:
create table t3(valor int)engine=innodb;
insert into t3(valor) values (0);
grant all on exdvd.t3 to 'operador'@'%' identified by 'op2019';

begin;
select valor from t3 where valor = 0 for update;
update t3 set valor = (valor + 1) where valor = 0;
select valor from t3; (ve los cambios reflejados)
commit;


-Sesión operador:
begin;
select valor from t3 where valor = 0 for update; (la consulta queda en espera porque el usuario root se ha reservado (intent) el valor justo antes. 
Obtiene un 'Empty set' si el usuario root ha modificado el valor antes que se exceda el timeout.
select valor from t3; (aún ve valor '0', dado que el nivel de aislamiento REPEATABLE READ da una 'lectura sucia'. Hasta que no finalice su transacción no podrá ver el valor actualizado por el usuario root.)
rollback;

select valor from t3; (ve el valor '1'. Si se le permite, podrá volver a actualizar el valor en una nueva transacción.) 

begin;
select valor from t3 where valor = 1 for update;
update t3 set valor = (valor + 1) where valor = 1;
select valor from t3;
commit;

13-
El nivel de aislamiento por defecto en motores transaccionales innoDB es REPEATABLE READ. 
Este nivel de aislamiento de transacciones nos muestra una lectura consistente de los datos durante toda la transacción. 
Es decir, una vez se empiece una transacción, los datos son los mismos hasta que se confirme la transacción.
Otro usuario puede modificar los datos de otras tuplas mientras un usuario realiza una transacción de la misma tabla y los cambios no se verán reflejados hasta que finalice su transacción.

14- 
El nivel de aislamiento que no permite 'lecturas sucias' en motores transaccionales innoDB es READ COMMITTED. 
Este nivel de aislamiento de transacciones nos muestra una 'lectura limpia' de los datos durante toda la transacción, al contrario que REPEATABLE READ y también no muestra cambios pendientes de confirmar, sólo cambios confirmados. 
Es decir, una vez se empiece una transacción, los datos mostrados pueden variar durante el transcurso de la transacción.
Otro usuario puede modificar los datos de otras tuplas mientras un usuario realiza una transacción de la misma tabla, los cambios se verán reflejados durante la transacción.