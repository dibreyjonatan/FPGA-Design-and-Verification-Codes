// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vtop.h for the primary calling header

#ifndef VERILATED_VTOP___024ROOT_H_
#define VERILATED_VTOP___024ROOT_H_  // guard

#include "verilated.h"


class Vtop__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vtop___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(read_clock,0,0);
    VL_IN8(write_clock,0,0);
    VL_IN8(data,7,0);
    VL_IN8(read_addr,5,0);
    VL_IN8(write_addr,5,0);
    VL_IN8(we,0,0);
    VL_OUT8(q,7,0);
    CData/*7:0*/ ram_dual__DOT__data;
    CData/*5:0*/ ram_dual__DOT__read_addr;
    CData/*5:0*/ ram_dual__DOT__write_addr;
    CData/*0:0*/ ram_dual__DOT__we;
    CData/*0:0*/ ram_dual__DOT__read_clock;
    CData/*0:0*/ ram_dual__DOT__write_clock;
    CData/*7:0*/ ram_dual__DOT__q;
    CData/*5:0*/ __Vdlyvdim0__ram_dual__DOT__ram__v0;
    CData/*7:0*/ __Vdlyvval__ram_dual__DOT__ram__v0;
    CData/*0:0*/ __Vdlyvset__ram_dual__DOT__ram__v0;
    CData/*0:0*/ __VstlFirstIteration;
    CData/*0:0*/ __VicoFirstIteration;
    CData/*0:0*/ __Vtrigprevexpr___TOP__write_clock__0;
    CData/*0:0*/ __Vtrigprevexpr___TOP__read_clock__0;
    CData/*0:0*/ __VactContinue;
    IData/*31:0*/ __VactIterCount;
    VlUnpacked<CData/*7:0*/, 64> ram_dual__DOT__ram;
    VlTriggerVec<1> __VstlTriggered;
    VlTriggerVec<1> __VicoTriggered;
    VlTriggerVec<2> __VactTriggered;
    VlTriggerVec<2> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vtop__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vtop___024root(Vtop__Syms* symsp, const char* v__name);
    ~Vtop___024root();
    VL_UNCOPYABLE(Vtop___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
