----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 10/08/2024 11:01:55 PM
-- Design Name:
-- Module Name: ALU - Behavioral
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

entity alu is
    port (
        cpu_clk         : in    std_logic;
        cpu_enable      : in    std_logic;
        opcode          : in    std_logic_vector(3 downto 0);
        operand1        : in    std_logic_vector(3 downto 0);
        operand2        : in    std_logic_vector(3 downto 0);
        result          : out   std_logic_vector(3 downto 0)
    );
end entity alu;

architecture behavioral of alu is

begin

    process (cpu_clk, cpu_enable, opcode, operand1, operand2) is
    begin
        if rising_edge(cpu_clk) then
            if cpu_enable = '1' then
                case opcode is
                    when "0000" =>
                        result <= std_logic_vector(unsigned(operand1) + unsigned(operand2));
                    when "0001" =>
                        result <= std_logic_vector(unsigned(operand1) - unsigned(operand2));
                    when others =>
                        result <= (others => '0');
                end case;
            end if;
        end if;
    end process;

end architecture behavioral;