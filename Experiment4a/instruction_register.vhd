LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY instruction_register IS PORT (           -- 声明实体外部接口
    clk, en_A, en_D, ld, reset: IN STD_LOGIC;
    aBus: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);     -- 数据总线输出
    dBus: INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    load, store, add, sub, mul, div, andd, orr, nott, neg, halt, branch: OUT STD_LOGIC
);
END instruction_register;

ARCHITECTURE irArch OF instruction_register IS
    SIGNAL irReg: STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
    PROCESS(clk) BEGIN
        IF clk'event AND clk = '0' THEN        -- load on falling edge
            IF reset = '1' THEN
                irReg <= "00000000";
            ELSIF ld = '1' THEN
                irReg <= dBus;
            END IF;
        END IF;
    END PROCESS;

    aBus <= "0000" & irReg(3 DOWNTO 0) WHEN en_A = '1' ELSE
        "ZZZZZZZZ";
    dBus <= "0000" & irReg(3 DOWNTO 0) WHEN en_D = '1' ELSE
        "ZZZZZZZZ";

    load    <= '1' WHEN irReg(7 DOWNTO 4) = "0000" ELSE '0';
    store   <= '1' WHEN irReg(7 DOWNTO 4) = "0001" ELSE '0';
    add     <= '1' WHEN irReg(7 DOWNTO 4) = "0010" ELSE '0';
    sub     <= '1' WHEN irReg(7 DOWNTO 4) = "0011" ELSE '0';
    mul     <= '1' WHEN irReg(7 DOWNTO 4) = "0100" ELSE '0';
    div     <= '1' WHEN irReg(7 DOWNTO 4) = "0101" ELSE '0';
    neg     <= '1' WHEN irReg = "0110" & "0000" ELSE '0';
    andd    <= '1' WHEN irReg(7 DOWNTO 4) = "0111" ELSE '0';
    orr     <= '1' WHEN irReg(7 DOWNTO 4) = "1000" ELSE '0';
    nott    <= '1' WHEN irReg(7 DOWNTO 4) = "1001" ELSE '0';
    halt    <= '1' WHEN irReg = "1010" & "0001" ELSE '0';
    branch  <= '1' WHEN irReg(7 DOWNTO 4) = "1011" ELSE '0';
END irArch;
