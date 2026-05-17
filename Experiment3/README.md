# 实验目标

题目要求根据给定的六位计数器，利用已有的 64 采样点正弦波数据，依时序生成正弦波数据并给定 8 位 DA 总线输出

## 题目分析

题目给出了六位计数器、存储器读取和对应的正弦波生成器顶层设计

因此，我们需要将它们尽量穿起来，并且设定一个存储器，用于存储对应的正弦波数据后，根据 6 位计数器提供的数字，选择位于对应位置的数据

由题目中我们还可以看到，因为是 6 位计数器，所以我们需要 64 个数据存储位置，并且由于数据取到了 255（0b11111111），所以数据位数应该设置为 8

## 功能分析

本题需要实现时序计数功能和存储器读取功能，时序计数功能主要用于存储器内数据的选定，存储器读取功能则用于将数据从已有的数据文件中读取出来并给到输出

## 数字逻辑实现

在数字逻辑上，6 位输出计数器的逻辑表达式有

- $Q_0 = \lnot Q_0$
- $Q_1 = Q_1 ⊕ Q_0$
- $Q_2 = Q_2 ⊕ (Q_1 \land Q_0)$
- ...
- $Q_5 = Q_5 ⊕ (Q_4 \land ... \land Q_0)$

以此实现了计数器的功能，而我们最终的八位输出 DOUT 有

- $DOUT = WAVEDATA [Q_5...Q_0]$

从而实现了从数据存储中选择对应的数据输出的功能

## 数据表

我们可以得到以下的 64 点正弦波数据

| 地址 | +0   | +1   | +2   | +3   | +4   | +5   | +6   | +7   |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| 0    | 255  | 254  | 252  | 249  | 245  | 239  | 233  | 225  |
| 8    | 217  | 207  | 197  | 186  | 174  | 162  | 150  | 137  |
| 16   | 124  | 112  | 99   | 87   | 75   | 64   | 53   | 43   |
| 24   | 34   | 26   | 19   | 13   | 8    | 4    | 1    | 0    |
| 32   | 0    | 1    | 4    | 8    | 13   | 19   | 26   | 34   |
| 40   | 43   | 53   | 64   | 75   | 87   | 99   | 112  | 124  |
| 48   | 137  | 150  | 162  | 174  | 186  | 197  | 207  | 217  |
| 56   | 225  | 233  | 239  | 245  | 249  | 252  | 254  | 255  |


# VHD 代码

### 数据选择器 data_rom.vhd

```verilog
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
```

### 正弦波发生器

```verilog
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
        inclock: IN STD_LOGIC;    -- 地址锁存时钟
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
```

# 电路图

![](./img/CleanShot%202026-05-17%20at%2010.24.29@2x.png)

# 验证

## 波形图

![](./img/CleanShot%202026-05-17%20at%2010.25.10@2x.png)

对组件进行仿真，将 Q1 的输出和 DOUT 的输出转换为 Unsigned Decimal 便于阅读，可以发现，从 Q1=1 到 Q1=50，与我们上方数据表的内容相符，以下面几组数据为例

- Q1 = 0b001010 = 10，此时 DOUT = 207
- Q1 = 0b010111 = 23，此时 DOUT = 53
- Q1 = 0b100100 = 36，此时 DOUT = 8
- Q1 = 0b101101 = 45，此时 DOUT = 87
- Q1 = 0b110111 = 55，此时 DOUT = 207

综上，实验的结果与预期相符
