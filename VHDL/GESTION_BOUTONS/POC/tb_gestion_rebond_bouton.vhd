-- Testbench pour gestion_rebond_bouton (horloge 50 MHz, temporisation 50 ms)
-- Compilation / simulation avec GHDL :
--   ghdl -a gestion_rebond_bouton.vhd tb_gestion_rebond_bouton.vhd
--   ghdl -e tb_gestion_rebond_bouton
--   ghdl -r tb_gestion_rebond_bouton --wave=tb.ghw
--   gtkwave tb.ghw
library ieee;
use ieee.std_logic_1164.all;

entity tb_gestion_rebond_bouton is
end entity tb_gestion_rebond_bouton;

architecture sim of tb_gestion_rebond_bouton is

  constant CLK_PERIOD : time := 20 ns;   -- 50 MHz

  signal clk      : std_logic := '0';
  signal rst      : std_logic := '0';    -- actif a '0'
  signal bp_ba    : std_logic := '0';
  signal bp_tri   : std_logic := '0';
  signal bp_stby  : std_logic := '0';
  signal ba_btn   : std_logic;
  signal tri_btn  : std_logic;
  signal stby_btn : std_logic;

  signal sim_end  : boolean := false;
  signal n_ba, n_tri, n_stby : natural := 0;   -- compteurs d'impulsions
  signal any_out  : std_logic;

  function ns_str(t : time) return string is
  begin
    return integer'image(t / 1 ns) & " ns";
  end function;

begin

  ------------------------------------------------------------------
  -- Horloge 50 MHz (s'arrete en fin de simulation)
  ------------------------------------------------------------------
  clk_gen : process
  begin
    while not sim_end loop
      clk <= '0'; wait for CLK_PERIOD / 2;
      clk <= '1'; wait for CLK_PERIOD / 2;
    end loop;
    wait;
  end process;

  ------------------------------------------------------------------
  -- DUT
  ------------------------------------------------------------------
  dut : entity work.gestion_rebond_bouton
    port map (
      clk          => clk,
      rst          => rst,
      BP_Baboard   => bp_ba,
      BP_Triboard  => bp_tri,
      BP_STBY      => bp_stby,
      Baboard_Btn  => ba_btn,
      Triboard_Btn => tri_btn,
      STBY_Btn     => stby_btn
    );

  ------------------------------------------------------------------
  -- Moniteurs : comptage des impulsions et controle de leur largeur
  ------------------------------------------------------------------
  any_out <= ba_btn or tri_btn or stby_btn;

  count_pulses : process (ba_btn, tri_btn, stby_btn)
  begin
    if rising_edge(ba_btn)   then n_ba   <= n_ba   + 1; end if;
    if rising_edge(tri_btn)  then n_tri  <= n_tri  + 1; end if;
    if rising_edge(stby_btn) then n_stby <= n_stby + 1; end if;
  end process;

  check_width : process
    variable t0 : time;
  begin
    wait until any_out = '1';
    t0 := now;
    wait until any_out = '0';
    assert (now - t0) = CLK_PERIOD
      report "Largeur d'impulsion inattendue : " & ns_str(now - t0)
      severity warning;
  end process;

  ------------------------------------------------------------------
  -- Stimuli et verifications
  ------------------------------------------------------------------
  stim : process
    variable errors  : natural := 0;
    variable t_start : time;
    variable delai   : time;
    variable b0, t0, s0 : natural;

    procedure check(cond : boolean; msg : string) is
    begin
      if cond then
        report "  [OK]   " & msg;
      else
        report "  [FAIL] " & msg severity error;
        errors := errors + 1;
      end if;
    end procedure;

    procedure snapshot is
    begin
      b0 := n_ba; t0 := n_tri; s0 := n_stby;
    end procedure;

    -- appui asynchrone par rapport a l'horloge : 3 ns apres un front montant
    procedure align_clk is
    begin
      wait until rising_edge(clk);
      wait for 3 ns;
    end procedure;

    -- appui avec rebonds (~2,65 ms au total), finit a '1'
    procedure bounce(signal s : out std_logic) is
    begin
      for i in 1 to 5 loop
        s <= '1'; wait for 200 us + i * 37 us;
        s <= '0'; wait for 150 us + i * 23 us;
      end loop;
      s <= '1';
    end procedure;

  begin
    ----------------------------------------------------------------
    report "=== Reset initial ===";
    rst <= '0';
    wait for 200 ns;
    rst <= '1';
    wait for 1 us;
    check(ba_btn = '0' and tri_btn = '0' and stby_btn = '0',
          "sorties a 0 apres reset");

    ----------------------------------------------------------------
    report "=== Test 1 : appui franc sur BP_Baboard ===";
    snapshot;
    align_clk;
    t_start := now;
    bp_ba <= '1';
    wait until ba_btn = '1' for 80 ms;
    delai := now - t_start;
    report "  delai appui -> sortie = " & ns_str(delai);
    check(ba_btn = '1', "Baboard_Btn passe a 1");
    check(delai > 49900 us and delai < 50100 us, "delai = 50 ms (+/- 0,1 ms)");
    bp_ba <= '0';                       -- relache juste apres l'impulsion
    wait for 60 ms;
    check(n_ba - b0 = 1, "exactement 1 impulsion sur Baboard_Btn");
    check(n_tri = t0 and n_stby = s0, "aucune impulsion sur les 2 autres sorties");

    ----------------------------------------------------------------
    report "=== Test 2 : appui avec rebonds sur BP_Triboard ===";
    snapshot;
    align_clk;
    t_start := now;
    bounce(bp_tri);
    wait until tri_btn = '1' for 80 ms;
    delai := now - t_start;
    report "  delai 1er front -> sortie = " & ns_str(delai);
    check(tri_btn = '1', "Triboard_Btn passe a 1 malgre les rebonds");
    check(delai > 49900 us and delai < 50100 us, "delai = 50 ms (+/- 0,1 ms)");
    bp_tri <= '0';
    wait for 2 ms;
    check(n_tri - t0 = 1, "exactement 1 impulsion sur Triboard_Btn");
    check(n_ba = b0 and n_stby = s0, "aucune impulsion sur les 2 autres sorties");

    ----------------------------------------------------------------
    report "=== Test 3 : parasite de 100 ns sur BP_STBY ===";
    snapshot;
    align_clk;
    bp_stby <= '1';
    wait for 100 ns;
    bp_stby <= '0';
    wait for 60 ms;
    check(n_ba = b0 and n_tri = t0 and n_stby = s0,
          "parasite ignore : aucune impulsion en sortie");

    ----------------------------------------------------------------
    report "=== Test 4 : appui simultane Triboard + STBY ===";
    snapshot;
    align_clk;
    bp_tri  <= '1';
    bp_stby <= '1';
    wait until tri_btn = '1' for 80 ms;
    check(stby_btn = '1', "STBY_Btn monte en meme temps que Triboard_Btn");
    bp_tri  <= '0';
    bp_stby <= '0';
    wait for 2 ms;
    check(n_tri - t0 = 1 and n_stby - s0 = 1 and n_ba = b0,
          "1 impulsion sur Triboard et sur STBY, aucune sur Baboard");

    ----------------------------------------------------------------
    report "=== Test 5 : appuis decales (Baboard a 0 ms, Triboard a 30 ms) ===";
    snapshot;
    align_clk;
    bp_ba <= '1';
    wait for 30 ms;
    bp_tri <= '1';
    wait until ba_btn = '1' for 80 ms;
    if tri_btn = '1' then
      report "  [NOTE] Triboard_Btn valide alors qu'il n'est appuye que depuis 20 ms"
             & " (un seul timer partage par les 3 boutons)" severity warning;
    else
      report "  [NOTE] Triboard_Btn non valide (anti-rebond propre a chaque bouton)";
    end if;
    bp_ba  <= '0';
    bp_tri <= '0';
    wait for 2 ms;

    ----------------------------------------------------------------
    report "=== Test 6 : appui maintenu 160 ms sur BP_STBY ===";
    snapshot;
    align_clk;
    bp_stby <= '1';
    wait for 160 ms;
    bp_stby <= '0';
    wait for 2 ms;
    report "  [NOTE] " & integer'image(n_stby - s0)
           & " impulsion(s) pour un seul appui maintenu (auto-repetition ~50 ms)"
           severity warning;

    ----------------------------------------------------------------
    report "=== Test 7 : reset pendant l'attente des 50 ms ===";
    snapshot;
    align_clk;
    bp_ba <= '1';
    wait for 20 ms;
    rst   <= '0';
    bp_ba <= '0';
    wait for 100 ns;
    rst   <= '1';
    wait for 10 ms;
    check(n_ba = b0, "pas d'impulsion parasite apres le reset");
    align_clk;
    t_start := now;
    bp_ba <= '1';
    wait until ba_btn = '1' for 80 ms;
    delai := now - t_start;
    report "  delai appui -> sortie apres reset = " & ns_str(delai);
    check(delai > 49900 us and delai < 50100 us,
          "delai = 50 ms apres un reset survenu pendant l'attente");
    bp_ba <= '0';
    wait for 2 ms;

    ----------------------------------------------------------------
    if errors = 0 then
      report "=== FIN : tous les tests passent ===";
    else
      report "=== FIN : " & integer'image(errors) & " verification(s) en echec ===" severity error;
    end if;
    sim_end <= true;
    wait;
  end process;

end architecture sim;
