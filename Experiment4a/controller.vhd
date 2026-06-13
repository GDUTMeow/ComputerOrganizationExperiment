LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY controller IS PORT (                     -- 声明实体外部接口
    clk, reset: IN STD_LOGIC;
    mem_enD, mem_rw: OUT STD_LOGIC;
    pc_enA, pc_ld, pc_inc: OUT STD_LOGIC;
    ir_enA, ir_enD, ir_ld: OUT STD_LOGIC;
    ir_load, ir_store, ir_add: IN STD_LOGIC;
    ir_sub, ir_mul, ir_div: IN STD_LOGIC;
    ir_and, ir_or, ir_not: IN STD_LOGIC;
    ir_neg, ir_halt, ir_branch: IN STD_LOGIC;
    acc_enD, acc_ld, acc_selAlu: OUT STD_LOGIC;
    alu_op: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    state_out: OUT STD_LOGIC_VECTOR(4 DOWNTO 0) -- 输出当前状态，便于调试
);
END controller;

ARCHITECTURE controllerArch OF controller IS
    TYPE state_type IS (
        reset_state,
        fetch0, fetch1,
        load0, load1,
        store0, store1,
        add0, add1,
        sub0, sub1,
        mul0, mul1,
        div0, div1,
        and0, and1,
        or0, or1,
        not0, not1,
        negate0, negate1,
        halt,
        branch0, branch1
    );
    SIGNAL state: state_type;
BEGIN
    PROCESS(clk) BEGIN
        IF clk'event AND clk = '1' THEN
            IF reset = '1' THEN
                state <= reset_state;
            ELSE
                CASE state IS
                    WHEN reset_state => state <= fetch0;
                    WHEN fetch0 => state <= fetch1;
                    WHEN fetch1 =>
                        IF ir_load = '1' THEN state <= load0;
                        ELSIF ir_store = '1' THEN state <= store0;
                        ELSIF ir_add = '1' THEN state <= add0;
                        ELSIF ir_sub = '1' THEN state <= sub0;
                        ELSIF ir_mul = '1' THEN state <= mul0;
                        ELSIF ir_div = '1' THEN state <= div0;
                        ELSIF ir_and = '1' THEN state <= and0;
                        ELSIF ir_or = '1' THEN state <= or0;
                        ELSIF ir_not = '1' THEN state <= not0;
                        ELSIF ir_neg = '1' THEN state <= negate0;
                        ELSIF ir_halt = '1' THEN state <= halt;
                        ELSIF ir_branch = '1' THEN state <= branch0;
                        END IF;
                    WHEN load0 => state <= load1;
                    WHEN load1 => state <= fetch0;
                    WHEN store0 => state <= store1;
                    WHEN store1 => state <= fetch0;
                    WHEN add0 => state <= add1;
                    WHEN add1 => state <= fetch0;
                    WHEN sub0 => state <= sub1;
                    WHEN sub1 => state <= fetch0;
                    WHEN mul0 => state <= mul1;
                    WHEN mul1 => state <= fetch0;
                    WHEN div0 => state <= div1;
                    WHEN div1 => state <= fetch0;
                    WHEN and0 => state <= and1;
                    WHEN and1 => state <= fetch0;
                    WHEN or0 => state <= or1;
                    WHEN or1 => state <= fetch0;
                    WHEN not0 => state <= not1;
                    WHEN not1 => state <= fetch0;
                    WHEN negate0 => state <= negate1;
                    WHEN negate1 => state <= fetch0;
                    WHEN halt => state <= halt;
                    WHEN branch0 => state <= branch1;
                    WHEN branch1 => state <= fetch0;
                    WHEN OTHERS => state <= halt;
                END CASE;
            END IF;
        END IF;
    END PROCESS;

    PROCESS(clk) BEGIN                          -- special process for memory write timing
        IF clk'event AND clk = '0' THEN
            IF state = store0 THEN
                mem_rw <= '0';
            ELSE
                mem_rw <= '1';
            END IF;
        END IF;
    END PROCESS;

    state_out <= 
        "00000" WHEN state = reset_state ELSE   -- 0 -> reset_state
        "00001" WHEN state = fetch0 ELSE        -- 1 -> fetch0
        "00010" WHEN state = fetch1 ELSE        -- 2 -> fetch1
        "00011" WHEN state = load0 ELSE         -- 3 -> load0
        "00100" WHEN state = load1 ELSE         -- 4 -> load1
        "00101" WHEN state = store0 ELSE        -- 5 -> store0
        "00110" WHEN state = store1 ELSE        -- 6 -> store1
        "00111" WHEN state = add0 ELSE          -- 7 -> add0
        "01000" WHEN state = add1 ELSE          -- 8 -> add1
        "01001" WHEN state = sub0 ELSE          -- 9 -> sub0
        "01010" WHEN state = sub1 ELSE          -- A -> sub1
        "01111" WHEN state = halt ELSE          -- F -> halt
        "11111";        -- 31 -> Invalid state

    mem_enD <= '1' WHEN state = fetch0 OR state = fetch1 OR
        state = load0 OR state = load1 OR
        state = add0 OR state = add1 OR
        state = sub0 OR state = sub1 OR
        state = mul0 OR state = mul1 OR
        state = div0 OR state = div1 OR
        state = and0 OR state = and1 OR
        state = or0 OR state = or1 ELSE '0';

    pc_enA <= '1' WHEN state = fetch0 OR state = fetch1 ELSE '0';
    pc_ld <= '1' WHEN state = branch0 ELSE '0';
    pc_inc <= '1' WHEN state = fetch1 ELSE '0';

    ir_enA <= '1' WHEN state = load0 OR state = load1 OR
        state = store0 OR state = store1 OR
        state = add0 OR state = add1 OR
        state = sub0 OR state = sub1 OR
        state = mul0 OR state = mul1 OR
        state = div0 OR state = div1 OR
        state = and0 OR state = and1 OR
        state = or0 OR state = or1 ELSE '0';
    ir_enD <= '1' WHEN state = branch0 ELSE '0';
    ir_ld <= '1' WHEN state = fetch1 ELSE '0';

    acc_enD <= '1' WHEN state = store0 OR state = store1 ELSE '0';
    acc_ld <= '1' WHEN state = load1 OR state = add1 OR state = negate1 OR
        state = sub1 OR state = mul1 OR state = div1 OR
        state = not1 OR state = or1 ELSE '0';

    acc_selAlu <= '1' WHEN state = add1 OR state = negate1 OR state = sub1 OR
        state = mul1 OR state = div1 OR state = not1 OR
        state = or1 ELSE '0';

    alu_op <= "0000" WHEN state = add0 OR state = add1 ELSE
        "0001" WHEN state = sub0 OR state = sub1 ELSE
        "0010" WHEN state = mul0 OR state = mul1 ELSE
        "0011" WHEN state = div0 OR state = div1 ELSE
        "0100" WHEN state = negate0 OR state = negate1 ELSE
        "0101" WHEN state = and0 OR state = and1 ELSE
        "0110" WHEN state = or0 OR state = or1;
    END controllerArch;
