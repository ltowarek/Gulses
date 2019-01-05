library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity binary_to_bcd is
    port(
        binary : in std_logic_vector(7 downto 0);
        bcd : out std_logic_vector(11 downto 0));
end binary_to_bcd;

architecture behavioral of binary_to_bcd is

begin
    double_dabble : process(binary)
        variable tmp_binary : std_logic_vector(7 downto 0);
        variable tmp_bcd : unsigned(11 downto 0) := (others => '0');
    begin
        tmp_binary := binary;
        tmp_bcd := (others => '0');
        for i in 0 to 7 loop
            if tmp_bcd(3 downto 0) > 4 then
                tmp_bcd(3 downto 0) := tmp_bcd(3 downto 0) + 3;
            end if;
            
            if tmp_bcd(7 downto 4) > 4 then
                tmp_bcd(7 downto 4) := tmp_bcd(7 downto 4) + 3;
            end if;
            
            tmp_bcd := tmp_bcd(10 downto 0) & tmp_binary(7);
            tmp_binary := tmp_binary(6 downto 0) & '0';            
        end loop;
        bcd <= std_logic_vector(tmp_bcd);
    end process;

end behavioral;
