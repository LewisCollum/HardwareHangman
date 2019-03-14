library ieee, vunit_lib, testing;
use vunit_lib.run_pkg.all;
use work.ps2_pkg;
use ieee.std_logic_1164.all, ieee.numeric_std.all;
use testing.clock_util, testing.pulse_util, testing.serial_util;

entity TestPS2Controller is
  generic(runner_cfg: string);
end entity;

architecture test of TestPS2Controller is
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
 
  signal unit: ps2_pkg.PS2Controller;
  
begin
  process

  begin
    test_runner_setup(runner, runner_cfg);
    
    while test_suite loop
      unit.reset <= '1';
      unit.peripheral.clock <= '1';
      unit.peripheral.data <= '1';
      wait for system.period;
      unit.reset <= '0';
      wait for system.period;

      if run("waveform") then
        --data is sent backwards
        
        serial_util.sendStreamWithParityOnRisingEdgeOfClock(
          dataToSend => "00111000",
          data => unit.peripheral.data,
          clock => unit.peripheral.clock,
          period => peripheral.period); --a
        
        serial_util.sendStreamWithParityOnRisingEdgeOfClock(
          dataToSend => "01001100",
          data => unit.peripheral.data,
          clock => unit.peripheral.clock,
          period => peripheral.period); --b
        
      end if;

      unit.peripheral.clock <= 'H';        
      unit.peripheral.data <= 'H';
      wait for peripheral.period*2;      
    end loop;
    
    test_runner_cleanup(runner);
  end process;

  unitPS2Controller: entity work.PS2Controller
    port map(
      clock => unit.clock,
      reset => unit.reset,
      peripheral => unit.peripheral,
      flag => unit.flag,
      data => unit.data);

  clock_util.generateClock(unit.clock, system.period);
end architecture;

