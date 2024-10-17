library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
USE ieee.std_logic_unsigned.all;



entity alu is
	Port (
		-- Entradas
		a_in : in STD_LOGIC_VECTOR(7 DOWNTO 0);
		b_in : in STD_LOGIC_VECTOR(7 DOWNTO 0);
		c_in : in STD_LOGIC;
		op_sel : in STD_LOGIC_VECTOR(3 DOWNTO 0);
		bit_sel : in STD_LOGIC_VECTOR(2 DOWNTO 0);
		-- Sa�das
		r_out : out STD_LOGIC_VECTOR(7 DOWNTO 0);
		c_out : out STD_LOGIC;
		dc_out : out STD_LOGIC;
		z_out : out STD_LOGIC;
	);
end alu;

architecture arch of alu is
    signal temp_result : STD_LOGIC_VECTOR(7 downto 0);
    SIGNAL bit_sel_int : INTEGER RANGE 0 TO 7 := TO_INTEGER(UNSIGNED(bit_sel));
    SIGNAL vector_BC_BS : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL bit_BC_BS : STD_LOGIC;
    SIGNAL dc_vector: STD_LOGIC_VECTOR(4 DOWNTO 0);
    CONSTANT zero : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
    CONSTANT one : STD_LOGIC_VECTOR(7 DOWNTO 0) := "11111111";
begin
	bit_BC_BS <= a_in(to_integer(unsigned(bit_sel)))
	with op_sel SELECT
		dc_vector <= '0' & a_in(3 DOWNTO 0) + b_in(3 DOWNTO 0) WHEN "0110", 
		'0' & a_in(3 DOWNTO 0) - b_in(3 DOWNTO 0) WHEN "0111",
		"00000" WHEN OTHERS;
		
	with bit_sel SELECT --Tabela das opera��es BC BS 
		vector_BC_BS <=
			"00000001" WHEN "000",
			"00000010" WHEN "001",
			"00000100" WHEN "010",
			"00001000" WHEN "011",
			"00010000" WHEN "100",
			"00100000" WHEN "101",
			"01000000" WHEN "110",
			"10000000" WHEN "111";
			
			
			
			
    with op_sel select
		temp_result <= a_in XOR b_in when "0000", -- XOR
					   a_in OR b_in when "0001",  -- OR
					   a_in AND b_in when "0010", -- AND
					   (others => '0') when "0011", -- CLR
					   std_logic_vector(unsigned(a_in) + unsigned(b_in)) when "0100",  -- ADD
					   std_logic_vector(unsigned(a_in) - unsigned(b_in)) when "0101",  -- SUB
					   std_logic_vector(unsigned(a_in) + 1) when "0110",  -- INC
					   std_logic_vector(unsigned(a_in) - 1) when "0111",  -- DEC
					   a_in when "1000", -- PASS_A
					   b_in when "1001", -- PASS_B
					   NOT a_in when "1010", -- COM (Complemento)
					   a_in(3 DOWNTO 0) & a_in(7 DOWNTO 4) when "1011", -- SWAP
					   vector_BC_BS OR a_in when "1100", -- BS
					   NOT vector_BC_BS OR a_in when "1101", -- BC
					   c_in & a_in(7 downto 1) when "1110", -- RR
					   a_in(6 downto 0) & c_in when "1111"; -- RL
					   
    
    with op_sel SELECT			-- Carry-out
		c_out <= result(8) WHEN "0100" and unsigned(a_in) + unsigned(b_in) > 255, -- Overflow
		NOT result(8) WHEN "0101" and unsigned(a_in) < unsigned(b_in), -- Emprestimo
		a_in(0) WHEN "1110",
		a_in(7) WHEN "1111",
		'0' WHEN OTHERS;
    
    dc_out <= dc_vector(4) WHEN (op_sel = "0100" OR op_sel = "0101" OR op_sel = "0110" OR op_sel = "0111") ELSE '0'; -- Digit Carry-out
    
                   
	r_out <= temp_result when (op_sel /= "1100" and op_sel /= "1101") else
             temp_result when (op_sel = "1100" and temp_result(to_integer(unsigned(bit_sel))) = '1') else
             temp_result when (op_sel = "1101" and temp_result(to_integer(unsigned(bit_sel))) = '0') else temp_result;

    z_out <= bit_BC_BS when op_sel = "1100" or op_sel = "1101" ELSE
				'1' when temp_result = "00000000" else
				'0';
end arch;