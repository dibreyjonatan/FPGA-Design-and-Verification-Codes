// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table implementation internals

#include "Vtop__pch.h"
#include "Vtop.h"
#include "Vtop___024root.h"

// FUNCTIONS
Vtop__Syms::~Vtop__Syms()
{

    // Tear down scope hierarchy
    __Vhier.remove(0, &__Vscope_ram_dual);

}

Vtop__Syms::Vtop__Syms(VerilatedContext* contextp, const char* namep, Vtop* modelp)
    : VerilatedSyms{contextp}
    // Setup internal state of the Syms class
    , __Vm_modelp{modelp}
    // Setup module instances
    , TOP{this, namep}
{
    // Configure time unit / time precision
    _vm_contextp__->timeunit(-9);
    _vm_contextp__->timeprecision(-12);
    // Setup each module's pointers to their submodules
    // Setup each module's pointer back to symbol table (for public functions)
    TOP.__Vconfigure(true);
    // Setup scopes
    __Vscope_TOP.configure(this, name(), "TOP", "TOP", 0, VerilatedScope::SCOPE_OTHER);
    __Vscope_ram_dual.configure(this, name(), "ram_dual", "ram_dual", -9, VerilatedScope::SCOPE_MODULE);

    // Set up scope hierarchy
    __Vhier.add(0, &__Vscope_ram_dual);

    // Setup export functions
    for (int __Vfinal = 0; __Vfinal < 2; ++__Vfinal) {
        __Vscope_TOP.varInsert(__Vfinal,"data", &(TOP.data), false, VLVT_UINT8,VLVD_IN|VLVF_PUB_RW,1 ,7,0);
        __Vscope_TOP.varInsert(__Vfinal,"q", &(TOP.q), false, VLVT_UINT8,VLVD_OUT|VLVF_PUB_RW,1 ,7,0);
        __Vscope_TOP.varInsert(__Vfinal,"read_addr", &(TOP.read_addr), false, VLVT_UINT8,VLVD_IN|VLVF_PUB_RW,1 ,5,0);
        __Vscope_TOP.varInsert(__Vfinal,"read_clock", &(TOP.read_clock), false, VLVT_UINT8,VLVD_IN|VLVF_PUB_RW,0);
        __Vscope_TOP.varInsert(__Vfinal,"we", &(TOP.we), false, VLVT_UINT8,VLVD_IN|VLVF_PUB_RW,0);
        __Vscope_TOP.varInsert(__Vfinal,"write_addr", &(TOP.write_addr), false, VLVT_UINT8,VLVD_IN|VLVF_PUB_RW,1 ,5,0);
        __Vscope_TOP.varInsert(__Vfinal,"write_clock", &(TOP.write_clock), false, VLVT_UINT8,VLVD_IN|VLVF_PUB_RW,0);
        __Vscope_ram_dual.varInsert(__Vfinal,"data", &(TOP.ram_dual__DOT__data), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,7,0);
        __Vscope_ram_dual.varInsert(__Vfinal,"q", &(TOP.ram_dual__DOT__q), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,7,0);
        __Vscope_ram_dual.varInsert(__Vfinal,"ram", &(TOP.ram_dual__DOT__ram), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,2 ,7,0 ,63,0);
        __Vscope_ram_dual.varInsert(__Vfinal,"read_addr", &(TOP.ram_dual__DOT__read_addr), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,5,0);
        __Vscope_ram_dual.varInsert(__Vfinal,"read_clock", &(TOP.ram_dual__DOT__read_clock), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_ram_dual.varInsert(__Vfinal,"we", &(TOP.ram_dual__DOT__we), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_ram_dual.varInsert(__Vfinal,"write_addr", &(TOP.ram_dual__DOT__write_addr), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,5,0);
        __Vscope_ram_dual.varInsert(__Vfinal,"write_clock", &(TOP.ram_dual__DOT__write_clock), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
    }
}
