######
#
# A Makefile for gtkcairotimer
#
######

include \
$(PATSHOME)/share/atsmake-pre.mk

######

MYTARGET=MYTARGET
MYCCRULE=MYCCRULE

######

include \
$(PATSHOME)/share/atsmake-post.mk

######
#
PATSCC2=$(PATSCC) $(INCLUDE)
INCLUDE+=-I$(PATSHOME)/npm-utils/contrib
INCLUDE+=-I$(PATSCONTRIB)/contrib
#
######

GTKFLAGS=`pkg-config gtk+-3.0 --cflags --libs`

######
#
all:: mytimer0
#
mytimer0: \
  mytimer0.dats ; \
  $(PATSCC2) -DATS_MEMALLOC_LIBC -D_GNU_SOURCE -o $@ \
  mytimer0.dats gtkcairotimer_toplevel.dats $(GTKFLAGS) -lm -lrt
#
regress:: mytimer0; ./$<
cleanall:: ; $(RMF) mytimer0
#
######
#
all:: mytimer1
#
mytimer1: \
  mytimer1.dats ; \
  $(PATSCC2) -DATS_MEMALLOC_LIBC -D_GNU_SOURCE -o $@ \
  mytimer1.dats gtkcairotimer_toplevel.dats $(GTKFLAGS) -lm -lrt
#
regress:: mytimer1; ./$<
cleanall:: ; $(RMF) mytimer1
#
######
#
all:: mytimer1-all
#
mytimer1-all: \
  mytimer1-all.dats ; \
  $(PATSCC2) -DATS_MEMALLOC_LIBC -D_GNU_SOURCE -o $@ $< $(GTKFLAGS) -lm -lrt
#
regress:: mytimer1-all; ./$<
cleanall:: ; $(RMF) mytimer1-all
#
######

testall:: all
testall:: cleanall

######

cleanats:: ; $(RMF) *_?ats.c

###### end of [Makefile] ######
