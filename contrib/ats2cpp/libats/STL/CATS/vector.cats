/*
(*
** A linear stack
** implementation based on STL:vector
*)
(* ****** ****** *)
(*
** Permission to use, copy, modify, and distribute this software for any
** purpose with or without fee is hereby granted, provided that the above
** copyright notice and this permission notice appear in all copies.
** 
** THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
** WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
** MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
** ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
** WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
** ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
** OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
*)
*/
/* ****** ****** */
//
// Author: Hongwei Xi
// Authoremal: gmhwxiATgmailDOTcom
// Start Time: December, 2016
//
/* ****** ****** */
//
#ifndef \
ATS2CPP_LIBATS_STL_VECTOR_CATS
#define \
ATS2CPP_LIBATS_STL_VECTOR_CATS
//
/* ****** ****** */
//
#include <vector>
//
#define \
fvectorptr(elt) std::vector<elt>*
//
#define \
fvectorptr_new(elt) new std::vector<int>()
#define \
fvectorptr_free(elt, p0) \
delete(static_cast<std::vector<elt>*>(p0))
//
#define \
fvectorptr_get_at(elt, p0, i) \
  (*(static_cast<std::vector<elt>*>(p0)))[i]
//
#define \
fvectorptr_size(elt, p0) \
  (static_cast<std::vector<elt>*>(p0))->size()
#define \
fvectorptr_back(elt, p0) \
  (static_cast<std::vector<elt>*>(p0))->back()
#define \
fvectorptr_pop_back(elt, p0) \
  (static_cast<std::vector<elt>*>(p0))->pop_back()
//
#define \
fvectorptr_push_back(elt, p0, x0) \
  (static_cast<std::vector<elt>*>(p0))->push_back(x0)
//
/* ****** ****** */
//
#endif // end of ifndef(ATS2CPP_LIBATS_STL_VECTOR_STACK_DATS)
//
/* ****** ****** */

/* end of [vector.cats] */