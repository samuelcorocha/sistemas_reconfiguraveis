library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity addr_mux is
    Port (
        rp_in : in STD_LOGIC_VECTOR(1 downto 0);
        dir_addr_in : in STD_LOGIC_VECTOR(6 downto 0);
        irp_in : in STD_LOGIC;
        ind_addr_in : in STD_LOGIC_VECTOR(7 downto 0);
        abus_out : out STD_LOGIC_VECTOR(8 downto 0)
    );
end addr_mux;

architecture Behavioral of addr_mux is
begin
    abus_out <= irp_in & ind_addr_in when dir_addr_in = "0000000"
                else rp_in & dir_addr_in;
end Behavioral;