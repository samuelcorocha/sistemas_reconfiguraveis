LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY PC_reg IS
	PORT(
		-- Entradas
		nrst       : IN STD_LOGIC;							-- Entrada de reset ass�ncrono
		clk_in     : IN STD_LOGIC;							-- Entrada de clock 
		addr_in    : IN STD_LOGIC_VECTOR(10 DOWNTO 0);		-- Entrada de dados para carga no registrador PC
		abus_in    : IN STD_LOGIC_VECTOR(8 DOWNTO 0);		-- Entrada de endere�amento para PCL e para o registrador PCLATH
		dbus_in    : IN STD_LOGIC_VECTOR(7 DOWNTO 0);		-- Entrada de dados para escrita em PCL e PCLATH
		inc_pc     : IN STD_LOGIC;							-- Entrada de habilita��o para incremento
		load_pc    : IN STD_LOGIC;							-- Entrada de habilita��o para carga
		wr_en      : IN STD_LOGIC;							-- Entrada de habilita��o para escrita
		rd_en      : IN STD_LOGIC;							-- Entrada de habilita��o para leitura
		stack_push : IN STD_LOGIC;							-- Entrada de habilita��o para colocar valores na pilha
		stack_pop  : IN STD_LOGIC;							-- Entrada de habilita��o para retirar valores da pilha
		
		-- Sa�das
		nextpc_out : OUT STD_LOGIC_VECTOR(12 DOWNTO 0);     -- Sa�da do valor a ser carregado em PC
		dbus_out   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)       -- Sa�da de dados lidos 
	);
END ENTITY;

ARCHITECTURE arch OF PC_reg IS
	SIGNAL PC     : STD_LOGIC_VECTOR(12 DOWNTO 0);		    -- Registrador program counter
	SIGNAL PCLATH : STD_LOGIC_VECTOR(7 DOWNTO 0);           -- Registrador de 8 bits
	
	SIGNAL stack_input  : STD_LOGIC_VECTOR(12 DOWNTO 0);
	SIGNAL stack_output : STD_LOGIC_VECTOR(12 DOWNTO 0);
	
	COMPONENT Stack IS
		PORT(
			nrst       : IN STD_LOGIC;
			clk_in     : IN STD_LOGIC;
			stack_in   : IN STD_LOGIC_VECTOR(12 DOWNTO 0);  
			stack_push : IN STD_LOGIC;						
			stack_pop  : IN STD_LOGIC;
			stack_out  : OUT STD_LOGIC_VECTOR(12 DOWNTO 0)						
		);
	END COMPONENT;
BEGIN			
	
	stack_PC : Stack PORT MAP(
		nrst 		=> nrst,
		clk_in 		=> clk_in,
		stack_in 	=> stack_input,
		stack_push  => stack_push,
		stack_pop   => stack_pop,
		stack_out   => stack_output
	);
	
	-- L�gica sequencial para PC_reg
	PROCESS(nrst, clk_in)
	BEGIN
		
		IF nrst = '0' THEN
			PC <= (OTHERS => '0');
		ELSIF RISING_EDGE(clk_in) THEN
			-- Opera��o de pop com preced�ncia sobre as outras
			IF stack_pop = '1' THEN
				-- PC recebe o valor que est� no topo da pilha
				PC <= stack_output;
			ELSIF inc_pc = '1' THEN
				PC <= PC + 1;
			ELSIF load_pc = '1' THEN
				PC(10 DOWNTO 0) <= addr_in;
				PC(12 DOWNTO 11) <= PCLATH(4 DOWNTO 3);
			ELSIF wr_en = '1' AND abus_in(6 DOWNTO 0) = "0000010" THEN
				PC(7 DOWNTO 0) <= dbus_in;
				PC(12 DOWNTO 8) <= PCLATH(4 DOWNTO 0);
			END IF;
			
			-- Opera��o de push (independente das outras)
			-- Pode acontecer junto com load_pc
			IF stack_push = '1' THEN
				-- Primeira posi��o da pilha recebe PC
				stack_input <= PC;
			END IF;
		END IF;
		
	END PROCESS;
	
	-- L�gica sequencial para PCLATH
	PROCESS(nrst, clk_in)
	BEGIN
	
	IF nrst = '0' THEN
		PCLATH <= (OTHERS => '0');
	ELSIF RISING_EDGE(clk_in) THEN
		IF wr_en = '1' AND abus_in(6 DOWNTO 0) = "0001010" THEN
			PCLATH <= dbus_in;
		END IF;
	END IF;
	
	END PROCESS;
	
	-- L�gica combinacional para nextpc
	-- Se n�o houver mudan�a no valor de PC, nextpc continua com o mesmo valor
	PROCESS(PC)
	BEGIN
	
		nextpc_out <= PC;
	
	END PROCESS;
	
	-- L�gica combinacional para dbus_out
	PROCESS(PC, PCLATH, abus_in, rd_en)
	BEGIN
		
		IF abus_in(6 DOWNTO 0) = "0000010" AND rd_en = '1' THEN
			dbus_out <= PC(7 DOWNTO 0);
		ELSIF abus_in(6 DOWNTO 0) = "0001010" AND rd_en = '1' THEN
			dbus_out <= PCLATH;
		ELSE
			dbus_out <= (OTHERS => 'Z');
		END IF;
		
	END PROCESS;
	
END arch;