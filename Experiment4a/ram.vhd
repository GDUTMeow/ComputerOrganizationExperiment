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
    TYPE ram_typ IS ARRAY(0 TO 63) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL ram: ram_typ;
BEGIN
    PROCESS(en, reset, r_w, aBus, dBus) BEGIN
        IF reset = '1' THEN
            ram(0) <= x"14";
            ram(1) <= x"30";
            ram(2) <= x"25";
            ram(3) <= x"15";
            ram(4) <= x"46";
            ram(5) <= x"31";
            ram(6) <= x"55";
            ram(7) <= x"06";
            ram(8) <= x"01";
        ELSIF r_w = '0' THEN    -- rw = 0 写入模式，转为 int 类型写入
            ram(conv_integer(unsigned(aBus))) <= dBus;
        END IF;
    END PROCESS;

    dBus <= ram(conv_integer(unsigned(aBus)))
        WHEN reset = '0' AND en = '1' AND r_w = '1' ELSE
        "ZZZZZZZZ";
END ramArch;
