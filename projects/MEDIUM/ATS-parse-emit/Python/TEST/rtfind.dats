(* ****** ****** *)
//
#include
"share/atspre_staload.hats"
//
(* ****** ****** *)

staload "./../prelude/SATS/integer.sats"

(* ****** ****** *)
//
extern
fun rtfind (f: int -> int): int = "mac#"
//
implement
rtfind (f) = let
//
fun loop
(
  f: int -> int, i: int
) : int =
  if f (i) = 0 then i else loop (f, i+1)
//
in
  loop (f, 0(*i*))
end // end of [rtfind]

(* ****** ****** *)

%{^
import sys
######
from basics_cats import *
from integer_cats import *
######
sys.setrecursionlimit(1000000)
%}

(* ****** ****** *)

%{$
#
poly1 = lambda x: x*x - x - 6
print('rtfind(lambda x: x*x - x - 6) =', rtfind(poly1))
#
poly2 = lambda x: x*x + 2*x - 99
print('rtfind(lambda x: x*x - 2*x - 99) =', rtfind(poly2))
#
%} // end of [%{$]

(* ****** ****** *)

(* end of [rtfind.dats] *)