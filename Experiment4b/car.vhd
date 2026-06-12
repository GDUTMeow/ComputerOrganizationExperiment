
--控制地址寄存器
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY CAR IS
  PORT (
    clk, reset : IN STD_LOGIC;
    CARc : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    CAR, OP : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    CARout : BUFFER STD_LOGIC_VECTOR(7 DOWNTO 0));
END CAR;
ARCHITECTURE behave OF CAR IS
BEGIN
  PROCESS (clk)
  BEGIN
    IF (clk'event AND clk = '1') THEN
      IF reset = '1' THEN
        IF CARc = "1000" THEN
          CARout <= "00000000";
        END IF;--CAR清零
        IF CARc = "0100" THEN
          CARout <= OP + CARout;
        END IF;--CAR+某个数
        IF CARc = "0010" THEN
          CARout <= CAR;
        END IF;--从外界输入CAR
        IF CARc = "0001" THEN
          CARout <= CARout + 1;
        END IF;--CAR自增
      ELSE
        CARout <= "00000000";
      END IF;
    END IF;
  END PROCESS;
END behave;