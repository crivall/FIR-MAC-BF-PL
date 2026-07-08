library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Master_CU_MAC_op_00 is
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
end Master_CU_MAC_op_00;

architecture RTl of Master_CU_MAC_op_00 is

    type state is (s0,s1,s2,s3,s4,s5,s6,s7);
    signal next_state,current_state: state;

begin

    status_reg: process(CLK)
    begin
        if(rising_edge(CLK))then
            if(ri='1')then
                current_state <= s0;
            else
                current_state <= next_state;
            end if;
        end if;
    end process;
    
    next_state_pro: process(ST_op, END_MUL, current_state)
    begin
        case current_state is
            when s0 =>
                if(ST_op='0')then
                    next_state <= s0;
                else
                    next_state <= s1;
                end if;
                
            when s1 => 
                next_state <= s2;
            
            when s2 => 
                next_state <= s3;
            
            when s3 => 
                next_state <= s4;
                
            
            when s4 => 
                
                if(END_MUL='0')then
                    next_state <= s4;
                else
                    next_state <= s5;
                end if;   
                
            when s5 =>
                next_state <= s6;
                
            when s6 =>
                next_state <= s7;
           
            when s7 =>
                if(ST_op='0')then
                    next_state <= s7;
                else
                    next_state <= s1;
                end if;        
     
            when others =>
                next_state <= s0;
            
        end case; 
    end process;     
    
    out_pro: process(current_state)
    begin
            EN_IN <= '0';
            U_S <= '0';
            EN_SR <= '0';
            RST_SR <= '0';
            EN_H <= '0';
            PRELOAD <= '0';
            EN_BF <= '0';
            RST_BF <= '0';
            EN_ACC <= '0';
            RST_ACC <= '0';
            EN_OUT <= '0';
            RST_OUT <= '0';
            END_op <= '0';
            EN_CONT <= '0';
            RST_CONT <= '0'; 
            
        case current_state is
            when s0 =>
                RST_SR <= '1';
                PRELOAD <= '1';
                RST_OUT <= '1'; 
            
            when s1 =>
                EN_IN<= '1';
                RST_ACC<= '1';
                RST_CONT<= '1';
                RST_BF<= '1';
                
            
            when s2 =>
                U_S <= '1';
                EN_SR <= '1';
                
            when s3=>
                EN_BF <= '1';
                EN_SR    <= '1';  
                EN_H     <= '1';
                EN_CONT <= '1';
                
            when s4 =>
                EN_BF <= '1';
                EN_CONT <= '1';
                EN_ACC   <= '1';
                EN_SR    <= '1';  
                EN_H     <= '1';
                
            when s5 =>
                EN_ACC   <= '1';
                                          
            when s6 =>
                EN_OUT   <= '1';  
                END_op   <= '1';
                
            when s7 =>
                null;
                
            when others =>
                RST_SR <= '1';
                PRELOAD <= '1';
                RST_OUT <= '1';                                  
        
            end case; 
        end process;
    

end RTl;
