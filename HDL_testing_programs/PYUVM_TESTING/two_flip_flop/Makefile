SIM ?= icarus
TOPLEVEL_LANG ?= verilog

PWD=$(shell pwd)
VERILOG_SOURCES +=$(PWD)/two_flipflop.sv

TOPLEVEL=sync_2dff
MODULE=testbench
COMPILE_ARGS+= --timing

export COCOTB_RESOLVE_X ?=ZEROS
export COCOTB_HDL_TIMEUNIT=1 ns
export COCOTB_HDL_TIMEPRECISON = 1 ns
include $(shell cocotb-config --makefiles)/Makefile.sim
