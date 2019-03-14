library ieee, ps2;
use ieee.std_logic_1164.all;
use ps2.ps2_pkg;

package user_pkg is
  type PlayingState is (guessing, guessed, wrong, correct);
  type ResultingState is (loss, win);
  type SystemState is (initializing, waiting, playing, resulting, done);
  
  type State is record
    system: SystemState;
    play: PlayingState;
    result: ResultingState;
  end record;

  type FlagPS2Adapter is record
    internal: ps2_pkg.FlagInternal;
    isNewGame: std_logic;
  end record;
  
  type FlagInternal is record
    ps2: FlagPS2Adapter;
  end record;

end package;
