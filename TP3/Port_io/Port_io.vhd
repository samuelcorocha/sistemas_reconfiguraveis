LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY port_io IS
    PORT (
        -- INPUT
        nrst      : IN STD_LOGIC;                      -- RESET
        clk_in    : IN STD_LOGIC;                      -- CLOCK
        abus_in   : IN STD_LOGIC_VECTOR(8 DOWNTO 0);   -- ADDRESS INPUT
        dbus_in   : IN STD_LOGIC_VECTOR(7 DOWNTO 0);   -- DATA TO WRITE
        wr_en     : IN STD_LOGIC;                      -- ENABLE WRITE
        rd_en     : IN STD_LOGIC;                      -- ENABLE READ
        port_io   : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);-- TWO-WAY PORT
        
        -- OUTPUT
        dbus_out  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)   -- DATA READED
    );
END port_io;

ARCHITECTURE Behavioral OF port_io IS
    SIGNAL port_reg : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0'); -- REG DATA OUTPUT
    SIGNAL tris_reg : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '1'); -- REG DIRECTION CONTROL
BEGIN
    -- WRITE port_reg AND tris_reg
    PROCESS(nrst, clk_in)
    BEGIN
        IF nrst = '0' THEN
            -- RESET
            port_reg <= (OTHERS => '0');
            tris_reg <= (OTHERS => '1');
        ELSIF rising_edge(clk_in) THEN
            IF wr_en = '1' THEN
                -- WRITE port_reg
                IF abus_in(6 DOWNTO 0) = "0000100" THEN
                    port_reg <= dbus_in;
                -- WRITE tris_reg
                ELSIF abus_in(6 DOWNTO 0) = "0001010" THEN
                    tris_reg <= dbus_in;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- READ to dbus_out
    dbus_out <= port_reg WHEN (rd_en = '1' AND abus_in(6 DOWNTO 0) = "0000100") ELSE
                tris_reg WHEN (rd_en = '1' AND abus_in(6 DOWNTO 0) = "0001010") ELSE
                (OTHERS => 'Z');

    -- TWO-WAY port_io
    port_io <= port_reg WHEN tris_reg = "00000000" ELSE (OTHERS => 'Z');

END Behavioral;
