--流寄存器
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY BR IS
     PORT (
          MBR_BRc : IN STD_LOGIC;--输入信号
          MBR_BR : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
          BRout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END BR;
ARCHITECTURE behave OF BR IS
BEGIN
     PROCESS (MBR_BRc)
     BEGIN
          IF MBR_BRc = '1' THEN
               BRout <= MBR_BR;
          END IF;
     END PROCESS;
END behave;