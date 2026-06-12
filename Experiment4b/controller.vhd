
--微程序控制器
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY CONTROLR IS
     PORT (
          control : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
          R, W, RW, PCc1, PCinc, PCc3 : OUT STD_LOGIC;
          ACCclear, MBR_MARc, PC_MARc : OUT STD_LOGIC;
          ACC_MBRc, MBR_OPc, MBR_BRc : OUT STD_LOGIC;
          CONTRout : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
          CARc : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
          CAR : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END CONTROLR;
ARCHITECTURE behave OF CONTROLR IS
BEGIN
     PROCESS (control)
     BEGIN --分解32位Control输入
          CAR <= control(7 DOWNTO 0);
          PCc1 <= control(8);
          PCinc <= control(9);
          PCc3 <= control(10);
          ACCclear <= control(11);
          CONTRout <= control(15 DOWNTO 12);
          R <= control(16);
          W <= control(17);
          MBR_MARc <= control(18);
          PC_MARc <= control(19);
          ACC_MBRc <= control(20);
          MBR_OPc <= control(21);
          MBR_BRc <= control(22);
          CARc <= control(26 DOWNTO 23);
          RW <= control(17);
     END PROCESS;
END behave;