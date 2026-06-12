LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
LIBRARY ALTERA_MF;
USE ALTERA_MF.ALTERA_MF_COMPONENTS.ALL;

ENTITY RAM IS
  PORT (
    clk : IN STD_LOGIC;
    DATA : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    address : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    RW : IN STD_LOGIC;
    reset : IN STD_LOGIC;
    Q : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END RAM;

ARCHITECTURE SYN OF ram IS
  SIGNAL ram_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
  COMPONENT altsyncram
    GENERIC (
      intended_device_family : STRING;
      width_a : NATURAL;
      widthad_a : NATURAL;
      numwords_a : NATURAL;
      operation_mode : STRING;
      outdata_reg_a : STRING;
      init_file : STRING;
      lpm_type : STRING
    );
    PORT (
      wren_a : IN STD_LOGIC;
      clock0 : IN STD_LOGIC;
      address_a : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      data_a : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      q_a : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
  END COMPONENT;
BEGIN
  altsyncram_component : altsyncram
  GENERIC MAP(
    intended_device_family => "Cyclone",
    width_a => 16,
    widthad_a => 8,
    numwords_a => 256,
    operation_mode => "SINGLE_PORT",
    outdata_reg_a => "UNREGISTERED",
    init_file => "ram2.mif",
    lpm_type => "altsyncram"
  )
  PORT MAP(
    wren_a => RW,
    clock0 => clk,
    address_a => address,
    data_a => DATA,
    q_a => ram_out
  );

  Q <= ram_out WHEN reset = '1' AND RW = '0' ELSE
    "ZZZZZZZZZZZZZZZZ";
END SYN;