library ieee, shift_register, synchronizer;
use ieee.std_logic_1164.all;
use shift_register.shift_pkg;
use synchronizer.sync_pkg;
use work.ps2_pkg;
use work.ps2_pkg.initializing,
  work.ps2_pkg.ready,
  work.ps2_pkg.starting,
  work.ps2_pkg.fetching,
  work.ps2_pkg.storing;


entity PeripheralDataReader is
  port(
    clock: in std_logic;
    dataPeripheral: in std_logic;
    state: in ps2_pkg.State;
    flag: out ps2_pkg.FlagPeripheralData;
    data: out ps2_pkg.Byte);
end entity;

architecture behavioral of PeripheralDataReader is
  constant memoryWidth: positive := ps2_pkg.totalTransmitLength;
  signal memory: shift_pkg.SIPOShiftRegister(output(memoryWidth-1 downto 0));
  signal dataSynced: std_logic; 
begin

  stateMachine: process(state, dataSynced, memory) is
  begin
    case state is
      when initializing =>
        memory.reset <= '1';
        memory.clock <= '0';
        data <= (others => '0');
        flag.isNewData <= '0';
        
      when ready =>
        data <= shift_pkg.flipBitOrder(memory.output(ps2_pkg.CodeByteRange));
        flag.isNewData <= not dataSynced;

      when starting =>
        flag.isNewData <= '0';
        memory.reset <= '0';
        
      when storing =>
        memory.input <= dataSynced;
        memory.clock <= '0';
        
      when fetching =>
        memory.clock <= '1';
        
    end case;
  end process;

  dataSynchronizer: entity synchronizer.Synchronizer
    port map(
      clock => clock,
      input => dataPeripheral,
      output => dataSynced);
  
  sipoShiftRegister: entity shift_register.SIPOShiftRegister
    generic map(width => memoryWidth)
    port map(
      clock => memory.clock,
      reset => memory.reset,
      input => memory.input,
      output => memory.output);
    
end architecture;
