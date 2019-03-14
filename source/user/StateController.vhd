library ieee;
use ieee.std_logic_1164.all, ieee.numeric_std.all;
use work.user_pkg;
use work.user_pkg.initializing,
  work.user_pkg.waiting,
  work.user_pkg.playing,
  work.user_pkg.resulting,
  work.user_pkg.done;

use work.user_pkg.guessing,
  work.user_pkg.guessed,
  work.user_pkg.wrong,
  work.user_pkg.correct;

use work.user_pkg.loss,
  work.user_pkg.win;

entity StateController is
  port(
    clock: in std_logic;
    reset: in std_logic;
    flag: in user_pkg.FlagInternal;
    state: out user_pkg.State);
end entity;

architecture behavioral of StateController is
begin

  process(clock)
  begin
    if rising_edge(clock) then
      if reset = '1' then
        state.system <= initializing;
      else
        case state.system is
          when initializing =>
            state.system <= waiting;

          when waiting =>
            if flag.ps2.internal.isNewData = '1' and flag.ps2.isNewGame = '1' then
              state.system <= playing;
              state.play <= guessing;
            end if;
            
          when playing =>
            case state.play is
              when guessing =>
              when guessed =>
              when wrong =>
              when correct =>
            end case;
            
          when resulting =>
            case state.result is
              when loss =>
              when win =>
            end case;
            
          when done =>
        end case;
      end if;
    end if;
  end process;
  
end architecture;
