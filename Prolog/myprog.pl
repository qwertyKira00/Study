writeNumber(X, A) :- X_NEW is X,
                    ((X_NEW >= A) -> write(X_NEW), write(" "); write("")).
fib(N1, N2, A, B) :-
    N1 > 0,
    F is N1 + N2,
    writeNumber(N1, A),
    N2 =< B,
    fib(N2, F, A, B).

f :- read(A), read(B), fib(1,1,A,B).
    


