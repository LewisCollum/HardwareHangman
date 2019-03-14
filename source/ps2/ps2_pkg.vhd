library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package ps2_pkg is
  subtype Byte is unsigned(7 downto 0);
  constant break: Byte := x"F0";
  constant multi: Byte := x"E0";

  constant startLength: positive := 1;
  constant stopLength: positive := 1;
  constant parityLength: positive := 1;
  constant totalTransmitLength: positive := startLength + Byte'length + parityLength + stopLength;
  subtype Code is unsigned(totalTransmitLength-1 downto 0);
  subtype CodeByteRange is natural range totalTransmitLength-1 - startLength
    downto totalTransmitLength-1 - Byte'length;
  
  type FlagInternal is record
    isNewData: std_logic;
    isBitCounterDone: std_logic;
    isReadyToFetch: std_logic;
    isReadyToStore: std_logic;
  end record;

  type FlagExternal is record
    isNewData: std_logic;
  end record;

  type FlagPeripheralClock is record
    isRising: std_logic;
    isFalling: std_logic;
  end record;

  type FlagPeripheralData is record
    isNewData: std_logic;
  end record;
  
  type Peripheral is record
    clock: std_logic;
    data: std_logic;
  end record;
  
  type PS2Controller is record
    clock: std_logic;
    reset: std_logic;
    peripheral: Peripheral;
    flag: FlagExternal;
    data: Byte;
  end record;

  type State is (initializing, starting, ready, fetching, storing);
end package;
