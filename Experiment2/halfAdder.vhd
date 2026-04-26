LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY h_adder IS PORT (
    a, b : IN STD_LOGIC; 
    co, so : OUT STD_LOGIC
    ); 
END ENTITY h_adder;    

ARCHITECTURE halfAdder OF h_adder IS SIGNAL 
    abc: STD_LOGIC_VECTOR(1 DOWNTO 0);
BEGIN
    abc <= a & b ;
    PROCESS(abc) BEGIN
        CASE abc IS
            WHEN "00" =>
                so<='0';
                co<='0';
            WHEN "01" =>
                so<='1';
                co<='0';
            WHEN "10" =>
                so<='1';
                co<='0';
            WHEN "11" =>
                so<='0';
                co<='1';
            WHEN OTHERS => NULL;    -- Catch-all 情况
        END CASE;
    END PROCESS;
END ARCHITECTURE halfAdder;