library ieee, ps2;
use ps2.ps2_pkg;
use ieee.std_logic_1164.all;

package adapter_pkg is
  type PS2State is (ready, parse);
  type PS2Adapter is record
    clock: std_logic;
    reset: std_logic;
    peripheral: ps2_pkg.Peripheral;
    data: ps2_pkg.Byte;
  end record;
end package;
