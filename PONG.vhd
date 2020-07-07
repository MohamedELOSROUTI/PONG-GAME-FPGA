 library ieee;
 use ieee.std_logic_1164.all;
 --use ieee.std_logic_arith.all;
 entity PONG is 
	Port(
				Clk_50MHz  : in std_logic:='0';
				gamer1     : in std_logic_vector(1 downto 0) := "00"; --buttons player 1
				gamer2     : in std_logic_vector(1 downto 0) := "00"; --buttons player 2
				rst        : in std_logic :='0';
				leds       : buffer std_logic_vector(1 to 32) := x"11001100"
	);   
	
end PONG;

architecture Behavourial of PONG is 
type ETAT is (E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13, E14, 
				  E15, E16, E17, E18, E19, E20, E21, E22, E23, E24, Loose1, Loose2);
				  
type player is (player1, player2);
type direction is (a1, b1, a2, b2, c2, a3, b3, c3, a4, b4);
signal dir : direction := a1;
 
signal turn : player := player2;
 
signal etat_present, etat_futur : etat := Loose1;

signal Clk_1Hz : std_logic :='0';
signal Cnt_1Hz : integer range 0 to 5000000 :=0;
signal rnd_cnt : integer range 0 to 2 := 0;
				  
begin

	clk_generator : process(clk_50MHz)
		begin
			if rising_edge(clk_50mhz) then
				if cnt_1hz /= 2500000 then
					cnt_1hz <= cnt_1hz + 1;
				else
					clk_1Hz <= not(clk_1hz);
					cnt_1hz <= 0;
				end if;
		end if;
	end process clk_generator;
		
	rnd_generator : process(clk_50mhz, rst, gamer1, gamer2)
		begin
			if rnd_cnt = 2 then
				rnd_cnt <= 0;
			else
				rnd_cnt <= rnd_cnt + 1;
			end if;
		end process rnd_generator;
				
	LogicComb_entree: process(Clk_1Hz, etat_present)
		begin
			case etat_present is
			
				when E1 =>
					turn <= player2;
					if leds(25) = '1' then
						if rnd_cnt = 0 then 
							etat_futur <= E6;
							dir <= a1;
							
						else
							etat_futur <= E5;
							dir <= b1;
						end if;
					else
						etat_futur <= Loose1;
						dir <= a1;
					end if;
					
				When E2 =>
					turn <= player2;
					if leds(26) = '1' then
						if rnd_cnt = 0 then
							etat_futur <= E6;
							dir <= a2;
						elsif rnd_cnt = 1 then
							etat_futur <= E5;
							dir <= b2;
						else
							etat_futur <= E7;
							dir <= c2;
						end if;
					else
						etat_futur <= Loose1;
						dir <= a1;
					end if;
						
				When E3 =>
					turn <= player2;
					if leds(27) = '1' then
						if rnd_cnt = 0 then
							etat_futur <= E8;
							dir <= a3;
						elsif rnd_cnt = 1 then
							etat_futur <= E6;
							dir <= b3;
						else
							etat_futur <= E7;
							dir <= c3;
						end if;
					else
						etat_futur <= Loose1;
						dir <= a1;
					end if;
							
				When E4 =>
					turn <= player2;
					if leds(28) = '1' then
						if rnd_cnt = 0 then
							etat_futur <= E7;
							dir <= a4;
						else
							etat_futur <= E8;
							dir <= b4;
						end if;
					else 
						etat_futur <= Loose1;
						dir <= a1;
					end if;
						
				When E5 =>
					if turn = player2 then
						if dir = b1 then
							etat_futur <= E9;
						elsif dir = b2 then
							etat_futur <= E10;
						end if;
					elsif turn = player1 then
						if dir = b1 then
							etat_futur <= E1;
						elsif dir = a3 then 
							etat_futur <= E2;
						end if;
					end if;							
						
				When E6 =>
					if turn = player2 then
						if dir = a1 then
							etat_futur <= E11;
						elsif dir = a2 then
							etat_futur <= E10;
						elsif dir = b3 then
							etat_futur <= E9;
						end if;
							
					elsif turn = player1 then
						if dir = b2 then
							etat_futur <= E2;
						elsif dir = c2 then
							etat_futur <= E1;
						elsif dir = a4 then
							etat_futur <= E3;
						end if;
					end if; 
						
				When E7 =>
					if turn = player2 then
						if dir = c2 then
							etat_futur <= E12;
						elsif dir = a2 then
							etat_futur <= E10;
						elsif dir = c3 then
							etat_futur <= E11;
						end if;
							
					elsif turn = player1 then
						if dir = a1 then
							etat_futur <= E2;
						elsif dir = b3 then
							etat_futur <= E3;
						elsif dir = c3 then
							etat_futur <= E4;
						end if;
					end if;
						
				When E8 =>
					if turn = player2 then
						if dir = a3 then
							etat_futur <= E11;
						elsif dir = b4 then
							etat_futur <= E12;
						end if;
							
					elsif turn = player1 then
						if dir = a2 then
							etat_futur <= E3;
						elsif dir = b4 then
							etat_futur <= E4;
						end if;
					end if;
						
				When E9 =>
					if turn = player2 then
						if dir = b1 then
							etat_futur <= E13;
						elsif dir = b3 then
							etat_futur <= E14;
						end if;
							
					elsif turn = player1 then
						if dir = b1 then
							etat_futur <= E5;
						elsif dir = a4 then
							etat_futur <= E6;
						end if;
					end if;
						
				When E10 =>
					if turn = player2 then
						if dir = a2 then
							etat_futur <= E14;
						elsif dir = b2 then
							etat_futur <= E15;
						elsif dir = a4 then
							etat_futur <= E13;
						end if;
							
					elsif turn = player1 then
						if dir = b2 then 
							etat_futur <= E6;
						elsif dir = a3 then
							etat_futur <= E5;
						elsif dir = c3 then 
							etat_futur <= E7;
						end if;
					end if;
						
				When E11 =>
					if turn = player2 then
						if dir = a1 then
							etat_futur <= E16;
						elsif dir = a3 then
							etat_futur <= E14;
						elsif dir = c3 then
							etat_futur <= E15;
						end if;
							
					elsif turn = player1 then
						if dir = a2 then
							etat_futur <= E8;
						elsif dir = c2 then
							etat_futur <= E6;
						elsif dir = b3 then
							etat_futur <= E7;
						end if;
					end if;
						
				When E12 =>
					if turn = player2 then
						if dir = c2 then
							etat_futur <= E15;
						elsif dir = b4 then
							etat_futur <= E16;
						end if;

							
					elsif turn = player1 then
						if dir = a1 then
							etat_futur <= E7;
						elsif dir = b4 then
							etat_futur <= E8;
						end if;
					end if;
						
				When E13 =>
					if turn = player2 then
						if dir = b1 then
							etat_futur <= E17;
						elsif dir = a4 then
							etat_futur <= E18;
						end if;

							
					elsif turn = player1 then
						if dir = b1 then
							etat_futur <= E9;
						elsif dir = c3 then
							etat_futur <= E10;
						end if;
					end if;
						
				When E14 =>
					if turn = player2 then
						if dir = a2 then
							etat_futur <= E18;
						elsif dir = a3 then
							etat_futur <= E17;
						end if;

							
					elsif turn = player1 then
						if dir = a2 then
							etat_futur <= E11;
						elsif dir = b2 then
							etat_futur <= E10;
						elsif dir = a4 then
							etat_futur <= E9;
						end if;
					end if;
						
				When E15 =>
					if turn = player2 then
						if dir = b2 then
							etat_futur <= E20;
						elsif dir = c2 then
							etat_futur <= E18;
						elsif dir = c3 then
							etat_futur <= E19;
						end if;
							
					elsif turn = player1 then
						if dir = a1 then
							etat_futur <= E12;
						elsif dir = a3 then
							etat_futur <= E10;
						elsif dir = b3 then
							etat_futur <= E11;
						end if;
					end if;
					
				When E16 =>
					if turn = player2 then
						if dir = a1 then
							etat_futur <= E19;
						elsif dir = b4 then
							etat_futur <= E20;
						end if;
							
					elsif turn = player1 then
						if dir = c2 then 
							etat_futur <= E11;
						elsif dir = b4 then
							etat_futur <= E12;
						end if;
					end if;
						
				When E17 =>
					if turn = player2 then
						if dir = b1 then
							etat_futur <= E21;
						elsif dir = a3 then
							etat_futur <= E21;
						end if;
					elsif turn = player1 then
						if dir = b1 then
							etat_futur <= E13;
						elsif dir = a2 then
							etat_futur <= E14;
						end if;
					end if;
						
				When E18 =>
					if turn = player2 then
						if dir = a2 then
							etat_futur <= E22;
						elsif dir = c2 then
							etat_futur <= E21;
						elsif dir = a4 then
							etat_futur <= E23;
						end if;
					elsif turn = player1 then
						if dir = a1 then
							etat_futur <= E15;
						elsif dir = b2 then
							etat_futur <= E14;
						elsif dir = c3 then
							etat_futur <= E13;
						end if;
					end if;
						
				When E19 =>
					if turn = player2 then
						if dir = a1 then
							etat_futur <= E22;
						elsif dir = b3 then
							etat_futur <= E24;
						end if;
					elsif turn = player1 then
						if dir = c2 then
							etat_futur <= E16;
						elsif dir = b3 then
							etat_futur <= E15;
						elsif dir = a4 then
							etat_futur <= E14;
						end if;
					end if;
					
				When E20 =>
					if turn = player2 then
						if dir = b2 then
							etat_futur <= E23;
							turn <= player1;
						elsif dir = b4 then
							etat_futur <= E24;
							turn <= player1;
						end if;
						
							
					elsif turn = player1 then
						if dir = a3 then
							etat_futur <= E15;
						elsif dir = b4 then
							etat_futur <= E16;
						end if;
					end if;
						
				When E21 =>
					turn <= player1;
					if leds(29) = '1' then
						if rnd_cnt = 0 then
							etat_futur <= E18;
							dir <= a1;
						elsif rnd_cnt = 1 then
							etat_futur <= E17;
							dir <= b1;
						end if;
					else
						etat_futur <= Loose1;
						dir <= a1;
					end if;
						
				When E22 =>
					turn <= player1;
					if leds(30) = '1' then
						if rnd_cnt = 0 then
							etat_futur <= E17;
							dir <= a2;
						elsif rnd_cnt = 1 then
							etat_futur <= E18;
							dir <= b2;
						elsif rnd_cnt = 2 then
							etat_futur <= E19;
							dir <= c2;
						end if;
					else
						etat_futur <= Loose1;
						dir <= a1;
					end if;
					
				When E23 =>
					turn <= player1;
					if leds(31) = '1' then
						if rnd_cnt = 0 then
							etat_futur <= E20;
							dir <= a3;
						elsif rnd_cnt = 1 then
							etat_futur <= E19;
							dir <= b3;
						elsif rnd_cnt = 2 then
							etat_futur <= E18;
							dir <= c3;
						end if;
					else
						etat_futur <= Loose1;
						dir <= a1;
					end if;
						
				When E24 =>
					turn <= player1;
					if leds(32) = '1' then
						if rnd_cnt = 0 then
							etat_futur <= E19;
							dir <= a4;
						elsif rnd_cnt = 1 then
							etat_futur <= E20;
							dir <= b4;
						end if;
					else
						etat_futur <= Loose1;
						dir <= a1;
					end if;
					
				When Loose1 =>
					if rst = '1' then
						etat_futur <= E15;
						if rnd_cnt = 0 then
							turn <= player1;
							dir <= a1;
						elsif rnd_cnt = 1 then
							turn <= player2;
							dir <= b2;
						elsif rnd_cnt = 2 then
							turn <= player1;
							dir <= a3;
						end if;
					else
						etat_futur <= Loose2;
					end if;
					
				When Loose2 =>
					if rst = '1' then
						etat_futur <= E15;
						if rnd_cnt = 0 then
							turn <= player1;
							dir <= a1;
						elsif rnd_cnt = 1 then
							turn <= player2;
							dir <= b2;
						elsif rnd_cnt = 2 then
							turn <= player1;
							dir <= a3;
						end if;
					else
						etat_futur <= Loose1;
					end if;
					
				end case;
			end process LogicComb_entree;
		
		Mem_etat : process(clk_1Hz, RST)
		
			begin
				if rst = '1' then
					etat_present <= loose1;
					
				elsif rising_edge(clk_1hz) then
					etat_present <= etat_futur;
				end if;
				
		end process Mem_etat;
		
		LogComb_sorties : process(etat_present)
		begin
			
			
			case etat_present is
				When E1 => 
					for i in 1 to 24 loop
						if i = 1 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
			
				When E2 => 
					for i in 1 to 24 loop
						if i = 2 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When E3 => 
					for i in 1 to 24 loop
						if i = 3 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When E4 =>
					for i in 1 to 24 loop
						if i = 4  then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When E5 => 
					for i in 1 to 24 loop
						if i = 5 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When E6 => 
					for i in 1 to 24 loop
						if i = 6 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When E7 => 
					for i in 1 to 24 loop
						if i = 7 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When E8 => 
					for i in 1 to 24 loop
						if i = 8 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When E9 => 
					for i in 1 to 24 loop
						if i = 9 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When E10 => 
					for i in 1 to 24 loop
						if i = 10 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When E11 => 
					for i in 1 to 24 loop
						if i = 11 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When E12 => 
					for i in 1 to 24 loop
						if i = 12 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When E13 => 
					for i in 1 to 24 loop
						if i = 13 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When E14 => 
					for i in 1 to 24 loop
						if i = 14 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When E15 => 
					for i in 1 to 24 loop
						if i = 15 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When E16 => 
					for i in 1 to 24 loop
						if i = 16 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When E17 => 
					for i in 1 to 24 loop
						if i = 17 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When E18 => 
					for i in 1 to 24 loop
						if i = 18 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When E19 => 
					for i in 1 to 24 loop
						if i = 19 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When E20 => 
					for i in 1 to 24 loop
						if i = 20 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When E21 => 
					for i in 1 to 24 loop
						if i = 21 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When E22 => 
					for i in 1 to 24 loop
						if i = 22 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When E23 => 
					for i in 1 to 24 loop
						if i = 23 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When E24 => 
					for i in 1 to 24 loop
						if i = 24 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
					
				When loose1 => 
					for i in 1 to 24 loop
						leds(i) <= '1';
					end loop;
					
				When loose2 => 
					for i in 1 to 24 loop
						leds(i) <='0';
					end loop;
				end case;
			end process LogComb_sorties;
			
		press_button_gamer1 : process(gamer1)
			begin
				if gamer1 = "01" then
					-- move right
					case leds(25 to 28) is
						when "0011" =>
							leds(25 to 28) <= "0011";
						when "0110" =>
							leds(25 to 28) <= "0011";
						when "1100" =>
							leds(25 to 28) <= "0110";
						when others =>
							
					end case; 
					
				elsif gamer1 = "10" then
					-- move left 
					case leds(25 to 28) is
						when "0011" =>
							leds(25 to 28) <= "0110";
						when "0110" =>
							leds(25 to 28) <= "1100";
						when "1100" =>
							leds(25 to 28) <= "1100";
						when others =>
							
					end case; 
					
				else
					-- do nothing
					
				end if;
				
			end process press_button_gamer1;
			
			press_button_gamer2 : process(gamer2)
			begin
				if gamer2 = "01" then
					-- move right
					case leds(29 to 32) is
						when "0011" =>
							leds(29 to 32) <= "0011";
						when "0110" =>
							leds(29 to 32) <= "0011";
						when "1100" =>
							leds(29 to 32) <= "0110";
						when others =>
							
					end case; 
					
				elsif gamer2 = "10" then
					-- move left 
					case leds(29 to 32) is
						when "0011" =>
							leds(29 to 32) <= "0110";
						when "0110" =>
							leds(29 to 32) <= "1100";
						when "1100" =>
							leds(29 to 32) <= "1100";
						when others =>
							
					end case; 
					
				else
					-- do nothing
					
				end if;
				
			end process press_button_gamer2;
					
end Behavourial;
