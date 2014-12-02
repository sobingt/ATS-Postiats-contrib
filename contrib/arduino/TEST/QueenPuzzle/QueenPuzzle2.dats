(*
#
# QueenPuzzle2
# it is for Uno/Yun
#
*)
(* ****** ****** *)

#define ATS_DYNLOADFLAG 0

(* ****** ****** *)
//
#include
"share/atspre_define.hats"
#include
"{$ARDUINO}/staloadall.hats"
//
(* ****** ****** *)

staload UN = "prelude/SATS/unsafe.sats"

(* ****** ****** *)
//
%{^
typedef char *charptr;
%} // end of [%{^]
//
abstype charptr = $extype"charptr"
//
(* ****** ****** *)
//
%{^
#define N 8
int theArray[N] =
{
  0,0,0,0,0,0,0,0
} ;
%} // end of [%{^]
#define N 8
macdef theArray =
  $extval(arrayref(int,N),"theArray")
//
(* ****** ****** *)
//
fnx
find_next
  {n:pos}
(
  A: arrayref(int, n), n: int(n)
) : bool = let
//
fun
loop
(
  i: natLte(n)
) : natLte(n) =
(
if
i < n
then
  if A[i] > 0 then loop (i+1) else i
else n
) (* end of [loop] *)
//
val i0 = loop (0)
//
in
//
if
i0 < n
then
(
  A[i0] := 1; find2_next (A, n, i0)
) (* end of [then] *)
else
(
  A[n-1] := A[n-1] + 1; find2_next (A, n, n-1)
) (* end of [else] *)
//
end // end of [find_next]

and
find2_next
  {n:pos}
(
  A: arrayref(int, n), n: int(n), i: natLt(n)
) : bool = let
//
fun
test (j: intGte(0)) : bool =
(
if
j >= i
then true
else
(
if
A[i] = A[j]
then false
else (if (i-j=abs(A[i]-A[j])) then false else test(j+1))
) (* end of [else] *)
) (* end of [test] *)
//
in
//
if
A[i] <= n
then let
in
//
if
test(0)
then
(
  if i+1=n then true else find_next(A, n)
) (* end of [then] *)
else (A[i] := A[i]+1; find2_next(A, n, i))
//
end // end of [then]
else let
  val () = A[i] := 0
in
  if i > 0 then (A[i-1] := A[i-1]+1; find2_next (A, n, i-1)) else false
end // end of [else]
//
end // end of [find2_next]

(* ****** ****** *)

%{^
#define ATS_MFREE free
#define ATS_MALLOC malloc
#define ATSextfcall(fun, funarg) fun funarg
#define ATSextmcall(obj, mtd, funarg) obj.mtd funarg
%} // end of [%{^]

(* ****** ****** *)

staload "{$ARDUINO}/SATS/Bridge/Bridge.sats"
staload "{$ARDUINO}/SATS/Bridge/Console.sats"

(* ****** ****** *)
//
extern
fun
setup (): void = "mac#"
//
implement
setup () = () where
{
//
val () = Bridge_ptr._begin()
val () = Console_ptr._begin()
val () = while (~Console_ptr.connected()) ()
val () = Console_ptr.println ("Let us solve the 8-queen puzzle!\n")
//
} (* end of [setup] *)
//
(* ****** ****** *)
//
implement
fprint_val<int>
  (out, x) = let
//
fun
ndot(n: int): void =
if n > 0 then
(
  Console_ptr.print(". "); ndot(n-1)
) (* end of [if] *)
//
val () = ndot(x-1)
val () = Console_ptr.print("Q ")
val () = ndot(N-x)
val () = Console_ptr.println((*void*))
//
in
  // nothing
end // end of [fprint_val]

(* ****** ****** *)
//
implement
fprint_string (out, x) = Console_ptr.print(x)
//
(* ****** ****** *)
//
implement
fprint_array$sep<> (out) = ()
//
(* ****** ****** *)
//
extern
fun loop (): void = "mac#"
//
implement
loop () =
myloop() where
{
fun
myloop(): void = let
//
val
out = $extval (FILEref, "0")
//
(*
val () =
randomSeed($UN.cast{uint}(millis()))
*)
//
val A = theArray
val found = find_next (A, N)
//
val () =
if found then
{
  val () =
  fprint_arrayref (out, A, i2sz(N))
  val () = Console_ptr.println()
} (* end of [then] *)
//
val () =
if ~found then
{
//
  val () =
  fprint_string (out, "All solutions are found!\n")
  val () = Console_ptr.println()
//
} (* end of [then] *)
//
in
  delay (1000); myloop ()
end // end of [myloop]
//
} (* end of [loop] *)
//
(* ****** ****** *)

(* end of [QueenPuzzle2.dats] *)
