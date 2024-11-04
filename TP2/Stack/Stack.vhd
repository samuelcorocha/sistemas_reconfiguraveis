LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY Stack IS
	PORT (
		-- INPUT
		nrst : IN STD_LOGIC; -- RESET
		clk_in : IN STD_LOGIC; -- CLOCK
		stack_in : IN STD_LOGIC_VECTOR(12 DOWNTO 0); -- DATA INPUT
		stack_push : IN STD_LOGIC; -- PUSH
		stack_pop : IN STD_LOGIC; -- POP
		
		-- OUTPUT
		stack_out : OUT STD_LOGIC_VECTOR(12 DOWNTO 0) -- OUTPUT DATA
	);
END Stack;

ARCHITECTURE Behavioral OF Stack IS
    -- Internal signal representing the stack of 8 registers, each 13 bits wide
    TYPE stack_mem IS ARRAY (7 DOWNTO 0) OF STD_LOGIC_VECTOR(12 DOWNTO 0);
    SIGNAL stack_reg : stack_mem := (OTHERS => (OTHERS => '0'));
BEGIN
    PROCESS(nrst, clk_in)
    BEGIN
        IF nrst = '0' THEN
            -- Reset to 0
            stack_reg <= (OTHERS => (OTHERS => '0'));
        ELSIF RISING_EDGE(clk_in) THEN
            IF stack_pop = '1' THEN
                -- Pop stack
                stack_reg(0) <= stack_reg(1);
                stack_reg(1) <= stack_reg(2);
                stack_reg(2) <= stack_reg(3);
                stack_reg(3) <= stack_reg(4);
                stack_reg(4) <= stack_reg(5);
                stack_reg(5) <= stack_reg(6);
                stack_reg(6) <= stack_reg(7);
                stack_reg(7) <= (OTHERS => '0');
            ELSIF stack_push = '1' THEN
                -- Push stack
                stack_reg(7) <= stack_reg(6);
                stack_reg(6) <= stack_reg(5);
                stack_reg(5) <= stack_reg(4);
                stack_reg(4) <= stack_reg(3);
                stack_reg(3) <= stack_reg(2);
                stack_reg(2) <= stack_reg(1);
                stack_reg(1) <= stack_reg(0);
                stack_reg(0) <= stack_in;
            END IF;
        END IF;
    END PROCESS;

    -- Output stack
    stack_out <= stack_reg(0);
END Behavioral;
