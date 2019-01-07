library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu is
    port(
        a : in std_logic_vector(7 downto 0);
        b : in std_logic_vector(7 downto 0);
        operation : in std_logic_vector(3 downto 0);
        output : out std_logic_vector(7 downto 0));
end alu;

architecture behavioral of alu is

signal result : std_logic_vector(7 downto 0) := (others => '0');

begin
    alu : process(a, b, operation)
    begin
        case operation is
            when "0000" => result <= a + b;
            when "0001" => result <= a - b;
            when "0010" => result <= std_logic_vector(to_unsigned(to_integer(unsigned(a)) * to_integer(unsigned(b)), 8));
            -- not supported when "0011" => result <= std_logic_vector(to_unsigned(to_integer(unsigned(a)) / to_integer(unsigned(b)), 8));
            when "0100" => result <= a and b;
            when "0101" => result <= a or b;
            when others => result <= a + b;
        end case;
    end process;
    
    output <= result;

end behavioral;
