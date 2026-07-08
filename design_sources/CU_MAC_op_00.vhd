library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CU_MAC_op_00 is
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
end CU_MAC_op_00;

architecture RTL of CU_MAC_op_00 is

    component Master_CU_MAC_op_00 is
    port(
        ST_op : in std_logic;
        END_MUL : in std_logic;
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
        END_op : out std_logic;
        EN_CONT : out std_logic;
        RST_CONT : out std_logic 
    );
    end component;
    
    component CONT is
    generic(N : integer:=24);
    port(EN_CONT : in std_logic;
         RST_CONT : in std_logic;
         CLK : in std_logic;
         END_MUL : out std_logic
    );
    end component;

signal END_MUL_t,EN_CONT_t,RST_CONT_t:std_logic;
begin

    Master_CU_MAC_op_00_init: Master_CU_MAC_op_00 
    port map(
        ST_op => ST_op,
        END_MUL => END_MUL_t,
        ri => ri,
        CLK => CLK,
        EN_IN => EN_IN,
        U_S => U_S,
        EN_SR => EN_SR,
        RST_SR => RST_SR,
        EN_H => EN_H,
        PRELOAD => PRELOAD,
        EN_BF => EN_BF,
        RST_BF => RST_BF,
        EN_ACC => EN_ACC,
        RST_ACC => RST_ACC,
        EN_OUT => EN_OUT,
        RST_OUT => RST_OUT,
        END_op => END_op,
        EN_CONT => EN_CONT_t,
        RST_CONT => RST_CONT_t 
    );

    
    CONT_init: CONT 
    generic map(N => N)
    port map(
         EN_CONT => EN_CONT_t,
         RST_CONT => RST_CONT_t,
         CLK => CLK,
         END_MUL => END_MUL_t
    );
    

end RTL;
