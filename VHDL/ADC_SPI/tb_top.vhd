library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all; -- pour std.env.stop (necessite --std=08)

-- =====================================================================
-- Testbench "top" : TROIS conversions ADC successives, boucle NATURELLE
-- (ATTENTE -> 100 ms -> START) entre chaque conversion, sans contournement.
-- Necessite top.vhd corrige (driver unique sur fin_tim).
--
-- Duree simulee totale : ~200 ms (2 attentes de 100 ms entre les 3
-- conversions) + 3 x ~15 us de conversion.
-- Preferez --wave=xxx.ghw a --vcd=xxx.vcd pour ce testbench (fichier
-- bien plus compact, et conserve les etats ep/es lisibles).
-- =====================================================================

entity tb_top is
end entity tb_top;

architecture sim of tb_top is

  constant MAX        : natural := 14;
  constant CLK_PERIOD  : time    := 20 ns; -- 50 MHz

  -- Trois motifs de test distincts (13 bits : 1 bit nul + 12 bits)
  constant TEST_PATTERN_1 : std_logic_vector(MAX-2 downto 0) := '0' & x"A5C";
  constant TEST_PATTERN_2 : std_logic_vector(MAX-2 downto 0) := '0' & x"3D1";
  constant TEST_PATTERN_3 : std_logic_vector(MAX-2 downto 0) := '0' & x"7E2";

  signal clk         : std_logic := '0';
  signal rst         : std_logic := '0';
  signal data_adc    : std_logic := '0';
  signal clk_adc     : std_logic;
  signal data_output : std_logic_vector(MAX-2 downto 0);
  signal cs          : std_logic;

begin

  ----------------------------------------------------------------------
  -- DUT
  ----------------------------------------------------------------------
  uut : entity work.top
    generic map ( max => MAX )
    port map (
      clk         => clk,
      rst         => rst,
      data_adc    => data_adc,
      clk_adc     => clk_adc,
      data_output => data_output,
      cs          => cs
    );

  ----------------------------------------------------------------------
  -- Horloge principale (50 MHz / 20 ns)
  ----------------------------------------------------------------------
  clk_gen : process
  begin
    clk <= '0';
    wait for CLK_PERIOD/2;
    clk <= '1';
    wait for CLK_PERIOD/2;
  end process;

  ----------------------------------------------------------------------
  -- Reset : actif a '0', pilote uniquement ici
  ----------------------------------------------------------------------
  rst_gen : process
  begin
    rst <= '0';
    wait for 5 * CLK_PERIOD;
    rst <= '1';
    wait;
  end process;

  ----------------------------------------------------------------------
  -- Garde-fou : 3 conversions + 2 attentes de 100 ms + marge
  ----------------------------------------------------------------------
  watchdog : process
  begin
    wait for 360 ms;
    report "ERREUR (watchdog) : la simulation aurait deja du s'arreter." severity error;
    std.env.stop(1);
  end process;

  ----------------------------------------------------------------------
  -- Pilote principal
  ----------------------------------------------------------------------
  stim : process
    variable errors : natural := 0;

    -- Envoie un motif de 13 bits sur data_adc, synchronise sur les
    -- fronts de clk_adc : 2 fronts pour READY (cmpt_fm=2), puis 13
    -- fronts pour CONVERT (cmpt_fd=max-1=13).
    procedure send_pattern(pattern : std_logic_vector(MAX-2 downto 0)) is
    begin
      for i in 0 to 1 loop
        wait until rising_edge(clk_adc);
      end loop;
      for i in MAX-2 downto 0 loop
        data_adc <= pattern(i);
        wait until rising_edge(clk_adc);
      end loop;
    end procedure;

    procedure run_and_check(pattern : std_logic_vector(MAX-2 downto 0); label_txt : string) is
    begin
      report "=== " & label_txt & " : envoi du motif " & to_hstring(pattern) & " ===";
      send_pattern(pattern);
      wait until cs = '1';
      report "  [t=" & time'image(now) & "] cs='1' -> data_output = " & to_hstring(data_output);
      if data_output = pattern then
        report "  RESULTAT : OK";
      else
        report "  RESULTAT : ERREUR -- attendu " & to_hstring(pattern) &
               ", recu " & to_hstring(data_output) severity error;
        errors := errors + 1;
      end if;
    end procedure;

    -- Attend le retour naturel a START (fin de l'attente de 100 ms)
    procedure wait_natural_restart is
    begin
      report "------------------------------------------------------------------";
      report "Attente du retour NATUREL a START (etat ATTENTE, ~100 ms)...";
      wait until cs = '0';
      report "[t=" & time'image(now) & "] cs='0' : retour naturel a START confirme";
      report "------------------------------------------------------------------";
    end procedure;

  begin
    report "==================================================================";
    report "DEMARRAGE DU TEST - 3 conversions successives (boucle NATURELLE)";
    report "==================================================================";

    wait until rst = '1';
    report "[t=" & time'image(now) & "] Reset relache -> START";

    run_and_check(TEST_PATTERN_1, "CONVERSION 1/3");
    wait_natural_restart;

    run_and_check(TEST_PATTERN_2, "CONVERSION 2/3");
    wait_natural_restart;

    run_and_check(TEST_PATTERN_3, "CONVERSION 3/3");

    report "==================================================================";
    if errors = 0 then
      report "SIMULATION TERMINEE : SUCCES (3/3 conversions correctes, boucle 100 ms validee 2 fois)";
    else
      report "SIMULATION TERMINEE : " & integer'image(errors) & " ERREUR(S) SUR 3 CONVERSIONS";
    end if;
    report "==================================================================";

    wait for CLK_PERIOD;
    if errors = 0 then
      std.env.stop(0);
    else
      std.env.stop(1);
    end if;
  end process;

end architecture sim;