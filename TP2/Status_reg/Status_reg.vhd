LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY Status_reg IS
	PORT (
		-- INPUT
		nrst : IN STD_LOGIC; -- RESET
		clk_in : IN STD_LOGIC; -- CLOCK
		abus_in : IN STD_LOGIC_VECTOR(8 DOWNTO 0); -- ADDRESS
		dbus_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- DATA
		wr_en : IN STD_LOGIC; -- WRITE ENABLE
		rd_en : IN STD_LOGIC; -- READ ENABLE
		z_in : IN STD_LOGIC; -- WRITE BIT 2
		dc_in : IN STD_LOGIC; -- WRITE BIT 1
		c_in : IN STD_LOGIC; -- WRITE BIT 0
		z_wr_en : IN STD_LOGIC; -- ENABLE WRITE BIT 2
		dc_wr_en : IN STD_LOGIC; -- ENABLE WRITE BIT 1
		c_wr_en : IN STD_LOGIC; -- ENABLE WRITE BIT 0
		
		-- OUTPUT
		dbus_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- DATA OUTPUT
        irp_out : OUT STD_LOGIC; -- BIT 7 OUTPUT
        rp_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); -- BITS 6 AND 5 OUTPUT
        z_out : OUT STD_LOGIC; -- BIT 2 OUTPUT
        dc_out : OUT STD_LOGIC; -- BIT 1 OUTPUT
        c_out : OUT STD_LOGIC -- BIT 0 OUTPUT
	);
END Status_reg;

ARCHITECTURE Behavioral OF Status_reg IS
	SIGNAL status_reg : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
	PROCESS(nrst, clk_in)
	BEGIN
		IF nrst = '0' THEN
            status_reg <= (OTHERS => '0');
        ELSIF RISING_EDGE(clk_in) THEN
            IF wr_en = '1' AND abus_in(6 DOWNTO 0) = "0000011" THEN
                status_reg <= dbus_in;
            END IF;
            
            IF z_wr_en = '1' THEN
                status_reg(2) <= z_in;
            END IF;
            
            IF dc_wr_en = '1' THEN
                status_reg(1) <= dc_in;
            END IF;
				
            IF c_wr_en = '1' THEN
                status_reg(0) <= c_in;
            END IF;
        END IF;
	END PROCESS;
	dbus_out <= status_reg WHEN (rd_en = '1' AND abus_in(6 DOWNTO 0) = "0000011") ELSE
                (OTHERS => 'Z');
	
	irp_out <= status_reg(7);
    rp_out <= status_reg(6 DOWNTO 5);
    z_out <= status_reg(2);
    dc_out <= status_reg(1);
    c_out <= status_reg(0);
END Behavioral;