#
# A Makefile for ATS-LOGO
#

######

PATSHOMEQ="$(PATSHOME)"
PATSCONTRIBQ="$(PATSCONTRIB)"

######

PATSCC=$(PATSHOMEQ)/bin/patscc
GTKFLAGS=`pkg-config gtk+-3.0 --cflags --libs`

######

all:: \
ats-logo
ats-logo: ats-logo.dats ; \
  $(PATSCC) -DATS_MEMALLOC_LIBC \
  -I$(PATSHOME)/npm-utils/contrib -I$(PATSCONTRIBQ)/contrib -o $@ $^ $(GTKFLAGS)
cleanall:: ; $(RMF) ats-logo

######

RMF=rm -f

######

clean:: ; $(RMF) *~
clean:: ; $(RMF) *_?ats.o
clean:: ; $(RMF) *_?ats.c

cleanall:: clean

###### end of [Makefile] ######
