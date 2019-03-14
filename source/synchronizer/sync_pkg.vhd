library ieee;
use ieee.std_logic_1164.all;

package sync_pkg is
  type Synchronizer is record
    clock: std_logic;
    input: std_logic;
    output: std_logic;
  end record;
end package;
