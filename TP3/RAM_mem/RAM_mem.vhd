LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY RAM_mem IS
    PORT (
        -- INPUT
        nrst     : IN STD_LOGIC;                      -- RESET
        clk_in   : IN STD_LOGIC;                      -- CLOCK
        abus_in  : IN STD_LOGIC_VECTOR(8 DOWNTO 0);   -- ADDRESS INPUT
        dbus_in  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);   -- DATA TO WRITE
        wr_en    : IN STD_LOGIC;                      -- ENABLE WRITE
        rd_en    : IN STD_LOGIC;                      -- ENABLE READ
        
        -- OUTPUT
        dbus_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)   -- DATA READED
    );
END RAM_mem;

ARCHITECTURE Behavioral OF RAM_mem IS
    -- MEMORY DEFINITION
    TYPE memory_array IS ARRAY (0 TO 79) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL mem0    : memory_array := (OTHERS => (OTHERS => '0'));
    SIGNAL mem1    : memory_array := (OTHERS => (OTHERS => '0'));
    SIGNAL mem2    : memory_array := (OTHERS => (OTHERS => '0'));
    SIGNAL mem_com : ARRAY (0 TO 15) OF STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => (OTHERS => '0'));

    SIGNAL addr_index : INTEGER;
BEGIN
    -- nrst and clk_in
    PROCESS(nrst, clk_in)
    BEGIN
        -- RESET
        IF nrst = '0' THEN
            mem0 <= (OTHERS => (OTHERS => '0'));
            mem1 <= (OTHERS => (OTHERS => '0'));
            mem2 <= (OTHERS => (OTHERS => '0'));
            mem_com <= (OTHERS => (OTHERS => '0'));
        
        -- WRITE
        ELSIF rising_edge(clk_in) THEN
            IF wr_en = '1' THEN
                -- MEMORY DECODIFICATION
                addr_index := CONV_INTEGER(abus_in(6 DOWNTO 0));
                
                CASE abus_in(8 DOWNTO 5) IS
                    WHEN "000" => -- mem0: 0x020 - 0x06F
                        IF addr_index < 80 THEN
                            mem0(addr_index) <= dbus_in;
                        END IF;
                        
                    WHEN "010" => -- mem1: 0x0A0 - 0x0EF
                        IF addr_index < 80 THEN
                            mem1(addr_index) <= dbus_in;
                        END IF;
                        
                    WHEN "100" => -- mem2: 0x120 - 0x16F
                        IF addr_index < 80 THEN
                            mem2(addr_index) <= dbus_in;
                        END IF;
                        
                    WHEN "001" | "011" | "101" | "111" => -- mem_com: 0x070 - 0x07F and alternatives
                        IF addr_index < 16 THEN
                            mem_com(addr_index) <= dbus_in;
                        END IF;
                        
                    WHEN OTHERS => NULL;
                END CASE;
            END IF;
        END IF;
    END PROCESS;

    -- MEMORY READ
    PROCESS(abus_in, rd_en)
    BEGIN
        IF rd_en = '1' THEN
            addr_index := CONV_INTEGER(abus_in(6 DOWNTO 0));
            
            CASE abus_in(8 DOWNTO 5) IS
                WHEN "000" => -- READ mem0
                    IF addr_index < 80 THEN
                        dbus_out <= mem0(addr_index);
                    ELSE
                        dbus_out <= (OTHERS => 'Z');
                    END IF;
                    
                WHEN "010" => -- READ mem1
                    IF addr_index < 80 THEN
                        dbus_out <= mem1(addr_index);
                    ELSE
                        dbus_out <= (OTHERS => 'Z');
                    END IF;
                    
                WHEN "100" => -- READ mem2
                    IF addr_index < 80 THEN
                        dbus_out <= mem2(addr_index);
                    ELSE
                        dbus_out <= (OTHERS => 'Z');
                    END IF;
                    
                WHEN "001" | "011" | "101" | "111" => -- READ mem_com
                    IF addr_index < 16 THEN
                        dbus_out <= mem_com(addr_index);
                    ELSE
                        dbus_out <= (OTHERS => 'Z');
                    END IF;
                    
                WHEN OTHERS => 
                    dbus_out <= (OTHERS => 'Z');
            END CASE;
        ELSE
            dbus_out <= (OTHERS => 'Z');
        END IF;
    END PROCESS;

END Behavioral;
