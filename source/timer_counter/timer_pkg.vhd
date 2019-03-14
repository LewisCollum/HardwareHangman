library ieee;
use ieee.std_logic_1164.all;

package timer_pkg is
  type TimerCounter is record
    clock: std_logic;
    reset: std_logic;
    isDone: std_logic;
  end record;
end package;
