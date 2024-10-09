----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 10/08/2024 10:55:17 PM
-- Design Name:
-- Module Name: CPU - Behavioral
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

entity cpu is
  port (
    cpu_clk     : in    std_logic := '0';
    cpu_enable  : in    std_logic := '1';
    cpu_reset   : in    std_logic := '1';
    instruction : in    std_logic_vector(15 downto 0) := (others => '0')
  );
end entity cpu;

architecture behavioral of cpu is

  signal program_counter : integer   := 0;
  signal instruction_raw : std_logic_vector(15 downto 0) := (others => '0');
  signal opcode          : std_logic_vector(3 downto 0) := (others => '0');
  signal operand1        : std_logic_vector(3 downto 0) := (others => '0');
  signal operand2        : std_logic_vector(3 downto 0) := (others => '0');
  signal result          : std_logic_vector(3 downto 0) := (others => '0');
  signal write_enable_in : std_logic := '0';

  type state_type is (idle, fetch, decode, read, execute, write, complete);
  signal state : state_type := idle;

  component decoder is
    port (
      cpu_clk     : in    std_logic;
      cpu_enable  : in    std_logic;
      cpu_reset   : in    std_logic;
      instruction : in    std_logic_vector(15 downto 0);
      opcode      : out   std_logic_vector(3 downto 0);
      operand1    : out   std_logic_vector(3 downto 0);
      operand2    : out   std_logic_vector(3 downto 0)
    );
  end component decoder;

  component alu is
    port (
      cpu_clk  : in    std_logic;
      cpu_enable  : in    std_logic;
      opcode   : in    std_logic_vector(3 downto 0);
      operand1 : in    std_logic_vector(3 downto 0);
      operand2 : in    std_logic_vector(3 downto 0);
      result   : out   std_logic_vector(3 downto 0)
    );
  end component alu;

  component registerfile is
    port (
      cpu_clk                : in    std_logic;
      cpu_enable             : in    std_logic;
      write_enable_in        : in    std_logic;
      register_dest_data_out : out   std_logic_vector(3 downto 0);
      register_src_data_out  : out   std_logic_vector(3 downto 0);
      register_dest_data_in  : in    std_logic_vector(3 downto 0);
      register_src_data_in   : in    std_logic_vector(3 downto 0)
    );
  end component registerfile;

begin

  decode_opcode : component decoder
    port map (
      cpu_clk     => cpu_clk,
      cpu_enable  => cpu_enable,
      cpu_reset   => cpu_reset,
      instruction => instruction_raw,
      opcode      => opcode,
      operand1    => operand1,
      operand2    => operand2
    );

  -- register_file : component registerfile
  --   port map (
  --     cpu_clk                => cpu_clk,
  --     cpu_enable             => cpu_enable,
  --     write_enable_in        => write_enable_in,
  --     register_dest_data_out => operand1,
  --     register_src_data_out  => operand2,
  --     register_dest_data_in  => result,
  --     register_src_data_in   => result
  --   );

  execute_opcode : component alu
    port map (
      cpu_clk   => cpu_clk,
      cpu_enable  => cpu_enable,
      opcode    => opcode,
      operand1  => operand1,
      operand2  => operand2,
      result    => result
    );

  process (cpu_clk) is
  begin

    if rising_edge(cpu_clk) then
      case state is
        when idle =>
          if (cpu_enable = '1') then
            state <= fetch;
          end if;
        when fetch =>
          instruction_raw <= instruction;
          state <= decode;
        when decode =>
          state <= read;
        when read =>
          state <= execute;
        when execute =>
          state <= write;
        when write =>
          state <= complete;
        when complete =>
          state <= idle;
      end case;

      if (cpu_enable = '1') then
        program_counter <= program_counter + 1;
      end if;
    end if;

  end process;

end architecture behavioral;
