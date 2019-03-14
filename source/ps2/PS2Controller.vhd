library ieee, timer_counter, flip_flop;
use work.ps2_pkg;
use ieee.std_logic_1164.all;

--delete after debug
use work.ps2_pkg.initializing,
  work.ps2_pkg.ready,
  work.ps2_pkg.starting,
  work.ps2_pkg.fetching,
  work.ps2_pkg.storing;


entity PS2Controller is
  port(
    clock: in std_logic;
    reset: in std_logic;
    peripheral: in ps2_pkg.Peripheral;
    flag: buffer ps2_pkg.FlagExternal;--TODO change back to out
    data: out ps2_pkg.Byte);
end entity;

architecture structural of PS2Controller is
  signal state: ps2_pkg.State;
  signal flagInternal: ps2_pkg.FlagInternal;
begin

  debug: process(clock, state)
  begin
    case state is
      when initializing | ready =>
        flag.isInitializing <= '1';
        flag.isFetching <= '0';
        flag.isStoring <= '0';
        flag.isStart <= '0';

      when starting =>
        flag.isInitializing <= '0';
        flag.isFetching <= '0';
        flag.isStoring <= '0';
        flag.isStart <= '1';

      when fetching =>
        flag.isInitializing <= '0';
        flag.isFetching <= '1';
        flag.isStoring <= '0';
        flag.isStart <= '0';

      when storing =>
        flag.isInitializing <= '0';
        flag.isFetching <= '0';
        flag.isStoring <= '1';
        flag.isStart <= '0';

    end case;
  end process;
  
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

  -- bitCounter: entity timer_counter.TimerCounter
  --   generic map(11)
  --   port map(
  --     clock => flagInternal.isReadyToFetch,
  --     reset => flag.isInitializing,
  --     isDone => flagInternal.isBitCounterDone);

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
