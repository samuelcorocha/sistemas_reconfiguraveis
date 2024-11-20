library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Port_io is
    generic (
        port_addr     : STD_LOGIC_VECTOR(8 downto 0) := "000000000"; -- ADDRESS TO port_reg
        tris_addr     : STD_LOGIC_VECTOR(8 downto 0) := "000000001"; -- ADDRESS TO tris_reg
        alt_port_addr : STD_LOGIC_VECTOR(8 downto 0) := "000000000"; -- COPYING port_reg
        alt_tris_addr : STD_LOGIC_VECTOR(8 downto 0) := "000000001"  -- COPYING tris_reg
    );
    port (
        nrst       : in  STD_LOGIC;                      -- RESET
        clk_in     : in  STD_LOGIC;                      -- CLOCK
        abus_in    : in  STD_LOGIC_VECTOR(8 downto 0);   -- ADDRESS INPUT
        dbus_in    : in  STD_LOGIC_VECTOR(7 downto 0);   -- DATA TO WRITE
        wr_en      : in  STD_LOGIC;                      -- ENABLE WRITE
        rd_en      : in  STD_LOGIC;                      -- ENABLE READ
        dbus_out   : out STD_LOGIC_VECTOR(7 downto 0);   -- TWO-WAY PORT
        port_io    : inout STD_LOGIC_VECTOR(7 downto 0)  -- DATA READED
    );
end Port_io;

architecture Behavioral of Port_io is
    signal port_reg : STD_LOGIC_VECTOR(7 downto 0) := (others => '0'); -- REG DATA OUTPUT
    signal tris_reg : STD_LOGIC_VECTOR(7 downto 0) := (others => '1'); -- REG DIRECTION CONTROL (1 = in, 0 = out)
    signal latch    : STD_LOGIC_VECTOR(7 downto 0);                    -- LACTH 
begin
    -- WRITE port_reg AND tris_reg
    process(nrst, clk_in)
    begin
        if nrst = '0' then
            port_reg <= (others => '0');
            tris_reg <= (others => '1');
        elsif rising_edge(clk_in) then
            if wr_en = '1' then
                if abus_in = tris_addr or abus_in = alt_tris_addr then
                    tris_reg <= dbus_in;
                elsif abus_in = port_addr or abus_in = alt_port_addr then
                    port_reg <= dbus_in;
                end if;
            end if;
        end if;
    end process;

    -- READ
    process(rd_en, abus_in, tris_reg, port_reg, port_io)
    begin
        if rd_en = '1' then
            if abus_in = tris_addr or abus_in = alt_tris_addr then
                dbus_out <= tris_reg;
            elsif abus_in = port_addr or abus_in = alt_port_addr then
                latch <= port_io; -- Captura o valor da porta
                dbus_out <= latch;
            else
                dbus_out <= (others => 'Z');
            end if;
        else
            dbus_out <= (others => 'Z');
        end if;
    end process;

    -- -- TWO-WAY port_io (Bit to Bit)
    gen_port_io: for i in 0 to 7 generate
        port_io(i) <= port_reg(i) when tris_reg(i) = '0' else 'Z';
    end generate gen_port_io;
end Behavioral;
