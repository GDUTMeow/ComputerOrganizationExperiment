LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY top_level IS PORT (                      -- 声明实体外部接口
    clk, reset: IN STD_LOGIC;
    abusX: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);    -- 数据总线输出
    dbusX: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    mem_enDX, mem_rwX: OUT STD_LOGIC;
    pc_enAX, pc_ldX, pc_incX: OUT STD_LOGIC;
    ir_enAX, ir_enDX, ir_ldX: OUT STD_LOGIC;
    acc_enDX, acc_ldX, acc_selAluX: OUT STD_LOGIC;
    acc_QX: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    alu_accZX: OUT STD_LOGIC;∏
    alu_opX: OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
);
END top_level;

ARCHITECTURE topArch OF top_level IS
    COMPONENT program_counter PORT (
        -- 时钟信号、使能信号、加载信号、自增信号、复位信号 = program_counter.clk .en_A .ld .inc .reset
        clk, en_A, ld, inc, reset: IN STD_LOGIC;
        aBus: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        dBus: IN STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
    END COMPONENT;

    COMPONENT instruction_register PORT (
        -- 时钟信号、双使能信号、加载信号、复位信号 = instruction_register.clk .en_A .en_D .ld .reset
        clk, en_A, en_D, ld, reset: IN STD_LOGIC;
        aBus: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        dBus: INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        load, store, add, sub, mul, div, neg, andd, orr, nott, halt, branch: OUT STD_LOGIC
    );
    END COMPONENT;

    COMPONENT accumulator PORT (
        -- 时钟信号、使能信号、加载信号、ALU 选择信号、复位信号 = accumulator.clk .en_D .ld .selAlu .reset
        clk, en_D, ld, selAlu, reset: IN STD_LOGIC;
        aluD: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        dBus: INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        q: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
    END COMPONENT;

    COMPONENT alu PORT (
        -- 运算类型、累加器输入、数据总线输入、运算结果输出、零标志输出 = alu.op .accD .dBus .result .accZ
        op: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        accD: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        dBus: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        result: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        accZ: OUT STD_LOGIC
    );
    END COMPONENT;

    COMPONENT ram PORT (
        -- 读写模式、使能信号、复位信号 = ram.r_w .ram_enD .reset
        r_w, en, reset: IN STD_LOGIC;
        aBus: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        dBus: INOUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
    END COMPONENT;

    COMPONENT controller PORT (
        clk, reset: IN STD_LOGIC;   -- 时钟信号、复位信号
        mem_enD, mem_rw: OUT STD_LOGIC;     -- 内存使能信号、内存读写信号
        pc_enA, pc_ld, pc_inc: OUT STD_LOGIC;   -- 程序计数器使能信号、程序计数器加载信号、程序计数器自增信号
        ir_enA, ir_enD, ir_ld: OUT STD_LOGIC;   -- 指令寄存器使能信号A、指令寄存器使能信号D、指令寄存器加载信号
        ir_load, ir_store, ir_add: IN STD_LOGIC;    -- 指令寄存器加载指令、存储指令、加法指令
        ir_sub, ir_mul, ir_div: IN STD_LOGIC;   -- 指令寄存器减法指令、乘法指令、除法指令
        ir_and, ir_or, ir_not: IN STD_LOGIC;    -- 指令寄存器与指令、或指令、非指令
        ir_neg, ir_halt, ir_branch: IN STD_LOGIC;   -- 指令寄存器取反指令、停止指令、分支指令
        acc_enD, acc_ld, acc_selAlu: OUT STD_LOGIC;     -- 累加器使能信号、累加器加载信号、累加器 ALU 选择信号
        alu_op: OUT STD_LOGIC_VECTOR(2 DOWNTO 0)    -- ALU 运算类型输出
    );
    END COMPONENT;

    SIGNAL abus: STD_LOGIC_VECTOR(7 DOWNTO 0);  -- 地址总线
    SIGNAL dbus: STD_LOGIC_VECTOR(7 DOWNTO 0);  -- 数据总线
    SIGNAL mem_enD, mem_rw: STD_LOGIC;  -- 内存使能信号、内存读写信号
    SIGNAL pc_enA, pc_ld, pc_inc: STD_LOGIC;    -- 程序计数器使能信号、程序计数器加载信号、程序计数器自增信号
    SIGNAL ir_enA, ir_enD, ir_ld: STD_LOGIC;    -- 指令寄存器使能信号A、指令寄存器使能信号D、指令寄存器加载信号
    SIGNAL ir_load, ir_store, ir_add: STD_LOGIC;    -- 指令寄存器加载指令、存储指令、加法指令
    SIGNAL ir_sub, ir_mul, ir_div: STD_LOGIC;   -- 指令寄存器减法指令、乘法指令、除法指令
    SIGNAL ir_and, ir_or, ir_not: STD_LOGIC;    -- 指令寄存器与指令、或指令、非指令
    SIGNAL ir_negate, ir_halt, ir_branch: STD_LOGIC;    -- 指令寄存器取反指令、停止指令、分支指令
    SIGNAL acc_enD, acc_ld, acc_selAlu: STD_LOGIC;   -- 累加器使能信号、累加器加载信号、累加器 ALU 选择信号
    SIGNAL acc_Q: STD_LOGIC_VECTOR(7 DOWNTO 0); -- 累加器输出
    SIGNAL alu_op: STD_LOGIC_VECTOR(2 DOWNTO 0);  -- ALU 运算类型输出
    SIGNAL alu_accZ: STD_LOGIC; -- ALU 零标志输出
    SIGNAL alu_result: STD_LOGIC_VECTOR(7 DOWNTO 0);    -- ALU 运算结果输出
BEGIN
    pc: program_counter PORT MAP(clk, pc_enA, pc_ld, pc_inc, reset, abus, dbus);
    ir: instruction_register PORT MAP(clk, ir_enA, ir_enD, ir_ld, reset, abus, dbus,
        ir_load, ir_store, ir_add, ir_sub, ir_mul, ir_div,
        ir_and, ir_or, ir_not, ir_negate, ir_halt, ir_branch);
    acc: accumulator PORT MAP(clk, acc_enD, acc_ld, acc_selAlu, reset, alu_result, dbus, acc_Q);
    aluu: alu PORT MAP(alu_op, acc_Q, dbus, alu_result, alu_accZ);
    mem: ram PORT MAP(mem_rw, mem_enD, reset, abus, dbus);
    ctl: controller PORT MAP(
        clk, reset, mem_enD, mem_rw, pc_enA, pc_ld, pc_inc,
        ir_enA, ir_enD, ir_ld, ir_load, ir_store, ir_add, ir_sub,
        ir_mul, ir_div, ir_and, ir_or, ir_not,
        ir_negate, ir_halt, ir_branch, acc_enD,
        acc_ld, acc_selAlu, alu_op
    );

    abusX <= abus;
    dbusX <= dbus;
    mem_enDX <= mem_enD;
    mem_rwX <= mem_rw;
    pc_enAX <= pc_enA;
    pc_ldX <= pc_ld;
    pc_incX <= pc_inc;
    ir_enAX <= ir_enA;
    ir_enDX <= ir_enD;
    ir_ldX <= ir_ld;
    acc_enDX <= acc_enD;
    acc_ldX <= acc_ld;
    acc_selAluX <= acc_selAlu;
    acc_QX <= acc_Q;
    alu_opX <= alu_op;
    alu_accZX <= alu_accZ;
END topArch;
