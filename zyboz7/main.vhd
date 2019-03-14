library ieee, user, ps2;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use user.user_pkg;

entity main is
  port(
    clock: in std_logic;
    ps2_clock: in std_logic;
    ps2_data: in std_logic;
    button: in unsigned(3 downto 0);
    switch: in unsigned(3 downto 0);
    led: out unsigned(3 downto 0);
    led_red: out std_logic;
    led_blue: out std_logic;
    led_green: out std_logic);
end entity;

architecture structural of main is
  signal data: unsigned(7 downto 0);
  signal state: user_pkg.State;
  signal temp: std_logic;
  signal isNewData: std_logic;
begin
--  led_red <= button(0);
--  led_blue <= button(1);

  led <= data(7 downto 4) when switch(0) = '0' else data(3 downto 0);

  -- ps2keyboard: entity work.ps2_keyboard
  --   generic map(125_000_000, 8)
  --   port map(
  --     clock,
  --     ps2_clock,
  --     ps2_data,
  --     isNewData,
  --     unsigned(ps2_code) => data);
      
 
  
  -- ps2Controller: entity ps2.PS2Controller
  --   port map(
  --     clock => clock,
  --     reset => button(0),
  --     peripheral.clock => ps2_clock,
  --     peripheral.data => ps2_data,
  --     data => data);
  
  -- ps2AdapterInstance: entity user.PS2Adapter
  --   port map(
  --     clock => clock,
  --     state => state,
  --     peripheral.clock => ps2_clock,
  --     peripheral.data => ps2_data,
  --     flag.isNewData => led_green,
  --     data => data);
  
end architecture;
