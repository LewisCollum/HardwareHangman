library ieee;
use ieee.std_logic_1164.all;

entity Synchronizer is
  port(
    clock: in std_logic;
    input: in std_logic;
    output: out std_logic);
end entity;

architecture behavioral of Synchronizer is
begin
  process(clock)
  begin
    if rising_edge(clock) then
      output <= input;
    end if;
  end process;
end architecture;
