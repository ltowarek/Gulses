library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity debounce_button is
    port(
        clock : in std_logic;
        input_button : in std_logic;
        output_button : out std_logic);
end debounce_button;

architecture behavioral of debounce_button is

signal counter : std_logic_vector(19 downto 0) := (others => '1');

begin
    debounce : process(clock)
    begin
        if rising_edge(clock) then
            if (not input_button) = '0' then
                counter <= (others => '1');
            else
                if counter /= 0 then
                    counter <= counter - 1;
                else
                    counter <= (others => '1');
                end if;
            end if;
        end if;
    end process;
    
    output_button <= '1' when counter = 0 else '0';

end behavioral;
