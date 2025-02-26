TOPLEVEL_LANG ?=verilog
PWD=$(shell pwd)
SIM ?= verilator

VERILOG_SOURCES+=$(PWD)/first_hdl.v
TOPLEVEL = andgate
MODULE = first_pytest

include $(shell cocotb-config --makefiles)/Makefile.sim
