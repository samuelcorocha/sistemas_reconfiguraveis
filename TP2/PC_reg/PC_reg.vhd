LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY PC_reg IS
    PORT (
        -- Entradas
        nrst       : IN STD_LOGIC;                    -- RESET
        clk_in     : IN STD_LOGIC;                    -- CLOCK
        addr_in    : IN STD_LOGIC_VECTOR(10 DOWNTO 0);-- DATA INPUT
        abus_in    : IN STD_LOGIC_VECTOR(8 DOWNTO 0); -- ADDRESS INPUT
        dbus_in    : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- DATA TO WRITE
        inc_pc     : IN STD_LOGIC;                    -- INCREMENTS PC
        load_pc    : IN STD_LOGIC;                    -- LOAD PC
        wr_en      : IN STD_LOGIC;                    -- ENABLE WRITE
        rd_en      : IN STD_LOGIC;                    -- ENABLE READ
        stack_push : IN STD_LOGIC;                    -- STACK PUSH
        stack_pop  : IN STD_LOGIC;                    -- STACK POP
        stack_in   : IN STD_LOGIC_VECTOR(12 DOWNTO 0);-- STACK DATA INPUT
        stack_out  : OUT STD_LOGIC_VECTOR(12 DOWNTO 0);-- STACK DATA OUTPUT

        -- Saídas
        nextpc_out : OUT STD_LOGIC_VECTOR(12 DOWNTO 0); -- NEXT PC 
        dbus_out   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)   -- DATA READED
    );
END PC_reg;

ARCHITECTURE Behavioral OF PC_reg IS
    SIGNAL pc        : STD_LOGIC_VECTOR(12 DOWNTO 0); -- REGISTER PC 13b
    SIGNAL pclath    : STD_LOGIC_VECTOR(7 DOWNTO 0);  -- REGISTER PCLATH 8b
    SIGNAL next_value: STD_LOGIC_VECTOR(12 DOWNTO 0); -- NEXT PC VALUE
BEGIN
    PROCESS(nrst, clk_in)
    BEGIN
        IF nrst = '0' THEN
            pc <= (OTHERS => '0');
            pclath <= (OTHERS => '0');
            next_value <= (OTHERS => '0');
        ELSIF RISING_EDGE(clk_in) THEN
            -- stack_pop
            IF stack_pop = '1' THEN
                next_value <= stack_in;

            -- inc_pc
            ELSIF inc_pc = '1' THEN
                next_value <= pc + 1;

            -- load_pc
            ELSIF load_pc = '1' THEN
                next_value(10 DOWNTO 0) <= addr_in;
                next_value(12 DOWNTO 11) <= pclath(4 DOWNTO 3);

            -- wr_en
            ELSIF wr_en = '1' THEN
                IF abus_in(6 DOWNTO 0) = "0000010" THEN
                    next_value(7 DOWNTO 0) <= dbus_in;
                    next_value(12 DOWNTO 8) <= pclath(4 DOWNTO 0);
                ELSIF abus_in(6 DOWNTO 0) = "0001010" THEN
                    pclath <= dbus_in;
                    next_value <= pc; 
                ELSE
                    next_value <= pc;
                END IF;
            ELSE
                next_value <= pc; 
            END IF;

            -- next_value
            pc <= next_value;

            -- stack_push
            IF stack_push = '1' THEN
                stack_out <= next_value;
            END IF;
        END IF;
    END PROCESS;

    -- nextpc_out
    nextpc_out <= next_value;

    -- dbus_out
    dbus_out <= pc(7 DOWNTO 0) WHEN (rd_en = '1' AND abus_in(6 DOWNTO 0) = "0000010") ELSE
                pclath WHEN (rd_en = '1' AND abus_in(6 DOWNTO 0) = "0001010") ELSE
                (OTHERS => 'Z');
END Behavioral;
