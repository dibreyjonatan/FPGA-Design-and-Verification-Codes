library ieee;
use ieee.std_logic_1164.all;

--------------------------------------------------------------------
-- Anti-rebond d'UN bouton, avec sortie en NIVEAU :
-- la sortie q ne change que lorsque l'entree est restee stable
-- pendant DEB_CYCLES periodes d'horloge (2 500 000 a 50 MHz = 50 ms),
-- a l'appui comme au relachement.
--------------------------------------------------------------------
entity debounce_niveau is
  generic (DEB_CYCLES : positive := 2_500_000);
  port (
    clk : in  std_logic;
    rst : in  std_logic;      -- actif a '0'
    bp  : in  std_logic;
    q   : out std_logic
  );
end entity debounce_niveau;

architecture rtl of debounce_niveau is
  signal sync1, sync2 : std_logic := '0';   -- resynchronisation (entree asynchrone)
  signal stable       : std_logic := '0';
begin
  process (clk, rst)
    variable cmpt : integer range 0 to DEB_CYCLES := 0;
  begin
    if rst = '0' then
      sync1  <= '0';
      sync2  <= '0';
      stable <= '0';
      cmpt   := 0;
    elsif rising_edge(clk) then
      sync1 <= bp;
      sync2 <= sync1;
      if sync2 = stable then          -- rien a valider (ou rebond revenu a l'etat stable)
        cmpt := 0;
      elsif cmpt = DEB_CYCLES - 1 then  -- l'entree a ete differente pendant tout le delai
        stable <= sync2;
        cmpt   := 0;
      else
        cmpt := cmpt + 1;
      end if;
    end if;
  end process;

  q <= stable;
end architecture rtl;


--------------------------------------------------------------------
-- Les 3 boutons (memes ports qu'avant : Gestion_boutons n'a pas a changer
-- son instanciation). Chaque sortie est un niveau : '1' tant que le
-- bouton est maintenu, apres 50 ms de stabilite.
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity gestion_rebond_bouton is
  generic (DEB_CYCLES : positive := 2_500_000);
  port (
    clk          : in  std_logic;
    rst          : in  std_logic;
    BP_Baboard   : in  std_logic;
    BP_Triboard  : in  std_logic;
    BP_STBY      : in  std_logic;
    -- sorties des boutons apres temporisation (niveaux)
    Baboard_Btn  : out std_logic;
    Triboard_Btn : out std_logic;
    STBY_Btn     : out std_logic
  );
end entity gestion_rebond_bouton;

architecture description of gestion_rebond_bouton is
begin
  u_babord  : entity work.debounce_niveau
    generic map (DEB_CYCLES => DEB_CYCLES)
    port map (clk => clk, rst => rst, bp => BP_Baboard,  q => Baboard_Btn);

  u_tribord : entity work.debounce_niveau
    generic map (DEB_CYCLES => DEB_CYCLES)
    port map (clk => clk, rst => rst, bp => BP_Triboard, q => Triboard_Btn);

  u_stby    : entity work.debounce_niveau
    generic map (DEB_CYCLES => DEB_CYCLES)
    port map (clk => clk, rst => rst, bp => BP_STBY,     q => STBY_Btn);
end architecture description;
