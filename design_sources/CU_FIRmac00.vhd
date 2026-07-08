library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CU_FIRmac00 is
port(
    END_op_in        : in std_logic;
    ST               : in std_logic;
    DATA_REDY_IN     : in std_logic;
    ACK              : in std_logic;
    CLK              : in std_logic;
    RST              : in std_logic;
    ST_op            : out std_logic;
    LD_out           : out std_logic;
    ri               : out std_logic;
    REQ_NEW_SAMPLE   : out std_logic;
    DATA_REDY_OUT    : out std_logic;
    END_OP           : out std_logic
);
end CU_FIRmac00;

architecture RTL of CU_FIRmac00 is

    type state is (s0,s1,s2,s3,s4,s5);
    signal next_state,current_state: state;

begin

    status_reg: process(CLK)
    begin
        if(rising_edge(CLK))then
            if(RST='1')then
                current_state <= s0;
            else
                current_state <= next_state;
            end if;
        end if;
    end process;

    next_state_pro: process(ST, DATA_REDY_IN, END_op_in, ACK, current_state)
    begin
        case current_state is
            when s0 =>
                if(ST='0')then
                    next_state <= s0;
                else
                    next_state <= s1;
                end if;
                
            when s1 =>
                if(DATA_REDY_IN='0')then
                    next_state <= s1;
                else
                    next_state <= s2;
                end if;
            
            when s2 => 
                next_state <= s3;
                
            when s3 =>
                if(END_op_in='0')then
                    next_state <= s3;
                else
                    next_state <= s4;
                end if;              
                
            when s4 => 
                next_state <= s5;

            when s5 =>
                if(ACK='0')then
                    next_state <= s5;
                elsif(ST='0')then
                    next_state <= s0;
                else
                    next_state <= s1;
                end if;
     
            when others =>
                next_state <= s0;
            
        end case; 
    end process; 
    
    out_pro: process(current_state)
    begin
        case current_state is
        when s0 =>
            ST_op            <= '0';
            LD_out           <= '0';
            ri               <= '1';
            REQ_NEW_SAMPLE   <= '0';
            DATA_REDY_OUT    <= '0';
            END_OP           <= '1';
            
        when s1 =>
            ST_op            <= '0';
            LD_out           <= '0';
            ri               <= '0';
            REQ_NEW_SAMPLE   <= '1';
            DATA_REDY_OUT    <= '0';
            END_OP           <= '0';
            
        when s2 =>
            ST_op            <= '1';
            LD_out           <= '0';
            ri               <= '0';
            REQ_NEW_SAMPLE   <= '0';
            DATA_REDY_OUT    <= '0';
            END_OP           <= '0'; 
            
        when s3 =>
            ST_op            <= '0';
            LD_out           <= '0';
            ri               <= '0';
            REQ_NEW_SAMPLE   <= '0';
            DATA_REDY_OUT    <= '0';
            END_OP           <= '0';  
            
        when s4 =>
            ST_op            <= '0';
            LD_out           <= '1';
            ri               <= '0';
            REQ_NEW_SAMPLE   <= '0';
            DATA_REDY_OUT    <= '0';
            END_OP           <= '0';           
            
        when s5 =>
            ST_op            <= '0';
            LD_out           <= '0';
            ri               <= '0';
            REQ_NEW_SAMPLE   <= '0';
            DATA_REDY_OUT    <= '1';
            END_OP           <= '0';                                                   
    
        when others =>
            ST_op            <= '0';
            LD_out           <= '0';
            ri               <= '1';
            REQ_NEW_SAMPLE   <= '0';
            DATA_REDY_OUT    <= '0';
            END_OP           <= '1';                                 
    
        end case; 
    end process;  
        
end RTL;
