----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:48:56 05/15/2023 
-- Design Name: 
-- Module Name:    state_test - Behavioral 
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

entity state_test is
	port (go_up : in STD_LOGIC_VECTOR(1 downto 0); 
			go_down : in STD_LOGIC_VECTOR(1 downto 0);
			go_floor: in STD_LOGIC_VECTOR(2 downto 0);
			floor : in STD_LOGIC_VECTOR(2 downto 0);
         clk :in STD_LOGIC;
         stateLedOut : out STD_LOGIC_VECTOR(3 downto 0);
			stateOut : out STD_LOGIC_VECTOR(3 downto 0);
			segment_floor : out STD_LOGIC_VECTOR(7 downto 0);
         receive_bits : in STD_LOGIC_VECTOR(1 downto 0)
);
end state_test;

architecture Behavioral of state_test is
type floor_state_type is (idle, Opened, request,going_up,OpenedUp_Only,OpenedDown_Only,going_down, finished);
signal floor_state : floor_state_type;
signal floor_temp : STD_LOGIC_VECTOR(2 downto 0);
signal floor_req_mid : STD_LOGIC := '0';
begin

	floor_state_machine: process(clk)

	begin
		if rising_edge(clk) then
			case floor_state is
				--when our current state is idle
				when idle =>
					if (go_floor /= "000") then
						if (go_floor > floor  ) then 
							floor_temp <= go_floor;
						floor_state <= going_up;
						elsif (go_floor < floor  ) then 
						floor_temp <= go_floor;	
						floor_state <= going_down;

					--otherwise we're going to stay at request
						else
							floor_state <= idle;
						end if;
						--first floor
					else
						if (go_up(0)='1' and floor="001") then 	
							floor_state <= Opened;
						elsif (go_up(0)='1' and floor /="001") then 
							floor_temp <= "001";
							floor_state <= going_down;
						

						--second floor
						elsif ((go_up(1)='1' or go_down(0)='1') and floor="010") then 
							floor_state <= Opened;
						elsif ((go_up(1)='1' or go_down(0)='1')and floor ="001") then 
							floor_temp <= "010";
							floor_state <= going_up;
						elsif ((go_up(1)='1' or go_down(0)='1') and floor ="100") then 
							floor_temp <= "010";
							floor_state <= going_down;

						--third floor
						elsif (go_down(1)='1' and floor="100") then 	
							floor_state <= Opened;
						elsif (go_down(1)='1' and floor /="100") then 
							floor_temp <= "100";
							floor_state <= going_up;

						else
							floor_state <= idle;
							
						end if;
					end if;
					
				when Opened =>
					if (receive_bits="11") then 
						--elevator opened
						floor_state <= request;
					else
						floor_state <= Opened;
					end if;

				when request =>
					if (go_floor = "000"  ) then 
						floor_state <= request;
					else 
						if(go_floor > floor) then 
							floor_temp <= go_floor;
						floor_state <= going_up;
						elsif (go_floor < floor ) then 
						floor_temp <= go_floor;	
						floor_state <= going_down;

					--otherwise we're going to stay at request
						else
							floor_state <= request;
						end if;
					end if;
				when going_up =>
					if (go_up(1) = '1' or go_floor(1)='1') then
						floor_req_mid <= '1';
					else
						if (floor_temp > floor and receive_bits="10") then 
							if (floor_req_mid= '1') then
								floor_state <= OpenedUp_Only;
							else
							floor_state <= going_up;
							end if;
						elsif (floor_temp = floor and receive_bits="10") then 
							floor_state <= finished;
					
					--otherwise we're going to stay at request
						else
							floor_state <= going_up;
						
						end if;
					end if;

				when going_down =>
					if (go_down(0) = '1' or go_floor(1)='1') then
						floor_req_mid <= '1';
					else
						if (floor_temp < floor and receive_bits="10") then 
							if (floor_req_mid= '1') then
								floor_state <= OpenedDown_Only;
							else
							floor_state <= going_down;
							end if;
						elsif (floor_temp = floor and receive_bits="10") then 
							floor_state <= finished;

						--otherwise we're going to stay at request
						else
							floor_state <= going_down;
						end if;
					end if;
					
				when OpenedUp_Only =>
					floor_req_mid <= '0';
					if (receive_bits="11") then 
					
						floor_state <= going_up;
					else
						floor_state <= OpenedUp_Only;
					end if;

				when OpenedDown_Only =>
					floor_req_mid <= '0';
					if (receive_bits="11") then 
					floor_req_mid <= '0';
						floor_state <= going_down;
					else
						floor_state <= OpenedDown_Only;
					end if;
					
				when finished=> 
					if (receive_bits="01") then 
						floor_state <= idle; 			

					else
						floor_state <= finished;
					end if;
				
			end case;	

		end if;
	end process;

	segment_floor <=     "10011110" when floor = "100" else
            "10110110" when floor = "010" else
            "00001100" when floor = "001" else
            "10000000";
				
	stateLedOut <= 	"0001" when (floor_state = idle) else
			"0010" when (floor_state = opened) else
			"0011" when (floor_state = request) else
			"0110" when (floor_state = going_up) else
			"0101" when (floor_state = going_down) else
			"0100" when (floor_state = finished) else
			"1100" when (floor_state = OpenedUp_Only) else
			"1010" when (floor_state = OpenedDown_Only) else
			"0001";
			
				
	stateOut <= 	"0001" when (floor_state = idle) else
			"0010" when (floor_state = opened) else
			"0011" when (floor_state = request) else
			"0110" when (floor_state = going_up) else
			"0101" when (floor_state = going_down) else
			"0100" when (floor_state = finished) else
			"1100" when (floor_state = OpenedUp_Only) else
			"1010" when (floor_state = OpenedDown_Only) else
			"0001";

end Behavioral;

