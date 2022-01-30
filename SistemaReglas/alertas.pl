/*
Sistema de generación de alertas en entorno turístico (Prolog?):

    - ¿A quién le mandas la alerta? Socorrista, Vigilantes, Limpieza, Ayuntamiento, Policía...
    - Animales en la playa...
    - Bañistas o Embarcaciones en zonas prohibidas/peligrosas.
    - Condiciones meteorológicas, banderas para el baño...
    - Situaciones de aforo (?)
    - Algo de embarcaciones del puerto (?)
    - Detección de basura
    - Detectar barco conocido/identificado vs no identificado
    - Urgencia/Importancia/Nivel de la alerta.
    - Utilizar una abstracción de regiones.
    - oleaje  o marea
*/

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

/* alertas alta prioridad */

alerta(limpieza, Region) :- detectado(basura, Region). % alerta de limpieza basura 
alerta(aforo, Region) :- aforo_act(Region, N), aforo_max(Region, M), N > M. % alerta por superar aforo
alerta(Objeto, Region) :- detectado(Objeto, Region), (prohibido(Objeto, Region); area_prohibida(Region)). % alerta persona/objeto en zona prohibida
alerta(personaEnPeligro, Region) :- detectado(persona, Region), bandera(roja, Region). % alerta bañista en zona con bandera roja
alerta(oleaje, Region) :- oleaje(fuerte, Region), not(bandera(roja, Region)).
alerta(barcoNoIdentificado, Region) :- detectado(barcoNoIdentificado, Region). % detección de posible patera o narco lancha

alertar(Sujeto, Motivo, Lugar) :- alerta(Motivo, Lugar), responsable(Sujeto, Motivo).

/* avisos media-baja prioridad */

/* Si supera el aforo maximo salta alerta */
aviso(aforo, Porcentaje, Region) :- aforo_act(Region, A), aforo_max(Region, M), A > 0.75 * M, A < M + 1, Porcentaje is A / M.
/*
aviso(aforo95, Region) :- aforo_act(Region, N), aforo_max(Region, M), N > 0.95 * M.
aviso(aforo90, Region) :- aforo_act(Region, N), aforo_max(Region, M), N > 0.9 * M, not(aviso(aforo95, Region)).
aviso(aforo80, Region) :- aforo_act(Region, N), aforo_max(Region, M), N > 0.8 * M, not(aviso(aforo95, Region)), not(aviso(aforo90, Region)).
*/

/* aviso cuando la ocupación de hamacas es alta */
aviso(hamacas, Porcentaje, Region) :- numHamacas(M, Region), hamacasOcupadas(H, Region), H > 0.75 * M, Porcentaje is H / M. %, string_concat(hamacas, Porcentaje, Hamacas).
/*
aviso(hamacas100, Region) :- numHamacas(M, Region), hamacasOcupadas(N, Region), M = N.
aviso(hamacas90, Region) :- numHamacas(M, Region), hamacasOcupadas(N, Region), M90 is M * 0.90, N > M90, not(aviso(hamacas100, Region)).
aviso(hamacas75, Region) :- numHamacas(M, Region), hamacasOcupadas(N, Region), M75 is M * 0.75, N > M75, not(aviso(hamacas100, Region)), not(aviso(hamacas90, Region)).
*/

/* aviso cuando la ocupacion de amarres del puerto es alta */
aviso(amarres, Porcentaje, Region) :- numAmarres(M, Region), amarresOcupados(A, Region), A > 0.75 * M, Porcentaje is A / M. %, string_concat(amarres, Porcentaje, Amarres).
/*
aviso(amarres100, Region) :- numAmarres(M, Region), amarresOcupados(N, Region), M = N.
aviso(amarres90, Puerto) :- numAmarres(M, Puerto), amarresOcupados(N, Puerto), M90 is M * 0.90, N > M90, not(aviso(amarres100, Region)).
aviso(amarres75, Puerto) :- numAmarres(M, Puerto), amarresOcupados(N, Puerto), M75 is M * 0.75, N > M75, not(aviso(amarres100, Region)), not(aviso(amarres90, Region)).
*/

avisar(Sujeto, Mensaje, Lugar) :- aviso(Motivo, Porcentaje, Lugar), responsable(Sujeto, Motivo), string_concat(Motivo, Porcentaje, Mensaje).