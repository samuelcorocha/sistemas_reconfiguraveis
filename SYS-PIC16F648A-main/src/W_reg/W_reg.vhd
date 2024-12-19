LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY W_reg is
    PORT (
        nrst   : in STD_LOGIC;         				-- Entrada de reset ass�ncrono
        clk_in : in STD_LOGIC;         				-- Entrada de clock para escrita no registrador
        d_in   : in STD_LOGIC_VECTOR(7 downto 0); 	-- Entrada de dados para escrita no registrador
        wr_en  : in STD_LOGIC;         				-- Entrada de habilita��o para escrita no registrador
        
        w_out  : out STD_LOGIC_VECTOR(7 downto 0) 	-- Sa�da de dados
    );
END W_reg;

ARCHITECTURE arch OF W_reg IS
    SIGNAL reg_data : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0'); -- Registrador de 8 bits

BEGIN
    process (clk_in, nrst)
    BEGIN
        IF nrst = '0' THEN
            -- Reset ass�ncrono ativado, zera o registrador
            reg_data <= (OTHERS => '0');
        ELSIF RISING_EDGE(clk_in) THEN
            -- Verifica a borda de subida do clock
            IF wr_en = '1' THEN
                -- Se wr_en est� ativo, escreve os dados no registrador
                reg_data <= d_in;
            END IF;
        END IF;
    END process;

    -- Sa�da sempre ativa
    w_out <= reg_data;
END arch;