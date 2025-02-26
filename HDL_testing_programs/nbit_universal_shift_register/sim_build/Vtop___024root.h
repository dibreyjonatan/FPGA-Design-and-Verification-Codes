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
    VL_IN8(clk,0,0);
    VL_IN8(reset,0,0);
    VL_IN8(control,1,0);
    CData/*1:0*/ univ_shift__DOT__control;
    CData/*0:0*/ univ_shift__DOT__clk;
    CData/*0:0*/ univ_shift__DOT__reset;
    CData/*0:0*/ __VstlFirstIteration;
    CData/*0:0*/ __VicoFirstIteration;
    CData/*0:0*/ __Vtrigprevexpr___TOP__clk__0;
    CData/*0:0*/ __Vtrigprevexpr___TOP__reset__0;
    CData/*0:0*/ __VactContinue;
    VL_IN16(data_in,15,0);
    VL_OUT16(data_out,15,0);
    SData/*15:0*/ univ_shift__DOT__data_in;
    SData/*15:0*/ univ_shift__DOT__data_out;
    IData/*31:0*/ __VactIterCount;
    VlTriggerVec<1> __VstlTriggered;
    VlTriggerVec<1> __VicoTriggered;
    VlTriggerVec<1> __VactTriggered;
    VlTriggerVec<1> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vtop__Syms* const vlSymsp;

    // PARAMETERS
    static constexpr IData/*31:0*/ univ_shift__DOT__n = 0x00000010U;
    static constexpr IData/*31:0*/ univ_shift__DOT__hold = 0U;
    static constexpr IData/*31:0*/ univ_shift__DOT__shift_left = 1U;
    static constexpr IData/*31:0*/ univ_shift__DOT__shift_right = 2U;
    static constexpr IData/*31:0*/ univ_shift__DOT__siso = 3U;

    // CONSTRUCTORS
    Vtop___024root(Vtop__Syms* symsp, const char* v__name);
    ~Vtop___024root();
    VL_UNCOPYABLE(Vtop___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
