#
# A simple Makefile
#
######
#
PATSCC=$(PATSHOME)/bin/patscc
PATSOPT=$(PATSHOME)/bin/patsopt
#
ATSCC2JS=$(PATSHOME)/bin/atscc2js
ATSCC2PY=$(PATSHOME)/bin/atscc2py3
#
######

PYTHON=python3

######
#
all:: \
assign02_dats.py
all:: \
assign02_sol_dats.py
#
######
#
assign02_dats.c: \
  assign02.dats; $(PATSOPT) -o $@ -d $<
assign02_dats.py: \
  assign02_dats.c; $(ATSCC2PY) -o $@ -i $<
#
######
#
assign02_sol_dats.c: \
  assign02_sol.dats; $(PATSOPT) -o $@ -d $<
assign02_sol_dats.py: \
  assign02_sol_dats.c; $(ATSCC2PY) -o $@ -i $<
#
######
#
regress:: \
assign02_dats.py; $(PYTHON) $< > assign02_dats.html
regress:: \
assign02_sol_dats.py; $(PYTHON) $< > assign02_sol_dats.html
#
######
#
clean:: ; rm -f *~
clean:: ; rm -f assign02_dats.c
clean:: ; rm -f assign02_sol_dats.c
#
cleanall:: clean
cleanall:: ; rm -f assign02_dats.py
cleanall:: ; rm -f assign02_dats.html
cleanall:: ; rm -f assign02_sol_dats.py
cleanall:: ; rm -f assign02_sol_dats.html
#
######

###### end of [Makefile] ######
