LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY alu IS PORT (                            -- 实体声明外部接口
    op: IN STD_LOGIC_VECTOR(3 DOWNTO 0);        -- 选择控制运算类型
    accD: IN STD_LOGIC_VECTOR(7 DOWNTO 0);      -- 累加器的 8 位数据
    dBus: IN STD_LOGIC_VECTOR(7 DOWNTO 0);      -- 数据总线用于运算
    result: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);   -- 结果的输出
    accZ: OUT STD_LOGIC
);
END alu;

ARCHITECTURE aluArch OF alu IS BEGIN
    PROCESS (op, accD, dBus) 
        VARIABLE tmpResult: STD_LOGIC_VECTOR(15 DOWNTO 0); -- 用于存储乘法结果
    BEGIN
        CASE op IS
            WHEN "0000" => -- 加
                result <= accD + dBus;
                -- result <= (NOT accD) + "00000001";
            WHEN "0001" => -- 减
                -- result <= accD + dBus;
                result <= accD - dBus;
            WHEN "0010" => -- +128
                result <= accD + "10000000";
            WHEN "0011" => -- 总线 +128
                result <= dBus + "10000000";
            WHEN "0100" => -- 取反减一
                result <= (NOT accD) - "00000001";
            WHEN "0101" => -- 减法
                result <= accD - dBus;
            WHEN "0110" => -- 乘法
                tmpResult := (accD * dBus); -- 乘法会扩张到 16 位
                result <= tmpResult(7 DOWNTO 0); -- 取低 8 位作为结果
            WHEN "0111" => -- 累加器乘以数据总线的取反
                tmpResult := (accD * (NOT dBus));   -- 处理同上，懒得再写了
                result <= tmpResult(7 DOWNTO 0);
            WHEN "1010" => -- 位与
                result <= accD AND dBus;
            WHEN "1011" => -- 位与非
                result <= accD NAND dBus;
            WHEN "1100" => -- 位或
                result <= accD OR dBus;
            WHEN "1101" => -- 位或非
                result <= accD NOR dBus;
            WHEN "1110" => -- 位异或
                result <= accD XNOR dBus;
            WHEN "1111" => -- 位非
                result <= NOT accD;
            WHEN OTHERS =>
                result <= "00000000"; -- 默认输出为0
        END CASE;
    END PROCESS;

    accZ <= NOT (accD(0) OR accD(1) OR accD(2) OR accD(3) OR
        accD(4) OR accD(5) OR accD(6) OR accD(7));
END aluArch;
