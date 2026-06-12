--ALU

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.NUMERIC_STD.ALL;
ENTITY ALU IS
   PORT (
      clk, reset, ACCclear : IN STD_LOGIC;
      aluCONTR : IN STD_LOGIC_VECTOR(3 DOWNTO 0);--控制命令
      BR : IN STD_LOGIC_VECTOR(15 DOWNTO 0);--缓冲寄存器输入
      PCjmp : OUT STD_LOGIC;
      ACC : BUFFER STD_LOGIC_VECTOR(15 DOWNTO 0)); --buffer 可以输出，可以内部读取，但是不能从外部输入
END ALU;
ARCHITECTURE behave OF ALU IS
BEGIN
   PROCESS (clk)
   BEGIN
      IF (clk'event AND clk = '0') THEN
         IF reset = '0' THEN
            ACC <= x"0000"; --重置ACC
         ELSE
            IF ACCclear = '1' THEN
               ACC <= x"0000";
            END IF; --重置ACC
            IF aluCONTR = "0011" THEN
               ACC <= BR + ACC;
            END IF; --ADD
            IF aluCONTR = "0100" THEN
               ACC <= ACC - BR;
            END IF; --SUB
            IF aluCONTR = "0110" THEN
               ACC <= ACC AND BR;
            END IF; --AND
            IF aluCONTR = "0111" THEN
               ACC <= ACC OR BR;
            END IF; --OR
            IF aluCONTR = "1000" THEN
               ACC <= NOT ACC;
            END IF; --NOT
            IF aluCONTR = "1001" THEN --SRR 右移
               ACC(14 DOWNTO 0) <= ACC(15 DOWNTO 1);
               ACC(15) <= '0';
            END IF;
            IF aluCONTR = "1010" THEN --SRL 左移
               ACC(15 DOWNTO 1) <= ACC(14 DOWNTO 0);
               ACC(0) <= '0';
            END IF;
            IF aluCONTR = "1011" THEN
               ACC <= STD_LOGIC_VECTOR(to_unsigned((to_integer(unsigned(ACC)) * to_integer(unsigned(BR))), 16));
            END IF; --MPY乘
         END IF;
      END IF;
      IF ACC > 0 THEN
         PCjmp <= '1'; --转移
      ELSE
         PCjmp <= '0';
      END IF;
   END PROCESS;
END behave;