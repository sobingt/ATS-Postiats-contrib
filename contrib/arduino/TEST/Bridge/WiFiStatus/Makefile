#
MYCFLAGS := -fpermissive -w
#
MYCFLAGS += -D_ATS_CCOMP_HEADER_NONE_
MYCFLAGS += -D_ATS_CCOMP_PRELUDE_NONE_
MYCFLAGS += -D_ATS_CCOMP_PRELUDE_USER_='"arduino/H/pats_ccomp.h"'
MYCFLAGS += -D_ATS_CCOMP_PRELUDE_USER2_='"arduino/H/pats_ccomp2.h"'
MYCFLAGS += -D_ATS_CCOMP_EXCEPTION_NONE_
#
MYCFLAGS += -D_ATSTYPE_VAR_SIZE_=1024
#
MYCFLAGS += -I./../../../..
#
MYCFLAGS += -I$(PATSHOME)
MYCFLAGS += -I$(PATSHOME)/ccomp/runtime
MYCFLAGS += -I$(PATSHOME)/npm-utils/contrib/libats-hwxi
#
CFLAGS_STD = $(MYCFLAGS)
CXXFLAGS_STD = $(MYCFLAGS)
#
BOARD_TAG = unoyun
#
# MONITOR_PORT=192.168.1.9
#
ARDUINO_LIBS = Bridge
#
include ./../../../Arduino-Makefile/Arduino.mk
#
######

SCP=scp
SSH=ssh
MAKE=make

######
#
# Try to find yours: 
#
UNOYUNIP=192.168.1.9
#
######
#
yunload:: yunload_step1
yunload:: yunload_step2
#
yunload_step1:: ; \
$(SCP) build-unoyun/WiFiStatus.hex root@$(UNOYUNIP):/tmp/.
yunload_step2:: ; \
$(SSH) -l root $(UNOYUNIP) \
  'merge-sketch-with-bootloader.lua /tmp/WiFiStatus.hex && run-avrdude /tmp/WiFiStatus.hex'
#
yunload_step3:: ; $(SSH) -l root $(UNOYUNIP) 'telnet localhost 6571'
#
######

cleanall:: ; $(MAKE) -f Makefile_ats cleanall

######
#
###### end of [Makefile] ######
