package user_pkg is
  type PlayingState is (guessing, guessed, wrong, correct);
  type ResultingState is (loss, win);
  type SystemState is (initializing, waiting, playing, resulting, done);
  
  type State is record
    system: SystemState;
    play: PlayingState;
    result: ResultingState;
  end record;
end package;
