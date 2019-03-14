use work.edge_pkg;

library ieee;
use ieee.std_logic_1164.all;

entity DualInputEdgeDetector is
  port(
    clock: in std_logic;
    reset: in std_logic;
    direction: in edge_pkg.Direction;
    first: in std_logic;
    second: in std_logic;
    output: out std_logic);
end entity;

architecture behavioral of DualInputEdgeDetector is
  signal firstEdgeFiltered: std_logic;
  signal secondEdgeFiltered: std_logic;
  signal isFirstDetected: std_logic;

begin

  process(reset, clock)
    variable directionLogic: std_logic;
  begin
    
    directionLogic := edge_pkg.directionToLogic(direction);
    
    if reset = '1' then
      output <= '0';
      isFirstDetected <= '0';

    elsif rising_edge(clock) then
      if firstEdgeFiltered = directionLogic then
        isFirstDetected <= '1';
      elsif isFirstDetected = '1' and secondEdgeFiltered = directionLogic then
        output <= '1';
        isFirstDetected <= '0';
      else
        output <= '0';
      end if;
    end if;
  end process;

  firstEdgeDetector: entity work.EdgeDetector
    port map(
      clock => clock,
      reset => reset,
      direction => direction,
      input => first,
      output => firstEdgeFiltered);

  secondEdgeDetector: entity work.EdgeDetector
    port map(
      clock => clock,
      reset => reset,
      direction => direction,
      input => second,
      output => secondEdgeFiltered);
end architecture;
