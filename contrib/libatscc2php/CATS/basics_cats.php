<?php

/*
******
*
* HX-2014-08:
* for PHP code
* translated from ATS
*
******
*/

/*
******
* beg of [basics_cats.php]
******
*/

/* ****** ****** */

function
ATSCKiseqz($x) { return ($x === 0); }
function
ATSCKisneqz($x) { return ($x !== 0); }

/* ****** ****** */

function
ATSCKptrisnull($xs) { return ($xs === NULL) ; }
function
ATSCKptriscons($xs) { return ($xs !== NULL) ; }

/* ****** ****** */

function
ATSCKpat_int($tmp, $given) { return ($tmp === $given) ; }
function
ATSCKpat_bool($tmp, $given) { return ($tmp === $given) ; }
function
ATSCKpat_char($tmp, $given) { return ($tmp === $given) ; }
function
ATSCKpat_float($tmp, $given) { return ($tmp === $given) ; }

/* ****** ****** */

function
ATSCKpat_con0($con, $tag) { return ($con === $tag) ; }
function
ATSCKpat_con1($con, $tag) { return ($con[0] === $tag) ; }

/* ****** ****** */
//
function
ats2phppre_echo0_obj() { return; }
function
ats2phppre_echo1_obj($x1) { echo($x1); return; }
function
ats2phppre_echo2_obj($x1, $x2) { echo($x1); echo($x2); return; }
//
function
ats2phppre_echo3_obj ($x1, $x2, $x3)
  { echo($x1); echo ($x2); echo($x3); return; }
function
ats2phppre_echo4_obj
  ($x1, $x2, $x3, $x4)
{
  echo($x1); echo($x2); echo($x3); echo($x4); return;
}
function
ats2phppre_echo5_obj
  ($x1, $x2, $x3, $x4, $x5)
{
  echo($x1); echo($x2); echo($x3); echo($x4); echo($x5); return;
}
function
ats2phppre_echo6_obj
  ($x1, $x2, $x3, $x4, $x5, $x6)
{
  echo($x1); echo($x2); echo($x3); echo($x4); echo($x5); echo($x6); return;
}
//
/* ****** ****** */
//
function
ats2phppre_print_obj($x) { print($x); return; }
//
function
ats2phppre_print_r_obj($x) { print_r($x); return; }
//
/* ****** ****** */

function
ats2phppre_print_newline() { print("\n"); flush(); return; }
function
ats2phppre_fprint_newline($out) { fprintf($out, "\n"); fflush($out); return; }

/* ****** ****** */
//
function
ats2phppre_assert_bool0($tfv, $errmsg) { if (!$tfv) exit(1); return; }
function
ats2phppre_assert_bool1($tfv, $errmsg) { if (!$tfv) exit(1); return; }
//
/* ****** ****** */
//
function
ats2phppre_assert_errmsg_bool0($tfv, $errmsg)
{
  if (!$tfv) { fprintf(STDERR, "%s", $errmsg); sys.exit(1); }; return;
}
function
ats2phppre_assert_errmsg_bool1($tfv, $errmsg)
{
  if (!$tfv) { fprintf(STDERR, "%s", $errmsg); sys.exit(1); }; return;
}
//
/* ****** ****** */

/* end of [basics_cats.php] */

?>
