SIM ?= verilator
TOPLEVEL_LANG ?= verilog

PWD=$(shell pwd)
VERILOG_SOURCES +=$(PWD)/single_port_ram.sv

TOPLEVEL=single_port_ram
MODULE=testbench_single_port_ram


include $(shell cocotb-config --makefiles)/Makefile.sim

.PHONY : clear
clear :
	rm -rf sim_build
	rm -f *.vcd 

