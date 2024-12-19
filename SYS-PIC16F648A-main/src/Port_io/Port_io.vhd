LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Port_io IS
	GENERIC (
		port_addr		: IN STD_LOGIC_VECTOR(8 DOWNTO 0) := "000000010";
		tris_addr		: IN STD_LOGIC_VECTOR(8 DOWNTO 0) := "000001000";
		alt_port_addr	: IN STD_LOGIC_VECTOR(8 DOWNTO 0) := "000000011";
		alt_tris_addr	: IN STD_LOGIC_VECTOR(8 DOWNTO 0) := "000001001"
	);
	
	PORT (
		--Entradas
		nrst		: IN STD_LOGIC;						
		clk_in		: IN STD_LOGIC;
		abus_in 	: IN STD_LOGIC_VECTOR (8 DOWNTO 0);
		dbus_in 	: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		wr_en 		: IN STD_LOGIC;
		rd_en 		: IN STD_LOGIC;
		-- SAIDAS
		dbus_out 	: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		-- BIDIRECIONAL
		port_io 	: INOUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE arch OF Port_io IS
	SIGNAL port_reg : STD_LOGIC_VECTOR (7 DOWNTO 0); 	-- Registrador que mant�m os dados de sa�da da porta
	SIGNAL tris_reg : STD_LOGIC_VECTOR (7 DOWNTO 0); 	-- Registrador que controla a dire��o da porta bit a bit
	SIGNAL latch : STD_LOGIC_VECTOR (7 DOWNTO 0); 		-- Latch que trava valores presentes na porta
	
	SIGNAL i : INTEGER;
BEGIN
	-- Opera��o de escrita nos registradores
	PROCESS (nrst, clk_in, i)
	BEGIN
		-- Reset condition
		IF nrst = '0' THEN
			port_reg <= (OTHERS => '0');
			tris_reg <= (OTHERS => '1');
		ELSIF RISING_EDGE (clk_in) THEN
			-- Write operation on port_reg
			IF wr_en = '1' AND (abus_in(7 DOWNTO 0) = port_addr(7 DOWNTO 0) OR abus_in(7 DOWNTO 0) = alt_port_addr(7 DOWNTO 0)) THEN
				port_reg <= dbus_in;
			-- Write operation on tris_reg
			ELSIF wr_en = '1' AND (abus_in(7 DOWNTO 0) = tris_addr(7 DOWNTO 0) OR abus_in(7 DOWNTO 0) = alt_tris_addr(7 DOWNTO 0)) THEN
				tris_reg <= dbus_in;
			END IF;
		END IF;
	END PROCESS;
	
	
	-- Opera��o de leitura dos registradores
	PROCESS (rd_en, abus_in, latch, tris_reg)
	BEGIN
		IF rd_en = '1' AND (abus_in(7 DOWNTO 0) = port_addr(7 DOWNTO 0) OR abus_in(7 DOWNTO 0) = alt_port_addr(7 DOWNTO 0)) THEN
			-- Read latch
			dbus_out <= latch;
		ELSIF rd_en = '1' AND (abus_in(7 DOWNTO 0) = tris_addr(7 DOWNTO 0) OR abus_in(7 DOWNTO 0) = alt_tris_addr(7 DOWNTO 0)) THEN
			-- Read tris_reg
			dbus_out <= tris_reg;
		ELSE
			dbus_out <= "ZZZZZZZZ";
		END IF;
	END PROCESS;

	-- L�gica da porta
	PROCESS(tris_reg, port_reg, port_io)
	BEGIN
		FOR i IN 0 TO 7 LOOP
			-- Se um bit de tris_reg estiver configurado como sa�da, port_io receber� o bit dessa posi��o de port_reg
			IF tris_reg(i) <= '0' THEN
				port_io(i) <= port_reg(i);
			-- Se n�o, a posi��o fica em alta imped�ncia
			ELSE
				port_io(i) <= 'Z';
			END IF;
		END LOOP;
	END PROCESS;

	-- L�gica do latch
	PROCESS (rd_en, port_io, abus_in)
	BEGIN
		IF rd_en = '1' THEN
			IF abus_in(7 DOWNTO 0) = port_addr(7 DOWNTO 0) OR abus_in(7 DOWNTO 0) = alt_port_addr(7 DOWNTO 0) THEN
				latch <= port_io; -- escrita port_io no latch
			END IF;
		END IF;
	END PROCESS;
END arch;
