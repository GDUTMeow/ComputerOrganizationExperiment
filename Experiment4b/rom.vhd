LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
ENTITY ROM IS
	PORT (
		address : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		Q : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END ROM;
ARCHITECTURE romArch OF rom IS
	TYPE rom_typ IS ARRAY(0 TO 255) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL rom : rom_typ;
BEGIN

	rom(0) <= x"00810000";
	rom(1) <= x"00A00000";
	rom(2) <= x"02000000";
	rom(3) <= x"01000014";
	rom(4) <= x"01000019";
	rom(5) <= x"0100001E";
	rom(6) <= x"01000023";
	rom(7) <= x"01000041";
	rom(8) <= x"01000028";
	rom(9) <= x"0100002D";
	rom(10) <= x"01000032";
	rom(11) <= x"01000037";
	rom(12) <= x"0100004B";
	rom(13) <= x"01000046";
	rom(14) <= x"0100004B";
	rom(15) <= x"00000000";

	rom(20) <= x"00840000";
	rom(21) <= x"00920200";
	rom(22) <= x"04080000";
	rom(23) <= x"00000000";
	rom(24) <= x"00000000";
	rom(25) <= x"00840000";
	rom(26) <= x"00810A00";
	rom(27) <= x"00C03000";
	rom(28) <= x"04080000";
	rom(29) <= x"00000000";
	rom(30) <= x"00840000";
	rom(31) <= x"00810200";
	rom(32) <= x"00C03000";
	rom(33) <= x"04080000";
	rom(34) <= x"00000000";
	rom(35) <= x"00840000";

	rom(36) <= x"00810200";
	rom(37) <= x"00C04000";
	rom(38) <= x"04080000";
	rom(39) <= x"00000000";
	rom(40) <= x"00840000";
	rom(41) <= x"00810200";
	rom(42) <= x"00C06000";
	rom(43) <= x"04080000";
	rom(44) <= x"00000000";
	rom(45) <= x"00840000";
	rom(46) <= x"00810200";
	rom(47) <= x"00C07000";
	rom(48) <= x"04080000";
	rom(49) <= x"00000000";
	rom(50) <= x"00840000";

	rom(51) <= x"00808200";
	rom(52) <= x"04080000";
	rom(53) <= x"00000000";
	rom(54) <= x"00000000";
	rom(55) <= x"00840000";
	rom(56) <= x"08092000";
	rom(57) <= x"04080000";
	rom(58) <= x"00000000";
	rom(59) <= x"00000000";
	rom(60) <= x"00840000";
	rom(61) <= x"0080A200";
	rom(62) <= x"04080000";
	rom(63) <= x"00000000";
	rom(64) <= x"00000000";
	rom(65) <= x"00840000";

	rom(66) <= x"00805000";
	rom(67) <= x"04080000";
	rom(68) <= x"00000000";
	rom(69) <= x"00000000";
	rom(70) <= x"00840000";
	rom(71) <= x"00810200";
	rom(72) <= x"00C0B000";
	rom(73) <= x"04080000";
	rom(74) <= x"00000000";
	rom(75) <= x"0100004B";
	rom(76) <= x"00000000";

	PROCESS (address) BEGIN
		Q <= rom(conv_integer(unsigned(address)));
	END PROCESS;

END romArch;