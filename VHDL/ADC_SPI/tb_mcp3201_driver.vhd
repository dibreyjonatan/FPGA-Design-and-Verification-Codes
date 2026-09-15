library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.ENV.ALL;

entity tb_mcp3201_driver is
end tb_mcp3201_driver;

architecture sim of tb_mcp3201_driver is

    ------------------------------------------------------------------
    -- Signaux du DUT
    ------------------------------------------------------------------
    signal clk      : std_logic := '0';
    signal rst      : std_logic := '0';

    signal adc_cs_n : std_logic;
    signal adc_clk  : std_logic;
    signal adc_dout : std_logic := '0';

    signal data_out : std_logic_vector(11 downto 0);
    signal RxIF     : std_logic;

    ------------------------------------------------------------------
    -- Horloge système : 50 MHz
    ------------------------------------------------------------------
    constant CLK_PERIOD : time := 20 ns;

begin

    ------------------------------------------------------------------
    -- DUT
    ------------------------------------------------------------------
    DUT : entity work.mcp3201_driver
        port map (
            clk      => clk,
            rst      => rst,
            adc_cs_n => adc_cs_n,
            adc_clk  => adc_clk,
            adc_dout => adc_dout,
            data_out => data_out,
            RxIF     => RxIF
        );

    ------------------------------------------------------------------
    -- HORLOGE 50 MHz
    ------------------------------------------------------------------
    clk_process : process
    begin
        while true loop

            clk <= '0';
            wait for CLK_PERIOD / 2;

            clk <= '1';
            wait for CLK_PERIOD / 2;

        end loop;
    end process;

    ------------------------------------------------------------------
    -- RESET ACTIF BAS
    ------------------------------------------------------------------
    reset_process : process
    begin

        rst <= '0';

        wait for 100 ns;

        rst <= '1';

        wait;

    end process;

    ------------------------------------------------------------------
    -- MODELE MCP3201
    ------------------------------------------------------------------
    adc_model : process

        ------------------------------------------------------------------
        -- Valeurs utilisées pour les 3 conversions
        ------------------------------------------------------------------
        constant ADC_VALUE_1 : std_logic_vector(11 downto 0)
            := "001100110011";       -- 819

        constant ADC_VALUE_2 : std_logic_vector(11 downto 0)
            := "100110011001";       -- 2457

        constant ADC_VALUE_3 : std_logic_vector(11 downto 0)
            := "111100001111";       -- 3855

        ------------------------------------------------------------------
        -- Compteur de conversion
        ------------------------------------------------------------------
        variable conv_num : integer := 1;

        ------------------------------------------------------------------
        -- Compteur des 16 cycles SPI
        ------------------------------------------------------------------
        variable edge_cnt : integer := 0;

    begin

        ------------------------------------------------------------------
        -- Attendre la fin du reset
        ------------------------------------------------------------------
        wait until rst = '1';

        ------------------------------------------------------------------
        -- 3 conversions
        ------------------------------------------------------------------
        while conv_num <= 3 loop

            --------------------------------------------------------------
            -- Attendre CS actif
            --------------------------------------------------------------
            wait until adc_cs_n = '0';

            report "============================================";
            report "DEBUT CONVERSION "
                & integer'image(conv_num);

            if conv_num = 1 then

                report "Valeur ADC envoyee = 819";

            elsif conv_num = 2 then

                report "Valeur ADC envoyee = 2457";

            else

                report "Valeur ADC envoyee = 3855";

            end if;

            report "============================================";


            --------------------------------------------------------------
            -- Réinitialiser le compteur
            --------------------------------------------------------------
            edge_cnt := 0;


            --------------------------------------------------------------
            -- Génération des 16 cycles SPI
            --
            -- IMPORTANT :
            --
            -- bit_cnt DUT :
            --
            -- 0  -> premier cycle
            -- 1  -> deuxième cycle
            -- 2  -> troisième cycle
            -- 3  -> B11
            -- 4  -> B10
            -- ...
            -- 14 -> B0
            -- 15 -> fin
            --
            -- On génère donc 16 fronts descendants.
            --------------------------------------------------------------

            while edge_cnt <= 15 loop

                ----------------------------------------------------------
                -- Attendre le front descendant de ADC_CLK
                ----------------------------------------------------------
                wait until falling_edge(adc_clk);

                ----------------------------------------------------------
                -- Le CS doit toujours être actif
                ----------------------------------------------------------
                if adc_cs_n = '0' then

                    ------------------------------------------------------
                    -- Cycle 0 : NULL
                    ------------------------------------------------------
                    if edge_cnt = 0 then

                        adc_dout <= '0';

                    ------------------------------------------------------
                    -- Cycle 1 : NULL
                    ------------------------------------------------------
                    elsif edge_cnt = 1 then

                        adc_dout <= '0';

                    ------------------------------------------------------
                    -- Cycle 2 : NULL
                    ------------------------------------------------------
                    elsif edge_cnt = 2 then

                        adc_dout <= '0';

                    ------------------------------------------------------
                    -- Cycle 3 : B11
                    ------------------------------------------------------
                    elsif edge_cnt = 3 then

                        if conv_num = 1 then
                            adc_dout <= ADC_VALUE_1(11);

                        elsif conv_num = 2 then
                            adc_dout <= ADC_VALUE_2(11);

                        else
                            adc_dout <= ADC_VALUE_3(11);

                        end if;

                    ------------------------------------------------------
                    -- Cycle 4 : B10
                    ------------------------------------------------------
                    elsif edge_cnt = 4 then

                        if conv_num = 1 then
                            adc_dout <= ADC_VALUE_1(10);

                        elsif conv_num = 2 then
                            adc_dout <= ADC_VALUE_2(10);

                        else
                            adc_dout <= ADC_VALUE_3(10);

                        end if;

                    ------------------------------------------------------
                    -- Cycle 5 : B9
                    ------------------------------------------------------
                    elsif edge_cnt = 5 then

                        if conv_num = 1 then
                            adc_dout <= ADC_VALUE_1(9);

                        elsif conv_num = 2 then
                            adc_dout <= ADC_VALUE_2(9);

                        else
                            adc_dout <= ADC_VALUE_3(9);

                        end if;

                    ------------------------------------------------------
                    -- Cycle 6 : B8
                    ------------------------------------------------------
                    elsif edge_cnt = 6 then

                        if conv_num = 1 then
                            adc_dout <= ADC_VALUE_1(8);

                        elsif conv_num = 2 then
                            adc_dout <= ADC_VALUE_2(8);

                        else
                            adc_dout <= ADC_VALUE_3(8);

                        end if;

                    ------------------------------------------------------
                    -- Cycle 7 : B7
                    ------------------------------------------------------
                    elsif edge_cnt = 7 then

                        if conv_num = 1 then
                            adc_dout <= ADC_VALUE_1(7);

                        elsif conv_num = 2 then
                            adc_dout <= ADC_VALUE_2(7);

                        else
                            adc_dout <= ADC_VALUE_3(7);

                        end if;

                    ------------------------------------------------------
                    -- Cycle 8 : B6
                    ------------------------------------------------------
                    elsif edge_cnt = 8 then

                        if conv_num = 1 then
                            adc_dout <= ADC_VALUE_1(6);

                        elsif conv_num = 2 then
                            adc_dout <= ADC_VALUE_2(6);

                        else
                            adc_dout <= ADC_VALUE_3(6);

                        end if;

                    ------------------------------------------------------
                    -- Cycle 9 : B5
                    ------------------------------------------------------
                    elsif edge_cnt = 9 then

                        if conv_num = 1 then
                            adc_dout <= ADC_VALUE_1(5);

                        elsif conv_num = 2 then
                            adc_dout <= ADC_VALUE_2(5);

                        else
                            adc_dout <= ADC_VALUE_3(5);

                        end if;

                    ------------------------------------------------------
                    -- Cycle 10 : B4
                    ------------------------------------------------------
                    elsif edge_cnt = 10 then

                        if conv_num = 1 then
                            adc_dout <= ADC_VALUE_1(4);

                        elsif conv_num = 2 then
                            adc_dout <= ADC_VALUE_2(4);

                        else
                            adc_dout <= ADC_VALUE_3(4);

                        end if;

                    ------------------------------------------------------
                    -- Cycle 11 : B3
                    ------------------------------------------------------
                    elsif edge_cnt = 11 then

                        if conv_num = 1 then
                            adc_dout <= ADC_VALUE_1(3);

                        elsif conv_num = 2 then
                            adc_dout <= ADC_VALUE_2(3);

                        else
                            adc_dout <= ADC_VALUE_3(3);

                        end if;

                    ------------------------------------------------------
                    -- Cycle 12 : B2
                    ------------------------------------------------------
                    elsif edge_cnt = 12 then

                        if conv_num = 1 then
                            adc_dout <= ADC_VALUE_1(2);

                        elsif conv_num = 2 then
                            adc_dout <= ADC_VALUE_2(2);

                        else
                            adc_dout <= ADC_VALUE_3(2);

                        end if;

                    ------------------------------------------------------
                    -- Cycle 13 : B1
                    ------------------------------------------------------
                    elsif edge_cnt = 13 then

                        if conv_num = 1 then
                            adc_dout <= ADC_VALUE_1(1);

                        elsif conv_num = 2 then
                            adc_dout <= ADC_VALUE_2(1);

                        else
                            adc_dout <= ADC_VALUE_3(1);

                        end if;

                    ------------------------------------------------------
                    -- Cycle 14 : B0
                    ------------------------------------------------------
                    elsif edge_cnt = 14 then

                        if conv_num = 1 then
                            adc_dout <= ADC_VALUE_1(0);

                        elsif conv_num = 2 then
                            adc_dout <= ADC_VALUE_2(0);

                        else
                            adc_dout <= ADC_VALUE_3(0);

                        end if;

                    ------------------------------------------------------
                    -- Cycle 15 : dernier cycle / fin
                    ------------------------------------------------------
                    elsif edge_cnt = 15 then

                        adc_dout <= '0';

                    end if;

                    ----------------------------------------------------------
                    -- Passer au cycle suivant
                    ----------------------------------------------------------
                    edge_cnt := edge_cnt + 1;

                end if;

            end loop;


            --------------------------------------------------------------
            -- Attendre que le DUT indique que la donnée est disponible
            --------------------------------------------------------------
            wait until RxIF = '1';


            --------------------------------------------------------------
            -- Vérification de la conversion
            --------------------------------------------------------------

            if conv_num = 1 then

                assert data_out = ADC_VALUE_1
                    report "FAIL CONVERSION 1 : valeur incorrecte"
                    severity error;

                report "PASS : conversion 1 = "
                    & integer'image(
                        to_integer(unsigned(data_out))
                    );


            elsif conv_num = 2 then

                assert data_out = ADC_VALUE_2
                    report "FAIL CONVERSION 2 : valeur incorrecte"
                    severity error;

                report "PASS : conversion 2 = "
                    & integer'image(
                        to_integer(unsigned(data_out))
                    );


            else

                assert data_out = ADC_VALUE_3
                    report "FAIL CONVERSION 3 : valeur incorrecte"
                    severity error;

                report "PASS : conversion 3 = "
                    & integer'image(
                        to_integer(unsigned(data_out))
                    );

            end if;


            --------------------------------------------------------------
            -- Attendre que CS repasse à 1
            --------------------------------------------------------------
            wait until adc_cs_n = '1';

            report "FIN CONVERSION "
                & integer'image(conv_num);


            --------------------------------------------------------------
            -- Conversion suivante
            --------------------------------------------------------------
            conv_num := conv_num + 1;

        end loop;


        ------------------------------------------------------------------
        -- TEST TERMINE
        ------------------------------------------------------------------

        report "********************************************";
        report "       TEST TERMINE AVEC SUCCES";
        report "       3 CONVERSIONS EFFECTUEES";
        report "********************************************";


        ------------------------------------------------------------------
        -- Arrêt propre
        ------------------------------------------------------------------
        std.env.stop;

        wait;

    end process;

end sim;