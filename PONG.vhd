 library ieee;
 use ieee.std_logic_1164.all;
 --use ieee.std_logic_arith.all;
 entity PONG is 
	Port(
				Clk_50MHz  : in std_logic:='0';
				gamer1     : in std_logic_vector(1 downto 0) := "00"; --buttons player 1
				gamer2     : in std_logic_vector(1 downto 0) := "00"; --buttons player 2
				rst        : in std_logic :='0';
				leds       : out std_logic_vector(1 to 32) := "00000000000000000000000010001000"
	);   
	
end PONG;
 
architecture Behavourial of PONG is 
type ETAT is (E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13, E14, 
				  E15, E16, E17, E18, E19, E20, E21, E22, E23, E24, Loose1, Loose2, ERROR);
				  
signal bar1_present, bar1_futur, bar2_present, bar2_futur : std_logic_vector(1 to 4) := "1000";
signal etat_present : etat := Loose1;
signal etat_futur : etat := Loose2;
signal etat_precedent : etat := Loose2;
signal cnt_10hz : integer range 0 to 50000000 := 0;
signal clk_10hz : std_logic := '0';
signal Clk_1Hz : std_logic :='0';
signal Cnt_1Hz : integer range 0 to 50000000 :=0;
signal rnd_cnt : integer range 0 to 10 := 0;
				  
begin

	clk_generator : process(clk_50MHz)
		begin
		
			if rising_edge(clk_50mhz) then
				if cnt_1hz = 25000000 then
				
					cnt_1hz <= 0;
					clk_1Hz <= not(clk_1hz);
					
				
					
				else
				
					cnt_1hz <= cnt_1hz + 1;
				
				end if;
		end if;
	end process clk_generator;
	
	clk_10hz_generator : process(clk_50mhz)
		begin
			if rising_edge(clk_50mhz) then
				if cnt_10hz = 3000000 then
					cnt_10hz <= 0;
					clk_10hz <= not(clk_10hz);
				else
				
					cnt_10hz <= cnt_10hz + 1;
				end if;
			end if;
			
		end process clk_10hz_generator;
		
	rnd_generator : process(clk_50mhz, gamer1, gamer2)
		begin
			if rnd_cnt = 10 or gamer1(1) = '1' or gamer1(0) = '1' or gamer2(1) = '1' or gamer2(0) = '1' then
				rnd_cnt <= 0;
			else
				rnd_cnt <= rnd_cnt + 1;
			end if;
		end process rnd_generator;
		
	logicBar1_entree: process(gamer1)
		begin
			case bar1_present is 
				when "1000" =>
					if gamer1 = "10" then
						bar1_futur <= "1000";
					elsif gamer1 = "01" then
						bar1_futur <= "0100";
					else
						bar1_futur <= bar1_present;
					end if;
				when "0100" =>
					if gamer1 = "10" then
						bar1_futur <= "1000";
					elsif gamer1 = "01" then
						bar1_futur <= "0010";
					else
						bar1_futur <= bar1_present;
					end if;
				when "0010" =>
					if gamer1 = "10" then
						bar1_futur <= "0100";
					elsif gamer1 = "01" then
						bar1_futur <= "0001";
					else
						bar1_futur <= bar1_present;
					end if;
				when "0001" =>
					if gamer1 = "10" then
						bar1_futur <= "0010";
					elsif gamer1 = "01" then
						bar1_futur <= "0001";
						
					else 
						bar1_futur <= bar1_present;
					end if;
				when others =>
					bar1_futur <= "1000";
				
				end case;
	end process logicBar1_entree;
	
		logicBar2_entree: process(clk_10hz, bar2_present)
		begin
			case bar2_present is 
			
				when "1000" =>
					if gamer2 = "10" then
						bar2_futur <= "1000";
					elsif gamer2 = "01" then
						bar2_futur <= "0100";
					else
						bar2_futur <= bar2_present;
					end if;
				when "0100" =>
					if gamer2 = "10" then
						bar2_futur <= "1000";
					elsif gamer2 = "01" then
						bar2_futur <= "0010";
					else
						bar2_futur <= bar2_present;
					end if;
				when "0010" =>
					if gamer2 = "10" then
						bar2_futur <= "0100";
					elsif gamer2 = "01" then
						bar2_futur <= "0001";
					else
						bar2_futur <= bar2_present;
					end if;
				when "0001" =>
					if gamer2 = "10" then
						bar2_futur <= "0010";
					elsif gamer2 = "01" then
						bar2_futur <= "0001";
					else
						bar2_futur <= bar2_present;
					end if;
					
				when others =>
					bar2_futur <= "1000";
				
				end case;
				
	end process logicBar2_entree;
	

	
	LogicComb_entree: process(etat_present,clk_1hz)
		begin
			case etat_present is
			
				when E1 =>
					
					if bar1_present(1) = '1' then
						if rnd_cnt <= 5 then
							etat_futur <= E6;
						else 
							etat_futur <= E5;
						end if;
					else
						etat_futur <= Loose1;
					end if;
					
				When E2 =>
					
					if bar1_present(2)  = '1' then
						if rnd_cnt <= 3 then
								etat_futur <= E5;
						elsif rnd_cnt <= 6 then
							etat_futur <= E6;
						elsif rnd_cnt <= 10 then
							etat_futur <= E7;
						end if;
			
					else
						etat_futur <= Loose1;
					end if;
						
				When E3 =>
					
					if bar1_present(3)  = '1' then
						if rnd_cnt <= 3 then
							etat_futur <= E6;
						elsif rnd_cnt <= 6 then
							etat_futur <= E7;
						else
							etat_futur <= E8;
						end if;
					else
						etat_futur <= Loose1;
					end if;
							
				When E4 =>
					
					if bar1_present(4) = '1' then
						if rnd_cnt <= 5 then
							etat_futur <= E7;
						else
							etat_futur <= E8;
						end if;
					else 
						etat_futur <= Loose1;
					end if;
						
				When E5 =>
					if etat_precedent = E1 then
						etat_futur <= E9;
					elsif etat_precedent = E2 then
						etat_futur <= E10;
					elsif etat_precedent = E9 then
						etat_futur <= E1;
					elsif etat_precedent = E10 then
						etat_futur <= E2;
					else
						etat_futur <= ERROR;
					end if;
						
				When E6 =>
					if etat_precedent = E1 then
						etat_futur <= E11;
					elsif etat_precedent = E2 then
						etat_futur <= E10;
					elsif etat_precedent = E3 then
						etat_futur <= E9;
					elsif etat_precedent = E9 then
						etat_futur <= E3;
					elsif etat_precedent = E10 then
						etat_futur <= E2;
					elsif etat_precedent = E11 then
						etat_futur <= E1;
					else
						etat_futur <= ERROR;
					end if;
				When E7 =>
					if etat_precedent = E2 then
						etat_futur <= E12;
					elsif etat_precedent = E3 then
						etat_futur <= E11;
					elsif etat_precedent = E4 then
						etat_futur <= E10;
					elsif etat_precedent = E10 then
						etat_futur <= E4;
					elsif etat_precedent = E11 then
						etat_futur <= E3;
					elsif etat_precedent = E12 then
						etat_futur <= E2;
					else
						etat_futur <= ERROR;
					end if;
						
				When E8 =>
					if etat_precedent = E3 then
						etat_futur <= E11;
					elsif etat_precedent = E4 then
						etat_futur <= E12;
					elsif etat_precedent = E11 then
						etat_futur <= E3;
					elsif etat_precedent = E12 then
						etat_futur <= E4;

					else
						etat_futur <= ERROR;
					end if;
						
				When E9 =>
					if etat_precedent = E5 then
						etat_futur <= E13;
					elsif etat_precedent = E6 then
						etat_futur <= E14;
					elsif etat_precedent = E13 then
						etat_futur <= E5;
					elsif etat_precedent = E14 then
						etat_futur <= E6;
					else
						etat_futur <= ERROR;
					end if;
						
				When E10 =>
					if etat_precedent = E5 then
						etat_futur <= E15;
					elsif etat_precedent = E6 then
						etat_futur <= E14;
					elsif etat_precedent = E7 then
						etat_futur <= E13;
					elsif etat_precedent = E13 then
						etat_futur <= E7;
					elsif etat_precedent = E14 then
						etat_futur <= E6;
					elsif etat_precedent = E15 then
						etat_futur <= E5;
					else
						etat_futur <= ERROR;
					end if;
						
				When E11 =>
					if etat_precedent = E6 then
						etat_futur <= E16;
					elsif etat_precedent = E7 then
						etat_futur <= E15;
					elsif etat_precedent = E8 then
						etat_futur <= E14;
					elsif etat_precedent = E14 then
						etat_futur <= E8;
					elsif etat_precedent = E15 then
						etat_futur <= E7;
					elsif etat_precedent = E16 then
						etat_futur <= E6;
					else
						etat_futur <= ERROR;
					end if;
						
				When E12 =>
					if etat_precedent = E7 then
						etat_futur <= E15;
					elsif etat_precedent = E8 then
						etat_futur <= E16;
					elsif etat_precedent = E15 then
						etat_futur <= E7;
					elsif etat_precedent = E16 then
						etat_futur <= E8;
					else
						etat_futur <= ERROR;
					end if;
						
				When E13 =>
					if etat_precedent = E9 then
						etat_futur <= E17;
					elsif etat_precedent = E10 then
						etat_futur <= E18;
					elsif etat_precedent = E17 then
						etat_futur <= E9;
					elsif etat_precedent = E18 then
						etat_futur <= E10;
					else
						etat_futur <= ERROR;
					end if;
						
				When E14 =>
					if etat_precedent = E9 then
						etat_futur <= E19;
					elsif etat_precedent = E10 then
						etat_futur <= E18;
					elsif etat_precedent = E11 then
						etat_futur <= E17;
					elsif etat_precedent = E17 then
						etat_futur <= E11;
					elsif etat_precedent = E18 then
						etat_futur <= E10;
					elsif etat_precedent = E19 then
						etat_futur <= E9;
					else
						etat_futur <= ERROR;
					end if;
						
				When E15 =>
					if etat_precedent = E10 then
						etat_futur <= E20;
					elsif etat_precedent = E11 then
						etat_futur <= E19;
					elsif etat_precedent = E12 then
						etat_futur <= E18;
					elsif etat_precedent = E18 then
						etat_futur <= E12;
					elsif etat_precedent = E19 then
						etat_futur <= E11;
					elsif etat_precedent = E20 then
						etat_futur <= E10;
					elsif etat_precedent = Loose1 then
						etat_futur <= E11;
					elsif etat_precedent = Loose2 then 
						etat_futur <= E19;
					
					else
						etat_futur <= ERROR;
					end if;
					
				When E16 =>
					if etat_precedent = E11 then
						etat_futur <= E19;
					elsif etat_precedent = E12 then
						etat_futur <= E20;
					elsif etat_precedent = E19 then
						etat_futur <= E11;
					elsif etat_precedent = E20 then
						etat_futur <= E12;
					else
						etat_futur <= ERROR;
					end if;
						
				When E17 =>
					if etat_precedent = E13 then
						etat_futur <= E21;
					elsif etat_precedent = E14 then
						etat_futur <= E22;
					elsif etat_precedent = E21 then
						etat_futur <= E13;
					elsif etat_precedent = E22 then
						etat_futur <= E14;
					else
						etat_futur <= ERROR;
					end if;
						
				When E18 =>
					if etat_precedent = E13 then
						etat_futur <= E23;
					elsif etat_precedent = E14 then
						etat_futur <= E22;
					elsif etat_precedent = E15 then
						etat_futur <= E21;
					elsif etat_precedent = E21 then
						etat_futur <= E15;
					elsif etat_precedent = E22 then
						etat_futur <= E14;
					elsif etat_precedent = E23 then
						etat_futur <= E13;
					else
						etat_futur <= ERROR;
					end if;
						
				When E19 =>
					if etat_precedent = E14 then
						etat_futur <= E24;
					elsif etat_precedent = E15 then
						etat_futur <= E23;
					elsif etat_precedent = E16 then
						etat_futur <= E22;
					elsif etat_precedent = E22 then
						etat_futur <= E16;
					elsif etat_precedent = E23 then
						etat_futur <= E15;
					elsif etat_precedent = E24 then
						etat_futur <= E14;
					else
						etat_futur <= ERROR;
					end if;
					
				When E20 =>
					if etat_precedent = E15 then
						etat_futur <= E23;
					elsif etat_precedent = E16 then
						etat_futur <= E24;
					elsif etat_precedent = E23 then
						etat_futur <= E15;
					elsif etat_precedent = E24 then
						etat_futur <= E16;
					else
						etat_futur <= ERROR;
					end if;
						
				When E21 =>
					
					if bar2_present(1)  = '1' then
						if rnd_cnt <= 5 then
							etat_futur <= E18;
						elsif rnd_cnt <= 10 then
							etat_futur <= E17;
						end if;
					else
						etat_futur <= Loose1;
					end if;
						
				When E22 =>
					
					if bar2_present(2) = '1' then
						if rnd_cnt <= 3 then
							etat_futur <= E17;
						elsif rnd_cnt <= 6 then
							etat_futur <= E18;
						elsif rnd_cnt <= 10 then
							etat_futur <= E19;
						end if;
					else
						etat_futur <= Loose1;
					end if;
					
				When E23 =>
					
					if bar2_present(3)= '1' then
						if rnd_cnt <= 3 then
							etat_futur <= E20;
						elsif rnd_cnt <= 6 then
							etat_futur <= E19;
						elsif rnd_cnt <= 10 then
							etat_futur <= E18;
						end if;
					else
						etat_futur <= Loose1;
					end if;
						
				When E24 =>
					
					if bar2_present(4)= '1' then
						if rnd_cnt <= 5 then
							etat_futur <= E19;
						elsif rnd_cnt <= 10 then
							etat_futur <= E20;
						end if;
					else
						etat_futur <= Loose1;
					end if;
					
				When Loose1 =>
					if rst = '1' then
						etat_futur <= E15;
					else
						etat_futur <= Loose2;
					end if;
					
				When Loose2 =>
					if rst = '1' then
						etat_futur <= E15;
					else
						etat_futur <= Loose1;
					end if;
				when ERROR => etat_futur <= ERROR;
				end case;
			end process LogicComb_entree;
			
		
		Mem_etat_bar1 : process(clk_10hz)
		 
			begin

					
				if rising_edge(clk_10hz) then
					bar1_present <= bar1_futur;
				end if;
				
		end process Mem_etat_bar1;
		
		Mem_etat_bar2 : process(clk_10hz)
		
			begin

					
				if rising_edge(clk_10hz) then
					bar2_present <= bar2_futur;
				end if;
				
		end process Mem_etat_bar2;
		

		
		Sortie_bar1 : process(bar1_present)
			begin
				case bar1_present is 
					when "1000" => leds(25 to 28) <= "1000";
					when "0100" => leds(25 to 28) <= "0100";
					when "0010" => leds(25 to 28) <= "0010";
					when "0001" => leds(25 to 28) <= "0001";
					when others =>
				end case;
				
		end process Sortie_bar1;
		
		Sortie_bar2 : process(bar2_present)
			begin
				case bar2_present is 
					when "1000" => leds(29 to 32) <= "1000";
					when "0100" => leds(29 to 32) <= "0100";
					when "0010" => leds(29 to 32) <= "0010";
					when "0001" => leds(29 to 32) <= "0001";
					when others =>
				end case;
				
		end process Sortie_bar2;
		
		Mem_etat : process(clk_1hz)
		begin
			if rising_edge(clk_1hz) then
				etat_precedent <= etat_present;
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
							leds(i) <='Z';
						end if;
					end loop;
			
				When E2 => 
					for i in 1 to 24 loop
						if i = 2 then
							leds(i) <= '1';
						else
							leds(i) <='Z';
						end if;
					end loop;
				When E3 => 
					for i in 1 to 24 loop
						if i = 3 then
							leds(i) <= '1';
						else
							leds(i) <='Z';
						end if;
					end loop;
				When E4 =>
					for i in 1 to 24 loop
						if i = 4  then
							leds(i) <= '1';
						else
							leds(i) <='Z';
						end if;
					end loop;
				When E5 => 
					for i in 1 to 24 loop
						if i = 5 then
							leds(i) <= '1';
						else
							leds(i) <='Z';
						end if;
					end loop;
				When E6 => 
					for i in 1 to 24 loop
						if i = 6 then
							leds(i) <= '1';
						else
							leds(i) <='Z';
						end if;
					end loop;
				When E7 => 
					for i in 1 to 24 loop
						if i = 7 then
							leds(i) <= '1';
						else
							leds(i) <='Z';
						end if;
					end loop;
				When E8 => 
					for i in 1 to 24 loop
						if i = 8 then
							leds(i) <= '1';
						else
							leds(i) <='Z';
						end if;
					end loop;
				When E9 => 
					for i in 1 to 24 loop
						if i = 9 then
							leds(i) <= '1';
						else
							leds(i) <='Z';
						end if;
					end loop;
				When E10 => 
					for i in 1 to 24 loop
						if i = 10 then
							leds(i) <= '1';
						else
							leds(i) <='Z';
						end if;
					end loop;
				When E11 => 
					for i in 1 to 24 loop
						if i = 11 then
							leds(i) <= '1';
						else
							leds(i) <='Z';
						end if;
					end loop;
				When E12 => 
					for i in 1 to 24 loop
						if i = 12 then
							leds(i) <= '1';
						else
							leds(i) <='Z';
						end if;
					end loop;
				When E13 => 
					for i in 1 to 24 loop
						if i = 13 then
							leds(i) <= '1';
						else
							leds(i) <='Z';
						end if;
					end loop;
				When E14 => 
					for i in 1 to 24 loop
						if i = 14 then
							leds(i) <= '1';
						else
							leds(i) <='Z';
						end if;
					end loop;
				When E15 => 
					for i in 1 to 24 loop
						if i = 15 then
							leds(i) <= '1';
						else
							leds(i) <='Z';
						end if;
					end loop;
				When E16 => 
					for i in 1 to 24 loop
						if i = 16 then
							leds(i) <= '1';
						else
							leds(i) <='Z';
						end if;
					end loop;
				When E17 => 
					for i in 1 to 24 loop
						if i = 17 then
							leds(i) <= '1';
						else
							leds(i) <='Z';
						end if;
					end loop;
				When E18 => 
					for i in 1 to 24 loop
						if i = 18 then
							leds(i) <= '1';
						else
							leds(i) <='Z';
						end if;
					end loop;
				When E19 => 
					for i in 1 to 24 loop
						if i = 19 then
							leds(i) <= '1';
						else
							leds(i) <='Z';
						end if;
					end loop;
				When E20 => 
					for i in 1 to 24 loop
						if i = 20 then
							leds(i) <= '1';
						else
							leds(i) <='Z';
						end if;
					end loop;
				When E21 => 
					for i in 1 to 24 loop
						if i = 21 then
							leds(i) <= '1';
						else
							leds(i) <='Z';
						end if;
					end loop;
				When E22 => 
					for i in 1 to 24 loop
						if i = 22 then
							leds(i) <= '1';
						else
							leds(i) <='Z';
						end if;
					end loop;
				When E23 => 
					for i in 1 to 24 loop
						if i = 23 then
							leds(i) <= '1';
						else
							leds(i) <='Z';
						end if;
					end loop;
				When E24 => 
					for i in 1 to 24 loop
						if i = 24 then
							leds(i) <= '1';
						else
							leds(i) <='Z';
						end if;
					end loop;
					
				When loose1 => 
					for i in 1 to 24 loop
						leds(i) <= '1';
					end loop;
					
				When loose2 => 
					for i in 1 to 24 loop
						leds(i) <='Z';
					end loop;
				when ERROR =>
					for i in 1 to 24 loop
						leds(i) <='Z';
					end loop;
				end case;
			end process LogComb_sorties;
			

					
end Behavourial;
