// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtop.h for the primary calling header

#include "Vtop__pch.h"
#include "Vtop___024root.h"

VL_INLINE_OPT void Vtop___024root___ico_sequent__TOP__0(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___ico_sequent__TOP__0\n"); );
    // Body
    vlSelf->shift_8x64_taps__DOT__clk = vlSelf->clk;
    vlSelf->shift_8x64_taps__DOT__sr_in = vlSelf->sr_in;
    vlSelf->shift_8x64_taps__DOT__shift = vlSelf->shift;
    vlSelf->sr_out = vlSelf->shift_8x64_taps__DOT__sr
        [0x3fU];
    vlSelf->sr_tap_one = vlSelf->shift_8x64_taps__DOT__sr
        [0xfU];
    vlSelf->sr_tap_two = vlSelf->shift_8x64_taps__DOT__sr
        [0x1fU];
    vlSelf->sr_tap_three = vlSelf->shift_8x64_taps__DOT__sr
        [0x2fU];
    vlSelf->shift_8x64_taps__DOT__sr_out = vlSelf->sr_out;
    vlSelf->shift_8x64_taps__DOT__sr_tap_one = vlSelf->sr_tap_one;
    vlSelf->shift_8x64_taps__DOT__sr_tap_two = vlSelf->sr_tap_two;
    vlSelf->shift_8x64_taps__DOT__sr_tap_three = vlSelf->sr_tap_three;
}

void Vtop___024root___eval_ico(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_ico\n"); );
    // Body
    if ((1ULL & vlSelf->__VicoTriggered.word(0U))) {
        Vtop___024root___ico_sequent__TOP__0(vlSelf);
    }
}

void Vtop___024root___eval_triggers__ico(Vtop___024root* vlSelf);

bool Vtop___024root___eval_phase__ico(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_phase__ico\n"); );
    // Init
    CData/*0:0*/ __VicoExecute;
    // Body
    Vtop___024root___eval_triggers__ico(vlSelf);
    __VicoExecute = vlSelf->__VicoTriggered.any();
    if (__VicoExecute) {
        Vtop___024root___eval_ico(vlSelf);
    }
    return (__VicoExecute);
}

void Vtop___024root___eval_act(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_act\n"); );
}

VL_INLINE_OPT void Vtop___024root___nba_sequent__TOP__0(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___nba_sequent__TOP__0\n"); );
    // Init
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v0;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v0 = 0;
    CData/*0:0*/ __Vdlyvset__shift_8x64_taps__DOT__sr__v0;
    __Vdlyvset__shift_8x64_taps__DOT__sr__v0 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v1;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v1 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v2;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v2 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v3;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v3 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v4;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v4 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v5;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v5 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v6;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v6 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v7;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v7 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v8;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v8 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v9;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v9 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v10;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v10 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v11;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v11 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v12;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v12 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v13;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v13 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v14;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v14 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v15;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v15 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v16;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v16 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v17;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v17 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v18;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v18 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v19;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v19 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v20;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v20 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v21;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v21 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v22;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v22 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v23;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v23 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v24;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v24 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v25;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v25 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v26;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v26 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v27;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v27 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v28;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v28 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v29;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v29 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v30;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v30 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v31;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v31 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v32;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v32 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v33;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v33 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v34;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v34 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v35;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v35 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v36;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v36 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v37;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v37 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v38;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v38 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v39;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v39 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v40;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v40 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v41;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v41 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v42;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v42 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v43;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v43 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v44;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v44 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v45;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v45 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v46;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v46 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v47;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v47 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v48;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v48 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v49;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v49 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v50;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v50 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v51;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v51 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v52;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v52 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v53;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v53 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v54;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v54 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v55;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v55 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v56;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v56 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v57;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v57 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v58;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v58 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v59;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v59 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v60;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v60 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v61;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v61 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v62;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v62 = 0;
    CData/*7:0*/ __Vdlyvval__shift_8x64_taps__DOT__sr__v63;
    __Vdlyvval__shift_8x64_taps__DOT__sr__v63 = 0;
    // Body
    __Vdlyvset__shift_8x64_taps__DOT__sr__v0 = 0U;
    if (vlSelf->shift) {
        vlSelf->shift_8x64_taps__DOT__n = 0x3eU;
        vlSelf->shift_8x64_taps__DOT__n = 0x3dU;
        vlSelf->shift_8x64_taps__DOT__n = 0x3cU;
        vlSelf->shift_8x64_taps__DOT__n = 0x3bU;
        vlSelf->shift_8x64_taps__DOT__n = 0x3aU;
        vlSelf->shift_8x64_taps__DOT__n = 0x39U;
        vlSelf->shift_8x64_taps__DOT__n = 0x38U;
        vlSelf->shift_8x64_taps__DOT__n = 0x37U;
        vlSelf->shift_8x64_taps__DOT__n = 0x36U;
        vlSelf->shift_8x64_taps__DOT__n = 0x35U;
        vlSelf->shift_8x64_taps__DOT__n = 0x34U;
        vlSelf->shift_8x64_taps__DOT__n = 0x33U;
        vlSelf->shift_8x64_taps__DOT__n = 0x32U;
        vlSelf->shift_8x64_taps__DOT__n = 0x31U;
        vlSelf->shift_8x64_taps__DOT__n = 0x30U;
        vlSelf->shift_8x64_taps__DOT__n = 0x2fU;
        vlSelf->shift_8x64_taps__DOT__n = 0x2eU;
        vlSelf->shift_8x64_taps__DOT__n = 0x2dU;
        vlSelf->shift_8x64_taps__DOT__n = 0x2cU;
        vlSelf->shift_8x64_taps__DOT__n = 0x2bU;
        vlSelf->shift_8x64_taps__DOT__n = 0x2aU;
        vlSelf->shift_8x64_taps__DOT__n = 0x29U;
        vlSelf->shift_8x64_taps__DOT__n = 0x28U;
        vlSelf->shift_8x64_taps__DOT__n = 0x27U;
        vlSelf->shift_8x64_taps__DOT__n = 0x26U;
        vlSelf->shift_8x64_taps__DOT__n = 0x25U;
        vlSelf->shift_8x64_taps__DOT__n = 0x24U;
        vlSelf->shift_8x64_taps__DOT__n = 0x23U;
        vlSelf->shift_8x64_taps__DOT__n = 0x22U;
        vlSelf->shift_8x64_taps__DOT__n = 0x21U;
        vlSelf->shift_8x64_taps__DOT__n = 0x20U;
        vlSelf->shift_8x64_taps__DOT__n = 0x1fU;
        vlSelf->shift_8x64_taps__DOT__n = 0x1eU;
        vlSelf->shift_8x64_taps__DOT__n = 0x1dU;
        vlSelf->shift_8x64_taps__DOT__n = 0x1cU;
        vlSelf->shift_8x64_taps__DOT__n = 0x1bU;
        vlSelf->shift_8x64_taps__DOT__n = 0x1aU;
        vlSelf->shift_8x64_taps__DOT__n = 0x19U;
        vlSelf->shift_8x64_taps__DOT__n = 0x18U;
        vlSelf->shift_8x64_taps__DOT__n = 0x17U;
        vlSelf->shift_8x64_taps__DOT__n = 0x16U;
        vlSelf->shift_8x64_taps__DOT__n = 0x15U;
        vlSelf->shift_8x64_taps__DOT__n = 0x14U;
        vlSelf->shift_8x64_taps__DOT__n = 0x13U;
        vlSelf->shift_8x64_taps__DOT__n = 0x12U;
        vlSelf->shift_8x64_taps__DOT__n = 0x11U;
        vlSelf->shift_8x64_taps__DOT__n = 0x10U;
        vlSelf->shift_8x64_taps__DOT__n = 0xfU;
        vlSelf->shift_8x64_taps__DOT__n = 0xeU;
        vlSelf->shift_8x64_taps__DOT__n = 0xdU;
        vlSelf->shift_8x64_taps__DOT__n = 0xcU;
        vlSelf->shift_8x64_taps__DOT__n = 0xbU;
        vlSelf->shift_8x64_taps__DOT__n = 0xaU;
        vlSelf->shift_8x64_taps__DOT__n = 9U;
        vlSelf->shift_8x64_taps__DOT__n = 8U;
        vlSelf->shift_8x64_taps__DOT__n = 7U;
        vlSelf->shift_8x64_taps__DOT__n = 6U;
        vlSelf->shift_8x64_taps__DOT__n = 5U;
        vlSelf->shift_8x64_taps__DOT__n = 4U;
        vlSelf->shift_8x64_taps__DOT__n = 3U;
        vlSelf->shift_8x64_taps__DOT__n = 2U;
        vlSelf->shift_8x64_taps__DOT__n = 1U;
        vlSelf->shift_8x64_taps__DOT__n = 0U;
        __Vdlyvval__shift_8x64_taps__DOT__sr__v0 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x3eU];
        __Vdlyvset__shift_8x64_taps__DOT__sr__v0 = 1U;
        __Vdlyvval__shift_8x64_taps__DOT__sr__v1 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x3dU];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v2 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x3cU];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v3 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x3bU];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v4 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x3aU];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v5 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x39U];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v6 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x38U];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v7 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x37U];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v8 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x36U];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v9 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x35U];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v10 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x34U];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v11 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x33U];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v12 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x32U];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v13 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x31U];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v14 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x30U];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v15 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x2fU];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v16 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x2eU];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v17 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x2dU];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v18 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x2cU];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v19 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x2bU];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v20 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x2aU];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v21 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x29U];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v22 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x28U];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v23 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x27U];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v24 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x26U];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v25 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x25U];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v26 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x24U];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v27 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x23U];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v28 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x22U];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v29 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x21U];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v30 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x20U];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v31 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x1fU];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v32 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x1eU];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v33 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x1dU];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v34 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x1cU];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v35 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x1bU];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v36 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x1aU];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v37 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x19U];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v38 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x18U];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v39 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x17U];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v40 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x16U];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v41 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x15U];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v42 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x14U];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v43 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x13U];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v44 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x12U];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v45 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x11U];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v46 = 
            vlSelf->shift_8x64_taps__DOT__sr[0x10U];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v47 = 
            vlSelf->shift_8x64_taps__DOT__sr[0xfU];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v48 = 
            vlSelf->shift_8x64_taps__DOT__sr[0xeU];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v49 = 
            vlSelf->shift_8x64_taps__DOT__sr[0xdU];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v50 = 
            vlSelf->shift_8x64_taps__DOT__sr[0xcU];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v51 = 
            vlSelf->shift_8x64_taps__DOT__sr[0xbU];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v52 = 
            vlSelf->shift_8x64_taps__DOT__sr[0xaU];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v53 = 
            vlSelf->shift_8x64_taps__DOT__sr[9U];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v54 = 
            vlSelf->shift_8x64_taps__DOT__sr[8U];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v55 = 
            vlSelf->shift_8x64_taps__DOT__sr[7U];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v56 = 
            vlSelf->shift_8x64_taps__DOT__sr[6U];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v57 = 
            vlSelf->shift_8x64_taps__DOT__sr[5U];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v58 = 
            vlSelf->shift_8x64_taps__DOT__sr[4U];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v59 = 
            vlSelf->shift_8x64_taps__DOT__sr[3U];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v60 = 
            vlSelf->shift_8x64_taps__DOT__sr[2U];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v61 = 
            vlSelf->shift_8x64_taps__DOT__sr[1U];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v62 = 
            vlSelf->shift_8x64_taps__DOT__sr[0U];
        __Vdlyvval__shift_8x64_taps__DOT__sr__v63 = vlSelf->sr_in;
    }
    if (__Vdlyvset__shift_8x64_taps__DOT__sr__v0) {
        vlSelf->shift_8x64_taps__DOT__sr[0x3fU] = __Vdlyvval__shift_8x64_taps__DOT__sr__v0;
        vlSelf->shift_8x64_taps__DOT__sr[0x3eU] = __Vdlyvval__shift_8x64_taps__DOT__sr__v1;
        vlSelf->shift_8x64_taps__DOT__sr[0x3dU] = __Vdlyvval__shift_8x64_taps__DOT__sr__v2;
        vlSelf->shift_8x64_taps__DOT__sr[0x3cU] = __Vdlyvval__shift_8x64_taps__DOT__sr__v3;
        vlSelf->shift_8x64_taps__DOT__sr[0x3bU] = __Vdlyvval__shift_8x64_taps__DOT__sr__v4;
        vlSelf->shift_8x64_taps__DOT__sr[0x3aU] = __Vdlyvval__shift_8x64_taps__DOT__sr__v5;
        vlSelf->shift_8x64_taps__DOT__sr[0x39U] = __Vdlyvval__shift_8x64_taps__DOT__sr__v6;
        vlSelf->shift_8x64_taps__DOT__sr[0x38U] = __Vdlyvval__shift_8x64_taps__DOT__sr__v7;
        vlSelf->shift_8x64_taps__DOT__sr[0x37U] = __Vdlyvval__shift_8x64_taps__DOT__sr__v8;
        vlSelf->shift_8x64_taps__DOT__sr[0x36U] = __Vdlyvval__shift_8x64_taps__DOT__sr__v9;
        vlSelf->shift_8x64_taps__DOT__sr[0x35U] = __Vdlyvval__shift_8x64_taps__DOT__sr__v10;
        vlSelf->shift_8x64_taps__DOT__sr[0x34U] = __Vdlyvval__shift_8x64_taps__DOT__sr__v11;
        vlSelf->shift_8x64_taps__DOT__sr[0x33U] = __Vdlyvval__shift_8x64_taps__DOT__sr__v12;
        vlSelf->shift_8x64_taps__DOT__sr[0x32U] = __Vdlyvval__shift_8x64_taps__DOT__sr__v13;
        vlSelf->shift_8x64_taps__DOT__sr[0x31U] = __Vdlyvval__shift_8x64_taps__DOT__sr__v14;
        vlSelf->shift_8x64_taps__DOT__sr[0x30U] = __Vdlyvval__shift_8x64_taps__DOT__sr__v15;
        vlSelf->shift_8x64_taps__DOT__sr[0x2fU] = __Vdlyvval__shift_8x64_taps__DOT__sr__v16;
        vlSelf->shift_8x64_taps__DOT__sr[0x2eU] = __Vdlyvval__shift_8x64_taps__DOT__sr__v17;
        vlSelf->shift_8x64_taps__DOT__sr[0x2dU] = __Vdlyvval__shift_8x64_taps__DOT__sr__v18;
        vlSelf->shift_8x64_taps__DOT__sr[0x2cU] = __Vdlyvval__shift_8x64_taps__DOT__sr__v19;
        vlSelf->shift_8x64_taps__DOT__sr[0x2bU] = __Vdlyvval__shift_8x64_taps__DOT__sr__v20;
        vlSelf->shift_8x64_taps__DOT__sr[0x2aU] = __Vdlyvval__shift_8x64_taps__DOT__sr__v21;
        vlSelf->shift_8x64_taps__DOT__sr[0x29U] = __Vdlyvval__shift_8x64_taps__DOT__sr__v22;
        vlSelf->shift_8x64_taps__DOT__sr[0x28U] = __Vdlyvval__shift_8x64_taps__DOT__sr__v23;
        vlSelf->shift_8x64_taps__DOT__sr[0x27U] = __Vdlyvval__shift_8x64_taps__DOT__sr__v24;
        vlSelf->shift_8x64_taps__DOT__sr[0x26U] = __Vdlyvval__shift_8x64_taps__DOT__sr__v25;
        vlSelf->shift_8x64_taps__DOT__sr[0x25U] = __Vdlyvval__shift_8x64_taps__DOT__sr__v26;
        vlSelf->shift_8x64_taps__DOT__sr[0x24U] = __Vdlyvval__shift_8x64_taps__DOT__sr__v27;
        vlSelf->shift_8x64_taps__DOT__sr[0x23U] = __Vdlyvval__shift_8x64_taps__DOT__sr__v28;
        vlSelf->shift_8x64_taps__DOT__sr[0x22U] = __Vdlyvval__shift_8x64_taps__DOT__sr__v29;
        vlSelf->shift_8x64_taps__DOT__sr[0x21U] = __Vdlyvval__shift_8x64_taps__DOT__sr__v30;
        vlSelf->shift_8x64_taps__DOT__sr[0x20U] = __Vdlyvval__shift_8x64_taps__DOT__sr__v31;
        vlSelf->shift_8x64_taps__DOT__sr[0x1fU] = __Vdlyvval__shift_8x64_taps__DOT__sr__v32;
        vlSelf->shift_8x64_taps__DOT__sr[0x1eU] = __Vdlyvval__shift_8x64_taps__DOT__sr__v33;
        vlSelf->shift_8x64_taps__DOT__sr[0x1dU] = __Vdlyvval__shift_8x64_taps__DOT__sr__v34;
        vlSelf->shift_8x64_taps__DOT__sr[0x1cU] = __Vdlyvval__shift_8x64_taps__DOT__sr__v35;
        vlSelf->shift_8x64_taps__DOT__sr[0x1bU] = __Vdlyvval__shift_8x64_taps__DOT__sr__v36;
        vlSelf->shift_8x64_taps__DOT__sr[0x1aU] = __Vdlyvval__shift_8x64_taps__DOT__sr__v37;
        vlSelf->shift_8x64_taps__DOT__sr[0x19U] = __Vdlyvval__shift_8x64_taps__DOT__sr__v38;
        vlSelf->shift_8x64_taps__DOT__sr[0x18U] = __Vdlyvval__shift_8x64_taps__DOT__sr__v39;
        vlSelf->shift_8x64_taps__DOT__sr[0x17U] = __Vdlyvval__shift_8x64_taps__DOT__sr__v40;
        vlSelf->shift_8x64_taps__DOT__sr[0x16U] = __Vdlyvval__shift_8x64_taps__DOT__sr__v41;
        vlSelf->shift_8x64_taps__DOT__sr[0x15U] = __Vdlyvval__shift_8x64_taps__DOT__sr__v42;
        vlSelf->shift_8x64_taps__DOT__sr[0x14U] = __Vdlyvval__shift_8x64_taps__DOT__sr__v43;
        vlSelf->shift_8x64_taps__DOT__sr[0x13U] = __Vdlyvval__shift_8x64_taps__DOT__sr__v44;
        vlSelf->shift_8x64_taps__DOT__sr[0x12U] = __Vdlyvval__shift_8x64_taps__DOT__sr__v45;
        vlSelf->shift_8x64_taps__DOT__sr[0x11U] = __Vdlyvval__shift_8x64_taps__DOT__sr__v46;
        vlSelf->shift_8x64_taps__DOT__sr[0x10U] = __Vdlyvval__shift_8x64_taps__DOT__sr__v47;
        vlSelf->shift_8x64_taps__DOT__sr[0xfU] = __Vdlyvval__shift_8x64_taps__DOT__sr__v48;
        vlSelf->shift_8x64_taps__DOT__sr[0xeU] = __Vdlyvval__shift_8x64_taps__DOT__sr__v49;
        vlSelf->shift_8x64_taps__DOT__sr[0xdU] = __Vdlyvval__shift_8x64_taps__DOT__sr__v50;
        vlSelf->shift_8x64_taps__DOT__sr[0xcU] = __Vdlyvval__shift_8x64_taps__DOT__sr__v51;
        vlSelf->shift_8x64_taps__DOT__sr[0xbU] = __Vdlyvval__shift_8x64_taps__DOT__sr__v52;
        vlSelf->shift_8x64_taps__DOT__sr[0xaU] = __Vdlyvval__shift_8x64_taps__DOT__sr__v53;
        vlSelf->shift_8x64_taps__DOT__sr[9U] = __Vdlyvval__shift_8x64_taps__DOT__sr__v54;
        vlSelf->shift_8x64_taps__DOT__sr[8U] = __Vdlyvval__shift_8x64_taps__DOT__sr__v55;
        vlSelf->shift_8x64_taps__DOT__sr[7U] = __Vdlyvval__shift_8x64_taps__DOT__sr__v56;
        vlSelf->shift_8x64_taps__DOT__sr[6U] = __Vdlyvval__shift_8x64_taps__DOT__sr__v57;
        vlSelf->shift_8x64_taps__DOT__sr[5U] = __Vdlyvval__shift_8x64_taps__DOT__sr__v58;
        vlSelf->shift_8x64_taps__DOT__sr[4U] = __Vdlyvval__shift_8x64_taps__DOT__sr__v59;
        vlSelf->shift_8x64_taps__DOT__sr[3U] = __Vdlyvval__shift_8x64_taps__DOT__sr__v60;
        vlSelf->shift_8x64_taps__DOT__sr[2U] = __Vdlyvval__shift_8x64_taps__DOT__sr__v61;
        vlSelf->shift_8x64_taps__DOT__sr[1U] = __Vdlyvval__shift_8x64_taps__DOT__sr__v62;
        vlSelf->shift_8x64_taps__DOT__sr[0U] = __Vdlyvval__shift_8x64_taps__DOT__sr__v63;
    }
    vlSelf->sr_out = vlSelf->shift_8x64_taps__DOT__sr
        [0x3fU];
    vlSelf->sr_tap_one = vlSelf->shift_8x64_taps__DOT__sr
        [0xfU];
    vlSelf->sr_tap_two = vlSelf->shift_8x64_taps__DOT__sr
        [0x1fU];
    vlSelf->sr_tap_three = vlSelf->shift_8x64_taps__DOT__sr
        [0x2fU];
    vlSelf->shift_8x64_taps__DOT__sr_out = vlSelf->sr_out;
    vlSelf->shift_8x64_taps__DOT__sr_tap_one = vlSelf->sr_tap_one;
    vlSelf->shift_8x64_taps__DOT__sr_tap_two = vlSelf->sr_tap_two;
    vlSelf->shift_8x64_taps__DOT__sr_tap_three = vlSelf->sr_tap_three;
}

void Vtop___024root___eval_nba(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_nba\n"); );
    // Body
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Vtop___024root___nba_sequent__TOP__0(vlSelf);
    }
}

void Vtop___024root___eval_triggers__act(Vtop___024root* vlSelf);

bool Vtop___024root___eval_phase__act(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_phase__act\n"); );
    // Init
    VlTriggerVec<1> __VpreTriggered;
    CData/*0:0*/ __VactExecute;
    // Body
    Vtop___024root___eval_triggers__act(vlSelf);
    __VactExecute = vlSelf->__VactTriggered.any();
    if (__VactExecute) {
        __VpreTriggered.andNot(vlSelf->__VactTriggered, vlSelf->__VnbaTriggered);
        vlSelf->__VnbaTriggered.thisOr(vlSelf->__VactTriggered);
        Vtop___024root___eval_act(vlSelf);
    }
    return (__VactExecute);
}

bool Vtop___024root___eval_phase__nba(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_phase__nba\n"); );
    // Init
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = vlSelf->__VnbaTriggered.any();
    if (__VnbaExecute) {
        Vtop___024root___eval_nba(vlSelf);
        vlSelf->__VnbaTriggered.clear();
    }
    return (__VnbaExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__ico(Vtop___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__nba(Vtop___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__act(Vtop___024root* vlSelf);
#endif  // VL_DEBUG

void Vtop___024root___eval(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval\n"); );
    // Init
    IData/*31:0*/ __VicoIterCount;
    CData/*0:0*/ __VicoContinue;
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    __VicoIterCount = 0U;
    vlSelf->__VicoFirstIteration = 1U;
    __VicoContinue = 1U;
    while (__VicoContinue) {
        if (VL_UNLIKELY((0x64U < __VicoIterCount))) {
#ifdef VL_DEBUG
            Vtop___024root___dump_triggers__ico(vlSelf);
#endif
            VL_FATAL_MT("/home/jonatan/HDL_testing_programs/shift_8x64_taps/shift_8x64_taps.sv", 1, "", "Input combinational region did not converge.");
        }
        __VicoIterCount = ((IData)(1U) + __VicoIterCount);
        __VicoContinue = 0U;
        if (Vtop___024root___eval_phase__ico(vlSelf)) {
            __VicoContinue = 1U;
        }
        vlSelf->__VicoFirstIteration = 0U;
    }
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        if (VL_UNLIKELY((0x64U < __VnbaIterCount))) {
#ifdef VL_DEBUG
            Vtop___024root___dump_triggers__nba(vlSelf);
#endif
            VL_FATAL_MT("/home/jonatan/HDL_testing_programs/shift_8x64_taps/shift_8x64_taps.sv", 1, "", "NBA region did not converge.");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        __VnbaContinue = 0U;
        vlSelf->__VactIterCount = 0U;
        vlSelf->__VactContinue = 1U;
        while (vlSelf->__VactContinue) {
            if (VL_UNLIKELY((0x64U < vlSelf->__VactIterCount))) {
#ifdef VL_DEBUG
                Vtop___024root___dump_triggers__act(vlSelf);
#endif
                VL_FATAL_MT("/home/jonatan/HDL_testing_programs/shift_8x64_taps/shift_8x64_taps.sv", 1, "", "Active region did not converge.");
            }
            vlSelf->__VactIterCount = ((IData)(1U) 
                                       + vlSelf->__VactIterCount);
            vlSelf->__VactContinue = 0U;
            if (Vtop___024root___eval_phase__act(vlSelf)) {
                vlSelf->__VactContinue = 1U;
            }
        }
        if (Vtop___024root___eval_phase__nba(vlSelf)) {
            __VnbaContinue = 1U;
        }
    }
}

#ifdef VL_DEBUG
void Vtop___024root___eval_debug_assertions(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->clk & 0xfeU))) {
        Verilated::overWidthError("clk");}
    if (VL_UNLIKELY((vlSelf->shift & 0xfeU))) {
        Verilated::overWidthError("shift");}
}
#endif  // VL_DEBUG
