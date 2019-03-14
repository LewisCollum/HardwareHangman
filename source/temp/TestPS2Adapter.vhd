library ieee, vunit_lib, testing;
use vunit_lib.run_pkg.all;
use work.adapter_pkg;
use testing.clock_util;
use ieee.std_logic_1164.all;

entity TestPS2Adapter is
  generic(runner_cfg: string);
end entity;

architecture test of TestPS2Adapter is
  type Clock is record
    frequency: positive;
    period: time;
  end record;

  constant system: Clock := (
    frequency => 125_000_000,
    period => clock_util.frequencyToPeriod(125_000_000));

  constant peripheral: Clock := (
    frequency => 12_500,
    period => clock_util.frequencyToPeriod(12_500));

  signal unit: adapter_pkg.PS2Adapter;
begin
  process
  begin
    test_runner_setup(runner, runner_cfg);

    while test_suite loop
      unit.reset <= '1';
      unit.peripheral.clock <= '1';
      unit.peripheral.data <= '1';
      wait for system.period*2;
      unit.reset <= '0';
      wait for system.period;

      if run("waveform") then
        --00111000 (backwards 0x1C) letter: a
        unit.peripheral.data <= '0';
        wait for peripheral.period/4;
        unit.peripheral.clock <= '0';
        wait for peripheral.period/2;
        unit.peripheral.clock <= '1';
        unit.peripheral.data <= '0';
        wait for peripheral.period/2;
        unit.peripheral.clock <= '0';
        
        wait for peripheral.period/2;
        unit.peripheral.clock <= '1';
        unit.peripheral.data <= '0';        
        wait for peripheral.period/2;
        unit.peripheral.clock <= '0';
        
        wait for peripheral.period/2;
        unit.peripheral.clock <= '1';
        unit.peripheral.data <= '1';        
        wait for peripheral.period/2;
        unit.peripheral.clock <= '0';
        
        wait for peripheral.period/2;
        unit.peripheral.clock <= '1';
        unit.peripheral.data <= '1';        
        wait for peripheral.period/2;
        unit.peripheral.clock <= '0';
        
        wait for peripheral.period/2;
        unit.peripheral.clock <= '1';
        unit.peripheral.data <= '1';        
        wait for peripheral.period/2;
        unit.peripheral.clock <= '0';
        
        wait for peripheral.period/2;
        unit.peripheral.clock <= '1';
        unit.peripheral.data <= '0';        
        wait for peripheral.period/2;
        unit.peripheral.clock <= '0';
        
        wait for peripheral.period/2;
        unit.peripheral.clock <= '1';
        unit.peripheral.data <= '0';        
        wait for peripheral.period/2;
        unit.peripheral.clock <= '0';
        
        wait for peripheral.period/2;
        unit.peripheral.clock <= '1';
        unit.peripheral.data <= '0';        
        wait for peripheral.period/2;
        unit.peripheral.clock <= '0';
        
        wait for peripheral.period/2;
        unit.peripheral.clock <= '1';
        unit.peripheral.data <= '0';
        wait for peripheral.period/2;
        unit.peripheral.clock <= '0';
        
        wait for peripheral.period/2;
        unit.peripheral.clock <= '1';
        unit.peripheral.data <= '1';
        wait for peripheral.period/2;
        unit.peripheral.clock <= '0';

        wait for peripheral.period/2;
        unit.peripheral.clock <= 'H';        
        unit.peripheral.data <= 'H';

        wait for peripheral.period*2;
      end if;
    end loop;    

    test_runner_cleanup(runner);
  end process;

  unitPS2Adapter: entity work.PS2Adapter
    port map(
      clock => unit.clock,
      reset => unit.reset,
      peripheral => unit.peripheral,
      data => unit.data);

  clock_util.generateClock(unit.clock, system.period);
end architecture;
