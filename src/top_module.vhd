library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_module is
    port(
        input_clock : in std_logic;
        dp_switch : in std_logic_vector(7 downto 0);
        switch : in std_logic_vector(1 downto 0);
        seven_segment_display_selection : out std_logic_vector(2 downto 0);
        seven_segment_display : out std_logic_vector(7 downto 0);
        led : out std_logic_vector(3 downto 0));
end top_module; 

architecture behavioral of top_module is

signal number_binary : std_logic_vector(7 downto 0) := (others => '0');
signal number_bcd : std_logic_vector(11 downto 0) := (others => '0');

signal switch_current_state : std_logic := '0';

type state_type is (instruction_selection, operand_a_selection, operand_b_selection, execution);
signal state : state_type := instruction_selection;
signal reset : std_logic;

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

component debounce_button is
    port(
        clock : in std_logic;
        input_button : in std_logic;
        output_button : out std_logic);
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
        
    debouncer : debounce_button 
    port map(
        clock => input_clock,
        input_button => switch(0),
        output_button => switch_current_state);
                
    reset <= not switch(1);
    
    state_machine : process(input_clock, reset)
        variable switch_previous_state : std_logic := '0';
    begin
        if reset = '1' then
            switch_previous_state := '0';
            state <= instruction_selection;
        elsif rising_edge(input_clock) then
            if switch_previous_state = '0' and switch_current_state = '1' then
                switch_previous_state := '1';
            end if;
            
            case state is
            when instruction_selection =>
                if switch_previous_state = '1' and switch_current_state = '0' then
                    state <= operand_a_selection;
                    switch_previous_state := '0';
                else
                    state <= instruction_selection;
                end if;
            when operand_a_selection =>
                if switch_previous_state = '1' and switch_current_state = '0' then
                    state <= operand_b_selection;
                    switch_previous_state := '0';
                else
                    state <= operand_a_selection;
                end if;
            when operand_b_selection =>
                if switch_previous_state = '1' and switch_current_state = '0' then
                    state <= execution;
                    switch_previous_state := '0';
                else
                    state <= operand_b_selection;
                end if;
            when execution =>
                state <= execution;
            end case;
        end if;
    end process;
    
    led(0) <= '1' when state = instruction_selection else '0';
    led(1) <= '1' when state = operand_a_selection else '0';
    led(2) <= '1' when state = operand_b_selection else '0';
    led(3) <= '1' when state = execution else '0';

end behavioral;
