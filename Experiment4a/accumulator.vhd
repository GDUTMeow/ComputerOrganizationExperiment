LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY accumulator IS PORT (                    -- 声明外部实体接口
    clk, en_D, ld, selAlu, reset: IN STD_LOGIC; -- 时钟信号
    aluD: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    dBus: INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    q: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
);
END accumulator;

ARCHITECTURE accArch OF accumulator IS
    SIGNAL accReg: STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
    PROCESS(clk) BEGIN
        IF clk'event AND clk = '1' THEN
            IF reset = '1' THEN
                accReg <= "00000000";
            ELSIF ld = '1' AND selAlu = '1' THEN
                accReg <= aluD;
            ELSIF ld = '1' AND selAlu = '0' THEN
                accReg <= dBus;
            END IF;
        END IF;
    END PROCESS;

    dBus <= accReg WHEN en_D = '1' ELSE "ZZZZZZZZ";
    q <= accReg;
END accArch;
