library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_module is
    port(
        input_clock : in std_logic;
        dp_switch : in std_logic_vector(7 downto 0);
        seven_segment_display_selection : out std_logic_vector(2 downto 0);
        seven_segment_display : out std_logic_vector(7 downto 0));
end top_module; 

architecture behavioral of top_module is

signal number_binary : std_logic_vector(7 downto 0) := (others => '0');
signal number_bcd : std_logic_vector(11 downto 0) := (others => '0');

component display_bcd_number is
    port(
        input_clock : in std_logic;
        number_bcd : in std_logic_vector(11 downto 0);
        seven_segment_display_selection : out std_logic_vector(2 downto 0);
        seven_segment_display : out std_logic_vector(7 downto 0));
end component; 

component binary_to_bcd is
    port(
        binary : in std_logic_vector(7 downto 0);
        bcd : out std_logic_vector(11 downto 0));
end component;

begin
    number_binary <= not dp_switch;
    
    display : display_bcd_number
    port map(
        input_clock => input_clock, 
        number_bcd => number_bcd,
        seven_segment_display_selection => seven_segment_display_selection,
        seven_segment_display => seven_segment_display);
        
    converter : binary_to_bcd
    port map(
        binary => number_binary,
        bcd => number_bcd);

end behavioral;
