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
    cpu_clk    : in std_logic;
    cpu_enable : in std_logic;
    alu_enable : in std_logic;
    opcode     : in std_logic_vector(3 downto 0);
    input1     : in std_logic_vector(7 downto 0);
    input2     : in std_logic_vector(7 downto 0);
    result1    : out std_logic_vector(7 downto 0) := (others => '0');
    result2    : out std_logic_vector(7 downto 0) := (others => '0')
  );
end entity alu;

architecture behavioral of alu is

begin

  process (cpu_clk, cpu_enable, alu_enable, opcode, input1, input2) is
  begin
    if rising_edge(cpu_clk) then
      if cpu_enable = '1' and alu_enable = '1' then
        case opcode is
          when "0000" =>
          -- Addition
            result1 <= std_logic_vector(unsigned(input1) + unsigned(input2));
            result2 <= input2;
          when "0001" =>
          -- Subtraction
            result1 <=  std_logic_vector(unsigned(input1) - unsigned(input2));
            result2 <= input2;
          when "0010" =>
          -- Multiplication
            result1 <= std_logic_vector(resize(unsigned(input1) * unsigned(input2), 8));
            result2 <= input2;
          when "0011" =>
          -- Division
            result1 <= std_logic_vector(unsigned(input1) / unsigned(input2));
            result2 <= input2;
          when "0100" =>
          -- AND
            result1 <= std_logic_vector(unsigned(input1) and unsigned(input2));
            result2 <= input2;
          when "0101" =>
          -- OR
            result1 <= std_logic_vector(unsigned(input1) or unsigned(input2));
            result2 <= input2;
          when "0110" =>
          -- XOR
            result1 <= std_logic_vector(unsigned(input1) xor unsigned(input2));
            result2 <= input2;
          when "0111" =>
          -- NOT
            result1 <= std_logic_vector(not unsigned(input1));
            result2 <= input2;
          when "1000" =>
          -- Negative Addition 
            result1 <= std_logic_vector(unsigned(input1) + not unsigned(input2) + 1);
            result2 <= std_logic_vector(unsigned(input2) - 1);
          when "1001" => 
          -- Store Data
            result1 <= input2;
            result2 <= input2;
          -- when "1010" =>
          -- -- 
          --   result1 <=
          --   result2 <= 
          -- when "1011" =>
          -- -- 
          --   result1 <=
          --   result2 <= 
          -- when "1100" =>
          -- -- 
          --   result1 <=
          --   result2 <= 
          -- when "1101" =>
          -- -- 
          --   result1 <=
          --   result2 <= 
          -- when "1110" =>
          -- -- 
          --   result1 <=
          --   result2 <= 
          -- when "1111" =>
          -- -- 
          --   result1 <=
          --   result2 <= 
          when others        =>
            result1 <= (others => '0');
        end case;
      end if;
    end if;
  end process;

end architecture behavioral;