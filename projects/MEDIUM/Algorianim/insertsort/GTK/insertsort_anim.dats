//
// Animating Insertion sort
//
(* ****** ****** *)
//
#define
LIBCAIRO_targetloc
"$PATSHOME/npm-utils\
/contrib/atscntrb-libcairo"
//
(* ****** ****** *)
//
#include
"share/atspre_define.hats"
#include
"share/atspre_staload.hats"
//
(* ****** ****** *)
//
#staload "./../insertsort.dats"
//
(* ****** ****** *)
//
#staload
"{$HX_MYTESTING}/SATS/randgen.sats"
#staload _ =
"{$HX_MYTESTING}/DATS/randgen.dats"
//
(* ****** ****** *)
//
#staload
"{$PATSHOME}/npm-utils/contrib\
/libats-hwxi/teaching/BUCS/DATS/BUCS320.dats"
//
(* ****** ****** *)

#define MYMAX 100

(* ****** ****** *)

local

val theExchlst =
  ref<List0(int)> (list_nil)

in (* in-of-local *)

fun theExchlst_add
  (ind: int): void =
(
  !theExchlst := cons (ind, !theExchlst)
)
fun
theExchlst_get_all
(
// argumentlst
) : List0(int) = let
  val xs = !theExchlst
  val () = !theExchlst := nil ()
in
  list_vt2t (list_reverse (xs))
end // end of [theExchlst_get_all]

end // end of [local]

(* ****** ****** *)

local

implement
randgen_val<int> () = randint (MYMAX)

in (* in-of-local *)

fun
genScript{n:int}
(
  out: FILEref, asz: size_t(n)
) :
(
  arrszref (int), List0(int)
) = let
//
val A =
randgen_arrayref<int> (asz)
//
local
implement
array_tabulate$fopr<int> (i) =
  let val i = $UNSAFE.cast{sizeLt(n)}(i) in A[i] end
in
//
val A2 = arrayref_tabulate<int> (asz)
//
end // end of [local]
//
val p0 = arrayref2ptr (A2)
//
local
//
val ptr_exch_int = ptr_exch<int>
//
implement
ptr_exch<int>
  (pf | p, x) = let
  val df = p - p0
  val ind = $UNSAFE.cast{size_t}(df) / sizeof<int>
  val ((*void*)) = $effmask_all (theExchlst_add (sz2i(ind)))
in
  ptr_exch_int (pf | p, x)
end // end of [ptr_exch]
//
in(*in-of-local*)
//
val (pf0, fpf0 | p0) =
  $UNSAFE.ptr0_vtake{array(int,n)}(p0)
val () = array_insertsort<int> (!p0, asz)
prval () = fpf0 (pf0)
//
end // end of [local]
//
(*
val () = fprint (out, A, asz)
val () = fprint_newline (out)
val () = fprint (out, A2, asz)
val () = fprint_newline (out)
*)
//
in
  (arrszref_make_arrayref (A, asz), theExchlst_get_all ())
end (* end of [genScript] *)

end // end of [local]

(* ****** ****** *)

local
//
val ind = ref<int> (0)
//
val () = srandom_with_time ()
//
val (ASZ, xs) =
  genScript (stdout_ref, i2sz(16))
//
val theExchlst = ref<List0(int)> (xs)
//
in (* in-of-local *)

val ASZ = ASZ
fun
ASZ_update () = let
//
  val i = !ind
  val xs = !theExchlst
//
  val () = (
    case+ xs of
    | nil () => !ind := 0
    | cons (x, xs) => (!ind := x; !theExchlst := xs)
  ) (* end of [val] *)
//
  val i = g0int2uint_int_size (i)
//
in
  if i > 0 then arrszref_interchange (ASZ, i, pred(i))
end (* end of [ASZ_update] *)

end // end of [local]

(* ****** ****** *)
//
#staload "{$LIBCAIRO}/SATS/cairo.sats"
//
#staload
"{$PATSHOME}/npm-utils/contrib\
/libats-hwxi/teaching/mydraw/SATS/mydraw.sats"
#staload
"{$PATSHOME}/npm-utils/contrib\
/libats-hwxi/teaching/mydraw/SATS/mydraw_cairo.sats"
//
#staload
"{$PATSHOME}/npm-utils/contrib\
/libats-hwxi/teaching/mydraw/DATS/mydraw_bargraph.dats"
//
#staload _ =
"{$PATSHOME}/npm-utils/contrib\
/libats-hwxi/teaching/mydraw/DATS/mydraw.dats"
#staload _ =
"{$PATSHOME}/npm-utils/contrib\
/libats-hwxi/teaching/mydraw/DATS/mydraw_cairo.dats"
//
(* ****** ****** *)

extern
fun
cairo_draw_arrszref
(
  cr: !cairo_ref1
, point, point, point, point, arrszref(int)
) : void // end-of-fun

(* ****** ****** *)

implement
cairo_draw_arrszref
(
  cr, p1, p2, p3, p4, ASZ
) = let
//
val p_cr = ptrcast (cr)
//
implement
mydraw_get0_cairo<> () = let
//
extern
castfn __cast {l:addr} (ptr(l)): vttakeout (void, cairo_ref(l))
//
in
  __cast (p_cr)
end // end of [mydraw_get0_cairo]
//
implement
mydraw_bargraph$color<>
  (i) = let
//
val alpha =
  0.50 * (ASZ[i]+1) / MYMAX
//
in
  color_make (alpha, alpha, alpha)
end // end of [mydraw_bargraph$color]

implement
mydraw_bargraph$height<> (i) = 1.0 * (ASZ[i]+1) / MYMAX
//
val asz = ASZ.size()
val asz = sz2i (asz)
val asz = ckastloc_gintGt (asz, 0)
//
in
  mydraw_bargraph (asz, p1, p2, p3, p4)
end // end of [cairo_draw_arrszref]

(* ****** ****** *)

extern
fun
mydraw_clock
  (cr: !cairo_ref1, width: int, height: int) : void
// end of [mydraw_clock]

(* ****** ****** *)

implement
mydraw_clock
  (cr, W, H) = let
//
val W =
g0int2float_int_double(W)
and H =
g0int2float_int_double(H)
//
val WH = min (W, H)
//
val xm = (W - WH) / 2
val ym = (H - WH) / 2
//
val v0 = vector_make (xm, ym)
//
val p1 = point_make (0. , WH) + v0
val p2 = point_make (WH , WH) + v0
val p3 = point_make (WH , 0.) + v0
val p4 = point_make (0. , 0.) + v0
//
val () = ASZ_update ()
//
val (pf | ()) = cairo_save (cr)
val () = cairo_draw_arrszref (cr, p1, p2, p3, p4, ASZ)
val ((*void*)) = cairo_restore (pf | cr)
//
in
  // nothing
end // [mydraw_clock]

(* ****** ****** *)

%{^
typedef char **charptrptr ;
%} ;
abstype charptrptr = $extype"charptrptr"

(* ****** ****** *)
//
#staload
"{$LIBATSHWXI}/teaching/myGTK/SATS/gtkcairoclock.sats"
#staload
_ = "{$LIBATSHWXI}/teaching/myGTK/DATS/gtkcairoclock.dats"
//
(* ****** ****** *)

implement
main0{n}
(
  argc, argv
) = let
//
var argc: int = argc
var argv: charptrptr = $UN.castvwtp1{charptrptr}(argv)
//
val () = $extfcall (void, "gtk_init", addr@(argc), addr@(argv))
//
implement
gtkcairoclock_title<> () = stropt_some"InsertionSort"
implement
gtkcairoclock_timeout_interval<> () = 500U // millisecs
implement
gtkcairoclock_mydraw<> (cr, width, height) = mydraw_clock (cr, width, height)
//
val ((*void*)) = gtkcairoclock_main ((*void*))
//
in
  // nothing
end // end of [main0]

(* ****** ****** *)

(* end of [insertsort_anim.dats] *)
