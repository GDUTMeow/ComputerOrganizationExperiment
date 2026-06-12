--程序计数器

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY PC IS
  PORT (
    clk, PCjmp, PCc1, PCinc, PCc3, reset : IN STD_LOGIC;--pcjmp 跳转信号，pcc1 清零信号，pcinc 自增信号，pcc3 MBR赋值信号
    CONTRalu : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    MBR_PC : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    PCout : BUFFER STD_LOGIC_VECTOR(7 DOWNTO 0));
END PC;
ARCHITECTURE behave OF PC IS
BEGIN
  PROCESS (clk)
  BEGIN
    IF (clk'event AND clk = '0') THEN
      IF reset = '1' THEN
        IF CONTRalu = "0101" THEN --跳转操作
          IF PCjmp = '1' THEN
            PCout <= MBR_PC;
          ELSIF PCjmp = '0' THEN
            PCout <= PCout + 1;
          END IF;
        END IF;
        IF PCc1 = '1' THEN
          PCout <= "00000000";
        END IF;
        IF PCinc = '1' THEN
          PCout <= PCout + 1;
        END IF;
        IF PCc3 = '1' THEN
          PCout <= MBR_PC;
        END IF;
      ELSE
        PCout <= "00000000";
      END IF;
    END IF;
  END PROCESS;
END behave;