library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu is
	Port (
		-- Entradas
		a_in : in STD_LOGIC_VECTOR(7 TO 0);
		b_in : in STD_LOGIC_VECTOR(7 TO 0);
		c_in : in STD_LOGIC;
		op_sel : in STD_LOGIC_VECTOR(3 TO 0);
		bit_sel : in STD_LOGIC_VECTOR(2 TO 0);
		-- Saídas
		r_out : out STD_LOGIC_VECTOR(7 TO 0);
		c_out : out STD_LOGIC;
		dc_out : out STD_LOGIC;
		z_out : out STD_LOGIC;
	);
end alu;

architecture arch of alu is
    signal temp_result : STD_LOGIC_VECTOR(7 downto 0);
begin
    with op_sel select
		temp_result <= a_in XOR b_in when "0000", -- XOR
					   a_in OR b_in when "0001",  -- OR
					   a_in AND b_in when "0010", -- AND
					   (others => '0') when "0011", -- CLR
					   std_logic_vector(unsigned(a_in) + unsigned(b_in)) when "0100",  -- ADD
					   std_logic_vector(unsigned(a_in) - unsigned(b_in)) when "0101",  -- SUB
					   std_logic_vector(unsigned(a_in) + 1) when "0110",  -- INC
					   std_logic_vector(unsigned(a_in) - 1) when "0111",  -- DEC
					   when "1000", -- PASS_A
					   when "1001", -- PASS_B
					   NOT a_in when "1010", -- COM (Complemento)
					   when "1011", -- SWAP
					   when "1100", -- BS
					   when "1101", -- BC
					   when "1110", -- RR
					   when "1111"; -- RL
                   
	r_out <= temp_result when (op_sel /= "1100" and op_sel /= "1101") else
             temp_result when (op_sel = "1100" and temp_result(to_integer(unsigned(bit_sel))) = '1') else
             temp_result when (op_sel = "1101" and temp_result(to_integer(unsigned(bit_sel))) = '0') else temp_result;

    z_out <= '1' when temp_result = "00000000" else '0';
end arch;