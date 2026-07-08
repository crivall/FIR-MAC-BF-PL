library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MAC_op_00 is
generic(ni : integer:=8;
        nh : integer:=12;
        no : integer:=25;
        N : integer:= 24
);
port(
    DATA_IN : in std_logic_vector(ni-1 downto 0);
    ST_op : in std_logic;
    CLK : in std_logic;
    ri : in std_logic;
    END_op : out std_logic;
    DATA_OUT : out std_logic_vector(no-1 downto 0)
);
end MAC_op_00;

architecture RTL of MAC_op_00 is

    component Core_MAC_op_00 is
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
    end component;
    
    component CU_MAC_op_00 is
    generic(N : integer:=24);
    port(
        ST_op : in std_logic;
        ri : in std_logic;
        CLK : in std_logic;
        EN_IN : out std_logic;
        U_S : out std_logic;
        EN_SR : out std_logic;
        RST_SR : out std_logic;
        EN_H : out std_logic;
        PRELOAD : out std_logic;
        EN_BF : out std_logic;
        RST_BF : out std_logic;
        EN_ACC : out std_logic;
        RST_ACC : out std_logic;
        EN_OUT : out std_logic;
        RST_OUT : out std_logic;
        END_op : out std_logic
    );
    end component;
    
    signal EN_IN_t, U_S_t, EN_SR_t, RST_SR_t, EN_H_t, PRELOAD_t, EN_BF_t, RST_BF_t, EN_ACC_t, RST_ACC_t, EN_OUT_t, RST_OUT_t : std_logic; 

begin

    Core_MAC_op_00_init: Core_MAC_op_00 
    generic map(ni => ni,
            nh => nh,
            no => no,
            N => N
    )
    port map(DATA_IN => DATA_IN,
         EN_IN => EN_IN_t,
         CLK => CLK,
         U_S => U_S_t,
         EN_SR => EN_SR_t,
         RST_SR => RST_SR_t, 
         EN_H => EN_H_t,
         PRELOAD => PRELOAD_t,
         EN_ACC => EN_ACC_t,
         RST_BF => RST_BF_t,
         EN_BF => EN_BF_t,
         RST_ACC => RST_ACC_t,
         EN_OUT => EN_OUT_t,
         RST_OUT => RST_OUT_t,    
         DATA_OUT => DATA_OUT 
    );

    CU_MAC_op_00_init: CU_MAC_op_00 
    generic map(N => N)
    port map(
        ST_op => ST_op,
        ri => ri,
        CLK => CLK,
        EN_IN => EN_IN_t,
        U_S => U_S_t,
        EN_SR => EN_SR_t,
        RST_SR => RST_SR_t,
        EN_H => EN_H_t,
        PRELOAD => PRELOAD_t,
        EN_BF => EN_BF_t,
        RST_BF => RST_BF_t,
        EN_ACC => EN_ACC_t,
        RST_ACC => RST_ACC_t,
        EN_OUT => EN_OUT_t,
        RST_OUT => RST_OUT_t,
        END_op => END_op 
    );

end RTL;
