 library ieee;
 use ieee.std_logic_1164.all;
 entity PONG is 
	Port(
				Clk_50MHz  : in std_logic:='0';
				gamer1     : in std_logic_vector(1 downto 0) := "00"; --buttons player 1
				gamer2     : in std_logic_vector(1 downto 0) := "00"; --buttons player 2
				rst        : in std_logic :='0';
				leds       : out std_logic_vector(1 to 32) := "00000000000000100000000010001000"
	);   
	
end PONG;
 
architecture Behavourial of PONG is 
type state is (S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, 
				  S15, S16, S17, S18, S19, S20, S21, S22, S23, S24, Loose1, Loose2);
				  
signal bar1_current, bar1_futur, bar2_current, bar2_futur : std_logic_vector(1 to 4) := "1000";
signal current_state: state := S15;
signal next_state: state := S20;
signal previous_state : state := S10;
signal cnt_8hz : integer range 0 to 50000000 := 0;
signal clk_8hz : std_logic := '0';
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
	
	clk_8hz_generator : process(clk_50mhz)
		begin
			if rising_edge(clk_50mhz) then
				if cnt_8hz = 3000000 then
					cnt_8hz <= 0;
					clk_8hz <= not(clk_8hz);
				else
				
					cnt_8hz <= cnt_8hz + 1;
				end if;
			end if;
			
		end process clk_8hz_generator;
		
	rnd_generator : process(clk_50mhz, gamer1, gamer2)
		begin
			if rnd_cnt >= 10 or gamer1(1) = '1' or gamer1(0) = '1' or gamer2(1) = '1' or gamer2(0) = '1' then
				rnd_cnt <= 0;
			else
				rnd_cnt <= rnd_cnt + 1;
			end if;
		end process rnd_generator;
		
	logicBar1_inputs: process(gamer1)
		begin
			case bar1_current is 
				when "1000" =>
					if gamer1 = "10" then
						bar1_futur <= "1000";
					elsif gamer1 = "01" then
						bar1_futur <= "0100";
					else
						bar1_futur <= bar1_current;
					end if;
				when "0100" =>
					if gamer1 = "10" then
						bar1_futur <= "1000";
					elsif gamer1 = "01" then
						bar1_futur <= "0010";
					else
						bar1_futur <= bar1_current;
					end if;
				when "0010" =>
					if gamer1 = "10" then
						bar1_futur <= "0100";
					elsif gamer1 = "01" then
						bar1_futur <= "0001";
					else
						bar1_futur <= bar1_current;
					end if;
				when "0001" =>
					if gamer1 = "10" then
						bar1_futur <= "0010";
					elsif gamer1 = "01" then
						bar1_futur <= "0001";
						
					else 
						bar1_futur <= bar1_current;
					end if;
				when others =>
					bar1_futur <= "1000";
				
				end case;
	end process logicBar1_inputs;
	
		logicBar2_inputs: process(clk_8hz, bar2_current)
		begin
			case bar2_current is 
			
				when "1000" =>
					if gamer2 = "10" then
						bar2_futur <= "1000";
					elsif gamer2 = "01" then
						bar2_futur <= "0100";
					else
						bar2_futur <= bar2_current;
					end if;
				when "0100" =>
					if gamer2 = "10" then
						bar2_futur <= "1000";
					elsif gamer2 = "01" then
						bar2_futur <= "0010";
					else
						bar2_futur <= bar2_current;
					end if;
				when "0010" =>
					if gamer2 = "10" then
						bar2_futur <= "0100";
					elsif gamer2 = "01" then
						bar2_futur <= "0001";
					else
						bar2_futur <= bar2_current;
					end if;
				when "0001" =>
					if gamer2 = "10" then
						bar2_futur <= "0010";
					elsif gamer2 = "01" then
						bar2_futur <= "0001";
					else
						bar2_futur <= bar2_current;
					end if;
					
				when others =>
					bar2_futur <= "1000";
				
				end case;
				
	end process logicBar2_inputs;
	

	
	LogicComb_entree: process(current_state)
		begin
			case current_state is
			
				when S1 =>
					
					if bar1_current(1) = '1' then
						if rnd_cnt <= 5 then
							next_state<= S6;
						else 
							next_state<= S5;
						end if;
					else
						next_state<= Loose1;
					end if;
					
				When S2 =>
					
					if bar1_current(2)  = '1' then
						if rnd_cnt <= 3 then
								next_state<= S5;
						elsif rnd_cnt <= 6 then
							next_state<= S6;
						elsif rnd_cnt <= 10 then
							next_state<= S7;
						end if;
			
					else
						next_state<= Loose1;
					end if;
						
				When S3 =>
					
					if bar1_current(3)  = '1' then
						if rnd_cnt <= 3 then
							next_state<= S6;
						elsif rnd_cnt <= 6 then
							next_state<= S7;
						else
							next_state<= S8;
						end if;
					else
						next_state<= Loose1;
					end if;
							
				When S4 =>
					
					if bar1_current(4) = '1' then
						if rnd_cnt <= 5 then
							next_state<= S7;
						else
							next_state<= S8;
						end if;
					else 
						next_state<= Loose1;
					end if;
						
				When S5 =>
					if previous_state = S1 then
						next_state<= S9;
					elsif previous_state = S2 then
						next_state<= S10;
					elsif previous_state = S9 then
						next_state<= S1;
					elsif previous_state = S10 then
						next_state<= S2;
					else
						
					end if;
						
				When S6 =>
					if previous_state = S1 then
						next_state<= S11;
					elsif previous_state = S2 then
						next_state<= S10;
					elsif previous_state = S3 then
						next_state<= S9;
					elsif previous_state = S9 then
						next_state<= S3;
					elsif previous_state = S10 then
						next_state<= S2;
					elsif previous_state = S11 then
						next_state<= S1;
					else
						
					end if;
				When S7 =>
					if previous_state = S2 then
						next_state<= S12;
					elsif previous_state = S3 then
						next_state<= S11;
					elsif previous_state = S4 then
						next_state<= S10;
					elsif previous_state = S10 then
						next_state<= S4;
					elsif previous_state = S11 then
						next_state<= S3;
					elsif previous_state = S12 then
						next_state<= S2;
					else
						
					end if;
						
				When S8 =>
					if previous_state = S3 then
						next_state<= S11;
					elsif previous_state = S4 then
						next_state<= S12;
					elsif previous_state = S11 then
						next_state<= S3;
					elsif previous_state = S12 then
						next_state<= S4;

					else
						
					end if;
						
				When S9 =>
					if previous_state = S5 then
						next_state<= S13;
					elsif previous_state = S6 then
						next_state<= S14;
					elsif previous_state = S13 then
						next_state<= S5;
					elsif previous_state = S14 then
						next_state<= S6;
					else
						
					end if;
						
				When S10 =>
					if previous_state = S5 then
						next_state<= S15;
					elsif previous_state = S6 then
						next_state<= S14;
					elsif previous_state = S7 then
						next_state<= S13;
					elsif previous_state = S13 then
						next_state<= S7;
					elsif previous_state = S14 then
						next_state<= S6;
					elsif previous_state = S15 then
						next_state<= S5;
					else
						
					end if;
						
				When S11 =>
					if previous_state = S6 then
						next_state<= S16;
					elsif previous_state = S7 then
						next_state<= S15;
					elsif previous_state = S8 then
						next_state<= S14;
					elsif previous_state = S14 then
						next_state<= S8;
					elsif previous_state = S15 then
						next_state<= S7;
					elsif previous_state = S16 then
						next_state<= S6;
					else
						
					end if;
						
				When S12 =>
					if previous_state = S7 then
						next_state<= S15;
					elsif previous_state = S8 then
						next_state<= S16;
					elsif previous_state = S15 then
						next_state<= S7;
					elsif previous_state = S16 then
						next_state<= S8;
					else
						
					end if;
						
				When S13 =>
					if previous_state = S9 then
						next_state<= S17;
					elsif previous_state = S10 then
						next_state<= S18;
					elsif previous_state = S17 then
						next_state<= S9;
					elsif previous_state = S18 then
						next_state<= S10;
					else
						
					end if;
						
				When S14 =>
					if previous_state = S9 then
						next_state<= S19;
					elsif previous_state = S10 then
						next_state<= S18;
					elsif previous_state = S11 then
						next_state<= S17;
					elsif previous_state = S17 then
						next_state<= S11;
					elsif previous_state = S18 then
						next_state<= S10;
					elsif previous_state = S19 then
						next_state<= S9;
					else
						
					end if;
						
				When S15 =>
					if previous_state = S10 then
						next_state<= S20;
					elsif previous_state = S11 then
						next_state<= S19;
					elsif previous_state = S12 then
						next_state<= S18;
					elsif previous_state = S18 then
						next_state<= S12;
					elsif previous_state = S19 then
						next_state<= S11;
					elsif previous_state = S20 then
						next_state<= S10;
					elsif previous_state = Loose1 then
						next_state<= S11;
					elsif previous_state = Loose2 then 
						next_state<= S19;
					
					else
						
					end if;
					
				When S16 =>
					if previous_state = S11 then
						next_state<= S19;
					elsif previous_state = S12 then
						next_state<= S20;
					elsif previous_state = S19 then
						next_state<= S11;
					elsif previous_state = S20 then
						next_state<= S12;
					else
						
					end if;
						
				When S17 =>
					if previous_state = S13 then
						next_state<= S21;
					elsif previous_state = S14 then
						next_state<= S22;
					elsif previous_state = S21 then
						next_state<= S13;
					elsif previous_state = S22 then
						next_state<= S14;
					else
						
					end if;
						
				When S18 =>
					if previous_state = S13 then
						next_state<= S23;
					elsif previous_state = S14 then
						next_state<= S22;
					elsif previous_state = S15 then
						next_state<= S21;
					elsif previous_state = S21 then
						next_state<= S15;
					elsif previous_state = S22 then
						next_state<= S14;
					elsif previous_state = S23 then
						next_state<= S13;
					else
						
					end if;
						
				When S19 =>
					if previous_state = S14 then
						next_state<= S24;
					elsif previous_state = S15 then
						next_state<= S23;
					elsif previous_state = S16 then
						next_state<= S22;
					elsif previous_state = S22 then
						next_state<= S16;
					elsif previous_state = S23 then
						next_state<= S15;
					elsif previous_state = S24 then
						next_state<= S14;
					else
						
					end if;
					
				When S20 =>
					if previous_state = S15 then
						next_state<= S23;
					elsif previous_state = S16 then
						next_state<= S24;
					elsif previous_state = S23 then
						next_state<= S15;
					elsif previous_state = S24 then
						next_state<= S16;
					else
						
					end if;
						
				When S21 =>
					
					if bar2_current(1)  = '1' then
						if rnd_cnt <= 5 then
							next_state<= S18;
						elsE 
							next_state<= S17;
						end if;
					else
						next_state<= Loose1;
					end if;
						
				When S22 =>
					
					if bar2_current(2) = '1' then
						if rnd_cnt <= 3 then
							next_state<= S17;
						elsif rnd_cnt <= 6 then
							next_state<= S18;
						elsif rnd_cnt <= 10 then
							next_state<= S19;
						end if;
					else
						next_state<= Loose1;
					end if;
					
				When S23 =>
					
					if bar2_current(3)= '1' then
						if rnd_cnt <= 3 then
							next_state<= S20;
						elsif rnd_cnt <= 6 then
							next_state<= S19;
						elsif rnd_cnt <= 10 then
							next_state<= S18;
						end if;
					else
						next_state<= Loose1;
					end if;
						
				When S24 =>
					
					if bar2_current(4)= '1' then
						if rnd_cnt <= 5 then
							next_state<= S20;
						elsif rnd_cnt <= 10 then
							next_state<= S19;
						end if;
					else
						next_state<= Loose1;
					end if;
					
				When Loose1 =>
					if rst = '1' then
						next_state<= S15;
					else
						next_state<= Loose2;
					end if;
					
				When Loose2 =>
					if rst = '1' then
						next_state<= S15;
					else
						next_state<= Loose1;
					end if;
				end case;
			end process LogicComb_entree;
			
		
		Mem_state_bar1 : process(clk_8hz)
		 
			begin

					
				if rising_edge(clk_8hz) then
					bar1_current <= bar1_futur;
				end if;
				
		end process Mem_state_bar1;
		
		Mem_state_bar2 : process(clk_8hz)
		
			begin

					
				if rising_edge(clk_8hz) then
					bar2_current <= bar2_futur;
				end if;
				
		end process Mem_state_bar2;
		

		
		Sortie_bar1 : process(bar1_current)
			begin
				case bar1_current is 
					when "1000" => leds(25 to 28) <= "1000";
					when "0100" => leds(25 to 28) <= "0100";
					when "0010" => leds(25 to 28) <= "0010";
					when "0001" => leds(25 to 28) <= "0001";
					when others =>
				end case;
				
		end process Sortie_bar1;
		
		Sortie_bar2 : process(bar2_current)
			begin
				case bar2_current is 
					when "1000" => leds(29 to 32) <= "1000";
					when "0100" => leds(29 to 32) <= "0100";
					when "0010" => leds(29 to 32) <= "0010";
					when "0001" => leds(29 to 32) <= "0001";
					when others =>
				end case;
				
		end process Sortie_bar2;
		
		Mem_state : process(clk_1hz)
		begin
			if rising_edge(clk_1hz) then
				previous_state <= current_state;
				current_state<= next_state;
			end if;
		end process Mem_state;
		
		LogComb_outputs : process(clk_1hz)
		begin
			
			
			case current_state is
				When S1 => 
					for i in 1 to 24 loop
						if i = 1 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
			
				When S2 => 
					for i in 1 to 24 loop
						if i = 2 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When S3 => 
					for i in 1 to 24 loop
						if i = 3 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When S4 =>
					for i in 1 to 24 loop
						if i = 4  then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When S5 => 
					for i in 1 to 24 loop
						if i = 5 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When S6 => 
					for i in 1 to 24 loop
						if i = 6 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When S7 => 
					for i in 1 to 24 loop
						if i = 7 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When S8 => 
					for i in 1 to 24 loop
						if i = 8 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When S9 => 
					for i in 1 to 24 loop
						if i = 9 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When S10 => 
					for i in 1 to 24 loop
						if i = 10 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When S11 => 
					for i in 1 to 24 loop
						if i = 11 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When S12 => 
					for i in 1 to 24 loop
						if i = 12 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When S13 => 
					for i in 1 to 24 loop
						if i = 13 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When S14 => 
					for i in 1 to 24 loop
						if i = 14 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When S15 => 
					for i in 1 to 24 loop
						if i = 15 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When S16 => 
					for i in 1 to 24 loop
						if i = 16 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When S17 => 
					for i in 1 to 24 loop
						if i = 17 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When S18 => 
					for i in 1 to 24 loop
						if i = 18 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When S19 => 
					for i in 1 to 24 loop
						if i = 19 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When S20 => 
					for i in 1 to 24 loop
						if i = 20 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When S21 => 
					for i in 1 to 24 loop
						if i = 21 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When S22 => 
					for i in 1 to 24 loop
						if i = 22 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When S23 => 
					for i in 1 to 24 loop
						if i = 23 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
				When S24 => 
					for i in 1 to 24 loop
						if i = 24 then
							leds(i) <= '1';
						else
							leds(i) <='0';
						end if;
					end loop;
					
				When Loose1 => 
					for i in 1 to 24 loop
						leds(i) <= '1';
					end loop;
					
				When Loose2 => 
					for i in 1 to 24 loop
						leds(i) <='0';
					end loop;

				end case;
			end process LogComb_outputs;
			

end Behavourial;
