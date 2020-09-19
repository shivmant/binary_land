-------------------------------------------------------
-- Design Name : lfsr
-- File Name   : lfsr.vhd
-- Function    : Linear feedback shift register
-- Coder       : Deepak Kumar Tala (Verilog)
-- Translator  : Alexander H Pham (VHDL)
-- parametraziatiom : el3ctriciian
-------------------------------------------------------

-- source: https://github.com/el3ctrician/lfsr/blob/master/lfsr.vhd

library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;
    
entity lfsr is
  generic
  (
    width: integer
  );
  port (
    cout   :out std_logic_vector (width-1 downto 0);-- Output of the counter
    CE     :in  std_logic;                    -- Enable counting
    CLK    :in  std_logic;                    -- Input clock
    SCLR   :in  std_logic;                     -- Input reset
    seed   :in  std_logic_vector (12 downto 0)
  );
end entity;

architecture rtl of lfsr is
    signal nSeed           : natural range 12 downto 0 := to_integer(unsigned(seed));
    signal count           :std_logic_vector (width-1 downto 0):= std_logic_vector(to_unsigned(nSeed,width)) ;
    signal linear_feedback :std_logic;
begin
    
    linear_feedback <= not(count(width-1) xor count(width/2));


    process (CLK, SCLR, CE) begin
        if (SCLR = '1') then
            cout <= (others=>'0');
        else
            cout <= count;
        end if;
        if (rising_edge(CLK)) then
            if (CE = '1' and SCLR = '0') then
                count(width-1 downto 1) <= count(width-2 downto 0) ;
                count(0) <= linear_feedback;
            end if;
        end if;


    end process;

end architecture;