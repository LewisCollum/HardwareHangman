library ieee, timer_counter, flip_flop;
use work.ps2_pkg;
use ieee.std_logic_1164.all;

entity PS2Controller is
  port(
    clock: in std_logic;
    reset: in std_logic;
    peripheral: in ps2_pkg.Peripheral;
    flag: out ps2_pkg.FlagExternal;
    data: out ps2_pkg.Byte);
end entity;

architecture structural of PS2Controller is
  signal state: ps2_pkg.State;
  signal flagInternal: ps2_pkg.FlagInternal;
begin

  flagDelay: entity flip_flop.DFlipFlop
    port map(
      clock => clock,
      data => flagInternal.isBitCounterDone,
      output => flag.isNewData);
  
  stateController: entity work.StateController
    port map(
      clock => clock,
      reset => reset,
      flag => flagInternal,
      state => state);

  bitCounter: entity work.BitCounter
    port map(
      state => state,
      isDone => flagInternal.isBitCounterDone);

  peripheralClockEdgeDetector: entity work.PeripheralClockEdgeDetector
    port map(
      clock => clock,
      clockPeripheral => peripheral.clock,
      state => state,
      flag.isRising => flagInternal.isReadyToFetch,
      flag.isFalling => flagInternal.isReadyToStore);

  peripheralDataReader: entity work.PeripheralDataReader
    port map(
      clock => clock,
      dataPeripheral => peripheral.data,
      state => state,
      flag.isNewData => flagInternal.isNewData,
      data => data);

end architecture;
