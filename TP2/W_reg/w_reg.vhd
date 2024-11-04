LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY W_reg IS
	PORT (
		-- INPUT
		nrst : IN STD_LOGIC; -- RESET
		clk_in : IN STD_LOGIC; -- CLOCK
		d_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- DATA
		wren : IN STD_LOGIC; -- ENABLE
		
		-- OUTPUT
		w_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
	
END w_reg;

ARCHITECTURE Behavioral OF W_reg IS
	SIGNAL reg_data : STD_LOGIC_VECTOR(7 DOWNTO 0);	
BEGIN
	PROCESS(nrst, clk_in)
	BEGIN
		IF nrst = '0' THEN
			reg_data <= (OTHERS => '0');
		ELSIF RISING_EDGE(clk_in) THEN
			IF wren = '1' THEN
				reg_data <= d_in;
			END IF;
		END IF;
	END PROCESS;
	
	w_out <= reg_data;
END Behavioral;