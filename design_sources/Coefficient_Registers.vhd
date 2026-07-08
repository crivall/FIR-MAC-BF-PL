library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use std.textio.all;


entity Coefficient_Registers is
generic(nh : integer:=12;
        N : integer:= 24
);
port(CLK : in std_logic;
     EN_H : in std_logic;
     PRELOAD : in std_logic;
     DATA_OUT : out std_logic_vector(nh-1 downto 0)
);
end Coefficient_Registers;

architecture RTL of Coefficient_Registers is

type RomType is array(0 to N-1) of bit_vector(nh-1 downto 0);
type Coefficient_Registers is array(0 to N-1) of std_logic_vector(nh-1 downto 0);

impure function InitRomFromFile (RomFileName : in string) return RomType is
FILE RomFile : text open READ_MODE is RomFileName;
variable RomFileLine : line;
variable ROM : RomType;
begin
for I in RomType'range loop
readline (RomFile, RomFileLine);
read (RomFileLine, ROM(I));
end loop;
return ROM;
end function;

signal ROM : RomType := InitRomFromFile("C:\Users\Cristina\Downloads\FIR_MAC_v00a_sources\matlab\roms_init_file.txt");
signal CR, PRELOAD_CR: Coefficient_Registers;

begin

    rom_core: for I in 0 to N-1 generate
    PRELOAD_CR(I) <=  To_StdLogicVector(ROM(I));
    end generate;
    
    CRinst: process(CLK)
    begin
        if rising_edge(CLK)then
            if(PRELOAD='1')then
                CR <= PRELOAD_CR;
            elsif (EN_H='1')then
                CR(0) <= CR(N-1);
                for I in 1 to N-1 loop
                    CR(I) <= CR(I-1);
                end loop; 
            end if;   
        end if;                                                                  
    end process;
    
    
    DATA_OUT <= CR(N-1);
    
    


end RTL;
