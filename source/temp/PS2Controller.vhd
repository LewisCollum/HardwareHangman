library ieee, timer_counter, shift_register;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ps2_pkg;
use work.ps2_pkg.ready, work.ps2_pkg.fetching, work.ps2_pkg.output;

entity PS2Controller is
  port(
    clock: in std_logic;
    reset: in std_logic;
    peripheral: in ps2_pkg.Peripheral;
    flag: out ps2_pkg.Flag;
    data: out ps2_pkg.Byte);
end entity;

architecture behavioral of PS2Controller is
  signal state: ps2_pkg.State;
  signal bitCounter: ps2_pkg.BitCounter;
  signal memory: ps2_pkg.Memory;
  signal peripheralSynced: ps2_pkg.Peripheral;
  signal previousData: std_logic;
  
begin

  PeripheralSyncer: process(clock)
  begin
    if rising_edge(clock) then
      peripheralSynced <= peripheral;
    end if;
  end process;

  DataDelay: process(clock)
  begin
    if rising_edge(clock) then
      previousData <= peripheralSynced.data;
    end if;
  end process;
  
  StateController: process(clock)
  begin
    if rising_edge(clock) then
      if reset = '1' then
        state <= ready;
        bitCounter.reset <= '1';
        memory.reset <= '1';
        flag.isBusy <= '0';
        data <= (others => '0');
      else 
        case state is
          when ready =>
            if peripheralSynced.data = '0' and previousData = '1' and peripheralSynced.clock = '1' then
              bitCounter.reset <= '0';
              memory.reset <= '1';
              state <= fetching;
              flag.isBusy <= '1';
            else
              bitCounter.reset <= '1';
            end if;
            
          when fetching =>
            memory.reset <= '0';
            if bitCounter.isDone = '1' then
              state <= output;
            end if;
            
          when output =>
            data <= memory.output(ps2_pkg.CodeByteRange);
            state <= ready;
            flag.isBusy <= '0';
        end case;
      end if;
    end if;
  end process;
   
  InputController: process(peripheralSynced.clock)
  begin
    if falling_edge(peripheralSynced.clock) then
      case state is
        when fetching =>
          memory.input <= peripheralSynced.data;          
        when others =>
          null;                      
      end case;
    end if;
  end process;       

  memoryInstance: entity shift_register.SIPOShiftRegister
    generic map(width => ps2_pkg.totalTransmitLength)
    port map(
      clock => peripheralSynced.clock,
      reset => memory.reset,
      input => memory.input,
      output => memory.output);

  bitCounterInstance: entity timer_counter.TimerCounter
    generic map(countMax => ps2_pkg.totalTransmitLength)
    port map(
      clock => peripheralSynced.clock,
      reset => bitCounter.reset,
      isDone => bitCounter.isDone);
end architecture;
