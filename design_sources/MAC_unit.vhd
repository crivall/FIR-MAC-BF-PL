library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity MAC_unit is
generic(ni : integer:=8;
        nh : integer:=12;
        no : integer:=25 
);
port(DATA_SR : in std_logic_vector(ni-1 downto 0);
     DATA_CR : in std_logic_vector(nh-1 downto 0);
     EN_BF : in std_logic;
     RST_BF : in std_logic;
     EN_ACC : in std_logic;
     RST_ACC : in std_logic;
     EN_OUT : in std_logic;
     RST_OUT : in std_logic;
     CLK : in std_logic;  
     DATA_OUT : out std_logic_vector(no-1 downto 0)
);
end MAC_unit;

architecture RTL of MAC_unit is

    signal mult,bf: signed((ni+nh)-1 downto 0);
    signal sum, ACC, Output : std_logic_vector (no-1 downto 0);

begin

    mult <= signed(DATA_SR) * signed(DATA_CR);
    
    BF_reg: process(CLK)
    begin
        if rising_edge(CLK) then
            if RST_BF = '1' then 
                bf <= (others => '0'); 
            elsif EN_BF = '1' then
                bf <= mult;
            end if;
        end if;
    end process; 
    
    sum <= std_logic_vector(resize(bf, no) + signed(ACC));
    
    ACC_reg: process(CLK)
    begin
        if rising_edge(CLK) then
            if RST_ACC = '1' then 
                ACC <= (others => '0'); 
            elsif EN_ACC = '1' then
                ACC <= sum;
            end if;
        end if;
    end process; 
    
    Output_reg: process(CLK)
    begin
        if rising_edge(CLK) then
            if RST_OUT = '1' then 
                Output <= (others => '0'); 
            elsif EN_OUT = '1' then
                Output <= ACC;
            end if;
        end if;
    end process; 
    
    DATA_OUT <= Output;
    

end RTL;
