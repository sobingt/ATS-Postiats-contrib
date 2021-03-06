(* ****** ****** *)
//
// ATS-unjsonize-2
//
(* ****** ****** *)
//
(*
** Author: Hongwei Xi
** Authoremail: gmhwxiATgmailDOTcom
** HX-2015-08-06: start
*)
//
(* ****** ****** *)
//
#define ATS_MAINATSFLAG 1
//
#define
ATS_DYNLOADNAME
"patsunj2_commarg__dynload"
//
(* ****** ****** *)
//
#include
"share/atspre_staload.hats"
//
(* ****** ****** *)
//
staload
STDIO = "libc/SATS/stdio.sats"
//
(* ****** ****** *)

staload "./patsunj2_parsing.sats"

(* ****** ****** *)

staload "./patsunj2_synent2.sats"
staload _ = "./patsunj2_synent2.dats"

(* ****** ****** *)

staload "./patsunj2_commarg.sats"

(* ****** ****** *)

implement
fprint_commarg(out, ca) = (
//
case+ ca of
//
| CAhelp(str) => fprint! (out, "CAhelp(", str, ")")
//
| CAgitem(str) => fprint! (out, "CAgitem(", str, ")")
//
| CAinput(str) => fprint! (out, "CAinput(", str, ")")
//
| CAoutput(str) => fprint! (out, "CAoutput(", str, ")")
//
| CAscript(str) => fprint! (out, "CAscript(", str, ")")
//
| CAargend((*void*)) => fprint! (out, "CAargend(", ")")
//
) (* end of [fprint_commarg] *)

(* ****** ****** *)

fun{
} argv_getopt_at
  {n:int}{i:nat}
(
  n: int n, argv: !argv(n), i: int i
) : stropt =
(
//
if i < n
  then stropt_some (argv[i]) else stropt_none ()
// end of [if]
//
) (* end of [argv_getopt_at] *)

(* ****** ****** *)

implement
patsunj2_cmdline
  (argc, argv) = let
//
vtypedef
res_vt = commarglst_vt
//
fun
aux
{n:int}
{i:nat | i <= n}
(
  argc: int n
, argv: !argv(n)
, i: int i, res0: res_vt
) : res_vt = let
in
//
if
i < argc
then let
//
val arg = argv[i]
//
in
//
case+ arg of
//
| "-h" => let
    val ca =
      CAhelp(arg)
    val res0 =
      cons_vt(ca, res0)
    // end of [val]
  in
    aux(argc, argv, i+1, res0)
  end // end of ...
| "--help" => let
    val ca =
      CAhelp(arg)
    val res0 =
      cons_vt(ca, res0)
    // end of [val]
  in
    aux(argc, argv, i+1, res0)
  end // end of ...
//
| "-i" => let
    val ca =
      CAinput(arg)
    val res0 =
      cons_vt(ca, res0)
    // end of [val]
  in
    aux(argc, argv, i+1, res0)
  end // end of ...
| "--input" => let
    val ca =
      CAinput(arg)
    val res0 =
      cons_vt(ca, res0)
    // end of [val]
  in
    aux(argc, argv, i+1, res0)
  end // end of ...
//
| _ (*rest*) => let
    val res0 =
      cons_vt(CAgitem(arg), res0)
    // end of [val]
  in
    aux(argc, argv, i+1, res0)
  end // end of [...]
//
end // end of [then]
else res0 // end of [else]
//
end // end of [aux]
//
val args = aux(argc, argv, 0, nil_vt)
//
in
//
list_vt_reverse(list_vt_cons(CAargend(), args))
//
end // end of [patsunj2_cmdline]

(* ****** ****** *)
//
extern fun patsunj2_help(): void
extern fun patsunj2_input(): void
extern fun patsunj2_gitem(string): void
extern fun patsunj2_input_arg(string): void
//
extern fun patsunj2_argend((*void*)): void
//
extern fun patsunj2_commarglst_finalize(): void
//
(* ****** ****** *)

typedef
state_struct =
@{
//
  nerr= int
//
, input= int
, ninput= int
//
, fopen_inp= int
, inpfil_ref= FILEref
//
} (* end of [state_struct] *)

(* ****** ****** *)

local
//
var
the_state: state_struct?
//
val () = the_state.nerr := 0
//
val () = the_state.input := 0
val () = the_state.ninput := 0
//
val () = the_state.fopen_inp := 0
val () = the_state.inpfil_ref := stdin_ref
//
in (* in-of-local *)
//
val
the_state
  : ref(state_struct) =
  ref_make_viewptr(view@the_state | addr@the_state)
//
end // end of [local]

(* ****** ****** *)

fun
process_arg
  (x: commarg): void = let
//
(*
val () =
fprintln!
(
  stdout_ref
, "patsunj2_commarglst: process_arg: x = ", x
) (* end of [val] *)
*)
//
in
//
case+ x of
//
| CAhelp _ => patsunj2_help ()
//
| CAinput _ => patsunj2_input ()
//
| CAgitem(str) => patsunj2_gitem(str)
//
(*
| CAoutput(str) => fprint! (out, "CAoutput(", str, ")")
| CAscript(str) => fprint! (out, "CAscript(", str, ")")
*)
| CAargend() => patsunj2_argend ()
//
| _ (*rest-of-CA*) => ()
//
end // end of [process_arg]

(* ****** ****** *)

implement
patsunj2_commarglst
  (xs) = let
(*
val () = println! ("patsunj2_commarglst")
*)
in
//
case+ xs of
| ~list_vt_cons
    (x, xs) => let
    val () = process_arg(x)
  in
    patsunj2_commarglst (xs)
  end // end of [list_vt_cons]
//
| ~list_vt_nil
    ((*void*)) => patsunj2_commarglst_finalize ()
  // end of [list_vt_nil]
//
end // end of [patsunj2_commarglst]

(* ****** ****** *)

implement
patsunj2_help() =
{
//
(*
val () =
prerrln! ("patsunj2_help: ...")
*)
//
} (* end of [patsunj2_help] *)

(* ****** ****** *)

implement
patsunj2_input() =
{
//
(*
val () =
prerrln! ("patsunj2_input: ...")
*)
//
val () = !the_state.input := 1
//
} (* end of [patsunj2_input] *)

(* ****** ****** *)

implement
patsunj2_gitem(arg) = let
//
(*
val () =
prerrln!
  ("patsunj2_gitem: arg = ", arg)
*)
//
macdef input() = (!the_state.input > 0)
//
in
//
case+ 0 of
| _ when
    input() =>
  {
    val () = patsunj2_input_arg(arg)
    val () = !the_state.ninput := !the_state.ninput+1
  }
| _ (*unrecognized*) => ()
//
end (* end of [patsunj2_gitem] *)

(* ****** ****** *)

implement
patsunj2_input_arg
  (path) = let
//
val opt =
fileref_open_opt(path, file_mode_r)
//
in
//
case+ opt of
| ~Some_vt(filr) =>
  {
//
    val n0 = !the_state.fopen_inp
    val () = !the_state.fopen_inp := 1
//
    val f0 = !the_state.inpfil_ref
    val () = if n0 > 0 then fileref_close(f0)
    val () = !the_state.inpfil_ref := filr
//
    val d2cs = parse_fileref_d2eclist(filr)
    val ((*void*)) = fprint(stdout_ref, d2cs)
    val ((*void*)) = fprint_newline (stdout_ref)
//
  } (* end of [Some_vt] *)
//
| ~None_vt((*void*)) =>
  {
//
    val n0 = !the_state.fopen_inp
    val () = !the_state.fopen_inp := 0
//
    val f0 = !the_state.inpfil_ref
    val () = if n0 > 0 then fileref_close(f0)
    val () = !the_state.inpfil_ref := stdin_ref
//
    val () =
    prerrln!
      ("The file [", path, "] cannot be opened for read!")
    // end of [val]
//
  } (* end of [None_vt] *)
//
end // end of [patsunj2_input_arg]

(* ****** ****** *)

implement
patsunj2_argend
  ((*void*)) = let
//
(*
val () = println! ("patsunj2_argend")
*)
//
macdef test() =
  (!the_state.input > 0 && !the_state.ninput = 0)
//
in
//
case+ 0 of
| _ when
    test() =>
  {
    val inp = stdin_ref
    val () = fprint_newline (stdout_ref)
  }
| _ (*rest*) => ((*ignored*))
//
end (* end of [patsunj2_argend] *)

(* ****** ****** *)

implement
patsunj2_commarglst_finalize
  ((*void*)) =
{
  val n0 = !the_state.fopen_inp
  val f0 = !the_state.inpfil_ref
  val () = if n0 > 0 then fileref_close(f0)
} (* end of [patsunj2_commarglst_finalize] *)

(* ****** ****** *)

(* end of [patsunj2_commarg.dats] *)
