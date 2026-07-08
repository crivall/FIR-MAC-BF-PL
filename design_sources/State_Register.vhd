
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity State_Register is
generic(ni : integer :=8;
        N : integer :=24
 );
 port(DATA_IN : in std_logic_vector(ni-1 downto 0);
      EN_IN : in std_logic;
      CLK : in std_logic;
      U_S : in std_logic;
      EN_SR: in std_logic;
      RST_SR : in std_logic;
      DATA_OUT: out std_logic_vector(ni-1 downto 0)  
 );
end State_Register;

architecture RTL of State_Register is

    signal Rin : std_logic_vector(ni-1 downto 0);  
    signal Min0, Min1, Mout : std_logic_vector(ni-1 downto 0); 

    type srType is array (0 to N-1) of std_logic_vector(ni-1 downto 0);
    signal SR: srType:=(others => (others => '0'));  

begin

    Rin_reg: process (CLK)
    begin
        if (rising_edge(CLK) and EN_IN='1') then
            Rin <= DATA_IN;
        end if;
    end process;
    
    Min1 <= Rin;
    

    MUX: process(U_S,Min0,Min1)
    begin
        if(U_S='0')then
            Mout <= Min0;
        else 
            Mout <= Min1;
        end if;
    end process;
    
    SRinst: process(CLK)
    begin
        if rising_edge(CLK) then
            if RST_SR = '1' then 
                SR <= (others => (others => '0')); 
            elsif EN_SR = '1' then
                SR(0) <= Mout;
                for I in 1 to N-1 loop
                    SR(I) <= SR(I-1);
                end loop;
            end if;
        end if;
    end process;
    
    Min0 <= SR(N-1);
    
    DATA_OUT <= SR(N-1);


end RTL;
