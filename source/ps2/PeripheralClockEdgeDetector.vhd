library ieee, edge_detector;
use ieee.std_logic_1164.all;
use work.ps2_pkg;
use edge_detector.edge_pkg;
use work.ps2_pkg.initializing,
  work.ps2_pkg.ready,
  work.ps2_pkg.starting,
  work.ps2_pkg.fetching,
  work.ps2_pkg.storing;

entity PeripheralClockEdgeDetector is
  port(
    clock: in std_logic;
    clockPeripheral: in std_logic;
    state: in ps2_pkg.State;
    flag: out ps2_pkg.FlagPeripheralClock);
end entity;

architecture behavioral of PeripheralClockEdgeDetector is
  signal edgeDetector: edge_pkg.EdgeDetector;
begin

  edgeDetector.clock <= clock;
  edgeDetector.input <= clockPeripheral;
  
  stateMachine: process(state, edgeDetector.output)
    procedure waitForRisingEdge is
    begin
      edgeDetector.direction <= edge_pkg.rising;
      flag.isRising <= edgeDetector.output;
    end procedure;

    procedure waitForFallingEdge is
    begin
      edgeDetector.direction <= edge_pkg.falling;
      flag.isFalling <= edgeDetector.output;
    end procedure;
    
  begin
    case state is
      when initializing =>
        edgeDetector.reset <= '1';
        flag <= (others => '0');
        
      when ready =>
        edgeDetector.reset <= '0';
        
      when starting | fetching =>
        waitForFallingEdge;
        flag.isRising <= '0';
        
      when storing =>
        waitForRisingEdge;
        flag.isFalling <= '0';

    end case;
    
  end process;
  
  synchronizedEdgeDetector: entity edge_detector.EdgeDetector
    port map(
      clock => edgeDetector.clock,
      reset => edgeDetector.reset,
      direction => edgeDetector.direction,
      input => edgeDetector.input,
      output => edgeDetector.output);
end architecture;
