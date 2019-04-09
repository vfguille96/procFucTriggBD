delimiter //

drop function if exists movimientoT//

create function movimientoT(idC int, fechaT date, cantidadB decimal(8, 2)) returns smallint deterministic
comment 'Comprueba si una transacción en una cuenta bancaria se lleva a cabo. 0 -> OK, -1 -> Descubierto, -2 -> fecha futuro, -3 -> idCuenta no existe'
begin
	declare idACalcular int;
	declare saldoB decimal(10, 2);

	if fechaT > date(now()) then
		return -2;
	end if;

	if idC not in (select id from cuenta) then
		return -3;
	end if;

	set saldoB = (select saldo from cuenta where id = idC);

	if (saldo + cantidadB < 0) then
		return -1;
	end if;

	if (select max(id) from movimiento) is null then
		set idACalcular = 0;
	else 
		set idACalcular = ((select max(id) from movimiento where fecha = fechaT) + 1);
	end if;

	insert into movimiento(fecha, id, cuenta, cantidad) values (fechaT, idACalcular, idC, cantidad);
	update cuenta set saldo = saldoB + cantidadB where id = idC;

	return 0;
end//


delimiter ;