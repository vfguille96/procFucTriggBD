delimiter //

-- El árbitro no puede tener la misma nacionalidad de los jugadores que está arbitrando.
drop trigger if exists bi_partida//
create trigger bi_partida after insert on partida for each row
begin
	declare paisArbitro char(2);
	declare paisJugadorBlancas char(2);
	declare paisJugadorNegras char(2);

	set paisArbitro = (select pais from participante where nSocio = new.arbitro);
	set paisJugadorBlancas = (select pais from participante where nSocio = new.jugadorBlancas);
	set paisJugadorNegras = (select pais from participante where nSocio = new.jugadorNegras);

	if (paisArbitro in (paisJugadorBlancas, paisJugadorNegras)) then
		signal sqlstate '45000' set MYSQL_ERRNO = 9300, message_text = 'El jugador y árbitro no pueden ser de la misma nacionalidad.';
	end if;

	-- No se pueden vender más entradas que el aforo de la sala.
	declare aforoMax char(2);

	set aforoMax = (select );

	if (new.entradasVendidas > )

	end if;
end//

-- Los jugadores y árbitros se deben alojar en la misma ciudad donde se juega.



-- El mismo jugador no puede jugar con blancas y negras.



delimiter ;