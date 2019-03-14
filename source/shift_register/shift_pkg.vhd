library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package shift_pkg is
  type SIPOShiftRegister is record
    clock: std_logic;
    reset: std_logic;
    input: std_logic;
    output: unsigned;
  end record;

  function flipBitOrder(signal input: in unsigned) return unsigned;
  
end package;

package body shift_pkg is
  function flipBitOrder(signal input: in unsigned) return unsigned is
    variable output: unsigned(input'length-1 downto 0);
  begin
    for i in output'range loop
      output(output'left-i) := input(i+input'right); 
    end loop;
    return output;
  end function;
end package body;
