% Aquí va el código.
integrante(sophieTrio, sophie, violin).
integrante(sophieTrio, santi, guitarra).
integrante(vientosDelEste, lisa, saxo).
integrante(vientosDelEste, santi, voz).
integrante(vientosDelEste, santi, guitarra).
integrante(jazzmin, santi, bateria).

nivelQueTiene(sophie, violin, 5).
nivelQueTiene(santi, guitarra, 2).
nivelQueTiene(santi, voz, 3).
nivelQueTiene(santi, bateria, 4).
nivelQueTiene(lisa, saxo, 4).
nivelQueTiene(lore, violin, 4).
nivelQueTiene(luis, trompeta, 1).
nivelQueTiene(luis, contrabajo, 4).

instrumento(violin, melodico(cuerdas)).
instrumento(guitarra, armonico).
instrumento(bateria, ritmico).
instrumento(saxo, melodico(viento)).
instrumento(trompeta, melodico(viento)).
instrumento(contrabajo, armonico).
instrumento(bajo, armonico).
instrumento(piano, armonico).
instrumento(pandereta, ritmico).
instrumento(voz, melodico(vocal)).

% Punto 1

poseeTipoInstrumento(Grupo, Tipo, Persona):-
    integrante(Grupo, Persona, Instrumento),
    instrumento(Instrumento, Tipo).

tieneBuenaBase(Grupo):-
    poseeTipoInstrumento(Grupo, ritmico, Persona1),
    poseeTipoInstrumento(Grupo, armonico, Persona2),
    Persona1 \= Persona2.

% Punto 2

nivelEnGrupo(Persona, Grupo, Nivel):-
    integrante(Grupo, Persona, Instrumento),
    nivelQueTiene(Persona, Instrumento, Nivel),
    forall((integrante(Grupo, Persona, OtroInst), nivelQueTiene(Persona, OtroInst, OtroNivel)), Nivel >= OtroNivel).

seDestaca(Persona, Grupo):-
    integrante(Grupo, Persona,_),
    nivelEnGrupo(Persona, Grupo, Nivel),
    forall((integrante(Grupo, Otro,_), Otro \= Persona, nivelEnGrupo(Otro, Grupo, OtroNivel)), Nivel >= 2 + OtroNivel).

% Punto 3

grupo(vientosDelEste, bigBand).
grupo(sophieTrio, formacion([contrabajo, guitarra, violin])).
grupo(jazzmin, formacion([bateria, bajo, trompeta, piano, guitarra])).
grupo(estudio1, ensamble(3)).

% Punto 4

leSirve(Grupo, Instrumento):-
    grupo(Grupo, bigBand),
    member(Instrumento, [bateria, bajo, piano]).

leSirve(Grupo, Instrumento):-
    grupo(Grupo, formacion(Requeridos)),
    member(Instrumento, Requeridos).

leSirve(Grupo,_):-
    grupo(Grupo, ensamble(_)).

nadieLoToca(Grupo, Instrumento):-
    grupo(Grupo,_),
    not(integrante(Grupo,_,Instrumento)).

hayCupo(Grupo, Instrumento):-
    grupo(Grupo, bigBand),
    instrumento(Instrumento, melodico(viento)).

hayCupo(Grupo, Instrumento):-
    leSirve(Grupo, Instrumento),
    nadieLoToca(Grupo, Instrumento).

% Punto 5

nivelEsperado(Grupo, 1):-
    grupo(Grupo, bigBand).

nivelEsperado(Grupo, Nivel):-
    grupo(Grupo, formacion(Requeridos)),
    length(Requeridos, Cantidad),
    Nivel is 7 - Cantidad.

nivelEsperado(Grupo, Nivel):-
    grupo(Grupo, ensamble(Nivel)).

cumpleConNivel(Persona, Instrumento, Grupo):-
    nivelQueTiene(Persona, Instrumento, Nivel),
    nivelEsperado(Grupo, Minimo),
    Nivel >= Minimo.

puedeIncorporarse(Persona, Instrumento, Grupo):-
    hayCupo(Grupo, Instrumento),
    cumpleConNivel(Persona, Instrumento, Grupo),
    not(integrante(Grupo, Persona,_)).

% Punto 6

seQuedoEnBanda(Persona):-
    nivelQueTiene(Persona,_,_),
    not(integrante(_,Persona,_)),
    not(puedeIncorporarse(Persona,_,_)).

% Punto 7

tocaTipoEnGrupo(Persona, Grupo, Tipo):-
    integrante(Grupo, Persona, Instrumento),
    instrumento(Instrumento, Tipo).

cumpleConTodos(Grupo, [Requerido]):-
    integrante(Grupo,_, Requerido).

cumpleConTodos(Grupo, [Requerido|Requeridos]):-
    integrante(Grupo,_, Requerido),
    cumpleConTodos(Grupo, Requeridos).

puedeTocar(Grupo):-
    grupo(Grupo, bigBand),
    tieneBuenaBase(Grupo),
    findall(Persona, (tocaTipoEnGrupo(Persona, Grupo, melodico(viento))), Personas),
    length(Personas, Cantidad),
    Cantidad >= 5.

puedeTocar(Grupo):-
    grupo(Grupo, formacion(Requeridos)),
    forall(member(Instrumento, Requeridos), integrante(Grupo,_, Instrumento)).

puedeTocar(Grupo):-
    grupo(Grupo, ensamble(_)),
    tieneBuenaBase(Grupo),
    tocaTipoEnGrupo(_, Grupo, melodico(_)).
