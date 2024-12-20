library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RAM_mem is
    port (
        nrst       : in  STD_LOGIC;
        clk_in     : in  STD_LOGIC;
        abus_in    : in  STD_LOGIC_VECTOR(8 downto 0);
        dbus_in    : in  STD_LOGIC_VECTOR(7 downto 0);
        wr_en      : in  STD_LOGIC;
        rd_en      : in  STD_LOGIC;
        dbus_out   : out STD_LOGIC_VECTOR(7 downto 0)
    );
end RAM_mem;

architecture Behavioral of RAM_mem is
    -- MEMORY TYPE
    type memory_array is array(0 to 79) of STD_LOGIC_VECTOR(7 downto 0);
    type memory_array_com is array(0 to 15) of STD_LOGIC_VECTOR(7 downto 0);
    
    -- MEMORY
    signal mem0 : memory_array := (others => (others => '0'));
    signal mem1 : memory_array := (others => (others => '0'));
    signal mem2 : memory_array := (others => (others => '0'));
    signal mem_com : memory_array_com := (others => (others => '0'));

   
    signal addr_index : integer;
begin
    -- WRITE
    process(clk_in, nrst)
    variable addr_index_var : integer;
    begin
        if nrst = '0' then
            -- Reset
            mem0 <= (others => (others => '0'));
            mem1 <= (others => (others => '0'));
            mem2 <= (others => (others => '0'));
            mem_com <= (others => (others => '0'));
        elsif rising_edge(clk_in) then
            if wr_en = '1' then
                
                addr_index_var := conv_integer(abus_in(6 downto 0));
                if abus_in(8 downto 5) = "0000" and addr_index_var < 80 then
                    mem0(addr_index_var) <= dbus_in;
                elsif abus_in(8 downto 5) = "0010" and addr_index_var < 80 then
                    mem1(addr_index_var) <= dbus_in;
                elsif abus_in(8 downto 5) = "0100" and addr_index_var < 80 then
                    mem2(addr_index_var) <= dbus_in;
                elsif abus_in(8 downto 5) = "0001" and addr_index_var < 16 then
                    mem_com(addr_index_var) <= dbus_in;
                elsif abus_in(8 downto 5) = "0011" and addr_index_var < 16 then
                    mem_com(addr_index_var) <= dbus_in;
                elsif abus_in(8 downto 5) = "0101" and addr_index_var < 16 then
                    mem_com(addr_index_var) <= dbus_in;
                elsif abus_in(8 downto 5) = "0111" and addr_index_var < 16 then
                    mem_com(addr_index_var) <= dbus_in;
                end if;
            end if;
        end if;
    end process;

    -- READ
    process(rd_en, abus_in)
    variable addr_index_var : integer; 
    begin
        addr_index_var := conv_integer(abus_in(6 downto 0)); 
        if rd_en = '1' then
            case abus_in(8 downto 5) is
                when "0000" => -- mem0: 0x020 - 0x06F
                    if addr_index_var < 80 then
                        dbus_out <= mem0(addr_index_var);
                    else
                        dbus_out <= (others => 'Z');
                    end if;

                when "0010" => -- mem1: 0x0A0 - 0x0EF
                    if addr_index_var < 80 then
                        dbus_out <= mem1(addr_index_var);
                    else
                        dbus_out <= (others => 'Z');
                    end if;

                when "0100" => -- mem2: 0x120 - 0x16F
                    if addr_index_var < 80 then
                        dbus_out <= mem2(addr_index_var);
                    else
                        dbus_out <= (others => 'Z');
                    end if;

                when "0001" | "0011" | "0101" | "0111" => -- mem_com: 0x070 - 0x07F e alternativos
                    if addr_index_var < 16 then
                        dbus_out <= mem_com(addr_index_var);
                    else
                        dbus_out <= (others => 'Z');
                    end if;

                when others =>
                    dbus_out <= (others => 'Z');
            end case;
        else
            dbus_out <= (others => 'Z');
        end if;
    end process;
end Behavioral;
