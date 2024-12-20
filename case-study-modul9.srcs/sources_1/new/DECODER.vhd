----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 10/08/2024 11:02:07 PM
-- Design Name:
-- Module Name: DECODER - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
-- library UNISIM;
-- use UNISIM.VComponents.all;

entity decoder is
  port (
    cpu_clk       : in std_logic;
    cpu_enable    : in std_logic;
    instruction   : in std_logic_vector(15 downto 0);
    opcode        : out std_logic_vector(3 downto 0);
    address_flag  : out std_logic;
    negative_flag : out std_logic;
    operand1      : out std_logic_vector(3 downto 0);
    operand2      : out std_logic_vector(5 downto 0)
  );
end entity decoder;

architecture behavioral of decoder is

begin

  decode_instruction : process (instruction, cpu_enable) is
  begin
    if cpu_enable = '1' then
      opcode        <= instruction(15 downto 12);
      address_flag  <= instruction(11);
      negative_flag <= instruction(10);
      operand1      <= instruction(9 downto 6);
      operand2      <= instruction(5 downto 0);
    else
      opcode        <= (others => '0');
      address_flag  <= '0';
      negative_flag <= '0';
      operand1      <= (others => '0');
      operand2      <= (others => '0');
    end if;
  end process decode_instruction;

end architecture behavioral;
