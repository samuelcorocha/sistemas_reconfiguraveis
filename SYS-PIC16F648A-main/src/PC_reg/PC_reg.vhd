LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY PC_reg IS
	PORT(
		-- Entradas
		nrst       : IN STD_LOGIC;							-- Entrada de reset assíncrono
		clk_in     : IN STD_LOGIC;							-- Entrada de clock 
		addr_in    : IN STD_LOGIC_VECTOR(10 DOWNTO 0);		-- Entrada de dados para carga no registrador PC
		abus_in    : IN STD_LOGIC_VECTOR(8 DOWNTO 0);		-- Entrada de endereçamento para PCL e para o registrador PCLATH
		dbus_in    : IN STD_LOGIC_VECTOR(7 DOWNTO 0);		-- Entrada de dados para escrita em PCL e PCLATH
		inc_pc     : IN STD_LOGIC;							-- Entrada de habilitação para incremento
		load_pc    : IN STD_LOGIC;							-- Entrada de habilitação para carga
		wr_en      : IN STD_LOGIC;							-- Entrada de habilitação para escrita
		rd_en      : IN STD_LOGIC;							-- Entrada de habilitação para leitura
		stack_push : IN STD_LOGIC;							-- Entrada de habilitação para colocar valores na pilha
		stack_pop  : IN STD_LOGIC;							-- Entrada de habilitação para retirar valores da pilha
		
		-- Saídas
		nextpc_out : OUT STD_LOGIC_VECTOR(12 DOWNTO 0);     -- Saída do valor a ser carregado em PC
		dbus_out   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)       -- Saída de dados lidos 
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
	
	-- Lógica sequencial para PC_reg
	PROCESS(nrst, clk_in)
	BEGIN
		
		IF nrst = '0' THEN
			PC <= (OTHERS => '0');
		ELSIF RISING_EDGE(clk_in) THEN
			-- Operação de pop com precedência sobre as outras
			IF stack_pop = '1' THEN
				-- PC recebe o valor que está no topo da pilha
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
			
			-- Operação de push (independente das outras)
			-- Pode acontecer junto com load_pc
			IF stack_push = '1' THEN
				-- Primeira posição da pilha recebe PC
				stack_input <= PC;
			END IF;
		END IF;
		
	END PROCESS;
	
	-- Lógica sequencial para PCLATH
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
	
	-- Lógica combinacional para nextpc
	-- Se não houver mudança no valor de PC, nextpc continua com o mesmo valor
	PROCESS(PC)
	BEGIN
	
		nextpc_out <= PC;
	
	END PROCESS;
	
	-- Lógica combinacional para dbus_out
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