library ieee;
use ieee.std_logic_1164.all, ieee.numeric_std.all;

package serial_util is
  procedure sendBitOnRisingEdgeOfClock(
    constant dataToSend: in std_logic;
    signal data, clock: out std_logic;
    constant period: time);

  procedure sendStreamWithParityOnRisingEdgeOfClock(
    constant dataToSend: in unsigned;
    signal data, clock: out std_logic;
    constant period: time);  
end package;

package body serial_util is
  procedure sendBitOnRisingEdgeOfClock(
    constant dataToSend: in std_logic;
    signal data, clock: out std_logic;
    constant period: time) is
  begin
    clock <= '1';
    data <= dataToSend;        
    wait for period/2;
    clock <= '0';
    wait for period/2;
  end procedure;

  procedure sendStreamWithParityOnRisingEdgeOfClock(
    constant dataToSend: in unsigned;
    signal data, clock: out std_logic;
    constant period: time) is
    
    variable sum: integer := 0;
    variable parity: std_logic;
    constant start: std_logic := '0';
    constant stop: std_logic := '1';
  begin
    serial_util.sendBitOnRisingEdgeOfClock(start, data, clock, period);

    for i in dataToSend'range loop
      serial_util.sendBitOnRisingEdgeOfClock(dataToSend(i), data, clock, period);
      sum := sum + 1 when dataToSend(i) = '1';
    end loop;
    parity := to_unsigned(sum, 1)(0);

    serial_util.sendBitOnRisingEdgeOfClock(parity, data, clock, period);
    serial_util.sendBitOnRisingEdgeOfClock(stop, data, clock, period);
  end procedure;
end package body;
