
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity CONT is
generic(N : integer:=24);
port(EN_CONT : in std_logic;
     RST_CONT : in std_logic;
     CLK : in std_logic;
     END_MUL : out std_logic
);
end CONT;

architecture RTL of CONT is

    signal cnt: integer range 0 to N;

begin

    cnt_proc: process(CLK)
    begin
        if rising_edge(CLK)then
            if RST_CONT='1' then
                cnt <= 0;
            elsif EN_CONT='1' then
                cnt <= cnt+1;
            end if;
         end if;
    end process;
    
    
    compare_proc: process(cnt)
    begin 
        if cnt=(N-1) then
            END_MUL <= '1';
        else
            END_MUL <= '0';
        end if;
    end process;

end RTL;
