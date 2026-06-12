LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
ENTITY RAM IS
  PORT (
    DATA : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    address : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    RW : IN STD_LOGIC;
    reset : IN STD_LOGIC;
    Q : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END RAM;
ARCHITECTURE ramArch OF ram IS
  TYPE ram_typ IS ARRAY(0 TO 255) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL ram : ram_typ;
BEGIN
  PROCESS (
    DATA, address, RW, reset
    ) BEGIN
    IF reset = '0' THEN --检测到复位信号时向RAM写入预设数据
      ram(0) <= x"022A";
      ram(1) <= x"032B";
      ram(2) <= x"012C";
      ram(3) <= x"0C00";
      ram(42) <= x"0016";
      ram(43) <= x"000A";

    ELSIF RW = '1' THEN --写入数据
      ram(conv_integer(unsigned(address))) <= DATA;
    END IF;
  END PROCESS;
  Q <= ram(conv_integer(unsigned(address))) --输出数据
    WHEN reset = '1' AND RW = '0' ELSE --当总线请求数据 状态为读 没有复位时输出数据
    "ZZZZZZZZZZZZZZZZ";
END ramArch;