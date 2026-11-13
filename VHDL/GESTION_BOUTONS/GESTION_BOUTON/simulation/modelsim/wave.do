onerror {resume}
quietly WaveActivateNextPane {} 0

# Horloge et Reset
add wave -noupdate -divider {Horloge & Reset}
add wave -noupdate -color {Yellow} -label CLK_50M /tb_gestion_boutons/clk_50M
add wave -noupdate -color {Red}    -label RAZ_N   /tb_gestion_boutons/raz_n

# Entrées de commande (Boutons-poussoirs)
add wave -noupdate -divider {Commandes (Boutons)}
add wave -noupdate -label BP_BABORD  /tb_gestion_boutons/BP_Babord
add wave -noupdate -label BP_TRIBORD /tb_gestion_boutons/BP_Tribord
add wave -noupdate -label BP_STBY    /tb_gestion_boutons/BP_STBY

# Sorties du composant (DUT)
add wave -noupdate -divider {Sorties (DUT)}
add wave -noupdate -color {Cyan}    -radix binary -label CODE_FONCTION /tb_gestion_boutons/codeFonction
add wave -noupdate -color {Green}   -radix binary -label LED_BABORD    /tb_gestion_boutons/ledBabord
add wave -noupdate -color {Green}   -radix binary -label LED_TRIBORD   /tb_gestion_boutons/ledTribord
add wave -noupdate -color {Orange}  -radix binary -label LED_STBY      /tb_gestion_boutons/ledSTBY
add wave -noupdate -color {Magenta} -radix binary -label OUT_BIP       /tb_gestion_boutons/out_bip

# Signaux de suivi du Testbench (Compteurs & fin de simu)
add wave -noupdate -divider {Suivi Testbench}
add wave -noupdate -radix unsigned -label N_BIP1  /tb_gestion_boutons/n_bip1
add wave -noupdate -radix unsigned -label N_BIP2  /tb_gestion_boutons/n_bip2
add wave -noupdate -radix unsigned -label N_CODE  /tb_gestion_boutons/n_code
add wave -noupdate                  -label SIM_END /tb_gestion_boutons/sim_end

# Signaux internes du DUT (états FSM, compteurs anti-rebond, appui long, etc.)
add wave -noupdate -divider {Signaux Internes DUT}
add wave -noupdate -radix unsigned -label {DUT Internes} /tb_gestion_boutons/dut/*

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 180
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ms
update
WaveRestoreZoom {0 ps} {2000 ms}