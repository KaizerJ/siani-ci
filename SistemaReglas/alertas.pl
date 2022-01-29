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

aforo_act(region1, 6).
aforo_max(region1, 5).
detectado(basura, region1).
detectado(perro, region1).
prohibido(perro, region1).
area_prohibida(regionP).
detectado(persona, regionP).
bandera(roja, region2).

responsable(equipoLimpieza, limpieza).
responsable(vigiliantes, aforo).
responsable(personaEnPeligro, socorristas).
responsable(oleaje, socorristas).
responsable(persona, policia).
responsable(perro, policia).

numHamacas(10, region3).
hamacasOcupadas(8, region3).
numAmarres(25, puerto1).
amarresOcupados(20, puerto1).

responsable(empresaHamacas, hamacas75).
responsable(empresaHamacas, hamacas90).
responsable(responsablePuerto, amarres75).
responsable(responsablePuerto, amarres90).

/* alertas alta prioridad */

alerta(limpieza, Region) :- detectado(basura, Region). % alerta de limpieza basura 
alerta(aforo, Region) :- aforo_act(Region, N), aforo_max(Region, M), N > M. % alerta por superar aforo
alerta(Objeto, Region) :- detectado(Objeto, Region), (prohibido(Objeto, Region); area_prohibida(Region)). % alerta persona/objeto en zona prohibida
alerta(personaEnPeligro, Region) :- detectado(persona, Region), bandera(roja, Region). % alerta bañista en zona con bandera roja
alerta(oleaje, Region) :- oleaje(fuerte, Region), not(bandera(roja, Region)).

alertar(Sujeto, Motivo, Lugar) :- alerta(Motivo, Lugar), responsable(Sujeto, Motivo).

/* avisos media-baja prioridad */

aviso(hamacas75, Region) :- numHamacas(M, Region), hamacasOcupadas(N, Region), M75 is M * 0.75, N > M75.
aviso(hamacas90, Region) :- numHamacas(M, Region), hamacasOcupadas(N, Region), M90 is M * 0.90, N > M90.
aviso(amarres75, Puerto) :- numAmarres(M, Puerto), amarresOcupados(N, Puerto), M75 is M * 0.75, N > M75.
aviso(amarres90, Puerto) :- numAmarres(M, Puerto), amarresOcupados(N, Puerto), M90 is M * 0.90, N > M90.

avisar(Sujeto, Motivo, Lugar) :- aviso(Motivo, Lugar), responsable(Sujeto, Motivo).