
SIM ?= verilator
PWD=$(shell pwd)
TOPLEVEL_LANG ?=verilog
ifeq ($(TOPLEVEL_LANG),verilog)
    VERILOG_SOURCES+=$(PWD)/counter_4bits.sv
endif
GUI=1
TOPLEVEL=countup 
MODULE=counter_test
 ifeq ($(SIM),verilator)
      COMPILE_ARGS += --timing 
 endif	  

COCOTB_HDL_TIMEUNIT=1us
COCOTB_HDL_TIMEPRECISION=1us


include $(shell cocotb-config --makefiles)/Makefile.sim