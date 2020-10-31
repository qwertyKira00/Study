ok.
pow(N,S,A,B,C):- N > B, write(S);
				 N < A, N1 is N + 1, pow(N1,S,A,B,C);
				 N mod C =:= 0, write(N), nl, N1 is N + 1, S1 is S + N, pow(N1,S1,A,B,C);
				 N1 is N + 1, pow(N1,S,A,B,C).
input(A,B,C):- read(A), read(B), read(C);ok.
f :-input(A,B,C),pow(0,0,A,B,C),ok.
