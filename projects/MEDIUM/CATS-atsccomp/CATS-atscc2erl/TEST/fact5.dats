(* ****** ****** *)
//
// HX-2015-07:
// A running example
// from ATS2 to Erlang
//
(* ****** ****** *)
//
#define ATS_DYNLOADFLAG 0
//
(* ****** ****** *)

%{^
%%
-module(fact5_dats).
%%
-export([fact/1]).
-export([mytest/0]).
%%
-export([ats2erlpre_ref_vt_server_proc/1]).
-export([ats2erlpre_ref_vt_server_proc2/0]).
%%
-compile(nowarn_unused_vars).
-compile(nowarn_unused_function).
%%
-include("$PATSHOMERELOC/contrib/libatscc/libatscc2erl/libatscc2erl_all.hrl").
%%
%} // end of [%{]

(* ****** ****** *)
//
#include
"share/atspre_define.hats"
//
(* ****** ****** *)
//
staload
"{$LIBATSCC2ERL}/SATS/integer.sats"
staload
"{$LIBATSCC2ERL}/SATS/reference.sats"
//
(* ****** ****** *)
//
extern
fun
fact : int -> int = "mac#fact"
//
implement
fact (n) = let
//
fun
loop
(
  n: int, res: ref_vt(int)
) : int =
if n > 0
then let
//
val (pf | r) = ref_vt_takeout(res)
val ((*void*)) = ref_vt_addback(pf | res, n * r)
//
in
  loop(n-1, res)
end // end of [then]
else ref_vt_getfree_elt(res) // end of [else]
//
val res = ref_vt{int}(1)
//
in
  loop (n, res)
end // end of [fact]

(* ****** ****** *)

%{$
mytest() ->
  N = 12
, io:format("fact(~p) = ~p~n", [N, fact(N)])
. %% mytest()
%} // end of [%{$]

(* ****** ****** *)

(* end of [fact5.dats] *)
