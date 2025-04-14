// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table implementation internals

#include "Vtop__pch.h"
#include "Vtop.h"
#include "Vtop___024root.h"

// FUNCTIONS
Vtop__Syms::~Vtop__Syms()
{

    // Tear down scope hierarchy
    __Vhier.remove(0, &__Vscope_shift_8x64_taps);

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
    __Vscope_shift_8x64_taps.configure(this, name(), "shift_8x64_taps", "shift_8x64_taps", -9, VerilatedScope::SCOPE_MODULE);

    // Set up scope hierarchy
    __Vhier.add(0, &__Vscope_shift_8x64_taps);

    // Setup export functions
    for (int __Vfinal = 0; __Vfinal < 2; ++__Vfinal) {
        __Vscope_TOP.varInsert(__Vfinal,"clk", &(TOP.clk), false, VLVT_UINT8,VLVD_IN|VLVF_PUB_RW,0);
        __Vscope_TOP.varInsert(__Vfinal,"shift", &(TOP.shift), false, VLVT_UINT8,VLVD_IN|VLVF_PUB_RW,0);
        __Vscope_TOP.varInsert(__Vfinal,"sr_in", &(TOP.sr_in), false, VLVT_UINT8,VLVD_IN|VLVF_PUB_RW,1 ,7,0);
        __Vscope_TOP.varInsert(__Vfinal,"sr_out", &(TOP.sr_out), false, VLVT_UINT8,VLVD_OUT|VLVF_PUB_RW,1 ,7,0);
        __Vscope_TOP.varInsert(__Vfinal,"sr_tap_one", &(TOP.sr_tap_one), false, VLVT_UINT8,VLVD_OUT|VLVF_PUB_RW,1 ,7,0);
        __Vscope_TOP.varInsert(__Vfinal,"sr_tap_three", &(TOP.sr_tap_three), false, VLVT_UINT8,VLVD_OUT|VLVF_PUB_RW,1 ,7,0);
        __Vscope_TOP.varInsert(__Vfinal,"sr_tap_two", &(TOP.sr_tap_two), false, VLVT_UINT8,VLVD_OUT|VLVF_PUB_RW,1 ,7,0);
        __Vscope_shift_8x64_taps.varInsert(__Vfinal,"clk", &(TOP.shift_8x64_taps__DOT__clk), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_shift_8x64_taps.varInsert(__Vfinal,"n", &(TOP.shift_8x64_taps__DOT__n), false, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,1 ,31,0);
        __Vscope_shift_8x64_taps.varInsert(__Vfinal,"shift", &(TOP.shift_8x64_taps__DOT__shift), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_shift_8x64_taps.varInsert(__Vfinal,"sr", &(TOP.shift_8x64_taps__DOT__sr), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,2 ,7,0 ,63,0);
        __Vscope_shift_8x64_taps.varInsert(__Vfinal,"sr_in", &(TOP.shift_8x64_taps__DOT__sr_in), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,7,0);
        __Vscope_shift_8x64_taps.varInsert(__Vfinal,"sr_out", &(TOP.shift_8x64_taps__DOT__sr_out), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,7,0);
        __Vscope_shift_8x64_taps.varInsert(__Vfinal,"sr_tap_one", &(TOP.shift_8x64_taps__DOT__sr_tap_one), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,7,0);
        __Vscope_shift_8x64_taps.varInsert(__Vfinal,"sr_tap_three", &(TOP.shift_8x64_taps__DOT__sr_tap_three), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,7,0);
        __Vscope_shift_8x64_taps.varInsert(__Vfinal,"sr_tap_two", &(TOP.shift_8x64_taps__DOT__sr_tap_two), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,7,0);
    }
}
