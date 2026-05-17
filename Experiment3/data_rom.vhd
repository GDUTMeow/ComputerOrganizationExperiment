LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
LIBRARY ALTERA_MF;    -- Altera MegaFunction
USE ALTERA_MF.ALTERA_MF_COMPONENTS.ALL;

ENTITY data_rom IS PORT (
        address: IN STD_LOGIC_VECTOR (5 DOWNTO 0);
        inclock: IN STD_LOGIC ;
        q: OUT STD_LOGIC_VECTOR (7 DOWNTO 0) 
    );
END data_rom;

ARCHITECTURE SYN OF data_rom IS
    SIGNAL sub_wire0  : STD_LOGIC_VECTOR (7 DOWNTO 0);
    COMPONENT altsyncram
        GENERIC (
            intended_device_family: STRING;
            width_a: NATURAL;
            widthad_a: NATURAL;
            numwords_a: NATURAL;
            operation_mode: STRING;
            outdata_reg_a: STRING;
            address_aclr_a: STRING;
            outdata_aclr_a: STRING;
            width_byteena_a: NATURAL;
            init_file: STRING;
            lpm_hint: STRING;
            lpm_type: STRING
        );
    PORT (
        clock0: IN STD_LOGIC;
        address_a: IN STD_LOGIC_VECTOR (5 DOWNTO 0);
        q_a: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
        );
    END COMPONENT; BEGIN
        q <= sub_wire0(7 DOWNTO 0);
        altsyncram_component: altsyncram
        GENERIC MAP (
            intended_device_family => "Cyclone", -- 参数传递映射
            width_a => 8,       -- 数据线宽度
            widthad_a => 6,     -- 地址线宽度 6
            numwords_a => 64,   -- 数据数量 64
            operation_mode => "ROM",            -- LPM 模式 ROM
            outdata_reg_a => "UNREGISTERED",    -- 输出无锁存
            address_aclr_a => "NONE",           -- 无异步地址清 0
            outdata_aclr_a => "NONE",           -- 无输出锁存异步清 0
            width_byteena_a => 1,               -- byteena_a 输入口宽度 1
            init_file => "./sinwave.hex", -- ROM 初始化数据
            lpm_hint => "ENABLE_RUNTIME_MOD=YES, INSTANCE_NAME=NONE",
            lpm_type => "altsyncram" 
        )
    PORT MAP (
        clock0 => inclock,
        address_a => address,
        q_a => sub_wire0
    );
END SYN;