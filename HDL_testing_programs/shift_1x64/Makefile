SIM ?= verilator
TOPLEVEL_LANG ?= verilog

PWD=$(shell pwd)
VERILOG_SOURCES +=$(PWD)/shift1x64.sv

TOPLEVEL=shift_1x64
MODULE=testbench_shift_1x64


include $(shell cocotb-config --makefiles)/Makefile.sim