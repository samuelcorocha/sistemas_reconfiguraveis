library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Status_reg IS
    PORT (
        nrst      : IN STD_LOGIC;          				-- Entrada de reset assíncrono
        clk_in    : IN STD_LOGIC;          				-- Entrada de clock para escrita
        abus_in   : IN STD_LOGIC_VECTOR(8 DOWNTO 0);	-- Entrada de endereçamento
        dbus_in   : IN STD_LOGIC_VECTOR(7 DOWNTO 0);	-- Entrada de dados para escrita
        wr_en     : IN STD_LOGIC;						-- Entrada de habilitação para escrita
        rd_en     : IN STD_LOGIC;						-- Entrada de habilitação para leitura
        z_in      : IN STD_LOGIC;						-- Entrada de dado para escrita no bit 2
        dc_in     : IN STD_LOGIC;						-- Entrada de dado para escrita no bit 1
        c_in      : IN STD_LOGIC;						-- Entrada de dado para escrita no bit 0
        z_wr_en   : IN STD_LOGIC;						-- Entrada para habilitação da escrita no bit 2
        dc_wr_en  : IN STD_LOGIC;						-- Entrada para habilitação da escrita no bit 1
        c_wr_en   : IN STD_LOGIC;						-- Entrada para habilitação da escrita no bit 0
        
        dbus_out  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);  	-- Saída de dados lidos
        irp_out   : OUT STD_LOGIC;          			-- Saída correspondente ao bit 7
        rp_out    : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);  	-- Saída correspondente aos bits 6 e 5
        z_out     : OUT STD_LOGIC;          			-- Saída correspondente ao bit 2
        dc_out    : OUT STD_LOGIC;          			-- Saída correspondente ao bit 1
        c_out     : OUT STD_LOGIC           			-- Saída correspondente ao bit 0
    );
END Status_reg;

ARCHITECTURE arch OF Status_reg IS
    SIGNAL reg_data 		: STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
	
	CONSTANT ABUS_BIT_MASK 	: STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000011";
BEGIN
    PROCESS (nrst, clk_in)
    BEGIN
        IF nrst = '0' THEN
            -- Reset assíncrono, zera o registrador
            reg_data <= (OTHERS => '0');
            dbus_out <= (OTHERS => 'Z');
        ELSIF RISING_EDGE(clk_in) THEN
			-- Verifica se endereço é valido (Escrita)
			IF abus_in(6 DOWNTO 0) = ABUS_BIT_MASK THEN
				IF wr_en = '1' THEN
					reg_data <= dbus_in;
				END IF;
				
                IF z_wr_en = '1' THEN
                    reg_data(2) <= z_in;
                END IF;

                IF dc_wr_en = '1' THEN
                    reg_data(1) <= dc_in;
				END IF;
                
                IF c_wr_en = '1'THEN
                    reg_data(0) <= c_in;
				END IF; 	
			ELSE
				dbus_out <= (OTHERS => 'Z');
			END IF;
		END IF;
    END PROCESS;
    
    PROCESS (abus_in, rd_en, reg_data)
	BEGIN
		-- Verifica se endereço é valido (Leitura)
		IF abus_in(6 DOWNTO 0) = ABUS_BIT_MASK THEN
			IF rd_en = '1' THEN
				-- Leitura habilitada e endereço especificado
				dbus_out <= reg_data;
			ELSE
				-- Leitura desabilitada ou endereço não correspondente
				dbus_out <= (OTHERS => 'Z');
			END IF;
		ELSE
			dbus_out <= (OTHERS => 'Z');	
		END IF;
	END PROCESS;

    -- Saídas fixas
    irp_out <= reg_data(7);
    rp_out <= reg_data(6 DOWNTO 5);
    z_out <= reg_data(2);
    dc_out <= reg_data(1);
    c_out <= reg_data(0);

end arch;