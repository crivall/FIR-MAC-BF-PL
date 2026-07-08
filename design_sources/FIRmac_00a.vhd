
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FIRmac_00a is
    generic(
        N       : integer := 24; -- Number of filter coefficients 
        ni      : integer := 8; -- Number of bits for inputs representation
        nh      : integer := 12;  -- Number of bits for coefficient representation
        no      : integer := 25 --(ni+nh+nacc) -- nacc:= ceil(log2(real(N)));  -- Number of bits for outputs representation
    );
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
end FIRmac_00a;

architecture RTL of FIRmac_00a is

    component CU_FIRmac00 is
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
    end component;
    
    component MAC_op_00 is
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
    end component;    
    
    signal END_op_t, ST_op_t, LD_out_t, ri_t: std_logic;
    signal R1: std_logic_vector(ni-1 downto 0);
    signal R2_t, R2 : std_logic_vector(no-1 downto 0);
    
begin


    CU_FIRmac00_init: CU_FIRmac00 
    port map(
        END_op_in        => END_op_t,
        ST               => ST,
        DATA_REDY_IN     => DATA_REDY_IN,
        ACK              => ACK,
        CLK              => CLK,
        RST              => RST,
        ST_op            => ST_op_t,
        LD_out           => LD_out_t,
        ri               => ri_t,
        REQ_NEW_SAMPLE   => REQ_NEW_SAMPLE,
        DATA_REDY_OUT    => DATA_REDY_OUT,
        END_OP           => END_OP
    );

    R1_reg: process(CLK)
    begin
        if rising_edge(CLK) then
            if ri_t = '1' then 
                R1 <= (others => '0'); 
            elsif ST_op_t = '1' then
                R1 <= DATA_IN;
            end if;
        end if;
    end process;
    
    MAC_op_00_init: MAC_op_00 
    generic map(ni => ni,
            nh => nh,
            no => no,
            N => N
    )
    port map(
        DATA_IN => R1,
        ST_op => ST_op_t,
        CLK => CLK,
        ri => ri_t,
        END_op => END_op_t,
        DATA_OUT => R2_t
    );

    R2_reg: process(CLK)
    begin
        if rising_edge(CLK) then
            if ri_t = '1' then 
                R2 <= (others => '0'); 
            elsif LD_out_t = '1' then
                R2 <= R2_t;
            end if;
        end if;
    end process;
    
    DATA_OUT <= R2;

end RTL;
