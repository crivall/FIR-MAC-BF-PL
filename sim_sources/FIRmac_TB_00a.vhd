----------------------------------------------------------------------------------
-- DSPHW 2024/2025
-- v00 250509
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.std_logic_signed.all;
use std.textio.all;

entity FIRmac_TB_00a is
--  Port ( );
end FIRmac_TB_00a;

architecture Behavioral of FIRmac_TB_00a is

constant ni             : integer:= 8;
constant no             : integer:= 25;

component FIRmac_00a is
    port(
        DATA_IN          : in std_logic_vector(ni-1 downto 0);
        ST               : in std_logic;
        DATA_REDY_IN     : in std_logic;
        ACK              : in std_logic;
        CLK              : in std_logic;
        RST              : in std_logic;
        DATA_OUT         : out std_logic_vector(no-1 downto 0);
        REQ_NEW_SAMPLE   : out std_logic;
        DATA_REDY_OUT    : out std_logic;
        END_OP           : out std_logic
    );
end component;

signal DATA_IN          : std_logic_vector(ni-1 downto 0):=(others =>'0');
signal ST               : std_logic:='0';
signal DATA_REDY_IN     : std_logic:='0';
signal ACK              : std_logic:='0';
signal CLK              : std_logic:='0';
signal RST              : std_logic:='0';
signal DATA_OUT         : std_logic_vector(no-1 downto 0):=(others =>'0');
signal REQ_NEW_SAMPLE   : std_logic:='0';
signal DATA_REDY_OUT    : std_logic:='0';
signal END_OP           : std_logic:='0';

signal DATA_REDY_IN_t, ACK_t, END_read: std_logic:='0';
signal DATA_IN_t: std_logic_vector(ni-1 downto 0):=(others =>'0');

constant Tclk: time:=15 ns; 

begin

-- UUT
UUT: FIRmac_00a 
    port map(
        DATA_IN          => DATA_IN,
        ST               => ST,
        DATA_REDY_IN     => DATA_REDY_IN,
        ACK              => ACK,
        CLK              => CLK,
        RST              => RST,
        DATA_OUT         => DATA_OUT,
        REQ_NEW_SAMPLE   => REQ_NEW_SAMPLE,
        DATA_REDY_OUT    => DATA_REDY_OUT,
        END_OP           => END_OP
    );
    
    -- clock -- 

CLK <= not CLK after Tclk/2;

    -- DATA_REDY_IN --

DATA_REDY_IN_proc: process(REQ_NEW_SAMPLE)
begin 
    if(rising_edge(REQ_NEW_SAMPLE))then
        DATA_REDY_IN_t <='1';
    elsif(falling_edge(REQ_NEW_SAMPLE))then
        DATA_REDY_IN_t <='0';
    end if; 
end process;

DATA_REDY_IN <= DATA_REDY_IN_t after Tclk/4;

    -- Read input file --
    
Read_input_file: process( REQ_NEW_SAMPLE )
    file fpi: text open read_mode is "C:\Users\Cristina\Downloads\FIR_MAC_v00a_sources\matlab\input_file.txt";
    variable lni: line;
    variable DI: bit_vector(ni-1 downto 0);
begin
    if (rising_edge(REQ_NEW_SAMPLE) and END_read='0') then
        readline( fpi, lni );
        read( lni, DI );
        DATA_IN_t <= To_StdLogicVector(DI);

        if endfile( fpi ) = true then
            END_read <= '1';
            DATA_IN_t <= (others =>'0');
        end if;
        
    end if;
end process;

DATA_IN <= DATA_IN_t after Tclk/4;

    -- ACK --

ACK_proc: process(DATA_REDY_OUT)
begin 
    if(rising_edge(DATA_REDY_OUT))then
        ACK_t <='1';
    elsif(falling_edge(DATA_REDY_OUT))then
        ACK_t <='0';
    end if; 
end process;

ACK <= ACK_t after Tclk/4;

    -- Write output file --
       
write_output_file: process(ACK)
    file fpo: text open write_mode is "C:\Users\Cristina\Downloads\FIR_MAC_v00a_sources\matlab\output_file_PL.txt";
    variable lno: line;
    --variable DO: bit_vector(no-1 downto 0);
    variable DO: integer;
begin 
    if rising_edge(ACK) then
        --DO := to_bitvector( DATA_OUT );        
        DO := CONV_INTEGER(DATA_OUT);
        write(lno,DO);
        writeline(fpo,lno);
    end if;
end process;

  -- Stimulus process --
stim_proc: process
begin
  -- Apply reset
  wait for 100 ns;
  wait for Tclk*100;
  RST <= '1';
  wait for Tclk*10;
  RST <= '0';

  -- Start the filter
  wait for Tclk*400;
  ST <= '1';
  wait for Tclk*16000; 

  -- Finish the test
  ST <= '0';
  wait;

end process;



end Behavioral;
