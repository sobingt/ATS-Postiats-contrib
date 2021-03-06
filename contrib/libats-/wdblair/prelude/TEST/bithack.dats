(**
  Some examples that implement and prove correctness of 
  bit twiddling hacks from the following page.
  
  https://graphics.stanford.edu/~seander/bithacks.html
*)

staload "contrib/libats-/wdblair/patsolve/SATS/bitvector.sats"
staload "contrib/libats-/wdblair/prelude/SATS/integer.sats"

(**
  Assume we're only working with 32 bit numbers in this file.
*)
macdef int2bv = bv32_of_int
macdef uint2bv = ubv32_of_uint
macdef bool2bv = bv32_of_bool

fun 
min {x,y:bv32} (
  x: int (x), y: int (y)
): int (min(x, y)) =
  y lxor ((x lxor y) land ~bool2bv (x < y))
  
fun
max {x,y:bv32} (
  x: int (x), y: int (y)
): int (max(x, y)) =
 x lxor ((x lxor y) land ~bool2bv(x < y))
 
fun
cond_set_or_clear {f:bool} {w,m:bv32} (
  f: bool (f), 
  w: &int (w) >> int (cond_set_or_clear(bv32(f), w, m)), 
  m: int (m)
): void = {
  val () = w := w lxor ((~bool2bv(f) lxor w) land m)
}

fun
swap {x,y:bv32} (
  x: &int (x) >> int (y), y: &int (y) >> int (x)
): void = {
  val () =  x := x lxor y
  val () =  y := y lxor x
  val () =  x := x lxor y
}

fun
swap_bits {b:bv32} {i,j,n:nat | abs(i - j) >  n} (
  b: int (b), i: int i, j: int j, n: int n
): int (swap (b, bv32(i), bv32(j), bv32(n))) = let
  val i = int2bv (i)
  val j = int2bv (j)
  val n = int2bv (n)
  val one = int2bv(1)
  //
  val mask = (one << n) - one
  val x = ((b >> i) lxor (b >> j)) land mask
  val r = b lxor ((x << i) lor (x << j))
  //
in
  r
end

fun
is_power_of_two {x:bv32} (
  x: uint (x)
): bool (is_power_of_2 (x)) =
  if x = 0u then
    false
  else
    ((x land (x - 1u)) = 0u)
    
fun
has_zero_byte {x:bv32} (
  x: uint (x)
): bool (has_zero_byte(x)) =
  ~(((x - 0x01010101u) land (lnot(x) land 0x80808080u)) = 0u)
  
fun
has_byte {x,n:bv32 | ule (n, bv32(0xff))} (
  x: uint (x), n: uint (n)
): bool (has_byte(x, n)) = let
  val mask = udiv(lnot (0u), 0xffu) // 0x01010101
  val test = x lxor (mask * n)
in
  has_zero_byte (test)
end

(**
  Encode different ways to count set bits.
*)

stacst bits_set_bv32: bv32 -> int
stadef bits_set = bits_set_bv32

absprop BitCount (bv32, bv32, int)

extern
praxi
bitcount_elim_lemma {b:bv32} {n:int} (
  BitCount (b, bv32(0), n)
): [bits_set (b) == n] void

extern 
praxi 
bitcount_nil {b:bv32} (): BitCount (b, b, 0)

overload Nil with bitcount_nil

(**
  Naive approach
  
  Takes up to 32 iterations.
*)
local

extern
praxi 
bitcount_naive_succ {b,x:bv32 | ugt(x, bv32(0))} {n:int} (
  BitCount (b, x, n)
): BitCount (b, lshr (x, bv32(1)), n + bv32toint(x land bv32(1)))

overload Succ with bitcount_naive_succ

in

fun
bits_set_naive {b:bv32} (
  b: uint b
): uint (bits_set(b)) = let
  //
  fun loop {x:bv32 | ule (x, b)} {n:int} .<x>. (
    pf: BitCount (b, x, n) | x: uint (x), c: uint (n)
  ): uint (bits_set (b)) =
    if x = 0u then let
        val () = bitcount_elim_lemma (pf)
    in
        c
    end
    else
      loop (Succ (pf) | x >> 1u, c + uint_of_bv32((x land 1u)))
in
  loop (Nil () | b, 0u)
end

(**
  Interestingly, this one doesn't work. Z3 gets hung up
  trying to prove the following
    
    x = 0
    bitset (b - x) = bitset (b)
    
fun
bits_set_naive1 {b:bv32} (
  b: uint b
): uint (bits_set(b)) = let

  fun loop {x:bv32} {n:int} (
    x: uint (x), c: uint (bits_set(b-x))
  ): uint (bits_set (b)) =
    if x = 0u then
      c
    else
      loop (x >> 1u, c + uint_of_bv32((x land 1u)))
      
in
  loop (b, 0u)
end

*)

end // end of [local]

(**
  Encoding Brian Kernighan's counting set bits routine in ATS.
  
  Runs as many iterations as there are bits set.
*)
local

extern
praxi
bitcount_kernighan_succ {b,x:bv32 | ugt(x, bv32(0))} {n:int} (
  BitCount (b, x, n)
): BitCount (b, x land (x - bv32(1)), n + 1)

overload Succ with bitcount_kernighan_succ

in

fun
bits_set_kernighan {b:bv32} (
  b: uint b
): uint (bits_set(b)) = let

  fun loop {x:bv32} {n:int} .<x>. (
    pf: BitCount (b, x, n) | x: uint (x), c: uint (n)
  ): uint (bits_set (b)) =
    if x = 0u then let
      prval () = bitcount_elim_lemma (pf)
    in
      c
    end
    else
      loop (Succ(pf) | x land (x - 1u), succ(c))

in
  loop (Nil() | b, 0u)
end

end // end of [local]

typedef Uintbv = [b:bv32] uint (b)

abst@ype filesystem = ptr
abst@ype block = ptr

absvt@ype bitmap (n:int) = ptr

extern
fun filesystem_get_block (fs: filesystem, i: uint): block

overload .get_block with filesystem_get_block

(**
    Suppose we have a large array of unsigned integers. Each bit of these
    integers represents a block in our filesystem. If a bit is set, then the block
    corresponding to that bit is claimed. Otherwise, it is available.
*)
fun 
find_free_block (
    fs: filesystem
): uint = let

    fun loop (
        i: uint
    ): uint = 
        if i > 261u then
             ~1u
        else let
           val block = fs.get_block (i)
           (**
               For every word in the block, check if a zero exists. If so, return its
               index in the whole bitmap.
           *)
        in
           loop (succ (i))
        end
        
in
    loop (257u)
end

(**
    Can I enforce invariants on memory mapped registers? I don't think
    so, all memory mapped registers would have to be left values, but
    they are global which makes things difficult.
*)

abst@ype register(b:bv32) = ptr

typedef InputOnly = 
    [b:bv32 | (b land (bv32(0x1) <<  bv32(0x1))) == bv32(0x0)] 
        register (b)

extern
fun
setbit {b:bv32} {i:nat | i < 32} (
    register(b), i: uint i
): void

extern
fun 
DDRB (): InputOnly

val d = DDRB()
val _ = setbit(d, 2u)
val d = setbit(d, 3u)