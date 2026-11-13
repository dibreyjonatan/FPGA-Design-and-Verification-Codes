-- Testbench de Gestion_boutons (+ gestion_rebond_bouton instancie dedans)
-- Horloge 50 MHz. Les verifications suivent le diagramme d'etats (etats 0 a 11).
--
--   ghdl -a -fsynopsys gestion_rebond_bouton.vhd Gestion_boutons.vhd tb_gestion_boutons.vhd
--   ghdl -e -fsynopsys tb_gestion_boutons
--   ghdl -r -fsynopsys tb_gestion_boutons --wave=tb.ghw
--
-- Generics (a adapter avec -g si tu reduis les constantes du DUT pour aller vite) :
--   DEB_CYCLES  : cycles du compteur anti-rebond  (DUT : 2_500_000   = 50 ms)
--   LONG_CYCLES : cycles du compteur d'appui long (DUT : 250_000_000 = 5 s)
--   RUN_LONG    : 0 pour sauter les 2 tests d'appui long (2 x ~5 s simules)
--   ex : ghdl -r -fsynopsys tb_gestion_boutons -gRUN_LONG=0
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_gestion_boutons is
  generic (
    DEB_CYCLES  : positive := 2_500_000;
    LONG_CYCLES : positive := 250_000_000;
    RUN_LONG    : natural  := 1
  );
end entity tb_gestion_boutons;

architecture sim of tb_gestion_boutons is

  constant CLK_PERIOD : time := 20 ns;                 -- 50 MHz
  constant DEB_T      : time := DEB_CYCLES  * CLK_PERIOD;
  constant LONG_T     : time := LONG_CYCLES * CLK_PERIOD;
  constant TAP        : time := DEB_T + DEB_T / 5;     -- appui bref : 1 seule validation anti-rebond
  constant HUMAN      : time := 3 * DEB_T;             -- appui "humain" (~150 ms) : plusieurs validations
  constant SETTLE     : time := DEB_T + DEB_T / 2;   -- apres relachement : anti-rebond + marge

  signal clk_50M    : std_logic := '0';
  signal raz_n      : std_logic := '0';
  signal BP_Babord  : std_logic := '0';
  signal BP_Tribord : std_logic := '0';
  signal BP_STBY    : std_logic := '0';

  signal codeFonction : std_logic_vector(3 downto 0);
  signal ledBabord    : std_logic_vector(1 downto 0);
  signal ledTribord   : std_logic_vector(1 downto 0);
  signal ledSTBY      : std_logic_vector(1 downto 0);
  signal out_bip      : std_logic_vector(1 downto 0);

  signal sim_end : boolean := false;

  type nat_arr is array (0 to 15) of natural;
  signal n_code : nat_arr := (others => 0);   -- nb d'apparitions de chaque codeFonction
  signal n_bip1 : natural := 0;               -- nb de "1 bip" (out_bip = "01")
  signal n_bip2 : natural := 0;               -- nb de "2 bips" (out_bip = "11")

  function us_str(t : time) return string is
  begin
    return integer'image(t / 1 us) & " us";
  end function;

  function slv_str(v : std_logic_vector) return string is
    variable r : string(1 to v'length);
    variable k : natural := 1;
  begin
    for i in v'range loop
      r(k) := std_logic'image(v(i))(2);
      k := k + 1;
    end loop;
    return r;
  end function;

  -- Niveaux attendus (diagramme / code) : "00"=OFF, "01"=F.E, "10"=ON, "11"=CL
  impure function st0 return boolean is   -- etat 0 : veille
  begin
    return codeFonction = "0000" and ledSTBY = "11" and ledBabord = "01"
           and ledTribord = "01" and out_bip = "00";
  end function;

  impure function st4 return boolean is   -- etat 4 : mode automatique
  begin
    return codeFonction = "0011" and ledSTBY = "10" and ledBabord = "00"
           and ledTribord = "00" and out_bip = "00";
  end function;

begin

  ------------------------------------------------------------------
  clk_gen : process
  begin
    while not sim_end loop
      clk_50M <= '0'; wait for CLK_PERIOD / 2;
      clk_50M <= '1'; wait for CLK_PERIOD / 2;
    end loop;
    wait;
  end process;

  ------------------------------------------------------------------
  dut : entity work.Gestion_boutons
    port map (
      BP_Babord    => BP_Babord,
      BP_Tribord   => BP_Tribord,
      BP_STBY      => BP_STBY,
      clk_50M      => clk_50M,
      raz_n        => raz_n,
      codeFonction => codeFonction,
      ledBabord    => ledBabord,
      ledTribord   => ledTribord,
      ledSTBY      => ledSTBY,
      out_bip      => out_bip
    );

  ------------------------------------------------------------------
  -- Journal des changements de sorties + compteurs d'evenements
  ------------------------------------------------------------------
  logger : process (codeFonction, ledBabord, ledTribord, ledSTBY, out_bip)
  begin
    report "    @" & us_str(now) & "  code=" & slv_str(codeFonction)
           & " STBY=" & slv_str(ledSTBY) & " Bab=" & slv_str(ledBabord)
           & " Tri=" & slv_str(ledTribord) & " bip=" & slv_str(out_bip);
  end process;

  counters : process (codeFonction, out_bip)
  begin
    if codeFonction'event then
      n_code(to_integer(unsigned(codeFonction))) <=
        n_code(to_integer(unsigned(codeFonction))) + 1;
    end if;
    if out_bip'event then
      if out_bip = "01" then n_bip1 <= n_bip1 + 1; end if;
      if out_bip = "11" then n_bip2 <= n_bip2 + 1; end if;
    end if;
  end process;

  ------------------------------------------------------------------
  -- Scenario
  ------------------------------------------------------------------
  stim : process
    variable errors : natural := 0;
    variable s_code : nat_arr;
    variable s_b1, s_b2 : natural;

    procedure check(cond : boolean; msg : string) is
    begin
      if cond then
        report "  [OK]   " & msg;
      else
        report "  [FAIL] " & msg severity error;
        errors := errors + 1;
      end if;
    end procedure;

    procedure snap is
    begin
      s_code := n_code; s_b1 := n_bip1; s_b2 := n_bip2;
    end procedure;

    impure function dcode(c : natural) return integer is
    begin
      return n_code(c) - s_code(c);
    end function;

    procedure align is   -- appui asynchrone : 3 ns apres un front d'horloge
    begin
      wait until rising_edge(clk_50M);
      wait for 3 ns;
    end procedure;

    procedure press(signal b : out std_logic; dur : time) is
    begin
      align;
      b <= '1'; wait for dur; b <= '0';
    end procedure;

    -- appui et relachement avec rebonds
    procedure press_bouncy(signal b : out std_logic; dur : time) is
      constant u : time := DEB_T / 500;
    begin
      align;
      for i in 1 to 4 loop
        b <= '1'; wait for u * (2 + i);
        b <= '0'; wait for u * (1 + i);
      end loop;
      b <= '1'; wait for dur;
      for i in 1 to 3 loop
        b <= '0'; wait for u * i;
        b <= '1'; wait for u * (i + 1);
      end loop;
      b <= '0';
    end procedure;

    procedure do_reset is
    begin
      raz_n <= '0'; wait for 1 us;
      raz_n <= '1'; wait for 1 us;
    end procedure;

    procedure goto_state4 is   -- reset puis appui bref sur STBY (etat 0 -> 3 -> 4)
    begin
      do_reset;
      press(BP_STBY, TAP);
      wait for SETTLE;
      if not st4 then
        report "  [WARN] navigation vers l'etat 4 echouee" severity warning;
      end if;
    end procedure;

  begin
    ----------------------------------------------------------------
    report "=== T1 : reset -> etat 0 ===";
    do_reset;
    check(st0, "etat 0 : code 0000, STBY clignote, Babord/Tribord F.E, pas de bip");

    ----------------------------------------------------------------
    report "=== T2 : etat 0 -> 1 -> 0 (appui bref sur BP_Babord) ===";
    do_reset; snap;
    press(BP_Babord, TAP);
    wait for SETTLE;
    check(dcode(1) = 1, "code 0001 emis (etat 1)");
    check(n_bip1 - s_b1 = 1, "1 bip");
    check(st0, "retour en etat 0 apres relachement");

    report "=== T2b : etat 1 maintenu pendant un appui de 2,5 x temporisation ===";
    do_reset; snap;
    align; BP_Babord <= '1';
    wait for DEB_T * 5 / 2;
    check(codeFonction = "0001" and ledBabord = "10" and ledSTBY = "00"
          and ledTribord = "00" and out_bip = "01",
          "[maintien] bouton tenu : etat 1 maintenu (0001, LED Babord ON, 1 bip)");
    BP_Babord <= '0';
    wait for SETTLE;
    check(dcode(1) = 1, "un seul appui = une seule entree dans l'etat 1");
    check(st0, "retour en etat 0");

    ----------------------------------------------------------------
    report "=== T3 : etat 0 -> 2 -> 0 (appui bref sur BP_Tribord) ===";
    do_reset; snap;
    press(BP_Tribord, TAP);
    wait for SETTLE;
    check(dcode(2) = 1, "code 0010 emis (etat 2)");
    check(n_bip1 - s_b1 = 1, "1 bip");
    check(st0, "retour en etat 0 apres relachement");

    report "=== T3b : etat 2 maintenu pendant un appui de 2,5 x temporisation ===";
    do_reset; snap;
    align; BP_Tribord <= '1';
    wait for DEB_T * 5 / 2;
    check(codeFonction = "0010" and ledTribord = "10" and ledSTBY = "00"
          and ledBabord = "00" and out_bip = "01",
          "[maintien] bouton tenu : etat 2 maintenu (0010, LED Tribord ON, 1 bip)");
    BP_Tribord <= '0';
    wait for SETTLE;
    check(dcode(2) = 1, "un seul appui = une seule entree dans l'etat 2");
    check(st0, "retour en etat 0");

    ----------------------------------------------------------------
    report "=== T4 : etat 0 -> 3 -> 4 (appui bref sur BP_STBY) ===";
    do_reset; snap;
    press(BP_STBY, TAP);
    wait for SETTLE;
    check(n_bip1 - s_b1 = 1, "1 bip (etat 3)");
    check(st4, "etat 4 : 0011, STBY ON, Babord/Tribord OFF");

    ----------------------------------------------------------------
    report "=== T5 : etat 4 -> 5 -> 0 (appui bref sur BP_STBY) ===";
    goto_state4; snap;
    press(BP_STBY, TAP);
    wait for SETTLE;
    check(n_bip1 - s_b1 = 1, "1 bip (etat 5)");
    check(st0, "retour en etat 0 (veille)");

    ----------------------------------------------------------------
    report "=== T6 : etat 4 -> 6 -> 7 -> 4 (appui court Babord = -1 deg) ===";
    goto_state4; snap;
    align; BP_Babord <= '1';
    wait for DEB_T + DEB_T / 10;
    check(ledBabord = "10" and ledSTBY = "00" and ledTribord = "00" and out_bip = "01",
          "etat 6 pendant l'appui : LED Babord ON, 1 bip");
    wait for DEB_T / 10;
    BP_Babord <= '0';
    wait for SETTLE;
    check(dcode(7) = 1, "code 0111 emis une fois (decrement 1 deg)");
    check(dcode(6) = 0, "pas de code 0110 (pas d'appui long)");
    check(st4, "retour en etat 4");

    ----------------------------------------------------------------
    report "=== T7 : etat 4 -> 9 -> 10 -> 4 (appui court Tribord = +1 deg) ===";
    goto_state4; snap;
    align; BP_Tribord <= '1';
    wait for DEB_T + DEB_T / 10;
    check(ledTribord = "10" and ledSTBY = "00" and ledBabord = "00" and out_bip = "01",
          "etat 9 pendant l'appui : LED Tribord ON, 1 bip");
    wait for DEB_T / 10;
    BP_Tribord <= '0';
    wait for SETTLE;
    check(dcode(4) = 1, "code 0100 emis une fois (increment 1 deg)");
    check(dcode(5) = 0, "pas de code 0101 (pas d'appui long)");
    check(st4, "retour en etat 4");

    ----------------------------------------------------------------
    if RUN_LONG /= 0 then
      report "=== T8 : etat 4 -> 6 -> 8 -> 4 (appui long Babord = -10 deg) ===";
      goto_state4; snap;
      align; BP_Babord <= '1';
      wait for DEB_T + LONG_T + DEB_T / 2;
      check(codeFonction = "0110" and ledBabord = "11" and out_bip = "11",
            "etat 8 pendant l'appui long : 0110, LED Babord clignote, 2 bips");
      BP_Babord <= '0';
      wait for SETTLE;
      check(dcode(6) = 1, "code 0110 emis une seule fois");
      check(dcode(7) = 0, "pas de decrement 1 deg parasite au relachement");
      check(st4, "retour en etat 4");

      report "=== T9 : etat 4 -> 9 -> 11 -> 4 (appui long Tribord = +10 deg) ===";
      goto_state4; snap;
      align; BP_Tribord <= '1';
      wait for DEB_T + LONG_T + DEB_T / 2;
      check(codeFonction = "0101" and ledTribord = "11" and out_bip = "11",
            "etat 11 pendant l'appui long : 0101, LED Tribord clignote, 2 bips");
      BP_Tribord <= '0';
      wait for SETTLE;
      check(dcode(5) = 1, "code 0101 emis une seule fois");
      check(dcode(4) = 0, "pas d'increment 1 deg parasite au relachement");
      check(st4, "retour en etat 4");
    else
      report "=== T8/T9 (appuis longs) sautes : RUN_LONG = 0 ===" severity warning;
    end if;

    ----------------------------------------------------------------
    report "=== T10 : Babord + Tribord simultanes en etat 0 (aucune transition) ===";
    do_reset; snap;
    align; BP_Babord <= '1'; BP_Tribord <= '1';
    wait for TAP;
    BP_Babord <= '0'; BP_Tribord <= '0';
    wait for SETTLE;
    check(dcode(1) = 0 and dcode(2) = 0, "aucun code 0001 / 0010");
    check(st0, "reste en etat 0");

    ----------------------------------------------------------------
    report "=== T11 : appui avec rebonds sur BP_Babord en etat 0 ===";
    do_reset; snap;
    press_bouncy(BP_Babord, TAP);
    wait for SETTLE;
    check(dcode(1) = 1, "une seule entree dans l'etat 1 malgre les rebonds");
    check(st0, "retour en etat 0");

    ----------------------------------------------------------------
    report "=== T12 : appui 'humain' (3 x temporisation) sur BP_STBY en etat 0 ===";
    do_reset; snap;
    press(BP_STBY, HUMAN);
    wait for SETTLE;
    check(n_bip1 - s_b1 = 1, "UN appui STBY = UN seul bip (pas de bascule multiple 0 -> 4 -> 0 -> 4)");
    check(st4, "UN appui STBY -> etat 4");

    report "=== T13 : appui 'humain' (3 x temporisation) court sur Babord en etat 4 ===";
    goto_state4; snap;
    press(BP_Babord, HUMAN);
    wait for SETTLE;
    check(dcode(7) = 1, "UN appui = UN decrement 1 deg (code 0111 une seule fois)");
    check(st4, "retour en etat 4");

    ----------------------------------------------------------------
    report "=== T14 : 2 appuis courts Babord enchaines en etat 4, SANS reset ===";
    goto_state4; snap;
    press(BP_Babord, TAP);
    wait for SETTLE;
    check(dcode(7) = 1, "1er appui court : un decrement 1 deg");
    align; BP_Babord <= '1';
    wait for DEB_T + DEB_T / 10;
    check(ledBabord = "10" and out_bip = "01",
          "2e appui : etat 6 attend le relachement (pas de sortie immediate de l'etat 6)");
    wait for DEB_T / 10;
    BP_Babord <= '0';
    wait for SETTLE;
    check(dcode(7) = 2, "2e appui court : second decrement 1 deg");
    check(st4, "retour en etat 4");

    report "=== T14b : 2 appuis courts Tribord enchaines en etat 4, SANS reset ===";
    goto_state4; snap;
    press(BP_Tribord, TAP);
    wait for SETTLE;
    check(dcode(4) = 1, "1er appui court : un increment 1 deg");
    align; BP_Tribord <= '1';
    wait for DEB_T + DEB_T / 10;
    check(ledTribord = "10" and out_bip = "01",
          "2e appui : etat 9 attend le relachement (pas de sortie immediate de l'etat 9)");
    wait for DEB_T / 10;
    BP_Tribord <= '0';
    wait for SETTLE;
    check(dcode(4) = 2, "2e appui court : second increment 1 deg");
    check(st4, "retour en etat 4");

    if RUN_LONG /= 0 then
      report "=== T15 : appui court puis appui long Babord enchaines, SANS reset ===";
      goto_state4; snap;
      press(BP_Babord, TAP);
      wait for SETTLE;
      align; BP_Babord <= '1';
      wait for DEB_T + LONG_T + DEB_T / 2;
      BP_Babord <= '0';
      wait for SETTLE;
      check(dcode(6) = 1, "l'appui long qui suit un appui court est bien reconnu (code 0110)");
    end if;

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
