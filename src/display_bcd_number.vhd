library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity display_bcd_number is
    port(
        input_clock : in std_logic;
        number_bcd : in std_logic_vector(11 downto 0);
        seven_segment_display_selection : out std_logic_vector(2 downto 0);
        seven_segment_display : out std_logic_vector(7 downto 0));
end display_bcd_number; 

architecture behavioral of display_bcd_number is

signal clock : std_logic := '1';
signal refresh_counter : integer := 0;
constant refresh_limit : integer := 12000000 / 2 / 250; -- 250Hz or 4ms
signal current_display : integer := 0;
signal current_digit_bcd : std_logic_vector(3 downto 0) := "0000";

begin
    divide_clock : process(input_clock)
    begin
        if rising_edge(input_clock) then
            if refresh_counter = refresh_limit - 1 then
                refresh_counter <= 0;
                clock <= not clock;
            else
                refresh_counter <= refresh_counter + 1;
            end if;
        end if;
    end process;

    select_display : process(clock)
    begin
        if rising_edge(clock) then
            if current_display = 3 - 1 then
                current_display <= 0;
            else
                current_display <= current_display + 1;
            end if;
        end if;
    end process;

    activate_display : process(current_display)
    begin
        case current_display is
            when 0 => seven_segment_display_selection <= "011";
            when 1 => seven_segment_display_selection <= "101";
            when 2 => seven_segment_display_selection <= "110";
            when others => seven_segment_display_selection <= "000";
        end case;
    end process;

    select_digit : process(current_display, number_bcd)
    begin
        case current_display is
            when 0 => current_digit_bcd <= number_bcd(11 downto 8);
            when 1 => current_digit_bcd <= number_bcd(7 downto 4);
            when 2 => current_digit_bcd <= number_bcd(3 downto 0);
            when others => current_digit_bcd <= "0000";
        end case;
    end process;

    display_digit : process(current_digit_bcd)
    begin
        case current_digit_bcd is
            when "0000" => seven_segment_display(7 downto 0) <= "00000011";
            when "0001" => seven_segment_display(7 downto 0) <= "10011111";
            when "0010" => seven_segment_display(7 downto 0) <= "00100101";
            when "0011" => seven_segment_display(7 downto 0) <= "00001101";
            when "0100" => seven_segment_display(7 downto 0) <= "10011001";
            when "0101" => seven_segment_display(7 downto 0) <= "01001001";
            when "0110" => seven_segment_display(7 downto 0) <= "01000001";
            when "0111" => seven_segment_display(7 downto 0) <= "00011111";
            when "1000" => seven_segment_display(7 downto 0) <= "00000001";
            when "1001" => seven_segment_display(7 downto 0) <= "00011001";
            when others => seven_segment_display(7 downto 0) <= "11111111";
        end case;
    end process;

end behavioral;
