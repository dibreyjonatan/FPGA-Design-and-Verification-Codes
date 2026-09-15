library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mcp3201_driver is
    Port (
        clk        : in  STD_LOGIC;
        rst        : in  STD_LOGIC;
        adc_cs_n   : out STD_LOGIC;
        adc_clk    : out STD_LOGIC;
        adc_dout   : in  STD_LOGIC;
        data_out   : out STD_LOGIC_VECTOR(11 downto 0);
        RxIF       : out STD_LOGIC
    );
end mcp3201_driver;

architecture Behavioral of mcp3201_driver is

    type etats is (IDLE, SAMPLING_CONV, HOLD_CS, WAIT_100MS);
    signal ep, es : etats := IDLE;

    -- Diviseur SPI 1 MHz
    signal clk_cnt     : integer range 0 to 24 := 0;
    signal spi_clk_reg : std_logic := '0';
    signal spi_tick    : std_logic := '0';

    -- Datapath
    signal bit_cnt     : integer range 0 to 15 := 0;
    signal shift_reg   : std_logic_vector(11 downto 0) := (others => '0');

    -- Timer 100 ms
    signal cmpt    : integer range 0 to 4999999 := 0;
    signal fin_tim : std_logic := '0';

begin

    ------------------------------------------------------------------
    -- Process 1 : HORLOGE SPI (diviseur 50 MHz -> 1 MHz)
    ------------------------------------------------------------------
    horloge_spi : process(clk, rst)
    begin
        if rst = '0' then
            clk_cnt     <= 0;
            spi_clk_reg <= '0';
            spi_tick    <= '0';
        elsif rising_edge(clk) then
            spi_tick <= '0';
            if clk_cnt = 24 then
                clk_cnt     <= 0;
                spi_clk_reg <= not spi_clk_reg;
                if spi_clk_reg = '0' then
                    spi_tick <= '1';
                end if;
            else
                clk_cnt <= clk_cnt + 1;
            end if;
        end if;
    end process horloge_spi;

    ------------------------------------------------------------------
    -- Process 2 : SEQUENTIEL (registre d'état + datapath)
    -- Utilise "ep" (état courant valide), jamais "es" en retard.
    ------------------------------------------------------------------
    sequentiel : process(clk, rst)
    begin
        if rst = '0' then
            ep        <= IDLE;
            adc_clk   <= '0';
            bit_cnt   <= 0;
            shift_reg <= (others => '0');
            data_out  <= (others => '0');
            RxIF      <= '0';

        elsif rising_edge(clk) then
            ep   <= es;      -- avancement de l'état
            RxIF <= '0';

            case ep is
                when IDLE =>
                    adc_clk <= '0';
                    bit_cnt <= 0;

                when SAMPLING_CONV =>
                    adc_clk <= spi_clk_reg;
                    if spi_tick = '1' then
                        if bit_cnt >= 3 and bit_cnt <= 14 then
                            shift_reg <= shift_reg(10 downto 0) & adc_dout;
                        end if;
                        if bit_cnt = 15 then
                            data_out <= shift_reg;
                            RxIF     <= '1';
                            bit_cnt  <= 0;
                        else
                            bit_cnt <= bit_cnt + 1;
                        end if;
                    end if;

                when HOLD_CS =>
                    adc_clk <= '0';

                when WAIT_100MS =>
                    adc_clk <= '0';
            end case;
        end if;
    end process sequentiel;

    ------------------------------------------------------------------
    -- Process 3 : COMBINATOIRE (calcul du prochain état, PUR, pas d'horloge)
    ------------------------------------------------------------------
    combinatoire : process(ep, spi_tick, bit_cnt, fin_tim)
    begin
        es <= ep;  -- valeur par défaut : rester dans l'état courant

        case ep is
            when IDLE =>
                es <= SAMPLING_CONV;

            when SAMPLING_CONV =>
                if spi_tick = '1' and bit_cnt = 15 then
                    es <= HOLD_CS;
                end if;

            when HOLD_CS =>
                if spi_tick = '1' then
                    es <= WAIT_100MS;
                end if;

            when WAIT_100MS =>
                if fin_tim = '1' then
                    es <= IDLE;
                end if;
        end case;
    end process combinatoire;

    ------------------------------------------------------------------
    -- Process 4 : SORTIE (décodage combinatoire de adc_cs_n, Moore)
    ------------------------------------------------------------------
    sortie : process(ep)
    begin
        case ep is
            when IDLE          => adc_cs_n <= '1';
            when SAMPLING_CONV => adc_cs_n <= '0';
            when HOLD_CS       => adc_cs_n <= '1';
            when WAIT_100MS    => adc_cs_n <= '1';
        end case;
    end process sortie;

    ------------------------------------------------------------------
    -- Process 5 : TEMPORISATEUR 100 ms
    ------------------------------------------------------------------
    timer_100ms : process(clk, rst)
    begin
        if rst = '0' then
            cmpt    <= 0;
            fin_tim <= '0';
        elsif rising_edge(clk) then
            fin_tim <= '0';
            if ep /= WAIT_100MS then
                cmpt <= 0;
            elsif cmpt = 4999999 then
                cmpt    <= 0;
                fin_tim <= '1';
            else
                cmpt <= cmpt + 1;
            end if;
        end if;
    end process timer_100ms;

end Behavioral;