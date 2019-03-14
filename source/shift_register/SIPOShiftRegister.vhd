library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SIPOShiftRegister is
  generic(width: positive);
  port(
    clock: in std_logic;
    reset: in std_logic;
    input: in std_logic;
    output: buffer unsigned(width-1 downto 0));
end entity;

architecture behavioral of SIPOShiftRegister is
begin
  process(clock, reset)
  begin
    if reset = '1' then
      output <= (others => '0');
    elsif rising_edge(clock) then
      output(width-1 downto 1) <= output(width-2 downto 0);
      output(0) <= input;
    end if;
  end process;
end architecture;
