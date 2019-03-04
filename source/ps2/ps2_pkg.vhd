library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package ps2_pkg is
  subtype Byte is unsigned(7 downto 0);
  constant break: Byte := x"F0";
  constant multi: Byte := x"E0";
  
  type Flag is record
    isNewData: std_logic;
  end record;
  
  type Peripheral is record
    clock: std_logic;
    data: std_logic;
  end record;
  
  type PS2Controller is record
    clock: std_logic;
    peripheral: Peripheral;
    flag: Flag;
    data: Byte;
  end record;
end package;
