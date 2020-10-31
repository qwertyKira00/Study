ok.
pow(F1,F2,F3,A,B):- F3 > B.
pow(F1,F2,F3,A,B):- 
	F3 < A, 
	F4 is F1 * F2,
	F5 = F1 + 1,
	pow(F5,F5,F4,A,B).
pow(F1,F2,F3,A,B):- write(F3), write("\n"), F4 is F1 * F2, F5 = F1 + 1, pow(F5,F5,F4,A,B).
f :-read(A), read(B),pow(0,0,0,A,B),ok.
