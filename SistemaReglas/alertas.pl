
/* hechos */

aforo_act(region1, 4).
aforo_max(region1, 5).
detectado(basura, region1).
detectado(perro, region1).
detectado(persona, regionP).
prohibido(perro, region1).
area_prohibida(regionP).
bandera(roja, region2).
oleaje(suave, region2).

responsable(equipoLimpieza, limpieza).
responsable(vigiliantes, aforo).
responsable(socorristas, personaEnPeligro).
responsable(socorristas, oleaje).
responsable(policia, persona).
responsable(policia, perro).
responsable(salvamentoMaritimo, barcoNoIdentificado).
responsable(guardiaCivil, barcoNoIdentificado).
responsable(empresaHamacas, hamacas).
responsable(responsablePuerto, amarres).

numHamacas(10, region3).
hamacasOcupadas(8, region3).
numAmarres(25, puerto1).
amarresOcupados(20, puerto1).

/* reglas */
/* alertas alta prioridad */

/* alerta de limpieza basura */
alerta(limpieza, Region) :- detectado(basura, Region).

/* alerta por superar aforo */
alerta(aforo, Region) :- aforo_act(Region, N), aforo_max(Region, M), N > M.

/* alerta persona/objeto en zona prohibida */
alerta(Objeto, Region) :- detectado(Objeto, Region), (prohibido(Objeto, Region); area_prohibida(Region)).

/* alerta bañista en zona con bandera roja */
alerta(personaEnPeligro, Region) :- detectado(persona, Region), bandera(roja, Region).

/* alerta cuando el oleaje es fuerte y no hay bandera roja */
alerta(oleaje, Region) :- oleaje(fuerte, Region), not(bandera(roja, Region)).

/* detección de posible patera o narco lancha */
alerta(barcoNoIdentificado, Region) :- detectado(barcoNoIdentificado, Region).

alertar(Sujeto, Motivo, Lugar) :- alerta(Motivo, Lugar), responsable(Sujeto, Motivo).

/* avisos media-baja prioridad */

/* Si supera el aforo maximo salta alerta */
aviso(aforo, Porcentaje, Region) :- aforo_act(Region, A), aforo_max(Region, M), A > 0.75 * M, A < M + 1, Porcentaje is A / M.

/* aviso cuando la ocupación de hamacas es alta */
aviso(hamacas, Porcentaje, Region) :- numHamacas(M, Region), hamacasOcupadas(H, Region), H > 0.75 * M, Porcentaje is H / M. %, string_concat(hamacas, Porcentaje, Hamacas).

/* aviso cuando la ocupacion de amarres del puerto es alta */
aviso(amarres, Porcentaje, Region) :- numAmarres(M, Region), amarresOcupados(A, Region), A > 0.75 * M, Porcentaje is A / M. %, string_concat(amarres, Porcentaje, Amarres).

avisar(Sujeto, Mensaje, Lugar) :- aviso(Motivo, Porcentaje, Lugar), responsable(Sujeto, Motivo), string_concat(Motivo, Porcentaje, Mensaje).