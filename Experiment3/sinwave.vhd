LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY SINGT IS     -- Signal Generator
    PORT (
        CLK: IN STD_LOGIC;              -- 时钟输入
        DOUT: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)     -- 8 位数据输出总线
    );
END;

ARCHITECTURE DACC OF SINGT IS
    COMPONENT data_rom PORT(    -- 调用数据存储器组件
        address: IN STD_LOGIC_VECTOR (5 DOWNTO 0); -- 6 位地址信号
        inclock: IN STD_LOGIC ;    -- 地址锁存时钟
        q: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)    -- 8 位数据输出总线
    );
    END COMPONENT;

SIGNAL Q1: STD_LOGIC_VECTOR (5 DOWNTO 0); BEGIN    -- 定义 6 位地址信号 Q1
    PROCESS(CLK) BEGIN  -- 根据时钟信号 CLK 的上升沿更新地址信号 Q1
        IF CLK 'EVENT AND CLK = '1' THEN    -- 当 CLK 信号发生上升沿时
            Q1 <= Q1 + 1;   -- Q1 + 1，变更地址信号，进而变更正弦波数值
        END IF;
    END PROCESS;
    u1: data_rom PORT MAP(
        address => Q1, 
        q => DOUT,
        inclock => CLK
    ); -- 实例化数据存储器组件，连接地址信号和输出数据
END;