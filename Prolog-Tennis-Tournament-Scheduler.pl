round_name(2, final).
round_name(4, semi_final).
round_name(8, quarter_final).
round_name(16, round_four).
round_name(32, round_five).
round_name(64, round_six).
round_name(128, round_seven).
round_name(256, round_eight).
round_name(512, round_nine).
round_name(1024, round_ten).
round_name(2048, round_eleven).
round_name(4069, round_twelve).
round_name(8192, round_thirteen).
round_name(16384, round_fourteen).

make_list1(L, N) :- make_list1_helper(L, 1, N).

make_list1_helper([H|T], M, N) :- M is N/2, H is N/2, T = [].
make_list1_helper([H|T], M, N) :- M < N/2, M = H, M1 is M + 1, make_list1_helper(T, M1, N).

make_list2(L, N) :- M is (N/2 + 1), make_list2_helper(L, M, N);

make_list2_helper([H|T], M, N) :- M is N, H is N, T = [].
make_list2_helper([H|T], M, N) :- M < N, M = H, M1 is M + 1, make_list2_helper(T, M1, N);

schedule_round(N, R) :- make_list1(L1, N), make_list2(L2, N), permutation(L22, L2), make_it(L1, L22, N, R).

make_it([], [], _, []).
make_it([H1|T1], [H2|T2], N, [game(H1, H2, S)|TR]) :- round_name(N, S), make_it(T1, T2, N, TR).

schedule_rounds(2, [R]) :- schedule_round(2, R).
schedule_rounds(N, [H|T]) :- N > 2, N1 is N/2, schedule_round(N, H), schedule_rounds(N1, T).

tournament(N, D, S) :- \+ (D is N - 1), generate_list(N, R), make_days(D, R, S).
tournament(N, D, S) :- D is N - 1, generate_list(N, R), make_days1(D, R, S).

make_days1(0, [], []).
make_days1(D, [H|T], [[H]|T2]) :- D > 0, D1 is D - 1, make_days1(D1, T, T2).

make_days(0, [], []).
make_days(D, [M,N|T], [H, T2]) :- D > 0, \+ (M = game(1, _, _), N = game(2, _, _)), \+ (M = game(2, _, _), N = game(1, _, _)),
									M = game(_, _, NAME), N = game(_, _, NAME), M @< N, H = [M, N], D1 is D - 1, make_days(D1, T, T2).
make_days(D, [H|T], [[H]|T2]) :- D > 0, D1 is D - 1, make_days(D1, T, T2).
make_days(D, [M, N, O|T], [H|T2]) :- D > 0, \+ (M = game(1, _, _), N = game(2, _, _)), \+ (M = game(2, _, _), N = game(1, _, _)),
										\+ (M = game(1, _, _), O = game(2, _, _)), \+ (M = game(2, _, _), O = game(1, _, _)),
										\+ (N = game(1, _, _), O = game(2, _, _)), \+ (N = game(2, _, _), O = game(1, _, _)).
										M @< N, N @< O, H = [M,N,O], D1 is D - 1, make_days(D1, T, T2).