library ieee;
use ieee.std_logic_1164.all;

library vunit_lib;
use vunit_lib.run_pkg.all;

library testing;
use testing.clock_util;
use testing.pulse_util;

use work.edge_pkg;

entity TestEdgeDetector is
  generic(runner_cfg: string);
end entity;

architecture test of TestEdgeDetector is
  constant period: time := 20 ns;
  signal edgeDetector: edge_pkg.EdgeDetector;
begin
  clock_util.generateClock(clock => edgeDetector.clock, period => period);

  process
  begin
    test_runner_setup(runner, runner_cfg);

    while test_suite loop
      edgeDetector.input <= '0';
      edgeDetector.direction <= edge_pkg.rising;
      wait for period*3/4;
      pulse_util.highPulseForTime(edgeDetector.reset, period);      

      if run("test_InputNotOnClockCycle_OutputOnClockCycle") then
        edgeDetector.input <= '1';
        wait for period;
                
        assert edgeDetector.output = '1';
        wait for period;
        assert edgeDetector.output = '0';
        
      elsif run("test_InputOnClockCycle_OutputTriggersOnSameClockCycle") then
        wait for period/4;
        edgeDetector.input <= '1';
        wait for period/10;

        assert edgeDetector.output = '1';
        
      end if;
    end loop;
    
    test_runner_cleanup(runner);
  end process;

  unit: entity work.EdgeDetector
    port map(
      clock => edgeDetector.clock,
      reset => edgeDetector.reset,
      direction => edgeDetector.direction,
      input => edgeDetector.input,
      output => edgeDetector.output);

end architecture;
