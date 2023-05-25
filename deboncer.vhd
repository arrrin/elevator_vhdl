----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:32:42 05/15/2023 
-- Design Name: 
-- Module Name:    deboncer - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity deboncer is
	Port (
	DATA: in std_logic;
	CLK : in std_logic;
	OP_DATA : out std_logic);
end deboncer ;
 
architecture Behavioral of deboncer is
 
Signal OP1, OP2, OP3: std_logic;
 
	begin
 
	Process(CLK)
 
	begin
 
	If rising_edge(CLK) then
 
	OP1 <= DATA;
 
	OP2 <= OP1;
 
	OP3 <= OP2;
 
	end if;
 
	end process;
 
	OP_DATA <= OP1 and OP2 and OP3;
 
end Behavioral;

