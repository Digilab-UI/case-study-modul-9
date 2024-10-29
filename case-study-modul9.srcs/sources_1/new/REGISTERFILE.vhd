----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 10/08/2024 11:02:23 PM
-- Design Name:
-- Module Name: REGISTERFILE - Behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
-- library UNISIM;
-- use UNISIM.VComponents.all;

entity registerfile is
  port (
    cpu_clk                      : in std_logic;
    cpu_enable                   : in std_logic;
    write_enable_in              : in std_logic;
    register_addr_dest_data_in   : in std_logic_vector(3 downto 0);
    register_addr_src_data_in    : in std_logic_vector(3 downto 0);
    register_value_dest_data_in  : in std_logic_vector(7 downto 0);
    register_value_src_data_in   : in std_logic_vector(7 downto 0);
    register_value_dest_data_out : out std_logic_vector(7 downto 0);
    register_value_src_data_out  : out std_logic_vector(7 downto 0)
  );
end entity registerfile;

architecture behavioral of registerfile is

  type register_file is array (0 to 15) of std_logic_vector(7 downto 0);
  signal registers : register_file := (
      0 => "00000011",  -- 3 in binary
      1 => "00000100",  -- 4 in binary
      2 => "00001011",  -- 5 in binary
      others => (others => '0')
  );

begin

  process (cpu_clk) is
  begin
    if rising_edge(cpu_clk) then
      if (cpu_enable = '1') then
        -- if read, which is indicated by write_enable_in = '0'
        case write_enable_in is
          when '0' =>
            register_value_dest_data_out <= registers(to_integer(unsigned(register_addr_dest_data_in)));
            register_value_src_data_out  <= registers(to_integer(unsigned(register_addr_src_data_in)));
            -- give alert
            report "Read from register file" severity note;
          when '1' =>
            -- registers(to_integer(unsigned(register_addr_dest_data_in))) <= register_value_dest_data_in;
            registers(to_integer(unsigned(register_addr_dest_data_in))) <= register_value_dest_data_in;
            registers(to_integer(unsigned(register_addr_src_data_in)))  <= register_value_src_data_in;
            -- give alert
            report "Write to register file" severity note;
          when others =>
            -- handle unexpected values if necessary
            report "Unexpected value for write_enable_in" severity error;
        end case;
      end if;
    end if;
  end process;

end architecture behavioral;