library ieee;
use ieee.std_logic_1164.all;

entity DFlipFlop is
  port(
    clock: in std_logic;
    data: in std_logic;
    output: out std_logic);
end entity;

architecture behavioral of DFlipFlop is
begin
  process(clock)
  begin
    if rising_edge(clock) then
      output <= data;
    end if;
  end process;
end architecture;
