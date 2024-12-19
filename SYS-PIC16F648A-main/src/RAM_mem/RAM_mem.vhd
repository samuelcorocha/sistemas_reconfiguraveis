LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY RAM_mem IS 
	PORT(
		-- Entradas
		nrst     : IN STD_LOGIC;						-- Reset ass�ncrono
		clk_in   : IN STD_LOGIC;						-- Clock do sistema
		abus_in  : IN STD_LOGIC_VECTOR(8 DOWNTO 0);		-- Endere�amento
		dbus_in  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);		-- Dados
		wr_en    : IN STD_LOGIC;						-- Habilita��o para escrita na mem�ria
		rd_en    : IN STD_LOGIC;						-- Habilita��o para leitura da mem�ria
		
		-- Sa�da
		dbus_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)		-- Sa�da de dados
	);
END ENTITY;

ARCHITECTURE arch OF RAM_mem IS
	-- Tr�s �reas de mem�ria de 80 bytes
	TYPE mem80bytes_type IS ARRAY(0 TO 79) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL mem0 : mem80bytes_type;
	SIGNAL mem1 : mem80bytes_type;
	SIGNAL mem2 : mem80bytes_type;
	
	-- Uma �rea de mem�ria de 16 bytes
	TYPE mem16bytes_type IS ARRAY(0 TO 15) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL mem_com : mem16bytes_type;
	
	-- Sinal para utilizar o endere�amento convertido em inteiro (unsigned)
	SIGNAL abus_int : INTEGER RANGE 0 TO 511;
BEGIN
	-- Convers�o do endere�amento
	abus_int <= TO_INTEGER(UNSIGNED(abus_in));

	-- Escrita (dependente do clock)
	PROCESS(nrst, clk_in) 
	BEGIN
		IF nrst = '0' THEN
			-- Se o reset for ativado toda a mem�ria RAM � zerada
			mem0 <= (OTHERS => (OTHERS => '0'));
			mem1 <= (OTHERS => (OTHERS => '0'));
			mem2 <= (OTHERS => (OTHERS => '0'));
			mem_com <= (OTHERS => (OTHERS => '0'));
		ELSIF RISING_EDGE(clk_in) THEN
			IF wr_en = '1' THEN
				-- A �rea de mem�ria a ser escrita � escolhida dependendo da faixa de valores do endere�amento abus_in   
				CASE abus_int IS
					-- Para escrever nos endere�os certos h� uma convers�o em cada faixa
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
					-- Se o endere�o n�o corresponder com a faixa pr�-definida n�o h� escrita
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
			-- Para ler dos endere�os certos h� uma convers�o em cada faixa
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
				-- Se o endere�o n�o corresponder com a faixa pr�-definida dbus_out fica em alta imped�ncia
				WHEN OTHERS =>
					dbus_out <= (OTHERS => 'Z');
			END CASE;
		-- Se n�o houver habilita��o de leitura dbus_out tamb�m fica em alta imped�ncia
		ELSE
			dbus_out <= (OTHERS => 'Z');
		END IF;
	END PROCESS;
END arch;

