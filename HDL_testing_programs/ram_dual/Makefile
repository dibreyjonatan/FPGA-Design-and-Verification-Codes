SIM ?= verilator
TOPLEVEL_LANG ?= verilog

PWD=$(shell pwd)
VERILOG_SOURCES +=$(PWD)/ram_dual.sv

TOPLEVEL=ram_dual
MODULE=testbench_ram


include $(shell cocotb-config --makefiles)/Makefile.sim
