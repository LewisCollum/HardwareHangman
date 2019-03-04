library ieee, vunit_lib, testing;
use vunit_lib.run_pkg.all;
use work.ps2_pkg;
use ieee.std_logic_1164.all, ieee.numeric_std.all;
use testing.clock_util, testing.pulse_util;

entity TestPS2Controller is
  generic(runner_cfg: string);
end entity;

architecture test of TestPS2Controller is
  constant frequency: positive := 50_000_000;
  constant period: time := clock_util.frequencyToPeriod(frequency);
  signal unit: ps2_pkg.PS2Controller;
begin
  process
  begin
    test_runner_setup(runner, runner_cfg);
    
    while test_suite loop
      if run("waveform") then
        
      end if;
    end loop;
    
    test_runner_cleanup(runner);
  end process;

  unitPS2Controller: entity work.PS2Controller
    generic map(
      clk_freq => frequency,
      debounce_counter_size => 8)
    port map(
      clk => unit.clock,
      ps2_clk => unit.peripheral.clock,
      ps2_data => unit.peripheral.data,
      ps2_code_new => unit.flag.isNewData,
      unsigned(ps2_code) => unit.data);

  clock_util.generateClock(unit.clock, period);
end architecture;
