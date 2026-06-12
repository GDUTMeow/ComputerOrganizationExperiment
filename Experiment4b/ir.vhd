--指令寄存器 用于暂存指令
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY IR IS
    PORT (
        opcode : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        IRout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END IR;
ARCHITECTURE behave OF IR IS
BEGIN
    IRout <= opcode;
END behave;