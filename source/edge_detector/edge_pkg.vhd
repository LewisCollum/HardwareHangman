library ieee;
use ieee.std_logic_1164.all;

package edge_pkg is
  type Direction is (rising, falling);

  function directionToLogic(direction: Direction) return std_logic;
  
  type EdgeDetector is record
    clock: std_logic;
    reset: std_logic;
    direction: Direction;
    input: std_logic;
    output: std_logic;
  end record;

  type DualInputEdgeDetector is record
    clock: std_logic;
    reset: std_logic;
    direction: Direction;
    first: std_logic;
    second: std_logic;
    output: std_logic;
  end record;
  
end package;

package body edge_pkg is
  function directionToLogic(direction: Direction) return std_logic is
  begin
    case direction is
      when rising =>
        return '1';
      when falling =>
        return '0';
    end case;
  end function;
end package body;
