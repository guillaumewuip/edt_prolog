/* tests/planifier.pl

Tests des prédicats de `planifier.pl`

@changelog
*/

:- include('../planifier.pl').

:- begin_tests(typesCoursIdentiques).

test("typesCoursIdentiques est vrai si les types cours sont identiques") :-
    typesCoursIdentiques(cm, cm).

test("typesCoursIdentiques est faux les types cours sont différents") :-
    \+ typesCoursIdentiques(cm, td).

:- end_tests(typesCoursIdentiques).


:- begin_tests(memeMomentCreneau).

test("memeMomentCreneau est faux si le mois est différent") :-
    C = [1, 1, 1, 2, a1],
    \+ memeMomentCreneau(1, 1, 1, C).

test("memeMomentCreneau est faux si le jour est différent") :-
    C = [1, 1, 2, 1, a1],
    \+ memeMomentCreneau(1, 1, 1, C).

test("memeMomentCreneau est faux si l'heure est différente") :-
    C = [1, 2, 1, 1, a1],
    \+ memeMomentCreneau(1, 1, 1, C).

test("memeMomentCreneau est vrai sinon") :-
    C = [1, 1, 1, 1, a1],
    memeMomentCreneau(1, 1, 1, C).

:- end_tests(memeMomentCreneau).


:- begin_tests(memeProfs).

test("memeProfs est vrai si la séance concerne un des prof ") :-
    C = [1, 1, 1, 1, a1],
    memeProfs([rashia, martinez, kuntz], C).

test("memeProfs est faux sinon") :-
    C = [11, 1, 1, 1, a1],
    \+ memeProfs([picarougne, rashia], C).

:- end_tests(memeProfs).


:- begin_tests(groupeIncompatibleCreneau).

test("groupesIncompatibleCreneau est vrai si un groupe est incompatible avec
    le groupe de la séance ") :-
    C = [13, 1, 1, 1, a1],
    groupesIncompatibleCreneau([silr1, id], C).

test("groupesIncompatibleCreneau est faux sinon") :-
    C = [13, 1, 1, 1, a1],
    \+ groupesIncompatibleCreneau([id], C).

:- end_tests(groupeIncompatibleCreneau).


:- begin_tests(sequencementValideCreneau).

test("sequencementValideCreneau est faux si suitSeance/4 n'est pas respecté") :-
    C = [1, 1, 1, 1, a1], % pas assez loin
    \+ sequencementValideCreneau(4, 1, 1, 1, C),

    C1 = [1, 1, 1, 1, a1], % mois trop loin
    \+ sequencementValideCreneau(4, 1, 1, 2, C1).

test("sequencementValideCreneau est vrai si suitSeance/4 est respecté") :-
    C = [1, 1, 0, 1, a1], % borne min
    sequencementValideCreneau(4, 1, 2, 1, C),

    C0 = [1, 1, 0, 1, a1], % milieu intervalle
    sequencementValideCreneau(4, 1, 3, 1, C0),

    C1 = [1, 1, 0, 1, a1], % borne max
    sequencementValideCreneau(4, 1, 5, 1, C1),

    % dans l'autre sens

    C2 = [4, 1, 2, 1, a1], % borne min
    sequencementValideCreneau(1, 1, 0, 1, C2),

    C3 = [4, 1, 3, 1, a1], % milieu intervalle
    sequencementValideCreneau(1, 1, 0, 1, C3),

    C4 = [4, 1, 5, 1, a1], % borne max
    sequencementValideCreneau(1, 1, 0, 1, C4).

test("sequencementValideCreneau est faux si suitSeance/2 n'est pas respecté") :-
    C = [2, 1, 1, 1, a1], % pas assez loin
    \+ sequencementValideCreneau(8, 1, 1, 1, C).

test("sequencementValideCreneau est vrai si suitSeance/2 est respecté") :-
    C = [2, 1, 0, 1, a1],
    sequencementValideCreneau(8, 1, 1, 1, C),

    C1 = [8, 1, 1, 1, a1],
    sequencementValideCreneau(2, 1, 0, 1, C1).

:- end_tests(sequencementValideCreneau).


:- begin_tests(creneauValideCreneau).

test("creneauValideCreneau est faux si prof incompatible et meme moment") :-
    C = [11, 1, 1, 1, a1],
    \+ creneauValideCreneau(12, [kuntz], silr2, 1, 1, 1, C).

test("creneauValideCreneau est faux si groupe incompatible et meme moment") :-
    C = [11, 1, 1, 1, a1],
    \+ creneauValideCreneau(12, [martinez], id, 1, 1, 1, C).

test("creneauValideCreneau est faux si le séquencement n'est pas respecté") :-
    C = [11, 1, 1, 1, a1],
    \+ creneauValideCreneau(12, [martinez], id, 1, 1, 1, C).

test("creneauValideCreneau est vrai sinon") :-
    C = [11, 1, 0, 1, a1],
    % moment différent
    creneauValideCreneau(1, [martinez], silr2, 1, 1, 2, C),
    % séance suivante
    creneauValideCreneau(12, [martinez], silr2, 1, 1, 1, C),
    % prof et groupe différent
    creneauValideCreneau(1, [martinez], silr2, 1, 1, 1, C).

:- end_tests(creneauValideCreneau).


:- begin_tests(creneauValide).

test("creneauValide est vrai si il n'y a pas de créneaux") :-
    creneauValide(12, [martinez], silr2, 1, 1, 2, []).

test("creneauValide est vrai si il n'y a que des créneaux valides") :-
    C1 = [11, 1, 0, 0, a1],
    C2 = [1, 1, 0, 0, a1],
    C3 = [2, 1, 0, 0, a1],
    creneauValide(12, [martinez], silr2, 1, 2, 1, [C1, C2, C3]).

test("creneauValide est faux si il y a au moins un créneau problématique") :-
    C0 = [1, 1, 1, 1, a1],
    C1 = [11, 1, 1, 1, a1],
    C2 = [12, 1, 1, 1, a1],
    C3 = [1, 2, 1, 1, a1],
    C4 = [11, 1, 1, 3, a1],
    \+ creneauValide(12, [martinez], silr2, 1, 1, 1, [C1, C2, C0, C3, C4]).

:- end_tests(creneauValide).


:- begin_tests(effectifGroupes).

test("effectifGroupes renvoit 0 si pas de groupes") :- effectifGroupes([], 0).
test("effectifGroupes renvoit le bon effectif") :-
    effectifGroupes([id, silr], 62).

:- end_tests(effectifGroupes).
