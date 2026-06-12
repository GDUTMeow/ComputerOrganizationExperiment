--内存流寄存器
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY MBR IS
  PORT (
    clk, reset, MBR_OPc, ACC_MBRc, R, W : IN STD_LOGIC;
    ACC_MBR : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    RAM_MBR : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    MBR_RAM : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    MBR_BR : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    MBR_OP : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    MBR_MAR : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    MBR_PC : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END MBR;
ARCHITECTURE behave OF MBR IS
BEGIN
  PROCESS (clk)
    VARIABLE temp : STD_LOGIC_VECTOR(15 DOWNTO 0);
  BEGIN
    IF (clk'event AND clk = '0') THEN
      IF reset = '1' THEN--重置信号
        IF ACC_MBRc = '1' THEN
          temp := ACC_MBR;
        END IF;--ACC_MBR输入到变量
        IF R = '1' THEN
          MBR_BR <= RAM_MBR;
        END IF;--读
        IF W = '1' THEN
          MBR_RAM <= temp;
        END IF;--写
        MBR_MAR <= RAM_MBR(7 DOWNTO 0);
        MBR_PC <= RAM_MBR(7 DOWNTO 0);
        IF MBR_OPc = '1' THEN
          MBR_OP <= RAM_MBR(15 DOWNTO 8);
        END IF;
      ELSE
        MBR_BR <= x"0000";
        MBR_MAR <= "00000000";
        MBR_OP <= "00000000";
        MBR_PC <= "00000000";
      END IF;
    END IF;
  END PROCESS;
END behave;