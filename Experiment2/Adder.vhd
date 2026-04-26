LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Adder IS PORT (
    ain, bin, cin: IN STD_LOGIC;
    cout, sum: OUT STD_LOGIC
    );
END ENTITY Adder;

ARCHITECTURE FullAdder OF FullAdder IS
    COMPONENT h_adder PORT (    -- 新建半加器组件
        a, b: IN STD_LOGIC;
        co, so: OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT or2a PORT (   -- 新建或门组件
        a, b: IN STD_LOGIC;
        c: OUT STD_LOGIC
        );
    END COMPONENT;

SIGNAL d, e, f: STD_LOGIC; BEGIN    --定义3个信号作为内部的连接线
    u1: h_adder PORT MAP(a=>ain, b=>bin, co=>d, so=>e);  -- 实例化第一个半加器，连接输入和中间信号
    u2: h_adder PORT MAP(a=>e, b=>cin, co=>f, so=>sum);  -- 实例化第二个半加器，连接第一个半加器的和输出和进位输入
    u3: or2a    PORT MAP(a=>d, b=>f, c=>cout);     -- 实例化或门，连接两个半加器的进位输出，得到最终的进位输出
END ARCHITECTURE FullAdder;