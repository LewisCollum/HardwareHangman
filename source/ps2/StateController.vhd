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
      if reset = '1' then
        state <= initializing;
      else
        case state is
          when initializing =>
            state <= ready;
            
          when ready =>
            if flag.isNewData = '1' then
              state <= starting;
            end if;

          when starting =>
            if flag.isReadyToStore = '1' then
              state <= storing;
            end if;

          when storing =>
            if flag.isBitCounterDone = '1' then
              state <= ready;
            elsif flag.isReadyToFetch = '1' then
              state <= fetching;
            end if;
            
          when fetching =>
            if flag.isReadyToStore = '1' then
              state <= storing;
            end if;
        end case;
      end if;
    end if;
  end process;
end architecture;
