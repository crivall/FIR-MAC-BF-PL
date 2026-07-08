library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity Core_MAC_op_00 is
generic(ni : integer:=8;
        nh : integer:=12;
        no : integer:=25;
        N : integer:= 24
);
port(DATA_IN : in std_logic_vector(ni-1 downto 0);
     EN_IN : in std_logic;
     CLK : in std_logic;
     U_S : in std_logic;
     EN_SR: in std_logic;
     RST_SR : in std_logic; 
     EN_H : in std_logic;
     PRELOAD : in std_logic;
     EN_BF : in std_logic;
     RST_BF : in std_logic;
     EN_ACC : in std_logic;
     RST_ACC : in std_logic;
     EN_OUT : in std_logic;
     RST_OUT : in std_logic;    
     DATA_OUT : out std_logic_vector(no-1 downto 0)
);
end Core_MAC_op_00;

architecture RTL of Core_MAC_op_00 is


    component State_Register is
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
    end component;
    
    component Coefficient_Registers is
    generic(nh : integer:=12;
            N : integer:= 24
    );
    port(CLK : in std_logic;
         EN_H : in std_logic;
         PRELOAD : in std_logic;
         DATA_OUT : out std_logic_vector(nh-1 downto 0)
    );
    end component;
    
    component MAC_unit is
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
    end component;
    
    signal DATA_SR_t : std_logic_vector(ni-1 downto 0);
    signal DATA_CR_t : std_logic_vector(nh-1 downto 0);

begin

init_State_Register: State_Register 
    generic map(ni => ni,
                N => N
                )
    port map (DATA_IN => DATA_IN,
              EN_IN => EN_IN,
              CLK => CLK,
              U_S => U_S,
              EN_SR => EN_SR,
              RST_SR => RST_SR,
              DATA_OUT => DATA_SR_t 
              );  


init_Coefficient_Registers: Coefficient_Registers 
    generic map (nh => nh, 
                 N => N 
                 )
    port map (CLK => CLK,
              EN_H => EN_H,
              PRELOAD => PRELOAD,
              DATA_OUT => DATA_CR_t
              );


init_MAC_unit: MAC_unit 
    generic map (ni => ni,
                 nh => nh,
                 no => no 
                 )
    port map (DATA_SR => DATA_SR_t,
              DATA_CR => DATA_CR_t,
              EN_BF =>EN_BF,
              RST_BF =>RST_BF,
              EN_ACC => EN_ACC,
              RST_ACC => RST_ACC,
              EN_OUT => EN_OUT,
              RST_OUT => RST_OUT,
              CLK => CLK, 
              DATA_OUT => DATA_OUT
              );


end RTL;
