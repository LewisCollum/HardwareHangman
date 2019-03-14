library ieee, timer_counter;
use ieee.std_logic_1164.all;
use work.ps2_pkg;
use timer_counter.timer_pkg;
use work.ps2_pkg.initializing,
  work.ps2_pkg.ready,
  work.ps2_pkg.starting,
  work.ps2_pkg.fetching,
  work.ps2_pkg.storing;

entity BitCounter is
  port(
    state: in ps2_pkg.State;
    isDone: out std_logic);
end entity;

architecture behavioral of BitCounter is
  signal timer: timer_pkg.TimerCounter;
begin
  
  -- process(state) is
  --   variable count: integer := 0;
  -- begin
  --   case state is
  --     when initializing | ready | starting =>
  --       count := 0;

  --     when storing =>
  --       count := count + 1;

  --     when others => null;
  --   end case;

  --   if count = 11 then
  --     isDone <= '1';
  --   else
  --     isDone <= '0';
  --   end if;
  -- end process;

  
  stateMachine: process(state, timer.isDone)
  begin
    case state is
      when initializing | ready =>
        timer.reset <= '1';
        timer.clock <= '0';
        isDone <= '0';
        
      when starting =>
        timer.reset <= '0';

      when storing =>
        timer.clock <= '1';
        if timer.isDone = '1' then
          isDone <= '1';
        end if;
        
      when fetching =>
        timer.clock <= '0';
        
    end case;
  end process;

  timerCounterInstance: entity timer_counter.TimerCounter
    generic map(countMax => ps2_pkg.totalTransmitLength)
    port map(timer.clock, timer.reset, timer.isDone);


  
end architecture;
    
