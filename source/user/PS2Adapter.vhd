library ieee, ps2;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ps2.ps2_pkg;
use work.state_pkg, work.state_pkg.ready, work.state_pkg.parse;

entity PS2Adapter is
  port(
    clock: in std_logic;
    peripheral: in ps2_pkg.Peripheral;
    flag: out std_logic; --TODO remove once finished debugging
    data: out ps2_pkg.Byte);
end entity;

architecture behavioral of PS2Adapter is
  signal state: state_pkg.PS2;
  signal ps2Controller: ps2_pkg.PS2Controller;
  signal flagDelayed: ps2_pkg.Flag;

  impure function newDataReceived return boolean is
  begin
    return flagDelayed.isNewData = '0' and ps2Controller.flag.isNewData = '1';
  end function;

  impure function notBreakCommand return boolean is
  begin
    return ps2Controller.data /= ps2_pkg.break;
  end function;

  impure function notMultiKeyCommand return boolean is
  begin
    return ps2Controller.data /= ps2_pkg.multi;
  end function;

begin
  ps2Controller.clock <= clock;
  ps2Controller.peripheral <= peripheral;
  flag <= ps2Controller.flag.isNewData;

  stateMachine: process(clock)
  begin
    if rising_edge(clock) then
      flagDelayed <= ps2Controller.flag;
      
      case state is
        when ready =>
          if newDataReceived then
            state <= parse;
          end if;

        when parse =>
          if notBreakCommand and notMultiKeyCommand then
            data <= ps2Controller.data;
          end if;
          state <= ready;

      end case;
    end if;
  end process;
    
  ps2ControllerInstance: entity ps2.PS2Controller --TODO fix this ugly entity
    generic map(
      clk_freq => 125_000_000,
      debounce_counter_size => 8)
    port map(
      clk => ps2Controller.clock,
      ps2_clk => ps2Controller.peripheral.clock,
      ps2_data => ps2Controller.peripheral.data,
      ps2_code_new => ps2Controller.flag.isNewData,
      unsigned(ps2_code) => ps2Controller.data);
      
end architecture;
