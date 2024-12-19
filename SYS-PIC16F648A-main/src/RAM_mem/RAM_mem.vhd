LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY RAM_mem IS 
	PORT(
		-- Entradas
		nrst     : IN STD_LOGIC;						-- Reset assíncrono
		clk_in   : IN STD_LOGIC;						-- Clock do sistema
		abus_in  : IN STD_LOGIC_VECTOR(8 DOWNTO 0);		-- Endereçamento
		dbus_in  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);		-- Dados
		wr_en    : IN STD_LOGIC;						-- Habilitação para escrita na memória
		rd_en    : IN STD_LOGIC;						-- Habilitação para leitura da memória
		
		-- Saída
		dbus_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)		-- Saída de dados
	);
END ENTITY;

ARCHITECTURE arch OF RAM_mem IS
	-- Três áreas de memória de 80 bytes
	TYPE mem80bytes_type IS ARRAY(0 TO 79) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL mem0 : mem80bytes_type;
	SIGNAL mem1 : mem80bytes_type;
	SIGNAL mem2 : mem80bytes_type;
	
	-- Uma área de memória de 16 bytes
	TYPE mem16bytes_type IS ARRAY(0 TO 15) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL mem_com : mem16bytes_type;
	
	-- Sinal para utilizar o endereçamento convertido em inteiro (unsigned)
	SIGNAL abus_int : INTEGER RANGE 0 TO 511;
BEGIN
	-- Conversão do endereçamento
	abus_int <= TO_INTEGER(UNSIGNED(abus_in));

	-- Escrita (dependente do clock)
	PROCESS(nrst, clk_in) 
	BEGIN
		IF nrst = '0' THEN
			-- Se o reset for ativado toda a memória RAM é zerada
			mem0 <= (OTHERS => (OTHERS => '0'));
			mem1 <= (OTHERS => (OTHERS => '0'));
			mem2 <= (OTHERS => (OTHERS => '0'));
			mem_com <= (OTHERS => (OTHERS => '0'));
		ELSIF RISING_EDGE(clk_in) THEN
			IF wr_en = '1' THEN
				-- A área de memória a ser escrita é escolhida dependendo da faixa de valores do endereçamento abus_in   
				CASE abus_int IS
					-- Para escrever nos endereços certos há uma conversão em cada faixa
					WHEN 32 TO 111  =>
						mem0((abus_int - 32)) <= dbus_in;
					WHEN 160 TO 239 =>
						mem1((abus_int - 160)) <= dbus_in;
					WHEN 288 TO 367 =>
						mem2((abus_int - 288)) <= dbus_in;
					WHEN 112 TO 127 =>  
						mem_com((abus_int - 112)) <= dbus_in;
					WHEN 240 TO 255 =>
						mem_com((abus_int - 240)) <= dbus_in;
					WHEN 368 TO 383 =>
						mem_com((abus_int - 368)) <= dbus_in;
					WHEN 496 TO 511 =>
						mem_com((abus_int - 496)) <= dbus_in;
					-- Se o endereço não corresponder com a faixa pré-definida não há escrita
					WHEN OTHERS =>
						null;
				END CASE;
			END IF;
		END IF;
	END PROCESS;
	
	-- Leitura (independente do clock)
	PROCESS(rd_en, abus_int, mem0, mem1, mem2, mem_com)
	BEGIN
		IF rd_en = '1' THEN
			CASE abus_int IS
			-- Para ler dos endereços certos há uma conversão em cada faixa
				WHEN 32 TO 111  =>
					dbus_out <= mem0((abus_int - 32));
				WHEN 160 TO 239 =>
					dbus_out <= mem1((abus_int - 160));
				WHEN 288 TO 367 =>
					dbus_out <= mem2((abus_int - 288));
				WHEN 112 TO 127 =>  
					dbus_out <= mem_com((abus_int - 112));
				WHEN 240 TO 255 =>
					dbus_out <= mem_com((abus_int - 240));
				WHEN 368 TO 383 =>
					dbus_out <= mem_com((abus_int - 368));
				WHEN 496 TO 511 =>
					dbus_out <= mem_com((abus_int - 496));
				-- Se o endereço não corresponder com a faixa pré-definida dbus_out fica em alta impedância
				WHEN OTHERS =>
					dbus_out <= (OTHERS => 'Z');
			END CASE;
		-- Se não houver habilitação de leitura dbus_out também fica em alta impedância
		ELSE
			dbus_out <= (OTHERS => 'Z');
		END IF;
	END PROCESS;
END arch;

