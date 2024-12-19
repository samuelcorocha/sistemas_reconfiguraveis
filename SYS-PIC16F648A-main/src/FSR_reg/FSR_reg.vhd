library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY FSR_reg IS
    PORT (
        nrst		: IN STD_LOGIC;         				-- Entrada de reset assíncrono
        clk_in		: IN STD_LOGIC;         				-- Entrada de clock para escrita no registrador
		abus_in		: IN STD_LOGIC_VECTOR(8 DOWNTO 0);		-- Entrada para endereçamento
		dbus_in		: IN STD_LOGIC_VECTOR(7 DOWNTO 0);		-- Entrada para dados
        wr_en		: IN STD_LOGIC;         				-- Entrada de habilitação para escrita no registrador
        rd_en		: IN STD_LOGIC;							-- Entrada de habilitação para leitura no registrador
        
        dbus_out	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);		-- Saida de dados lidos
        fsr_out		: OUT STD_LOGIC_VECTOR(7 DOWNTO 0) 		-- Saída de registrador correspondente
    );
END FSR_reg;

ARCHITECTURE arch OF FSR_reg IS    
    CONSTANT ABUS_BIT_MASK : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000100";
    
BEGIN
    PROCESS (nrst, clk_in, abus_in, dbus_in, wr_en, rd_en)
        VARIABLE reg_data : STD_LOGIC_VECTOR(7 DOWNTO 0);
    BEGIN
        IF nrst = '0' THEN
            reg_data := (others => '0');
            dbus_out <= (others => 'Z');
            
        ELSIF RISING_EDGE(clk_in) THEN
			-- Operação de escrita no registrador
            IF (abus_in(6 DOWNTO 0) = ABUS_BIT_MASK) AND (wr_en = '1') THEN
				reg_data := dbus_in;
			END IF;
        END IF; 
		
		-- Operação de leitura no registrador
		IF (abus_in(6 DOWNTO 0) = ABUS_BIT_MASK) AND (rd_en = '1') THEN
			dbus_out <= reg_data;
		ELSE
			dbus_out <= (OTHERS => 'Z');
		END IF;
		
		fsr_out <= reg_data;
    END PROCESS;
END arch;