library ieee, ps2;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.user_pkg;
use work.user_pkg.initializing,
  work.user_pkg.waiting,
  work.user_pkg.playing,
  work.user_pkg.resulting;
use ps2.ps2_pkg;
use work.adapter_pkg, work.adapter_pkg.ready, work.adapter_pkg.parse;

entity PS2Adapter is
  port(
    clock: in std_logic;
    state: in user_pkg.State;
    peripheral: in ps2_pkg.Peripheral;
    flag: out ps2_pkg.FlagExternal;
    data: out ps2_pkg.Byte);
end entity;

architecture behavioral of PS2Adapter is
  signal controller: ps2_pkg.PS2Controller;

  impure function notBreakCommand return boolean is
  begin
    return controller.data /= ps2_pkg.break;
  end function;

  impure function notMultiKeyCommand return boolean is
  begin
    return controller.data /= ps2_pkg.multi;
  end function;

begin
  controller.clock <= clock;
  controller.peripheral <= peripheral;
  flag <= controller.flag;

  stateMachine: process(clock, peripheral)
  begin
    case state.system is
      when initializing =>
        controller.reset <= '1';
        
      when waiting =>
        controller.reset <= '0';
        controller.peripheral <= peripheral;
        
      when playing =>
        controller.peripheral <= peripheral;

      when resulting =>
        controller.peripheral <= (others => '0');

      when others =>
        null;
        
    end case;
    -- if rising_edge(clock) then
    --   if reset = '1' then
    --     --flagDelayed.isBusy <= '0';
    --     data <= (others => '0');
    --   else
    --     --flagDelayed <= controller.flag;

    --     if notBreakCommand and notMultiKeyCommand then
    --       data <= controller.data;
    --     end if;        

    --     -- case state is
    --     --   when ready =>
    --     --     if newDataReceived then
    --     --       state <= parse;
    --     --     end if;

    --     --   when parse =>
    --     --     if notBreakCommand and notMultiKeyCommand then
    --     --       data <= controller.data;
    --     --     end if;
    --     --     state <= ready;
    --     -- end case;
    --   end if;
    -- end if;
  end process;
    
  controllerInstance: entity ps2.PS2Controller
    port map(
      clock => controller.clock,
      reset => controller.reset,
      peripheral => controller.peripheral,
      flag => controller.flag,
      data => controller.data);
      
end architecture;
