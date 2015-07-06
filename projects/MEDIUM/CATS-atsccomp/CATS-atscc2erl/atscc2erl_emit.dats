(* ****** ****** *)
//
// Atscc2erl:
// from ATS to Erlang
//
(* ****** ****** *)
//
// HX-2015-06-29: start
//
(* ****** ****** *)
//
#include
"share/atspre_staload.hats"
//
(* ****** ****** *)
//
staload
UN = "prelude/SATS/unsafe.sats"
//
(* ****** ****** *)
//
#define
CATSPARSEMIT_targetloc "./.CATS-parsemit"
//
(* ****** ****** *)
//
staload "{$CATSPARSEMIT}/catsparse.sats"
//
staload "{$CATSPARSEMIT}/catsparse_syntax.sats"
//
staload "{$CATSPARSEMIT}/catsparse_emit.sats"
//
staload "{$CATSPARSEMIT}/catsparse_typedef.sats"
//
(* ****** ****** *)

local

staload
TM = "libc/SATS/time.sats"
stadef time_t = $TM.time_t

in (* in-of-local *)

implement
emit_time_stamp (out) = let
//
var tm: time_t
val () = tm := $TM.time_get ()
val (pfopt | p_tm) = $TM.localtime (tm)
//
val () = emit_text (out, "%%%%%%\n");
val () = emit_text (out, "%%\n");
val () = emit_text (out, "%% The Erlang code is generated by atscc2erl\n")
val () = emit_text (out, "%% The starting compilation time is: ")
//
val () =
if
p_tm > 0
then let
  prval Some_v @(pf1, fpf1) = pfopt
  val tm_min = $TM.tm_get_min (!p_tm)
  val tm_hour = $TM.tm_get_hour (!p_tm)
  val tm_mday = $TM.tm_get_mday (!p_tm)
  val tm_mon = 1 + $TM.tm_get_mon (!p_tm)
  val tm_year = 1900 + $TM.tm_get_year (!p_tm)
  prval () = fpf1 (pf1)
in
  $extfcall
  (
    void
  , "fprintf"
  , out, "%i-%i-%i: %2ih:%2im\n", tm_year, tm_mon, tm_mday, tm_hour, tm_min
  )
end // end of [then]
else let
  prval None_v () = pfopt
in
  emit_text (out, "**TIME-ERROR**\n")
end // end of [else]
//
val () = emit_text (out, "%%\n")
val () = emit_text (out, "%%%%%%\n")
//
in
  // emit_newline (out)
end // end of [emit_time_stamp]

end // end of [local]

(* ****** ****** *)

implement
emit_PMVint
  (out, tok) = let
//
val-T_INT(base, rep) = tok.token_node
//
in
  emit_text (out, rep)
end // end of [emit_PMVint]
//
implement
emit_PMVintrep
  (out, tok) = let
//
val-T_INT(base, rep) = tok.token_node
//
in
  emit_text (out, rep)
end // end of [emit_PMVintrep]
//
(* ****** ****** *)

implement
emit_PMVbool
  (out, tfv) = (
//
emit_text
( out
, if tfv then "true" else "false"
) (* end of [emit_text] *)
//
) (* end of [emit_PMVbool] *)

(* ****** ****** *)

implement
emit_PMVstring
  (out, tok) = let
//
val-T_STRING(rep) = tok.token_node
//
in
  emit_text (out, rep)
end // end of [emit_PMVstring]

(* ****** ****** *)

implement
emit_PMVfloat
  (out, tok) = let
//
val-T_FLOAT(base, rep) = tok.token_node
//
in
  emit_text (out, rep)
end // end of [emit_PMVfloat]

(* ****** ****** *)

implement
emit_PMVi0nt
  (out, tok) = let
//
val-T_INT(base, rep) = tok.token_node
//
in
  emit_text (out, rep)
end // end of [emit_PMVi0nt]

(* ****** ****** *)

implement
emit_PMVf0loat
  (out, tok) = let
//
val-T_FLOAT(base, rep) = tok.token_node
//
in
  emit_text (out, rep)
end // end of [emit_PMVf0loat]

(* ****** ****** *)
//
implement
emit_PMVempty
  (out, _) = emit_text (out, "null")
//  
implement
emit_PMVextval
  (out, toks) = emit_tokenlst (out, toks)
//
(* ****** ****** *)
//
extern
fun
emit_f0ide
  : emit_type (i0de) = "ext#atscc2erl_emit_f0ide"
extern
fun
emit_flabel
  : emit_type (label) = "ext#atscc2erl_emit_flabel"
//
implement
emit_f0ide
  (out, fid) = let
//
val sym = fid.i0de_sym
val name = symbol_get_name(sym)
//
val c0 =
  $UN.ptr0_get<char> (string2ptr(name))
//
val () = if c0 = '_' then emit_text(out, "f")
//
in
  emit_symbol(out, sym)
end // end of [emit_f0ide]
//
implement
emit_flabel
  (out, flab) = emit_f0ide (out, flab)
//
(* ****** ****** *)
//
implement
emit_PMVfunlab
  (out, flab) = emit_flabel (out, flab)
//
(* ****** ****** *)

implement
emit_PMVcfunlab
  (out, flab, d0es_env) =
{
//
val () =
  emit_flabel (out, flab)
//
val () =
  emit_text (out, "__closurerize")
//
val () = emit_LPAREN (out)
val () = emit_d0explst (out, d0es_env)
val () = emit_RPAREN (out)
//
} (* end of [emit_PMVcfunlab] *)

(* ****** ****** *)

implement
emit_CSTSPmyloc
  (out, tok) = let
//
val-T_STRING(rep) = tok.token_node
//
in
  emit_text (out, rep)
end // end of [emit_CSTSPmyloc]

(* ****** ****** *)

implement
emit_ATSCKiseqz(out, d0e) =
{
//
val () = emit_text (out, "?ATSCKiseqz(")
val () = (emit_d0exp (out, d0e); emit_RPAREN (out))
//
} (* end of [emit_ATSCKiseqz] *)

implement
emit_ATSCKisneqz(out, d0e) =
{
//
val () = emit_text (out, "?ATSCKisneqz(")
val () = (emit_d0exp (out, d0e); emit_RPAREN (out))
//
} (* end of [emit_ATSCKisneqz] *)

(* ****** ****** *)

implement
emit_ATSCKptriscons(out, d0e) =
{
//
val () = emit_text (out, "?ATSCKptriscons(")
val () = (emit_d0exp (out, d0e); emit_RPAREN (out))
//
} (* end of [emit_ATSCKptriscons] *)

implement
emit_ATSCKptrisnull(out, d0e) =
{
//
val () = emit_text (out, "?ATSCKptrisnull(")
val () = (emit_d0exp (out, d0e); emit_RPAREN (out))
//
} (* end of [emit_ATSCKptrisnull] *)

(* ****** ****** *)

implement
emit_ATSCKpat_int
  (out, d0e, i) =
{
//
val () =
emit_text (out, "?ATSCKpat_int(")
val () = (
  emit_d0exp (out, d0e); emit_text (out, ", "); emit_d0exp (out, i); emit_RPAREN (out)
) (* end of [val] *)
//
} (* end of [emit_ATSCKpat_int] *)

(* ****** ****** *)

implement
emit_ATSCKpat_con0
  (out, d0e, tag) =
{
//
val () =
emit_text (out, "?ATSCKpat_con0(")
val () = (
  emit_d0exp (out, d0e); emit_text (out, ", "); emit_int (out, tag); emit_RPAREN (out)
) (* end of [val] *)
//
} (* end of [emit_ATSCKpat_con0] *)

implement
emit_ATSCKpat_con1
  (out, d0e, tag) =
{
//
val () =
emit_text (out, "?ATSCKpat_con1(")
val () = (
  emit_d0exp (out, d0e); emit_text (out, ", "); emit_int (out, tag); emit_RPAREN (out)
) (* end of [val] *)
//
} (* end of [emit_ATSCKpat_con1] *)

(* ****** ****** *)
//
implement
emit_tmpvar
  (out, tmp) = let
//
val
sym = tmp.i0de_sym
val
name =
g1ofg0(symbol_get_name(sym))
//
in
//
if
isneqz(name)
then let
//
  val p0 = string2ptr(name)
  val C0 = toupper($UN.ptr0_get<char>(p0))
//
  val p1 = ptr0_succ<char>(p0)
  val name1 = $UN.cast{string}(p1)
//
in
  emit_char(out, C0); emit_text(out, name1)
end // end of [then]
else () // end of [else]
//
end // end of [emit_tmpvar]
//
(* ****** ****** *)

fun
s0exp_get_arity
  (s0e: s0exp): int =
(
case+
s0e.s0exp_node
of // case+
| S0Elist(s0es) => list_length(s0es) | _ => ~1
) (* end of [s0exp_get_arity] *)

(* ****** ****** *)

implement
emit_d0exp
  (out, d0e0) = let
in
//
case+
d0e0.d0exp_node of
//
| D0Eide (tmp) => 
  {
    val () = emit_tmpvar (out, tmp)
  }
//
| D0Eappid (fid, d0es) =>
  {
    val () = emit_f0ide (out, fid)
    val () = emit_LPAREN (out)
    val () = emit_d0explst (out, d0es)
    val () = emit_RPAREN (out)
  }
| D0Eappexp (d0e, d0es) =>
  {
    val () = emit_d0exp (out, d0e)
    val () = emit_LPAREN (out)
    val () = emit_d0explst (out, d0es)
    val () = emit_RPAREN (out)
  }
//
| D0Elist (d0es) =>
  {
    val () = emit_text (out, "D0Elist")
    val () = emit_LPAREN (out)
    val () = emit_d0explst (out, d0es)
    val () = emit_RPAREN (out)
  }
//
| ATSPMVint (int) => emit_PMVint (out, int)
| ATSPMVintrep (int) => emit_PMVintrep (out, int)
//
| ATSPMVbool (tfv) => emit_PMVbool (out, tfv)
//
| ATSPMVfloat (flt) => emit_PMVfloat (out, flt)
//
| ATSPMVstring (str) => emit_PMVstring (out, str)
//
| ATSPMVi0nt (int) => emit_PMVi0nt (out, int)
| ATSPMVf0loat (flt) => emit_PMVf0loat (out, flt)
//
| ATSPMVempty (dummy) => emit_PMVempty (out, 0)
| ATSPMVextval (toklst) => emit_PMVextval (out, toklst)
//
| ATSPMVrefarg0 (d0e) => emit_d0exp (out, d0e)
| ATSPMVrefarg1 (d0e) => emit_d0exp (out, d0e)
//
| ATSPMVfunlab (fl) => emit_PMVfunlab (out, fl)
| ATSPMVcfunlab
    (_(*knd*), fl, d0es) => emit_PMVcfunlab (out, fl, d0es)
  // end of [ATSPMVcfunlab]
//
| ATSPMVcastfn
    (_(*fid*), _(*s0e*), arg) => emit_d0exp (out, arg)
//
| ATSCSTSPmyloc (tok) => emit_CSTSPmyloc (out, tok)
//
| ATSCKpat_int
    (d0e, int) => emit_ATSCKpat_int (out, d0e, int)
| ATSCKpat_con0
    (d0e, tag) => emit_ATSCKpat_con0 (out, d0e, tag)
| ATSCKpat_con1
    (d0e, tag) => emit_ATSCKpat_con1 (out, d0e, tag)
//
| ATSCKiseqz(d0e) => emit_ATSCKiseqz (out, d0e)
| ATSCKisneqz(d0e) => emit_ATSCKisneqz (out, d0e)
| ATSCKptriscons(d0e) => emit_ATSCKptriscons (out, d0e)
| ATSCKptrisnull(d0e) => emit_ATSCKptrisnull (out, d0e)
//
| ATSSELcon _ => emit_SELcon (out, d0e0)
| ATSSELrecsin _ => emit_SELrecsin (out, d0e0)
| ATSSELboxrec _ => emit_SELboxrec (out, d0e0)
| ATSSELfltrec _ => emit_text (out, "ATSSELfltrec(...)")
//
| ATSextfcall
    (_fun, _arg) => {
    val () = emit_i0de (out, _fun)
    val () = emit_d0exparg (out, _arg)
  } (* end of [ATSextfcall] *)
| ATSextmcall
    (_obj, _mtd, _arg) => {
//
    val () = emit_d0exp (out, _obj)
    val () = emit_DOT (out)
    val () = emit_d0exp (out, _mtd)
//
    val () = emit_d0exparg (out, _arg)
//
  } (* end of [ATSextmcall] *)
//
| ATSfunclo_fun
  (
    d0e_fun, s0e_arg, _(*res*)
  ) =>
  {
    val () =
    emit_text
      (out, "?ATSfunclo_fun")
    // end of [val]
    val () =
    (
      emit_LPAREN (out); emit_d0exp (out, d0e_fun); emit_RPAREN (out)
    ) (* end of [val] *)
  } (* end of [ATSfunclo_fun] *)
//
| ATSfunclo_clo
  (
    d0e_fun, _(*arg*), _(*res*)
  ) =>
  {
    val () =
    emit_text(out, "?ATSfunclo_clo")
    val () =
    (
      emit_LPAREN (out); emit_d0exp (out, d0e_fun); emit_RPAREN (out)
    ) (* end of [val] *)
  } (* end of [ATSfunclo_clo] *)
//
end // end of [emit_d0exp]

(* ****** ****** *)

local

fun
loop
(
  out: FILEref, d0es: d0explst, i: int
) : void =
(
case+ d0es of
| list_nil () => ()
| list_cons (d0e, d0es) => let
    val () =
      if i > 0 then emit_text (out, ", ")
    // end of [val]
  in
    emit_d0exp (out, d0e); loop (out, d0es, i+1)
  end // end of [list_cons]
)

in (* in-of-local *)

implement
emit_d0explst (out, d0es) = loop (out, d0es, 0)
implement
emit_d0explst_1 (out, d0es) = loop (out, d0es, 1)

end // end of [local]

(* ****** ****** *)

implement
emit_d0exparg
  (out, d0es) = 
{
//
val () = emit_LPAREN (out)
val () = emit_d0explst (out, d0es)
val () = emit_RPAREN (out)
//
} (* end of [emit_d0exparg] *)

(* ****** ****** *)
//
extern
fun
tyrec_labsel
  (tyrec: tyrec, lab: symbol): int
//
implement
tyrec_labsel
  (tyrec, lab) = let
//
fun loop
(
  xs: tyfldlst, i: int
) : int =
(
case+ xs of
| list_cons (x, xs) => let
    val TYFLD (id, s0e) = x.tyfld_node
  in
    if lab = id.i0de_sym then i else loop (xs, i+1)
  end // end of [list_cons
| list_nil ((*void*)) => ~1(*error*)
)
//
in
  loop (tyrec.tyrec_node, 0)
end // end of [tyrec_labsel]
//
(* ****** ****** *)

implement
emit_SELcon
  (out, d0e) = let
//
val-
ATSSELcon
  (d0rec, s0e, id) = d0e.d0exp_node
//
val-S0Eide(name) = s0e.s0exp_node
val-~Some_vt(s0rec) = typedef_search_opt(name)
//
val tupi = tyrec_labsel(s0rec, id.i0de_sym)
//
val () =
emit_text
  (out, "?ATSSELcon")
//
val () = emit_LPAREN (out)
//
val () =
(
  emit_d0exp (out, d0rec); emit_text (out, ", "); emit_int (out, tupi)
) (* end of [val] *)
//
val () = emit_RPAREN (out)
//
in
  // nothing
end // end of [emit_SELcon]

(* ****** ****** *)

implement
emit_SELrecsin
  (out, d0e) = let
//
val-
ATSSELrecsin
  (d0rec, s0e, id) = d0e.d0exp_node
//
in
  emit_d0exp (out, d0rec)
end // end of [emit_SELrecsin]

(* ****** ****** *)

implement
emit_SELboxrec
  (out, d0e) = let
//
val-
ATSSELboxrec
  (d0rec, s0e, id) = d0e.d0exp_node
//
val-S0Eide(name) = s0e.s0exp_node
val-~Some_vt(s0rec) = typedef_search_opt(name)
//
val tupi = tyrec_labsel(s0rec, id.i0de_sym)
//
val () =
emit_text
  (out, "?ATSSELboxrec")
//
val () = emit_LPAREN (out)
//
val () =
(
  emit_d0exp (out, d0rec); emit_text (out, ", "); emit_int (out, tupi)
) (* end of [val] *)
//
val () = emit_RPAREN (out)
//
in
  // nothing
end // end of [emit_SELboxrec]

(* ****** ****** *)
//
implement
emit_COMMENT_line
  (out, tok) = let
//
val-
T_COMMENT_line
  (str) = tok.token_node
//
in
  emit_text (out, str)
end // end of [emit_COMMENT_line]
//
implement
emit_COMMENT_block
  (out, tok) = let
//
val-
T_COMMENT_block
  (str) = tok.token_node
//
in
  emit_text (out, str)
end // end of [emit_COMMENT_block]
//
(* ****** ****** *)

local

fun
aux0_cenv
(
  out: FILEref
, s0es: s0explst
) : void = let
//
fun
auxlst
(
  i: int, s0es: s0explst
) : void =
(
case+ s0es of
| list_nil() => ()
| list_cons
    (_, s0es) => let
    val () =
      emit_text(out, ", ")
    val () =
    (
      emit_text(out, "Cenv"); emit_int(out, i)
    )
  in
    auxlst(i+1, s0es)
  end // end of [auxlst]
)
//
val () = emit_LBRACE(out)
val () = (emit_text(out, "_"); auxlst(1, s0es))
val () = emit_RBRACE(out)
//
in
  // nothing
end (* end of [aux0_cenv] *)

fun
aux0_arglst
(
  out: FILEref
, s0es: s0explst
, n0: int, i: int
) : void = (
//
case+ s0es of
| list_nil
    ((*void*)) => ()
| list_cons
    (s0e, s0es) => let
    val () =
    if n0+i > 0
      then emit_text (out, ", ")
    // end of [val]
    val () =
    (
      emit_text (out, "XArg"); emit_int (out, i)
    ) (* end of [val] *)
  in
    aux0_arglst (out, s0es, n0, i+1)
  end // end of [list_cons]
//
) (* end of [aux0_arglst] *)

fun
aux0_envlst
(
  out: FILEref
, s0es: s0explst
, n0: int, i: int
) : void = (
//
case+ s0es of
| list_nil () => ()
| list_cons
    (s0e, s0es) => let
    val () =
    if n0+i > 0
      then emit_text (out, ", ")
    // end of [val]
    val () =
    (
      emit_text (out, "XEnv"); emit_int (out, i)
    ) (* end of [val] *)
  in
    aux0_envlst (out, s0es, n0, i+1)
  end // end of [list_cons]
//
) (* end of [aux0_envlst] *)

fun
aux1_envlst
(
  out: FILEref
, s0es: s0explst, i: int
) : int =
(
case+ s0es of
| list_nil
    ((*void*)) => (i)
| list_cons
    (s0e, s0es) => let
    val () =
    if i > 0
      then emit_text (out, ", ")
    // end of [val]
    val () =
    (
      emit_text (out, "Cenv"); emit_int (out, i+1)
    ) (* end of [val] *)
  in
    aux1_envlst (out, s0es, i+1)
  end // end of [list_cons]
) (* end of [aux1_envlst] *)

in (* in-of-local *)

implement
emit_closurerize
(
  out, flab, env, arg, res
) = let
//
val-S0Elist(s0es_env) = env.s0exp_node
val-S0Elist(s0es_arg) = arg.s0exp_node
//
val () = emit_ENDL (out)
//
val () =
emit_text (out, "%%fun%%\n")
val () = emit_flabel (out, flab)
val () =
emit_text (out, "__closurerize(")
val () = aux0_envlst (out, s0es_env, 0, 0)
val ((*closing*)) = emit_text (out, ") -> \n")
//
val ((*opening*)) = emit_text (out, "%{\n")
//
val () = emit_nspc (out, 2)
val () = emit_text (out, "{")
val () = emit_text (out, "fun(")
//
val () = aux0_cenv (out, s0es_env)
val () = aux0_arglst (out, s0es_arg, 1, 0)
//
val () = emit_text (out, ") -> ")
//
val () = emit_flabel (out, flab)
//
val () = emit_LPAREN (out)
val n0 = aux1_envlst (out, s0es_env, 0)
val () = aux0_arglst (out, s0es_arg, n0, 0)
val () = emit_RPAREN (out)
//
val () = emit_text (out, " end")
//
val () = aux0_envlst (out, s0es_env, 1, 0)
val ((*closing*)) = emit_text (out, "}.\n%}\n")
//
val ((*flushing*)) = emit_newline (out)
//
in
  // nothing
end // end of [emit_closurerize]

end // end of [local]

(* ****** ****** *)

(* end of [atscc2erl_emit.dats] *)
