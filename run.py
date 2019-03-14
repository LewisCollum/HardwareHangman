import os.path
from vunit import VUnit

ui = VUnit.from_argv()
root = os.path.dirname(__file__)
source = os.path.join(root, "source")
libraries = dict.fromkeys([
    "user",
    "ps2",
    "debouncer",
    "enabler",
    "timer_counter",
    "shift_register",
    "testing",
    "edge_detector",
    "synchronizer",
    "flip_flop",
    "uart"
])

board = ui.add_library("zyboz7");
board.add_source_files(os.path.join("zyboz7", "*.vhd"))
                       
for name, library in libraries.items():
    library = ui.add_library(name);
    library.add_source_files(os.path.join(source, name, "*.vhd"), allow_empty = True)

ui.main()
    
    
