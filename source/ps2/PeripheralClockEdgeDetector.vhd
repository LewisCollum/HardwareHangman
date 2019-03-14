library ieee, synchronizer;
use ieee.std_logic_1164.all;
use work.ps2_pkg;
use synchronizer.sync_pkg;
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
  signal clockSynced: std_logic;
begin

  stateMachine: process(state, clockSynced)
  begin
    case state is
      when initializing | ready =>
        flag <= (others => '0');
        
      when starting | fetching =>
        flag.isFalling <= not clockSynced;
        flag.isRising <= '0';
        
      when storing =>
        flag.isRising <= clockSynced;
        flag.isFalling <= '0';

    end case;  
  end process;

  clockSynchronizer: entity synchronizer.Synchronizer
    port map(
      clock => clock,
      input => clockPeripheral,
      output => clockSynced);
  
end architecture;
