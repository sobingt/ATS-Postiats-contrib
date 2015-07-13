(*
** Atscc2erl:
** Basis for session-types
*)

(* ****** ****** *)
//
// HX-2015-07:
// prefix for external names
//
#define
ATS_EXTERN_PREFIX "libats2erl_session_"
//
(* ****** ****** *)
//
#include
"share/atspre_define.hats"
//
staload
"{$LIBATSCC2ERL}/basics_erl.sats"
//
(* ****** ****** *)
//
abstype chsnd(a:vt@ype)
abstype chrcv(a:vt@ype)
//
(* ****** ****** *)

abstype chnil
abstype chcons(a:type, ss:type)

(* ****** ****** *)
//
stadef nil = chnil
//
stadef :: = chcons
stadef cons = chcons
//
(* ****** ****** *)

absvtype chanpos(type) = ptr
absvtype channeg(type) = ptr

(* ****** ****** *)
//
fun
chanpos_send
  {a:vt0p}{ss:type}
(
  chp: !chanpos(chsnd(a)::ss) >> chanpos(ss), x: a
) : void = "mac#%" // end-of-function
//
fun
channeg_recv
  {a:vt0p}{ss:type}
(
  chn: !channeg(chrcv(a)::ss) >> channeg(ss), x: a
) : void = "mac#%" // end-of-function
//
(* ****** ****** *)
//
fun
chanpos_recv
  {a:vt0p}{ss:type}
  (!chanpos(chrcv(a)::ss) >> chanpos(ss)): a = "mac#%"
//
fun
channeg_send
  {a:vt0p}{ss:type}
  (!channeg(chsnd(a)::ss) >> channeg(ss)): a = "mac#%"
//
(* ****** ****** *)
//
fun chanpos_nil_wait (chp: chanpos(nil)): void = "mac#%"
fun channeg_nil_close (chn: channeg(nil)): void = "mac#%"
//
(* ****** ****** *)
//
fun
chanposneg_link
  {ss:type}(chp: chanpos(ss), chn: channeg(ss)): void = "mac#%"
//
(* ****** ****** *)
//
fun
channeg_create{ss:type}
  (fserv: chanpos(ss) -<lincloptr1> void): channeg(ss) = "mac#%"
//
(* ****** ****** *)

symintr channel_send
overload channel_send with chanpos_send
overload channel_send with channeg_recv

(* ****** ****** *)

symintr channel_recv
overload channel_recv with chanpos_recv
overload channel_recv with channeg_send

(* ****** ****** *)

symintr channel_close
overload channel_close with chanpos_nil_wait
overload channel_close with channeg_nil_close

(* ****** ****** *)
//
macdef
channel_send_close
  (chx, x0) = (
//
let val chx = ,(chx) in channel_send(chx, ,(x0)); channel_close(chx) end
//
) (* end of [channel_send_close] *)
//
(* ****** ****** *)
//
macdef
channel_recv_close(chx) =
let val chx = ,(chx); val x0 = channel_recv(chx) in channel_close(chx); x0 end
//
(* ****** ****** *)

abstype chansrv(ss:type) = ptr
abstype chansrv2(env:vt@ype, ss:type) = ptr

(* ****** ****** *)
//
fun
chansrv_create{ss:type}
(
  fserv: chanpos(ss) -<cloref1> void
) : chansrv(ss) = "mac#%" // end-of-fun
//
fun
chansrv_request
  {ss:type}
  (chsrv: chansrv(ss)): channeg(ss) = "mac#%"
//
(* ****** ****** *)
//
fun
chansrv2_create
  {env:vt0p}{ss:type}
(
  fserv: (env, chanpos(ss)) -<cloref1> void
) : chansrv2(env, ss) = "mac#%" // end-of-fun
//
fun
chansrv2_request
  {env:vt0p}{ss:type}
  (env, chansrv2(env, ss)): channeg(ss) = "mac#%"
//
(* ****** ****** *)
//
fun
chansrv_register
  {ss:type}
  (name: atom, chsrv: chansrv(ss)): void = "mac#%"
fun
chansrv2_register
  {env:vt0p}{ss:type}
  (name: atom, chsrv: chansrv2(env, ss)): void = "mac#%"
//
(* ****** ****** *)

(* end of [basis.sats] *)
