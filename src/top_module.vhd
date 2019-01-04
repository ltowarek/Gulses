library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_module is
    port(
        input_clock : in std_logic;
        seven_segment_display_selection : out std_logic_vector(2 downto 0);
        seven_segment_display : out std_logic_vector(7 downto 0));
end top_module; 

architecture behavioral of top_module is

constant input_bcd_number : std_logic_vector(11 downto 0) := "000101011001";

component display_bcd_number is
    port(
        input_clock : in std_logic;
        number_bcd : in std_logic_vector(11 downto 0);
        seven_segment_display_selection : out std_logic_vector(2 downto 0);
        seven_segment_display : out std_logic_vector(7 downto 0));
end component; 

begin

display : display_bcd_number
port map(
    input_clock => input_clock, 
    number_bcd => input_bcd_number,
    seven_segment_display_selection => seven_segment_display_selection,
    seven_segment_display => seven_segment_display);

end behavioral;
