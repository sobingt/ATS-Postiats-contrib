(* ****** ****** *)
//
// ATS-parse-emit
//
(* ****** ****** *)
//
// HX-2014-07-02: start
//
(* ****** ****** *)
//
#include
"share/atspre_define.hats"
#include
"share/atspre_staload.hats"
//
(* ****** ****** *)

staload UN = $UNSAFE

(* ****** ****** *)

staload "./atsparemit.sats"
staload "./atsparemit_syntax.sats"
staload "./atsparemit_parsing.sats"

(* ****** ****** *)

infix ++
overload ++ with location_combine

(* ****** ****** *)

implement
parse_f0kind
  (buf, bt, err) = let
//
val err0 = err
val n0 = tokbuf_get_ntok (buf)
val tok = tokbuf_get_token (buf)
val loc = tok.token_loc
//
(*
val () = println! ("parse_f0kind: tok = ", tok)
*)
//
macdef incby1 () = tokbuf_incby1 (buf)
//
in
//
case+
tok.token_node of
| T_KWORD
  (
    ATSextern()
  ) => let
    val bt = 0
    val () = incby1 ()
    val ent1 = p_LPAREN (buf, bt, err)
    val ent2 = pif_fun (buf, bt, err, p_RPAREN, err0)
  in
    if err = err0
      then f0kind_extern (tok, ent2)
      else tokbuf_set_ntok_null (buf, n0)
    // end of [if]
  end
| T_KWORD
  (
    ATSstatic()
  ) => let
    val bt = 0
    val () = incby1 ()
    val ent1 = p_LPAREN (buf, bt, err)
    val ent2 = pif_fun (buf, bt, err, p_RPAREN, err0)
  in
    if err = err0
      then f0kind_static (tok, ent2)
      else tokbuf_set_ntok_null (buf, n0)
    // end of [if]
  end
| _ (*error*) => let
    val () = err := err + 1 in synent_null ()
  end (* end of [_] *)
//
end // end of [parse_f0kind]

(* ****** ****** *)

implement
parse_f0head
  (buf, bt, err) = let
//
val err0 = err
val ntok0 = tokbuf_get_ntok (buf)
//
val ent1 = parse_s0exp (buf, bt, err)
val ent2 = pif_fun (buf, bt, err, parse_i0de, err0)
val ent3 = pif_fun (buf, bt, err, parse_f0marg, err0)
//
in
//
if
err = err0
then f0head_make (ent1, ent2, ent3)
else tokbuf_set_ntok_null (buf, ntok0)
//
end // end of [parse_f0head]

(* ****** ****** *)

implement
parse_f0arg
  (buf, bt, err) = let
//
(*
val () = println! ("parse_f0arg")
*)
//
val err0 = err
var ent: synent?
val ntok0 = tokbuf_get_ntok (buf)
//
val ent1 = parse_s0exp (buf, bt, err)
//
in
//
if (
err = err0
) then (
case+ 0 of
//
| _ when ptest_fun
  (
    buf, parse_i0de, ent
  ) => let
    val ent2 = synent_decode2{i0de}(ent)
  in
    f0arg_some (ent1, ent2)
  end // end of [parse_i0de]
//
| _ (*none*) => f0arg_none (ent1)
//
) else tokbuf_set_ntok_null (buf, ntok0)
//
end // end of [parse_f0arg]

(* ****** ****** *)

(*
f0marg = '(' f0argseq ')'
*)

implement
parse_f0marg
  (buf, bt, err) = let
//
val err0 = err
val n0 = tokbuf_get_ntok (buf)
val tok = tokbuf_get_token (buf)
val loc = tok.token_loc
//
macdef incby1 () = tokbuf_incby1 (buf)
//
in
//
case+
tok.token_node of
//
| T_LPAREN () => let
    val bt = 0
    val () = incby1 ()
    val ent2 =
      pstar_fun0_COMMA (buf, bt, parse_f0arg)
    val ent3 = p_RPAREN (buf, bt, err) // err = err0
  in
    if err = err0
      then f0marg_make (tok, list_vt2t(ent2), ent3)
      else let
        val () = list_vt_free (ent2) in synent_null ()
      end // end of [else]
    // end of [if]
  end // end of [T_LPAREN]
//
| _ (*error*) => let
    val () = err := err + 1 in synent_null ()
  end (* end of [_] *)
//
end // end of [parse_f0marg]

(* ****** ****** *)

implement
parse_tmpdec
  (buf, bt, err) = let
//
val err0 = err
val n0 = tokbuf_get_ntok (buf)
val tok = tokbuf_get_token (buf)
val loc = tok.token_loc
//
macdef incby1 () = tokbuf_incby1 (buf)
//
in
//
case+
tok.token_node of
| T_KWORD(ATStmpdec()) => let
    val bt = 0
    val () = incby1 ()
    val ent1 = p_LPAREN (buf, bt, err)
    val ent2 = pif_fun (buf, bt, err, parse_i0de, err0)
    val ent3 = pif_fun (buf, bt, err, p_COMMA, err0)
    val ent4 = pif_fun (buf, bt, err, parse_s0exp, err0)
    val ent5 = pif_fun (buf, bt, err, p_RPAREN, err0)
    val ent6 = pif_fun (buf, bt, err, p_SEMICOLON, err0)
  in
    if err = err0
      then tmpdec_make_some (tok, ent2, ent4, ent5)
      else tokbuf_set_ntok_null (buf, n0)
    // end of [if]
  end // end of [ATStmpdec]
| T_KWORD(ATStmpdec_void()) => let
    val bt = 0
    val () = incby1 ()
    val ent1 = p_LPAREN (buf, bt, err)
    val ent2 = pif_fun (buf, bt, err, parse_i0de, err0)
    val ent3 = pif_fun (buf, bt, err, p_RPAREN, err0)
    val ent4 = pif_fun (buf, bt, err, p_SEMICOLON, err0)
  in
    if err = err0
      then tmpdec_make_none (tok, ent2, ent3) else tokbuf_set_ntok_null (buf, n0)
    // end of [if]
  end // end of [ATStmpdec_void]
//
| _ (*error*) => let
    val () = err := err + 1 in synent_null ()
  end (* end of [_] *)
//
end // end of [parse_tmpdec]

(* ****** ****** *)
//
implement
parse_tmpdecs
  (buf, bt, err) =
  list_vt2t (pstar_fun (buf, bt, parse_tmpdec))
//
(* ****** ****** *)

implement
parse_f0body
  (buf, bt, err) = let
//
val err0 = err
val n0 = tokbuf_get_ntok (buf)
val tok = tokbuf_get_token (buf)
val loc = tok.token_loc
//
macdef incby1 () = tokbuf_incby1 (buf)
//
in
//
case+
tok.token_node of
| T_LBRACE () => let
    val bt = 0
    val () = incby1 ()
    val ent1 =
      pif_fun (buf, bt, err, parse_tmpdecs, err0)
    val ent2 =
      pif_fun (buf, bt, err, parse_instrseq, err0)
    val ent3 = pif_fun (buf, bt, err, p_RBRACE, err0)
  in
    if err = err0
      then f0body_make (tok, ent1, ent2, ent3)
      else tokbuf_set_ntok_null (buf, n0)
    // end of [if]
  end // end of [T_LBRACE]
| _ (*error*) => let
    val () = err := err + 1 in synent_null ()
  end (* end of [_] *)
//
end // end of [parse_f0body]

(* ****** ****** *)

implement
parse_f0decl
  (buf, bt, err) = let
//
val err0 = err
var ent: synent?
val ntok0 = tokbuf_get_ntok (buf)
//
val ent1 = parse_f0head (buf, bt, err)
//
in
//
if (
err = err0
) then (
case+ 0 of
| _ when ptest_fun
  (
    buf, parse_f0body, ent
  ) => let
    val ent2 = synent_decode2{f0body}(ent)
  in
    f0decl_some (ent1, ent2)
  end // ...
//
| _ when
    p_SEMICOLON_test (buf) => f0decl_none (ent1)
//
| _ (*error*) => let
    val () = err := err + 1 in f0decl_none (ent1)
  end // end of [_]
//
) else tokbuf_set_ntok_null (buf, ntok0)
//
end // end of [parse_f0decl]

(* ****** ****** *)

implement
parse_d0ecl
  (buf, bt, err) = let
//
val err0 = err
var ent: synent?
//
val n0 = tokbuf_get_ntok (buf)
val tok = tokbuf_get_token (buf)
val loc = tok.token_loc
//
macdef incby1 () = tokbuf_incby1 (buf)
//
in
//
case+
tok.token_node of
//
| _ when
    ptest_SRPif0 (buf) => let
    val () = incby1 ()
    val () = pskip_SRPif0 (buf, 1(*level*))
  in
    parse_d0ecl (buf, bt, err)
  end // end of [#if(0)]
//
| T_KWORD(SRPinclude()) => let
    val bt = 0
    val () = incby1 ()
    val tok2 = p_STRING (buf, bt, err)
  in
    if err = err0
      then d0ecl_include (tok, tok2) else tokbuf_set_ntok_null (buf, n0) 
    // end of [if]
  end // end of [SRPinclude]
//
| T_KWORD(SRPifdef()) => let
    val bt = 0
    val () = incby1 ()
    val ent1 = parse_i0de (buf, bt, err) 
    val ent2 = pif_fun (buf, bt, err, parse_d0eclseq, err0)
    val ent3 = pif_fun (buf, bt, err, p_SRPendif, err0)
  in
    if err = err0
      then (
        d0ecl_ifdef (tok, ent1, ent2, ent3)
      ) else tokbuf_set_ntok_null (buf, n0)
    // end of [if]
  end // end of [SRPifdef]
//
| T_KWORD(SRPifndef()) => let
    val bt = 0
    val () = incby1 ()
    val ent1 = parse_i0de (buf, bt, err) 
    val ent2 = pif_fun (buf, bt, err, parse_d0eclseq, err0)
    val ent3 = pif_fun (buf, bt, err, p_SRPendif, err0)
  in
    if err = err0
      then (
        d0ecl_ifdef (tok, ent1, ent2, ent3)
      ) else tokbuf_set_ntok_null (buf, n0)
    // end of [if]
  end // end of [SRPifndef]
//
| T_KWORD(TYPEDEF()) => let
    val bt = 0
    val () = incby1 ()
    val ent1 = parse_tyrec (buf, bt, err)
    val ent2 = pif_fun (buf, bt, err, parse_i0de, err0)
    val ent3 = pif_fun (buf, bt, err, p_SEMICOLON, err0)
  in
    if err = err0
      then d0ecl_typedef (tok, ent1, ent2)
      else tokbuf_set_ntok_null (buf, n0)
    // end of [if]
  end // end of [TYPEDEF]
//
| T_KWORD(ATSdyncst_mac()) => let
    val bt = 0
    val () = incby1 ()
    val ent1 = p_LPAREN (buf, bt, err)
    val ent2 = pif_fun (buf, bt, err, parse_i0de, err0)
    val ent3 = pif_fun (buf, bt, err, p_RPAREN, err0)
  in
    if err = err0
      then d0ecl_dyncst_mac (tok, ent2, ent3)
      else tokbuf_set_ntok_null (buf, n0)
    // end of [if]
  end // end of [ATSdyncst_mac]
//
| T_KWORD(ATSdyncst_extfun()) => let
    val bt = 0
    val () = incby1 ()
    val ent1 = p_LPAREN (buf, bt, err)
    val ent2 = pif_fun (buf, bt, err, parse_i0de, err0)
    val ent3 = pif_fun (buf, bt, err, p_COMMA, err0)
    val ent4 = pif_fun (buf, bt, err, p_LPAREN, err0)
    val ent5 = pif_fun (buf, bt, err, parse_s0expseq, err0)
    val ent6 = pif_fun (buf, bt, err, p_RPAREN, err0)
    val ent7 = pif_fun (buf, bt, err, p_COMMA, err0)
    val ent8 = pif_fun (buf, bt, err, parse_s0exp, err0)
    val ent9 = pif_fun (buf, bt, err, p_RPAREN, err0)
    val ent10 = pif_fun (buf, bt, err, p_SEMICOLON, err0)
  in
    if err = err0
      then d0ecl_dyncst_extfun (tok, ent2, ent5, ent8, ent9)
      else tokbuf_set_ntok_null (buf, n0)
    // end of [if]
  end // end of [ATSdyncst_extfun]
//
| _ when ptest_fun
  (
    buf, parse_f0kind, ent
  ) => let
    val ent1 =
      synent_decode2{f0kind}(ent)
    // end of [val]
    val ent2 = parse_f0decl (buf, bt, err)
  in
    if err = err0
      then d0ecl_fundecl (ent1, ent2)
      else tokbuf_set_ntok_null (buf, n0)
    // end of [if]
  end // end of [parse_f0kind]
//
| _ (*error*) => let
    val () = err := err + 1
    val () = the_parerrlst_add_ifnbt (bt, loc, PARERR_d0ecl)
  in
    synent_null ((*void*))
  end // end of [_]
//
end // end of [parse_d0ecl]

(* ****** ****** *)
//
implement
parse_d0eclseq
  (buf, bt, err) =
  list_vt2t (pstar_fun (buf, bt, parse_d0ecl))
//
(* ****** ****** *)

(* end of [atsparemit_parsing_d0ecl.dats] *)