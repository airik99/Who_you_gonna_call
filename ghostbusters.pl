% ------------------- PUNTO 1 ------------------- 

integrante(egon, [aspiradora(200), trapeador]).
integrante(peter, [trapeador]).
integrante(winston, [varitaDeNeutrones]).
integrante(ray, []).
integrante(airik, [trapeador, plumero, aspiradora(200), sopapa]).

% ------------------- PUNTO 2 ------------------- 

tieneHerramientaRequerida(Integrante, HerramientaRequerida) :-
    integrante(Integrante, Herramientas),
    member(HerramientaRequerida, Herramientas).

tieneHerramientaRequerida(Integrante, aspiradora(PotenciaMinima)) :-
    integrante(Integrante, Herramientas),
    member(aspiradora(UnaPotencia), Herramientas),
    UnaPotencia >= PotenciaMinima.

% ------------------- PUNTO 3 ------------------- 

puedeRealizar(Integrante, Tarea) :-
    herramientasRequeridas(Tarea, HerramientasRequeridas),
    tieneLasHerramientas(Integrante, HerramientasRequeridas).

tieneLasHerramientas(Integrante, _) :-
    integrante(Integrante, Herramientas),
    member(varitaDeNeutrones, Herramientas).

tieneLasHerramientas(Integrante, HerramientasRequeridas) :-
    integrante(Integrante, _),
    forall(member(HerramientaRequerida, HerramientasRequeridas), tieneHerramientaRequerida(Integrante, HerramientaRequerida)).

% ------------------- PUNTO 4 ------------------- 

tareaPedida(facondo, ordenarCuarto, 10).
tareaPedida(darkSunnar, limpiarBanio, 5).
tareaPedida(darkSunnar, ordenarCuarto, 20).

precio(ordenarCuarto, 20).
precio(limpiarBanio, 10).

cuantoCobra(Cliente, Precio) :-
    tareaPedida(Cliente, _, _),
    findall(PrecioTarea, precioTareaPorMetro(Cliente, PrecioTarea), PreciosDeTareas),
    sum_list(PreciosDeTareas, Precio).

precioTareaPorMetro(Cliente, Precio) :-
    tareaPedida(Cliente, Tarea, Metros),
    precio(Tarea, PrecioTarea),
    Precio is PrecioTarea * Metros.

% ------------------- PUNTO 5 ------------------- 

aceptaPedido(Integrante, Cliente) :-
    tareaPedida(Cliente, _, _),
    integrante(Integrante, _),
    puedeRealizarLasTareas(Integrante, Cliente),
    estaDispuesto(Integrante, Cliente).

puedeRealizarLasTareas(Integrante, Cliente) :-
    forall(tareaPedida(Cliente, Tarea, _), puedeRealizar(Integrante, Tarea)).

estaDispuesto(ray, Cliente) :-
    forall(tareaPedida(Cliente, Tarea, _), Tarea \= limpiarTecho).

estaDispuesto(winston, Cliente) :-
    cuantoCobra(Cliente, Precio),
    Precio >= 500.

estaDispuesto(egon, Cliente) :-
    forall(tareaPedida(Cliente, Tarea, _), not(tareaCompleja(Tarea))).

estaDispuesto(peter, _).

tareaCompleja(Tarea) :-
    herramientasRequeridas(Tarea, Herramientas),
    length(Herramientas, Cantidad),
    Cantidad > 2.
    
tareaCompleja(limpiarTecho).

% ------------------- PUNTO 6 ------------------- 

herramientasRequeridas(ordenarCuarto, [aspiradora(100), trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordedadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradpesora, cera, aspiradora(300)]).

herramientasRequeridas(ordenarCuarto, [escoba, trapeador, plumero]).

% Explicar a qué se debe que esto sea difícil o fácil de incorporar.

% Al agregar otra clausulo en herramientasRequeridas en la tarea ordenarCuarto, no habria que cambiar todo lo hecho anteriormente ya que de esta forma
% decimos que las herramientas necesarias para ordenar el cuarto pueden ser tanto [aspiradora(100), trapeador, plumero] como [escoba, trapeador, plumero].
% Lo único que hacemos es agregar otra clausula de la misma tarea, con las herramientas que se necesiten