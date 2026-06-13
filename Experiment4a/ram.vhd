LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY ram IS PORT (
    r_w, en, reset: IN STD_LOGIC;
    aBus: IN STD_LOGIC_VECTOR(7 DOWNTO 0);      -- 数据总线输入
    dBus: INOUT STD_LOGIC_VECTOR(7 DOWNTO 0)
);
END ram;

ARCHITECTURE ramArch OF ram IS
    TYPE ram_typ IS ARRAY(0 TO 63) OF STD_LOGIC_VECTOR(7 DOWNTO 0);     -- 64 条指令，每条指令 8 位
    SIGNAL ram: ram_typ;
BEGIN
    PROCESS(en, reset, r_w, aBus, dBus) BEGIN
        IF reset = '1' THEN     -- Operand to address bus for finding the real operand with address
            -- ram(0) <= x"14";    -- OpCode = 1, Operand = 4
            -- ram(1) <= x"30";    -- OpCode = 3, Operand = 0
            -- ram(2) <= x"25";    -- OpCode = 2, Operand = 5
            -- ram(3) <= x"15";    -- OpCode = 1, Operand = 5
            -- ram(4) <= x"46";    -- OpCode = 4, Operand = 6
            -- ram(5) <= x"31";    -- OpCode = 3, Operand = 1
            -- ram(6) <= x"55";    -- OpCode = 5, Operand = 5
            -- ram(7) <= x"06";    -- OpCode = 0, Operand = 6
            -- ram(8) <= x"01";    -- OpCode = 0, Operand = 1
            
            -- 傻逼 Inter Quartus 不支持 08 标准以后的 VHDL 多行注释，不要直接贴
            ram(0) <= x"06";    -- Load [$6] => acc = 24
            ram(1) <= x"27";    -- [$6] + [$7] => 24 + 43 = 67
            ram(2) <= x"38";    -- acc - [$8] => 67 - 33 = 34
            ram(3) <= x"15";    -- Store [$5] <= 34
            ram(4) <= x"A1";    -- Halt
            ram(5) <= x"00";    -- Padding Empty
            ram(6) <= x"18";    -- 预存 24
            ram(7) <= x"2B";    -- 预存 43
            ram(8) <= x"21";    -- 预存 33
            

        ELSIF r_w = '0' THEN    -- rw = 0 写入模式，转为 int 类型写入
            ram(conv_integer(unsigned(aBus))) <= dBus;
        END IF;
    END PROCESS;

    dBus <= ram(conv_integer(unsigned(aBus)))
        WHEN reset = '0' AND en = '1' AND r_w = '1' ELSE
        "ZZZZZZZZ";
END ramArch;
