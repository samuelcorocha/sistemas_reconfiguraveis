LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Control IS
	PORT (

		nrst, clk, alu_z : IN STD_LOGIC;
		instr : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		wr_z_en, wr_dc_en, wr_c_en, wr_w_reg_en, wr_en, rd_en, load_pc, inc_pc, stack_push, stack_pop, lit_sel : OUT STD_LOGIC;
		op_sel : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
		bit_sel : OUT STD_LOGIC_VECTOR (2 DOWNTO 0)

	);
END ENTITY;

ARCHITECTURE arch OF Control IS

	TYPE state_type IS (fetch_only, fetch_decod_exec, rst);
	SIGNAL next_state : state_type;
	SIGNAL pres_state : state_type;

BEGIN
	PROCESS (clk, nrst)
	BEGIN
		IF nrst = '0' THEN
			pres_state <= rst;
		ELSIF RISING_EDGE(clk) THEN
			pres_state <= next_state;
		END IF;
	END PROCESS;

	PROCESS (nrst, pres_state, instr, alu_z)
	BEGIN

		op_sel <= "0000";
		bit_sel <= "000";
		wr_z_en <= '0';
		wr_dc_en <= '0';
		wr_c_en <= '0';
		wr_w_reg_en <= '0';
		wr_en <= '0';
		rd_en <= '0';
		load_pc <= '0';
		inc_pc <= '0';
		stack_push <= '0';
		stack_pop <= '0';
		lit_sel <= '0';

		next_state <= rst;

		IF pres_state = rst THEN
			IF nrst = '1' THEN
				next_state <= fetch_only;
			ELSIF nrst = '0' THEN
				next_state <= rst;
			END IF;

		ELSIF pres_state = fetch_only THEN
			IF nrst = '1' THEN
				next_state <= fetch_decod_exec;
				inc_pc <= '1';
			ELSIF nrst = '0' THEN
				next_state <= rst;
			END IF;

		ELSIF pres_state = fetch_decod_exec THEN
			IF nrst = '1' THEN
				IF instr(13 DOWNTO 12) = "00" THEN
					-- ADDWF
					IF instr(11 DOWNTO 8) = "0111" THEN
						next_state <= fetch_decod_exec;
						op_sel <= "0100";
						wr_z_en <= '1';
						wr_dc_en <= '1';
						wr_c_en <= '1';
						rd_en <= '1';
						inc_pc <= '1';
						IF instr(7) = '0' THEN
							wr_w_reg_en <= '1';
						ELSE
							wr_en <= '1';
						END IF;
						-- ANDDWF
					ELSIF instr(11 DOWNTO 8) = "0101" THEN
						next_state <= fetch_decod_exec;
						op_sel <= "0001";
						wr_z_en <= '1';
						rd_en <= '1';
						inc_pc <= '1';
						-- CLRF/CLRW
					ELSIF instr(11 DOWNTO 8) = "0001" THEN
						inc_pc <= '1';
						next_state <= fetch_decod_exec;
						op_sel <= "1011";
						-- CLRF
						IF instr(7) = '1' THEN
							wr_en <= '1';
							-- CLRW
						ELSE
							wr_w_reg_en <= '1';
						END IF;
						-- COMF
					ELSIF instr(11 DOWNTO 8) = "1001" THEN
						next_state <= fetch_decod_exec;
						op_sel <= "0011";
						wr_z_en <= '1';
						rd_en <= '1';
						inc_pc <= '1';
						IF instr(7) = '0' THEN
							wr_w_reg_en <= '1';
						ELSE
							wr_en <= '1';
						END IF;
						-- DECF
					ELSIF instr(11 DOWNTO 8) = "0011" THEN
						next_state <= fetch_decod_exec;
						op_sel <= "0111";
						wr_z_en <= '1';
						rd_en <= '1';
						inc_pc <= '1';
						IF instr(7) = '0' THEN
							wr_w_reg_en <= '1';
						ELSE
							wr_en <= '1';
						END IF;
						-- DECFSZ
					ELSIF instr(11 DOWNTO 8) = "1011" THEN
						IF alu_z = '1' THEN
							next_state <= fetch_only;
						ELSE
							next_state <= fetch_decod_exec;
						END IF;
						op_sel <= "0111";
						rd_en <= '1';
						inc_pc <= '1';
						IF instr(7) = '0' THEN
							wr_w_reg_en <= '1';
						ELSE
							wr_en <= '1';
						END IF;
						-- INCF
					ELSIF instr(11 DOWNTO 8) = "1010" THEN
						next_state <= fetch_decod_exec;
						op_sel <= "0110";
						wr_z_en <= '1';
						rd_en <= '1';
						inc_pc <= '1';
						IF instr(7) = '0' THEN
							wr_w_reg_en <= '1';
						ELSE
							wr_en <= '1';
						END IF;
						-- INCFSZ
					ELSIF instr(11 DOWNTO 8) = "1111" THEN
						IF alu_z = '1' THEN
							next_state <= fetch_only;
						ELSE
							next_state <= fetch_decod_exec;
						END IF;
						op_sel <= "0000";
						rd_en <= '1';
						inc_pc <= '1';
						IF instr(7) = '0' THEN
							wr_w_reg_en <= '1';
						ELSE
							wr_en <= '1';
						END IF;
						-- IORWF
					ELSIF instr(11 DOWNTO 8) = "0100" THEN
						next_state <= fetch_decod_exec;
						op_sel <= "0111";
						wr_z_en <= '1';
						inc_pc <= '1';
						IF instr(7) = '0' THEN
							wr_w_reg_en <= '1';
						ELSE
							wr_en <= '1';
						END IF;
						-- RLF
					ELSIF instr(11 DOWNTO 8) = "1101" THEN
						next_state <= fetch_decod_exec;
						op_sel <= "1001";
						wr_c_en <= '1';
						rd_en <= '1';
						inc_pc <= '1';
						IF instr(7) = '0' THEN
							wr_w_reg_en <= '1';
						ELSE
							wr_en <= '1';
						END IF;
						-- RRF
					ELSIF instr(11 DOWNTO 8) = "1100" THEN
						next_state <= fetch_decod_exec;
						op_sel <= "1000";
						wr_c_en <= '1';
						rd_en <= '1';
						inc_pc <= '1';
						IF instr(7) = '0' THEN
							wr_w_reg_en <= '1';
						ELSE
							wr_en <= '1';
						END IF;
						-- SUBWF
					ELSIF instr(11 DOWNTO 8) = "0010" THEN
						next_state <= fetch_decod_exec;
						op_sel <= "0101";
						wr_z_en <= '1';
						wr_c_en <= '1';
						wr_dc_en <= '1';
						rd_en <= '1';
						inc_pc <= '1';
						IF instr(7) = '0' THEN
							wr_w_reg_en <= '1';
						ELSE
							wr_en <= '1';
						END IF;
						-- SWAPF
					ELSIF instr(11 DOWNTO 8) = "1110" THEN
						next_state <= fetch_decod_exec;
						op_sel <= "1010";
						wr_z_en <= '1';
						rd_en <= '1';
						inc_pc <= '1';
						IF instr(7) = '0' THEN
							wr_w_reg_en <= '1';
						ELSE
							wr_en <= '1';
						END IF;
						-- XORWF
					ELSIF instr(11 DOWNTO 8) = "0110" THEN
						next_state <= fetch_decod_exec;
						op_sel <= "0010";
						wr_z_en <= '1';
						rd_en <= '1';
						inc_pc <= '1';
						IF instr(7) = '0' THEN
							wr_w_reg_en <= '1';
						ELSE
							wr_en <= '1';
						END IF;
						-- MOVF
					ELSIF instr(11 DOWNTO 8) = "1000" THEN
						next_state <= fetch_decod_exec;
						op_sel <= "1110";
						inc_pc <= '1';
						IF instr(7) = '0' THEN
							wr_w_reg_en <= '1';
						ELSE
							wr_en <= '1';
						END IF;
						-- MOVEWF/NOP/RETURN
					ELSIF instr(11 DOWNTO 8) = "0000" THEN
						-- MOVEWF
						IF instr(7) = '1' THEN
							next_state <= fetch_decod_exec;
							op_sel <= "1111";
							inc_pc <= '1';
							wr_en <= '1';
							-- RETURN
						ELSIF instr(6 DOWNTO 0) = "0001000" THEN
							next_state <= fetch_only;
							stack_pop <= '1';
							-- NOP/SLEEP/RETFIE/CLRWDT
						ELSE
							next_state <= fetch_decod_exec;
							inc_pc <= '1';
						END IF;
					END IF;
				ELSIF instr(13 DOWNTO 12) = "01" THEN
					-- BCF
					IF instr(11 DOWNTO 10) = "00" THEN
						next_state <= fetch_decod_exec;
						bit_sel <= instr(9 DOWNTO 7);
						op_sel <= "1100";
						wr_en <= '1';
						rd_en <= '1';
						inc_pc <= '1';
						-- BSF
					ELSIF instr(11 DOWNTO 10) = "01" THEN
						next_state <= fetch_decod_exec;
						bit_sel <= instr(9 DOWNTO 7);
						op_sel <= "1101";
						wr_en <= '1';
						rd_en <= '1';
						inc_pc <= '1';
						-- BTFSC
					ELSIF instr(11 DOWNTO 10) = "10" THEN
						IF alu_z = '1' THEN
							next_state <= fetch_only;
						ELSE
							next_state <= fetch_decod_exec;
						END IF;
						bit_sel <= instr(9 DOWNTO 7);
						op_sel <= "1100";
						rd_en <= '1';
						inc_pc <= '1';
						-- BTFSS
					ELSIF instr(11 DOWNTO 10) = "11" THEN
						IF alu_z = '1' THEN
							next_state <= fetch_only;
						ELSE
							next_state <= fetch_decod_exec;
						END IF;
						bit_sel <= instr(9 DOWNTO 7);
						op_sel <= "1101";
						rd_en <= '1';
						inc_pc <= '1';
					END IF;
				ELSIF instr(13 DOWNTO 12) = "10" THEN
					-- CALL
					IF instr(11) = '0' THEN
						next_state <= fetch_only;
						load_pc <= '1';
						stack_push <= '1';
						-- GOTO
					ELSIF instr(11) = '1' THEN
						next_state <= fetch_only;
						load_pc <= '1';
					END IF;
				ELSIF instr(13 DOWNTO 12) = "11" THEN
					-- ADDLW
					IF instr(11 DOWNTO 8) = "1110" OR instr(11 DOWNTO 8) = "1111" THEN
						next_state <= fetch_decod_exec;
						op_sel <= "0000";
						lit_sel <= '1';
						wr_w_reg_en <= '1';
						wr_z_en <= '1';
						wr_c_en <= '1';
						wr_dc_en <= '1';
						inc_pc <= '1';
						-- ANDLW
					ELSIF instr(11 DOWNTO 8) = "1001" THEN
						next_state <= fetch_decod_exec;
						op_sel <= "0001";
						lit_sel <= '1';
						wr_w_reg_en <= '1';
						wr_z_en <= '1';
						inc_pc <= '1';
						-- IORLW
					ELSIF instr(11 DOWNTO 8) = "1000" THEN
						next_state <= fetch_decod_exec;
						op_sel <= "0000";
						lit_sel <= '1';
						wr_w_reg_en <= '1';
						wr_z_en <= '1';
						inc_pc <= '1';
						-- MOVLW
					ELSIF instr(11 DOWNTO 8) = "0000" OR instr(11 DOWNTO 8) = "0001" OR instr(11 DOWNTO 8) = "0010" OR instr(11 DOWNTO 8) = "0011" THEN
						next_state <= fetch_decod_exec;
						op_sel <= "1110";
						lit_sel <= '1';
						wr_w_reg_en <= '1';
						inc_pc <= '1';
						-- RETLW
					ELSIF instr(11 DOWNTO 8) = "0100" OR instr(11 DOWNTO 8) = "0101" OR instr(11 DOWNTO 8) = "0110" OR instr(11 DOWNTO 8) = "0111" THEN
						next_state <= fetch_only;
						op_sel <= "1110";
						lit_sel <= '1';
						wr_w_reg_en <= '1';
						stack_pop <= '1';
						-- XORLW
					ELSIF instr(11 DOWNTO 8) = "1010" THEN
						next_state <= fetch_decod_exec;
						op_sel <= "0110";
						lit_sel <= '1';
						wr_w_reg_en <= '1';
						wr_z_en <= '1';
						inc_pc <= '1';
						-- SUBLW
					ELSIF instr(11 DOWNTO 8) = "1100" OR instr(11 DOWNTO 8) = "1101" THEN
						next_state <= fetch_decod_exec;
						op_sel <= "0001";
						lit_sel <= '1';
						wr_w_reg_en <= '1';
						wr_z_en <= '1';
						wr_c_en <= '1';
						wr_dc_en <= '1';
						inc_pc <= '1';
					END IF;
				END IF;
			ELSIF nrst = '0' THEN
				next_state <= rst;
			END IF;
		END IF;
	END PROCESS;
END arch;