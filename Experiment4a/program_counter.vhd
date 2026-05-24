LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY program_counter IS PORT (
    clk, en_A, ld, inc, reset: IN STD_LOGIC;
    aBus: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);     -- 数据总线输出
    dBus: IN STD_LOGIC_VECTOR(7 DOWNTO 0)       -- 数据总线输入
);
END program_counter;

ARCHITECTURE pcArch OF program_counter IS
    SIGNAL pcReg: STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
    PROCESS(clk) BEGIN
        IF clk'event AND clk = '1' THEN
            IF reset = '1' THEN
                pcReg <= "00000000";
            ELSIF ld = '1' THEN
                pcReg <= dBus;
            ELSIF inc = '1' THEN
                pcReg <= pcReg + "00000001";
            END IF;
        END IF;
    END PROCESS;

    aBus <= pcReg WHEN en_A = '1' ELSE "ZZZZZZZZ";
END pcArch;
