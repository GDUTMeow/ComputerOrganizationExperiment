
--内存地址寄存器

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY MAR IS
  PORT (
    clk, PC_MARc, MBR_MARc : IN STD_LOGIC;
    PC, MBR_MAR : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    MARout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END MAR;
ARCHITECTURE behave OF MAR IS
BEGIN
  PROCESS (clk)
  BEGIN
    IF (clk'event AND clk = '1') THEN
      IF PC_MARc = '1' THEN
        MARout <= PC;
      END IF;--PC请求时输入PC
      IF MBR_MARc = '1' THEN
        MARout <= MBR_MAR;
      END IF;--MBR请求时输入MBR
    END IF;
  END PROCESS;
END behave;