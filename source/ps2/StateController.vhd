library ieee;
use ieee.std_logic_1164.all, ieee.numeric_std.all;
use work.ps2_pkg;
use work.ps2_pkg.initializing,
  work.ps2_pkg.ready,
  work.ps2_pkg.starting,
  work.ps2_pkg.fetching,
  work.ps2_pkg.storing;

entity StateController is
  port(
    clock: in std_logic;
    reset: in std_logic;
    flag: in ps2_pkg.FlagInternal;
    state: buffer ps2_pkg.State);
end entity;

architecture behavioral of StateController is
begin

  updateState: process(clock, reset, flag)
  begin
     if rising_edge(clock) then
      case state is
        when initializing =>
          state <= unaffected when reset = '1' else
                   ready;
          
        when ready =>
          state <= initializing when reset = '1' else
                   starting when flag.isNewData = '1' else
                   ready;

        when starting =>
          state <= initializing when reset = '1' else
                   storing when flag.isReadyToStore = '1' else
                   starting;

        when storing =>
          state <= initializing when reset = '1' else
                   ready when flag.isBitCounterDone = '1' else
                   fetching when flag.isReadyToFetch = '1' else
                   storing;
          
        when fetching =>
          state <= initializing when reset = '1' else
                   storing when flag.isReadyToStore = '1' else
                   fetching;

      end case;
    end if;
  end process;
end architecture;
