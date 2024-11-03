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
    cpu_clk     : in std_logic                     := '0';
    cpu_enable  : in std_logic                     := '1';
    cpu_reset   : in std_logic                     := '0';
    -- instruction : in std_logic_vector(15 downto 0) := (others => '0')
    instruction : in std_logic_vector(15 downto 0) := "0000000010001000" -- Delete this line
  );
end entity cpu;

architecture behavioral of cpu is

  -- Program Counter
  signal program_counter : integer                       := 0;
  signal instruction_raw : std_logic_vector(15 downto 0) := (others => '0');
  signal opcode          : std_logic_vector(3 downto 0)  := (others => '0');
  signal address_flag    : std_logic;
  signal negative_flag   : std_logic;
  signal operand1        : std_logic_vector(3 downto 0);
  signal operand2        : std_logic_vector(5 downto 0);
  signal operand2_addr   : std_logic_vector(3 downto 0);

  -- Register File
  signal write_enable_in : std_logic                    := '0'; -- '1' Write, '0' Read
  signal rf_val_dest_in  : std_logic_vector(7 downto 0) := (others => '0');
  signal rf_val_src_in   : std_logic_vector(7 downto 0) := (others => '0');
  signal rf_val_dest_out : std_logic_vector(7 downto 0) := (others => '0');
  signal rf_val_src_out  : std_logic_vector(7 downto 0) := (others => '0');

  -- ALU
  signal alu_enable   : std_logic                    := '0';
  signal alu_operand1 : std_logic_vector(7 downto 0) := (others => '0');
  signal alu_operand2 : std_logic_vector(7 downto 0) := (others => '0');
  signal alu_result1  : std_logic_vector(7 downto 0) := (others => '0');
  signal alu_result2  : std_logic_vector(7 downto 0) := (others => '0');

  type state_type is (idle, fetch, decode, read_operand, read_address, execute, write, complete);
  signal state : state_type := idle;

  component decoder is
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
  end component decoder;

  component alu is
    port (
      cpu_clk    : in std_logic;
      cpu_enable : in std_logic;
      alu_enable : in std_logic;
      opcode     : in std_logic_vector(3 downto 0);
      input1     : in std_logic_vector(7 downto 0);
      input2     : in std_logic_vector(7 downto 0);
      result1    : out std_logic_vector(7 downto 0);
      result2    : out std_logic_vector(7 downto 0)
    );
  end component alu;

  component registerfile is
    port (
      cpu_clk                      : in std_logic;
      cpu_enable                   : in std_logic;
      write_enable_in              : in std_logic;
      address_flag                 : in std_logic;
      negative_flag                : in std_logic;
      register_addr_dest_data_in   : in std_logic_vector(3 downto 0);
      register_addr_src_data_in    : in std_logic_vector(3 downto 0);
      register_value_dest_data_in  : in std_logic_vector(7 downto 0);
      register_value_src_data_in   : in std_logic_vector(7 downto 0);
      register_value_dest_data_out : out std_logic_vector(7 downto 0);
      register_value_src_data_out  : out std_logic_vector(7 downto 0)
    );
  end component registerfile;

begin

  decode_opcode : component decoder
    port map
    (
      cpu_clk       => cpu_clk,
      cpu_enable    => cpu_enable,
      instruction   => instruction_raw,
      address_flag  => address_flag,
      negative_flag => negative_flag,
      opcode        => opcode,
      operand1      => operand1,
      operand2      => operand2
    );

  register_file : component registerfile
    port map
    (
      cpu_clk                      => cpu_clk,
      cpu_enable                   => cpu_enable,
      write_enable_in              => write_enable_in,
      address_flag                 => address_flag,
      negative_flag                => negative_flag,
      register_addr_dest_data_in   => operand1,
      register_addr_src_data_in    => operand2_addr, -- operand2_addr is not defined
      register_value_dest_data_in  => rf_val_dest_in,
      register_value_src_data_in   => rf_val_src_in,
      register_value_dest_data_out => rf_val_dest_out,
      register_value_src_data_out  => rf_val_src_out
    );

  execute_opcode : component alu
    port map
    (
      cpu_clk    => cpu_clk,
      cpu_enable => cpu_enable,
      opcode     => opcode,
      alu_enable => alu_enable,
      input1     => rf_val_dest_out,
      input2     => rf_val_src_out,
      result1    => alu_result1,
      result2    => alu_result2
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
          state           <= decode;
        when decode =>
          if (address_flag = '1') then
            operand2_addr <= operand2(5 downto 2);
          else
            operand2_addr <= "0000";
            rf_val_src_in <= "00" & operand2(5 downto 0);
          end if;
          state           <= read_operand;
        when read_operand =>
          write_enable_in <= '0';
          alu_enable      <= '1';
          state        <= read_address;
        when read_address =>
          alu_operand1 <= rf_val_dest_out;
          alu_operand2 <= rf_val_src_out;
          alu_enable   <= '0';
          state <= execute;
        when execute =>
          write_enable_in <= '1';
          rf_val_dest_in  <= alu_result1;
          rf_val_src_in   <= alu_result2;
          state <= write;
        when write =>
          write_enable_in <= '0';
          state           <= complete;
        when complete =>
          state           <= idle;
      end case;

      if (cpu_enable = '1') then
        program_counter <= program_counter + 1;
      end if;
    end if;

  end process;

end architecture behavioral;
