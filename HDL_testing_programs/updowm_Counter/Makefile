SIM ?= verilator
TOPLEVEL_LANG ?= verilog

PWD=$(shell pwd)
VERILOG_SOURCES +=$(PWD)/updown_counter.sv

TOPLEVEL=up_down_counter
MODULE=updown_counter_test


include $(shell cocotb-config --makefiles)/Makefile.sim