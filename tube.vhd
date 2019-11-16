library ieee;
use ieee.std_logic_1164.all;

entity tube is port(s:in std_logic_vector(3 downto 0);
							clk,rst:in std_logic;
							dig:out std_logic_vector(3 downto 0);
							seg:out std_logic_vector(0 to 6);
							led:out std_logic_vector(3 downto 0));
end tube;

architecture beh of tube is

function num2digit (n:integer) return std_logic_vector is
begin
    case n is
    when 0 => return "0000001"; -- "0"     
    when 1 => return "1001111"; -- "1" 
    when 2 => return "0010010"; -- "2" 
    when 3 => return "0000110"; -- "3" 
    when 4 => return "1001100"; -- "4" 
    when 5 => return "0100100"; -- "5" 
    when 6 => return "0100000"; -- "6" 
    when 7 => return "0001111"; -- "7" 
    when 8 => return "0000000"; -- "8"     
    when 9 => return "0000100"; -- "9" 
	 when others=> return "1111111";
    end case;
end function;

signal cnt:integer range 0 to 9999:=0;
signal cl:integer range 0 to 50_000_000:=0;
signal dt:std_logic_vector(3 downto 0):="1110";
signal cl240:integer range 0 to 240:=0;

begin
led<=s;
	process(clk,rst)
	begin
	if(rst = '0') then
		cl<=0;cnt<=0;cl240<=0;dt<="1110";
	elsif(rising_edge(clk)) then
		if(cl=49_999_999) then
			cl<=0;cnt<=cnt+1;
				if(cnt= 9998) then cnt<=0;end if;
		elsif(cl<49_999_999) then cl<=cl+1; end if;
		if(cl240 = 239) then cl240<=0;dt<=dt(2 downto 0)&dt(3); 
		else cl240<=cl240+1;end if;
	end if;
		end process;
		

		with dt select seg<=
		num2digit(cnt rem 10) when "1110",
		num2digit((cnt / 10) rem 10) when "1101",
		num2digit((cnt / 100) rem 10) when "1011",
		num2digit(cnt / 1000) when "0111",
		"ZZZZZZZ" WHEn others;
		
		dig<=dt;
end beh;
			
			
		
	
	
	