LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY alu IS PORT (                            -- 实体声明外部接口
    op: IN STD_LOGIC_VECTOR(3 DOWNTO 0);        -- 选择控制运算类型
    accD: IN STD_LOGIC_VECTOR(7 DOWNTO 0);      -- 累加器的8位数据
    dBus: IN STD_LOGIC_VECTOR(7 DOWNTO 0);      -- 数据总线用于运算
    result: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);   -- 结果的输出
    accZ: OUT STD_LOGIC
);
END alu;

ARCHITECTURE aluArch OF alu IS
BEGIN
    result <= (NOT accD) + "00000001" WHEN op = "0000" ELSE
        accD + dBus WHEN op = "0001" ELSE
        accD + "10000000" WHEN op = "0010" ELSE
        dBus + "10000000" WHEN op = "0011" ELSE
        (NOT accD) - "00000001" WHEN op = "0100" ELSE
        accD - dBus WHEN op = "0101" ELSE
        (accD * dBus)(7 DOWNTO 0) WHEN op = "0110" ELSE -- 乘法结果位数是两个相加，但是输出为 8 位，截断一下
        (accD * (NOT dBus))(7 DOWNTO 0) WHEN op = "0111" ELSE
        accD AND dBus WHEN op = "1010" ELSE
        accD NAND dBus WHEN op = "1011" ELSE
        accD OR dBus WHEN op = "1100" ELSE
        accD NOR dBus WHEN op = "1101" ELSE
        accD XNOR dBus WHEN op = "1110" ELSE
        NOT accD WHEN op = "1111" ELSE
        "00000000";

    accZ <= NOT (accD(0) OR accD(1) OR accD(2) OR accD(3) OR
        accD(4) OR accD(5) OR accD(6) OR accD(7));
END aluArch;
