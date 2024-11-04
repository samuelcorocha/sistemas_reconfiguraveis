LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY FSR_reg IS
	PORT (
		-- INPUT
		nrst : IN STD_LOGIC; -- RESET
        clk_in : IN STD_LOGIC; -- CLOCK
        abus_in : IN STD_LOGIC_VECTOR(8 downto 0); -- ADDRESS
        dbus_in : IN STD_LOGIC_VECTOR(7 downto 0); -- DATA
        wr_en : IN STD_LOGIC; -- WRITE ENABLE
        rd_en : IN STD_LOGIC; -- READ ENABLE
        
        -- OUTPUT
        dbus_out : OUT STD_LOGIC_VECTOR(7 downto 0);
        fsr_out : OUT STD_LOGIC_VECTOR(7 downto 0)
	);
END FSR_reg;

ARCHITECTURE Behavioral OF FSR_reg IS
	SIGNAL reg_data : 	STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
	PROCESS(nrst, clk_in)
	BEGIN
		IF nrst = '0' THEN
            reg_data <= (OTHERS => '0');
        ELSIF RISING_EDGE(clk_in) THEN
            IF wr_en = '1' AND abus_in(6 DOWNTO 0) = "0000100" THEN
                reg_data <= dbus_in;
            END IF;
        END IF;
	END PROCESS;
	
	dbus_out <= reg_data WHEN (rd_en = '1' AND abus_in(6 DOWNTO 0) = "0000100") ELSE
				(OTHERS => 'Z'); 
	
	fsr_out <= reg_data;
END Behavioral;