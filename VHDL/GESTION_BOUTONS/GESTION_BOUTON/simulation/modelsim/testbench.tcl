# Arrêter toute simulation en cours
quit -sim

# Créer la bibliothèque si elle n'existe pas, et mapper work dessus
if {![file exists rtl_work]} {
    vlib rtl_work
}
vmap work rtl_work

# Design 
vcom -2008 -work work ../../Gestion_boutons.vhd

# Testbench (dossier modelsim/)
vcom -2008 -work work tb_gestion_boutons.vhd

# Lancer la simulation
vsim -t ps work.tb_gestion_boutons

# Formes d'onde
if {[file exists wave.do]} {
    do wave.do
} else {
    add wave -r /*
}

# Durée de simulation
run 1000ms