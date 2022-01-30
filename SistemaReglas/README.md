# Sistema de alertas y avisos para un sistema de vigilancia en la playa
## Fecha: 30/01/2022
## Autor: Jonay Suárez Ramírez

En el archivo `alertas.pl` se define un programa prolog (hechos y reglas) de un sistema de alertas por zonas para una zona de playa/puerto.
Se definen dos niveles, alertas y avisos. Donde los primeros serían urgentes y los segundos menos relevantes que avisarían para que se tomen algunas acciones.

El uso sería el siguiente

1. Cargar el archivo `alertas.pl` en SWI-Prolog.
2. Consultar, por ejemplo, `alertar(Sujeto, Motivo, Lugar).` o `avisar(Sujeto, Motivo, Lugar).` .