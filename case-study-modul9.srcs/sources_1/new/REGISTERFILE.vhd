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
    cpu_clk                : in    std_logic;
    cpu_enable             : in    std_logic;
    write_enable_in        : in    std_logic;
    register_dest_data_out : out   std_logic_vector(3 downto 0);
    register_src_data_out  : out   std_logic_vector(3 downto 0);
    register_dest_data_in  : in    std_logic_vector(3 downto 0);
    register_src_data_in   : in    std_logic_vector(3 downto 0)
  );
end entity registerfile;

architecture behavioral of registerfile is

  type register_file is array (0 to 15) of std_logic_vector(3 downto 0);
  signal registers : register_file := (others => (others => '0'));

begin

  process (cpu_clk) is
  begin
    if rising_edge(cpu_clk) then
      if (cpu_enable = '1') then
        if (write_enable_in = '1') then
          registers(to_integer(unsigned(register_dest_data_in))) <= register_src_data_in;
        end if;
      end if;
    end if;
  end process;

  register_dest_data_out <= registers(to_integer(unsigned(register_dest_data_in)));
  register_src_data_out  <= registers(to_integer(unsigned(register_src_data_in)));

end architecture behavioral;