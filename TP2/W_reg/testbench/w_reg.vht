-- Copyright (C) 1991-2010 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- *****************************************************************************
-- This file contains a Vhdl test bench with test vectors .The test vectors     
-- are exported from a vector file in the Quartus Waveform Editor and apply to  
-- the top level entity of the current Quartus project .The user can use this   
-- testbench to simulate his design using a third-party simulation tool .       
-- *****************************************************************************
-- Generated on "11/09/2024 11:56:23"
                                                                        
-- Vhdl Self-Checking Test Bench (with test vectors) for design :       W_reg
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

LIBRARY STD;                                                            
USE STD.textio.ALL;                                                     

PACKAGE W_reg_vhd_tb_types IS
-- input port types                                                       
-- output port names                                                     
CONSTANT w_out_name : STRING (1 TO 5) := "w_out";
-- n(outputs)                                                            
CONSTANT o_num : INTEGER := 1;
-- mismatches vector type                                                
TYPE mmvec IS ARRAY (0 to (o_num - 1)) OF INTEGER;
-- exp o/ first change track vector type                                     
TYPE trackvec IS ARRAY (1 to o_num) OF BIT;
-- sampler type                                                            
SUBTYPE sample_type IS STD_LOGIC;                                          
-- utility functions                                                     
FUNCTION std_logic_to_char (a: STD_LOGIC) RETURN CHARACTER;              
FUNCTION std_logic_vector_to_string (a: STD_LOGIC_VECTOR) RETURN STRING; 
PROCEDURE write (l:INOUT LINE; value:IN STD_LOGIC; justified: IN SIDE:= RIGHT; field:IN WIDTH:=0);                                               
PROCEDURE write (l:INOUT LINE; value:IN STD_LOGIC_VECTOR; justified: IN SIDE:= RIGHT; field:IN WIDTH:=0);                                        
PROCEDURE throw_error(output_port_name: IN STRING; expected_value : IN STD_LOGIC; real_value : IN STD_LOGIC);                                   
PROCEDURE throw_error(output_port_name: IN STRING; expected_value : IN STD_LOGIC_VECTOR; real_value : IN STD_LOGIC_VECTOR);                     

END W_reg_vhd_tb_types;

PACKAGE BODY W_reg_vhd_tb_types IS
        FUNCTION std_logic_to_char (a: STD_LOGIC)  
                RETURN CHARACTER IS                
        BEGIN                                      
        CASE a IS                                  
         WHEN 'U' =>                               
          RETURN 'U';                              
         WHEN 'X' =>                               
          RETURN 'X';                              
         WHEN '0' =>                               
          RETURN '0';                              
         WHEN '1' =>                               
          RETURN '1';                              
         WHEN 'Z' =>                               
          RETURN 'Z';                              
         WHEN 'W' =>                               
          RETURN 'W';                              
         WHEN 'L' =>                               
          RETURN 'L';                              
         WHEN 'H' =>                               
          RETURN 'H';                              
         WHEN '-' =>                               
          RETURN 'D';                              
        END CASE;                                  
        END;                                       

        FUNCTION std_logic_vector_to_string (a: STD_LOGIC_VECTOR)       
                RETURN STRING IS                                        
        VARIABLE result : STRING(1 TO a'LENGTH);                        
        VARIABLE j : NATURAL := 1;                                      
        BEGIN                                                           
                FOR i IN a'RANGE LOOP                                   
                        result(j) := std_logic_to_char(a(i));           
                        j := j + 1;                                     
                END LOOP;                                               
                RETURN result;                                          
        END;                                                            

        PROCEDURE write (l:INOUT LINE; value:IN STD_LOGIC; justified: IN SIDE:=RIGHT; field:IN WIDTH:=0) IS 
        BEGIN                                                           
                write(L,std_logic_to_char(VALUE),JUSTIFIED,field);      
        END;                                                            
                                                                        
        PROCEDURE write (l:INOUT LINE; value:IN STD_LOGIC_VECTOR; justified: IN SIDE:= RIGHT; field:IN WIDTH:=0) IS                           
        BEGIN                                                               
                write(L,std_logic_vector_to_string(VALUE),JUSTIFIED,field); 
        END;                                                                

        PROCEDURE throw_error(output_port_name: IN STRING; expected_value : IN STD_LOGIC; real_value : IN STD_LOGIC) IS                               
        VARIABLE txt : LINE;                                              
        BEGIN                                                             
        write(txt,string'("ERROR! Vector Mismatch for output port "));  
        write(txt,output_port_name);                                      
        write(txt,string'(" :: @time = "));                             
        write(txt,NOW);                                                   
		writeline(output,txt);                                            
        write(txt,string'("     Expected value = "));                   
        write(txt,expected_value);                                        
		writeline(output,txt);                                            
        write(txt,string'("     Real value = "));                       
        write(txt,real_value);                                            
        writeline(output,txt);                                            
        END;                                                              

        PROCEDURE throw_error(output_port_name: IN STRING; expected_value : IN STD_LOGIC_VECTOR; real_value : IN STD_LOGIC_VECTOR) IS                 
        VARIABLE txt : LINE;                                              
        BEGIN                                                             
        write(txt,string'("ERROR! Vector Mismatch for output port "));  
        write(txt,output_port_name);                                      
        write(txt,string'(" :: @time = "));                             
        write(txt,NOW);                                                   
		writeline(output,txt);                                            
        write(txt,string'("     Expected value = "));                   
        write(txt,expected_value);                                        
		writeline(output,txt);                                            
        write(txt,string'("     Real value = "));                       
        write(txt,real_value);                                            
        writeline(output,txt);                                            
        END;                                                              

END W_reg_vhd_tb_types;

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

USE WORK.W_reg_vhd_tb_types.ALL;                                         

ENTITY W_reg_vhd_sample_tst IS
PORT (
	clk_in : IN STD_LOGIC;
	d_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	nrst : IN STD_LOGIC;
	wren : IN STD_LOGIC;
	sampler : OUT sample_type
	);
END W_reg_vhd_sample_tst;

ARCHITECTURE sample_arch OF W_reg_vhd_sample_tst IS
SIGNAL tbo_int_sample_clk : sample_type := '-';
SIGNAL current_time : TIME := 0 ps;
BEGIN
t_prcs_sample : PROCESS ( clk_in , d_in , nrst , wren )
BEGIN
	IF (NOW > 0 ps) THEN
		IF (NOW > 0 ps) AND (NOW /= current_time) THEN
			IF (tbo_int_sample_clk = '-') THEN
				tbo_int_sample_clk <= '0';
			ELSE
				tbo_int_sample_clk <= NOT tbo_int_sample_clk ;
			END IF;
		END IF;
		current_time <= NOW;
	END IF;
END PROCESS t_prcs_sample;
sampler <= tbo_int_sample_clk;
END sample_arch;

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

LIBRARY STD;                                                            
USE STD.textio.ALL;                                                     

USE WORK.W_reg_vhd_tb_types.ALL;                                         

ENTITY W_reg_vhd_check_tst IS 
GENERIC (
	debug_tbench : BIT := '0'
);
PORT ( 
	w_out : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	sampler : IN sample_type
);
END W_reg_vhd_check_tst;
ARCHITECTURE ovec_arch OF W_reg_vhd_check_tst IS
SIGNAL w_out_expected,w_out_expected_prev,w_out_prev : STD_LOGIC_VECTOR(7 DOWNTO 0);

SIGNAL trigger : BIT := '0';
SIGNAL trigger_e : BIT := '0';
SIGNAL trigger_r : BIT := '0';
SIGNAL trigger_i : BIT := '0';
SIGNAL num_mismatches : mmvec := (OTHERS => 0);

BEGIN

-- Update history buffers  expected /o
t_prcs_update_o_expected_hist : PROCESS (trigger) 
BEGIN
	w_out_expected_prev <= w_out_expected;
END PROCESS t_prcs_update_o_expected_hist;


-- Update history buffers  real /o
t_prcs_update_o_real_hist : PROCESS (trigger) 
BEGIN
	w_out_prev <= w_out;
END PROCESS t_prcs_update_o_real_hist;


-- expected w_out[7]
t_prcs_w_out_7: PROCESS
BEGIN
	w_out_expected(7) <= '0';
	WAIT FOR 15000 ps;
	w_out_expected(7) <= '1';
	WAIT FOR 35000 ps;
	w_out_expected(7) <= '0';
	WAIT FOR 10000 ps;
	w_out_expected(7) <= 'X';
WAIT;
END PROCESS t_prcs_w_out_7;
-- expected w_out[6]
t_prcs_w_out_6: PROCESS
BEGIN
	w_out_expected(6) <= '0';
	WAIT FOR 15000 ps;
	w_out_expected(6) <= '1';
	WAIT FOR 35000 ps;
	w_out_expected(6) <= '0';
	WAIT FOR 10000 ps;
	w_out_expected(6) <= 'X';
WAIT;
END PROCESS t_prcs_w_out_6;
-- expected w_out[5]
t_prcs_w_out_5: PROCESS
BEGIN
	w_out_expected(5) <= '0';
	WAIT FOR 25000 ps;
	w_out_expected(5) <= '1';
	WAIT FOR 25000 ps;
	w_out_expected(5) <= '0';
	WAIT FOR 10000 ps;
	w_out_expected(5) <= 'X';
WAIT;
END PROCESS t_prcs_w_out_5;
-- expected w_out[4]
t_prcs_w_out_4: PROCESS
BEGIN
	w_out_expected(4) <= '0';
	WAIT FOR 25000 ps;
	w_out_expected(4) <= '1';
	WAIT FOR 25000 ps;
	w_out_expected(4) <= '0';
	WAIT FOR 10000 ps;
	w_out_expected(4) <= 'X';
WAIT;
END PROCESS t_prcs_w_out_4;
-- expected w_out[3]
t_prcs_w_out_3: PROCESS
BEGIN
	w_out_expected(3) <= '0';
	WAIT FOR 15000 ps;
	w_out_expected(3) <= '1';
	WAIT FOR 10000 ps;
	w_out_expected(3) <= '0';
	WAIT FOR 35000 ps;
	w_out_expected(3) <= 'X';
WAIT;
END PROCESS t_prcs_w_out_3;
-- expected w_out[2]
t_prcs_w_out_2: PROCESS
BEGIN
	w_out_expected(2) <= '0';
	WAIT FOR 15000 ps;
	w_out_expected(2) <= '1';
	WAIT FOR 10000 ps;
	w_out_expected(2) <= '0';
	WAIT FOR 35000 ps;
	w_out_expected(2) <= 'X';
WAIT;
END PROCESS t_prcs_w_out_2;
-- expected w_out[1]
t_prcs_w_out_1: PROCESS
BEGIN
	w_out_expected(1) <= '0';
	WAIT FOR 60000 ps;
	w_out_expected(1) <= 'X';
WAIT;
END PROCESS t_prcs_w_out_1;
-- expected w_out[0]
t_prcs_w_out_0: PROCESS
BEGIN
	w_out_expected(0) <= '0';
	WAIT FOR 60000 ps;
	w_out_expected(0) <= 'X';
WAIT;
END PROCESS t_prcs_w_out_0;

-- Set trigger on real/expected o/ pattern changes                        

t_prcs_trigger_e : PROCESS(w_out_expected)
BEGIN
	trigger_e <= NOT trigger_e;
END PROCESS t_prcs_trigger_e;

t_prcs_trigger_r : PROCESS(w_out)
BEGIN
	trigger_r <= NOT trigger_r;
END PROCESS t_prcs_trigger_r;


t_prcs_selfcheck : PROCESS
VARIABLE i : INTEGER := 1;
VARIABLE txt : LINE;

VARIABLE last_w_out_exp : STD_LOGIC_VECTOR(7 DOWNTO 0) := "UUUUUUUU";

VARIABLE on_first_change : trackvec := "1";
BEGIN

WAIT UNTIL (sampler'LAST_VALUE = '1'OR sampler'LAST_VALUE = '0')
	AND sampler'EVENT;
IF (debug_tbench = '1') THEN
	write(txt,string'("Scanning pattern "));
	write(txt,i);
	writeline(output,txt);
	write(txt,string'("| expected "));write(txt,w_out_name);write(txt,string'(" = "));write(txt,w_out_expected_prev);
	writeline(output,txt);
	write(txt,string'("| real "));write(txt,w_out_name);write(txt,string'(" = "));write(txt,w_out_prev);
	writeline(output,txt);
	i := i + 1;
END IF;
IF ( w_out_expected_prev /= "XXXXXXXX" ) AND (w_out_expected_prev /= "UUUUUUUU" ) AND (w_out_prev /= w_out_expected_prev) AND (
	(w_out_expected_prev /= last_w_out_exp) OR
	(on_first_change(1) = '1')
		) THEN
	throw_error("w_out",w_out_expected_prev,w_out_prev);
	num_mismatches(0) <= num_mismatches(0) + 1;
	on_first_change(1) := '0';
	last_w_out_exp := w_out_expected_prev;
END IF;
    trigger_i <= NOT trigger_i;
END PROCESS t_prcs_selfcheck;


t_prcs_trigger_res : PROCESS(trigger_e,trigger_i,trigger_r)
BEGIN
	trigger <= trigger_i XOR trigger_e XOR trigger_r;
END PROCESS t_prcs_trigger_res;

t_prcs_endsim : PROCESS
VARIABLE txt : LINE;
VARIABLE total_mismatches : INTEGER := 0;
BEGIN
WAIT FOR 1000000 ps;
total_mismatches := num_mismatches(0);
IF (total_mismatches = 0) THEN                                              
        write(txt,string'("Simulation passed !"));                        
        writeline(output,txt);                                              
ELSE                                                                        
        write(txt,total_mismatches);                                        
        write(txt,string'(" mismatched vectors : Simulation failed !"));  
        writeline(output,txt);                                              
END IF;                                                                     
WAIT;
END PROCESS t_prcs_endsim;

END ovec_arch;

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

LIBRARY STD;                                                            
USE STD.textio.ALL;                                                     

USE WORK.W_reg_vhd_tb_types.ALL;                                         

ENTITY W_reg_vhd_vec_tst IS
END W_reg_vhd_vec_tst;
ARCHITECTURE W_reg_arch OF W_reg_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk_in : STD_LOGIC;
SIGNAL d_in : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL nrst : STD_LOGIC;
SIGNAL w_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL wren : STD_LOGIC;
SIGNAL sampler : sample_type;

COMPONENT W_reg
	PORT (
	clk_in : IN STD_LOGIC;
	d_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	nrst : IN STD_LOGIC;
	w_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	wren : IN STD_LOGIC
	);
END COMPONENT;
COMPONENT W_reg_vhd_check_tst
PORT ( 
	w_out : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	sampler : IN sample_type
);
END COMPONENT;
COMPONENT W_reg_vhd_sample_tst
PORT (
	clk_in : IN STD_LOGIC;
	d_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	nrst : IN STD_LOGIC;
	wren : IN STD_LOGIC;
	sampler : OUT sample_type
	);
END COMPONENT;
BEGIN
	i1 : W_reg
	PORT MAP (
-- list connections between master ports and signals
	clk_in => clk_in,
	d_in => d_in,
	nrst => nrst,
	w_out => w_out,
	wren => wren
	);

-- nrst
t_prcs_nrst: PROCESS
BEGIN
	nrst <= '0';
	WAIT FOR 10000 ps;
	nrst <= '1';
	WAIT FOR 40000 ps;
	nrst <= '0';
WAIT;
END PROCESS t_prcs_nrst;

-- clk_in
t_prcs_clk_in: PROCESS
BEGIN
	FOR i IN 1 TO 5
	LOOP
		clk_in <= '0';
		WAIT FOR 5000 ps;
		clk_in <= '1';
		WAIT FOR 5000 ps;
	END LOOP;
	clk_in <= '0';
	WAIT FOR 5000 ps;
	clk_in <= '1';
	WAIT FOR 5000 ps;
	clk_in <= '0';
WAIT;
END PROCESS t_prcs_clk_in;
-- d_in[7]
t_prcs_d_in_7: PROCESS
BEGIN
	d_in(7) <= '1';
	WAIT FOR 40000 ps;
	d_in(7) <= '0';
	WAIT FOR 10000 ps;
	d_in(7) <= '1';
	WAIT FOR 10000 ps;
	d_in(7) <= '0';
WAIT;
END PROCESS t_prcs_d_in_7;
-- d_in[6]
t_prcs_d_in_6: PROCESS
BEGIN
	d_in(6) <= '0';
	WAIT FOR 10000 ps;
	d_in(6) <= '1';
	WAIT FOR 30000 ps;
	d_in(6) <= '0';
WAIT;
END PROCESS t_prcs_d_in_6;
-- d_in[5]
t_prcs_d_in_5: PROCESS
BEGIN
	d_in(5) <= '1';
	WAIT FOR 10000 ps;
	d_in(5) <= '0';
	WAIT FOR 10000 ps;
	d_in(5) <= '1';
	WAIT FOR 10000 ps;
	d_in(5) <= '0';
	WAIT FOR 10000 ps;
	d_in(5) <= '1';
	WAIT FOR 20000 ps;
	d_in(5) <= '0';
WAIT;
END PROCESS t_prcs_d_in_5;
-- d_in[4]
t_prcs_d_in_4: PROCESS
BEGIN
	d_in(4) <= '0';
	WAIT FOR 20000 ps;
	d_in(4) <= '1';
	WAIT FOR 10000 ps;
	d_in(4) <= '0';
	WAIT FOR 10000 ps;
	d_in(4) <= '1';
	WAIT FOR 10000 ps;
	d_in(4) <= '0';
WAIT;
END PROCESS t_prcs_d_in_4;
-- d_in[3]
t_prcs_d_in_3: PROCESS
BEGIN
	d_in(3) <= '1';
	WAIT FOR 20000 ps;
	d_in(3) <= '0';
	WAIT FOR 10000 ps;
	d_in(3) <= '1';
	WAIT FOR 10000 ps;
	d_in(3) <= '0';
	WAIT FOR 10000 ps;
	d_in(3) <= '1';
	WAIT FOR 10000 ps;
	d_in(3) <= '0';
WAIT;
END PROCESS t_prcs_d_in_3;
-- d_in[2]
t_prcs_d_in_2: PROCESS
BEGIN
	d_in(2) <= '0';
	WAIT FOR 10000 ps;
	d_in(2) <= '1';
	WAIT FOR 10000 ps;
	d_in(2) <= '0';
	WAIT FOR 10000 ps;
	d_in(2) <= '1';
	WAIT FOR 10000 ps;
	d_in(2) <= '0';
WAIT;
END PROCESS t_prcs_d_in_2;
-- d_in[1]
t_prcs_d_in_1: PROCESS
BEGIN
	d_in(1) <= '1';
	WAIT FOR 10000 ps;
	d_in(1) <= '0';
	WAIT FOR 30000 ps;
	d_in(1) <= '1';
	WAIT FOR 20000 ps;
	d_in(1) <= '0';
WAIT;
END PROCESS t_prcs_d_in_1;
-- d_in[0]
t_prcs_d_in_0: PROCESS
BEGIN
	d_in(0) <= '0';
	WAIT FOR 40000 ps;
	d_in(0) <= '1';
	WAIT FOR 10000 ps;
	d_in(0) <= '0';
WAIT;
END PROCESS t_prcs_d_in_0;

-- wren
t_prcs_wren: PROCESS
BEGIN
	wren <= '1';
	WAIT FOR 30000 ps;
	wren <= '0';
	WAIT FOR 20000 ps;
	wren <= '1';
	WAIT FOR 10000 ps;
	wren <= '0';
WAIT;
END PROCESS t_prcs_wren;
tb_sample : W_reg_vhd_sample_tst
PORT MAP (
	clk_in => clk_in,
	d_in => d_in,
	nrst => nrst,
	wren => wren,
	sampler => sampler
	);

tb_out : W_reg_vhd_check_tst
PORT MAP (
	w_out => w_out,
	sampler => sampler
	);
END W_reg_arch;
