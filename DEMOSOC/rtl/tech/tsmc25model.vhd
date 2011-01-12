------------------------------------------------------------------
-- Behavioural models only needed for simulation, not synthesis.
------------------------------------------------------------------

-- synopsys translate_off

------------------------------------------------------------------
-- behavioural ram models ----------------------------------------
------------------------------------------------------------------

-- Synchronous SRAM simulation model

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity asic_syncram_ss is
  generic ( abits : integer := 10; dbits : integer := 8 );
  port (
    CLK: in std_logic;
    CEN: in std_logic;
    WEN: in std_logic_vector(3 downto 0);
    A:  in  std_logic_vector((abits -1) downto 0);
    D:  in  std_logic_vector((dbits -1) downto 0);
    Q:  out std_logic_vector((dbits -1) downto 0)
  ); 
end;     

architecture behavioral of asic_syncram_ss is
  subtype word is std_logic_vector((dbits -1) downto 0);
  type mem is array(0 to (2**abits -1)) of word;
begin
g0:if dbits = 32 generate
  main : process(CLK)
  variable memarr : mem;
  begin
    if rising_edge(CLK) and (CEN = '0') then
      if not is_x(A) then
        if WEN(0) = '0' then
          memarr(conv_integer(unsigned(A)))(7 downto 0) := D(7 downto 0);
        end if;
        if WEN(1) = '0' then
          memarr(conv_integer(unsigned(A)))(15 downto 8) := D(15 downto 8);
        end if;
        if WEN(2) = '0' then
          memarr(conv_integer(unsigned(A)))(23 downto 16) := D(23 downto 16);
        end if;
        if WEN(3) = '0' then
          memarr(conv_integer(unsigned(A)))(31 downto 24) := D(31 downto 24);
        end if;
        Q <= memarr(conv_integer(unsigned(A)));
      else
        Q <= (others => 'Z');
      end if;
    end if;
  end process;
  end generate;

g1:if dbits /= 32 generate
  main : process(CLK)
  variable memarr : mem;
  begin
    if rising_edge(CLK) and (CEN = '0') then
      if not is_x(A) then
        if WEN(0) = '0' then
          memarr(conv_integer(unsigned(A))) := D;
        end if;
        Q <= memarr(conv_integer(unsigned(A)));
      else
        Q <= (others => 'Z');
      end if;
    end if;
  end process;
  end generate;

end behavioral;


-- Synchronous DPRAM simulation model

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity asic_dpram_ss is
  generic (
    abits : integer := 8;
    dbits : integer := 32;
    words : integer := 256
  );
  port (
    CLKA: in std_logic;
    CENA: in std_logic;
    WENA: in std_logic;
    AA: in std_logic_vector (abits -1 downto 0);
    DA: in std_logic_vector (dbits -1 downto 0);
    QA: out std_logic_vector (dbits -1 downto 0);
    CLKB: in std_logic;
    CENB: in std_logic;
    WENB: in std_logic;
    AB: in std_logic_vector (abits -1 downto 0);
    DB: in std_logic_vector (dbits -1 downto 0);
    QB: out std_logic_vector (dbits -1 downto 0)
  );
end;

architecture behav of asic_dpram_ss is

  signal writea : std_logic := '0';
  signal writeb : std_logic := '0';
  signal reada  : std_logic := '0';
  signal readb  : std_logic := '0';

  subtype word is std_logic_vector((dbits -1) downto 0);
  type mem is array(0 to words-1) of word;

  constant t_cc : time := 2 ns;  -- clock collision time
  constant t_ac : time := 3 ns;  -- access time
  
begin

  portA : process(CLKA,CLKB)

  variable memarr : mem;
  variable last_addr: std_logic_vector (abits -1 downto 0);

  begin
    if rising_edge(CLKA) and (CENA = '0') then
      if not is_x(AA) then
        if writeb = '1'  and last_addr = AA then
          if WENA = '0' then  -- write-write collision
            memarr(conv_integer(unsigned(AA)) mod words) := (others => 'X');
            QA <= DA  after t_ac;
            writea <= '1', '0' after t_cc;
          else
            QA <= (others => 'X'); -- write-read collision
          end if;
        else
          if WENA = '0' then
            memarr(conv_integer(unsigned(AA)) mod words) := DA;
            writea <= '1', '0' after t_cc;
            if readb = '1' and last_addr = AA then
              QB <= (others => 'X');  -- read-write collision
            end if;
          else
            reada <= '1', '0' after t_cc;
          end if;
          last_addr := AA;
          QA <= memarr(conv_integer(unsigned(AA)) mod words) after t_ac;
        end if;
      else
        QA <= (others => 'X');
      end if;
    end if;

    if rising_edge(CLKB) and (CENB = '0') then
      if not is_x(AB) then
        if writea = '1' and last_addr = AA then 
          if WENB = '0' then   -- write-write collision
            memarr(conv_integer(unsigned(AB)) mod words) := (others => 'X');
            QB <= DB after t_ac;
            writeb <= '1', '0' after t_cc;
          else
            QB <= (others => 'X'); -- write-read collision
          end if;
        else
          if WENB = '0' then
            memarr(conv_integer(unsigned(AB)) mod words) := DB;
            writeb <= '1', '0' after t_cc;
            if reada = '1' and last_addr = AB then
              QA <= (others => 'X');  -- read-write collision
            end if;
          else
            readb <= '1', '0' after t_cc;
          end if;
          last_addr := AB;
          QB <= memarr(conv_integer(unsigned(AB)) mod words) after t_ac;
        end if;
      else
        QB <= (others => 'X');
      end if;
    end if;

  end process;

end behav;


-----------------------------------------------------------
-- syncronous tsmc25 sram simulation model package --------
-----------------------------------------------------------

LIBRARY ieee;
use IEEE.std_logic_1164.all;
package tech_asic_sim is

component asic_syncram_ss
  generic ( abits : integer := 10; dbits : integer := 8 );
  port (
  CLK: in std_logic;
  CEN: in std_logic;
  WEN: in std_logic_vector(3 downto 0);
  A: in std_logic_vector((abits -1) downto 0);
  D: in std_logic_vector((dbits -1) downto 0);
  Q: out std_logic_vector((dbits -1) downto 0)
  ); 
end component;     

component asic_dpram_ss
  generic (
    abits : integer := 8;
    dbits : integer := 32;
    words : integer := 256
  );
  port (
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector (abits -1 downto 0);
   DA: in std_logic_vector (dbits -1 downto 0);
   QA: out std_logic_vector (dbits -1 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector (abits -1 downto 0);
   DB: in std_logic_vector (dbits -1 downto 0);
   QB: out std_logic_vector (dbits -1 downto 0)
  );
end component;

end;

-----------------------------------------------------------

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram16384x32 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(13 downto 0);
   D: in std_logic_vector(31 downto 0);
   Q: out std_logic_vector(31 downto 0)
   );
end;

architecture behavioral of ram16384x32 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 14, dbits => 32)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram8192x32 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(12 downto 0);
   D: in std_logic_vector(31 downto 0);
   Q: out std_logic_vector(31 downto 0)
   );
end;

architecture behavioral of ram8192x32 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 13, dbits => 32)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram4096x32 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic_vector(3 downto 0);
   A: in std_logic_vector(11 downto 0);
   D: in std_logic_vector(31 downto 0);
   Q: out std_logic_vector(31 downto 0)
   );
end;

architecture behavioral of ram4096x32 is
begin
  syncram0 : asic_syncram_ss
    generic map ( abits => 12, dbits => 32)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => WEN,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram2400x32 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(11 downto 0);
   D: in std_logic_vector(31 downto 0);
   Q: out std_logic_vector(31 downto 0)
   );
end;

architecture behavioral of ram2400x32 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 12, dbits => 32)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram2048x32 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic_vector(3 downto 0);
   A: in std_logic_vector(10 downto 0);
   D: in std_logic_vector(31 downto 0);
   Q: out std_logic_vector(31 downto 0)
   );
end;

architecture behavioral of ram2048x32 is
begin
  syncram0 : asic_syncram_ss
    generic map ( abits => 11, dbits => 32)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => WEN,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram1024x32 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic_vector(3 downto 0);
   A: in std_logic_vector(9 downto 0);
   D: in std_logic_vector(31 downto 0);
   Q: out std_logic_vector(31 downto 0)
   );
end;

architecture behavioral of ram1024x32 is
begin
  syncram0 : asic_syncram_ss
    generic map ( abits => 10, dbits => 32)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => WEN,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram512x32 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(8 downto 0);
   D: in std_logic_vector(31 downto 0);
   Q: out std_logic_vector(31 downto 0)
   );
end;

architecture behavioral of ram512x32 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 9, dbits => 32)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram256x32 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(7 downto 0);
   D: in std_logic_vector(31 downto 0);
   Q: out std_logic_vector(31 downto 0)
   );
end;

architecture behavioral of ram256x32 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 8, dbits => 32)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram128x32 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(6 downto 0);
   D: in std_logic_vector(31 downto 0);
   Q: out std_logic_vector(31 downto 0)
   );
end;

architecture behavioral of ram128x32 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 7, dbits => 32)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram64x32 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(5 downto 0);
   D: in std_logic_vector(31 downto 0);
   Q: out std_logic_vector(31 downto 0)
   );
end;

architecture behavioral of ram64x32 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 6, dbits => 32)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram32x32 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(4 downto 0);
   D: in std_logic_vector(31 downto 0);
   Q: out std_logic_vector(31 downto 0)
   );
end;

architecture behavioral of ram32x32 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 5, dbits => 32)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram64x31 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(5 downto 0);
   D: in std_logic_vector(30 downto 0);
   Q: out std_logic_vector(30 downto 0)
   );
end;

architecture behavioral of ram64x31 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 6, dbits => 31)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram32x31 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(4 downto 0);
   D: in std_logic_vector(30 downto 0);
   Q: out std_logic_vector(30 downto 0)
   );
end;

architecture behavioral of ram32x31 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 5, dbits => 31)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram32x30 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(4 downto 0);
   D: in std_logic_vector(29 downto 0);
   Q: out std_logic_vector(29 downto 0)
   );
end;

architecture behavioral of ram32x30 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 5, dbits => 30)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram64x30 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(5 downto 0);
   D: in std_logic_vector(29 downto 0);
   Q: out std_logic_vector(29 downto 0)
   );
end;

architecture behavioral of ram64x30 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 6, dbits => 30)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram128x30 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(6 downto 0);
   D: in std_logic_vector(29 downto 0);
   Q: out std_logic_vector(29 downto 0)
   );
end;

architecture behavioral of ram128x30 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 7, dbits => 30)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram256x29 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(7 downto 0);
   D: in std_logic_vector(28 downto 0);
   Q: out std_logic_vector(28 downto 0)
   );
end;

architecture behavioral of ram256x29 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 8, dbits => 29)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram128x29 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(6 downto 0);
   D: in std_logic_vector(28 downto 0);
   Q: out std_logic_vector(28 downto 0)
   );
end;

architecture behavioral of ram128x29 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 7, dbits => 29)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram64x29 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(5 downto 0);
   D: in std_logic_vector(28 downto 0);
   Q: out std_logic_vector(28 downto 0)
   );
end;

architecture behavioral of ram64x29 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 6, dbits => 29)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram512x28 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(8 downto 0);
   D: in std_logic_vector(27 downto 0);
   Q: out std_logic_vector(27 downto 0)
   );
end;

architecture behavioral of ram512x28 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 9, dbits => 28)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram256x28 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(7 downto 0);
   D: in std_logic_vector(27 downto 0);
   Q: out std_logic_vector(27 downto 0)
   );
end;

architecture behavioral of ram256x28 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 8, dbits => 28)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram128x28 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(6 downto 0);
   D: in std_logic_vector(27 downto 0);
   Q: out std_logic_vector(27 downto 0)
   );
end;

architecture behavioral of ram128x28 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 7, dbits => 28)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram64x28 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(5 downto 0);
   D: in std_logic_vector(27 downto 0);
   Q: out std_logic_vector(27 downto 0)
   );
end;

architecture behavioral of ram64x28 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 6, dbits => 28)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram1024x27 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(9 downto 0);
   D: in std_logic_vector(26 downto 0);
   Q: out std_logic_vector(26 downto 0)
   );
end;

architecture behavioral of ram1024x27 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 10, dbits => 27)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram512x27 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(8 downto 0);
   D: in std_logic_vector(26 downto 0);
   Q: out std_logic_vector(26 downto 0)
   );
end;

architecture behavioral of ram512x27 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 9, dbits => 27)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram256x27 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(7 downto 0);
   D: in std_logic_vector(26 downto 0);
   Q: out std_logic_vector(26 downto 0)
   );
end;

architecture behavioral of ram256x27 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 8, dbits => 27)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram128x27 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(6 downto 0);
   D: in std_logic_vector(26 downto 0);
   Q: out std_logic_vector(26 downto 0)
   );
end;

architecture behavioral of ram128x27 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 7, dbits => 27)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram64x27 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(5 downto 0);
   D: in std_logic_vector(26 downto 0);
   Q: out std_logic_vector(26 downto 0)
   );
end;

architecture behavioral of ram64x27 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 6, dbits => 27)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram2048x26 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(10 downto 0);
   D: in std_logic_vector(25 downto 0);
   Q: out std_logic_vector(25 downto 0)
   );
end;

architecture behavioral of ram2048x26 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 11, dbits => 26)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram1024x26 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(9 downto 0);
   D: in std_logic_vector(25 downto 0);
   Q: out std_logic_vector(25 downto 0)
   );
end;

architecture behavioral of ram1024x26 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 10, dbits => 26)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram512x26 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(8 downto 0);
   D: in std_logic_vector(25 downto 0);
   Q: out std_logic_vector(25 downto 0)
   );
end;

architecture behavioral of ram512x26 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 9, dbits => 26)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram256x26 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(7 downto 0);
   D: in std_logic_vector(25 downto 0);
   Q: out std_logic_vector(25 downto 0)
   );
end;

architecture behavioral of ram256x26 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 8, dbits => 26)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram128x26 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(6 downto 0);
   D: in std_logic_vector(25 downto 0);
   Q: out std_logic_vector(25 downto 0)
   );
end;

architecture behavioral of ram128x26 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 7, dbits => 26)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram64x26 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(5 downto 0);
   D: in std_logic_vector(25 downto 0);
   Q: out std_logic_vector(25 downto 0)
   );
end;

architecture behavioral of ram64x26 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 6, dbits => 26)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram2048x25 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(10 downto 0);
   D: in std_logic_vector(24 downto 0);
   Q: out std_logic_vector(24 downto 0)
   );
end;

architecture behavioral of ram2048x25 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 11, dbits => 25)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram1024x25 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(9 downto 0);
   D: in std_logic_vector(24 downto 0);
   Q: out std_logic_vector(24 downto 0)
   );
end;

architecture behavioral of ram1024x25 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 10, dbits => 25)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram512x25 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(8 downto 0);
   D: in std_logic_vector(24 downto 0);
   Q: out std_logic_vector(24 downto 0)
   );
end;

architecture behavioral of ram512x25 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 9, dbits => 25)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram256x25 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(7 downto 0);
   D: in std_logic_vector(24 downto 0);
   Q: out std_logic_vector(24 downto 0)
   );
end;

architecture behavioral of ram256x25 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 8, dbits => 25)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram128x25 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(6 downto 0);
   D: in std_logic_vector(24 downto 0);
   Q: out std_logic_vector(24 downto 0)
   );
end;

architecture behavioral of ram128x25 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 7, dbits => 25)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram2048x24 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(10 downto 0);
   D: in std_logic_vector(23 downto 0);
   Q: out std_logic_vector(23 downto 0)
   );
end;

architecture behavioral of ram2048x24 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 11, dbits => 24)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram1024x24 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(9 downto 0);
   D: in std_logic_vector(23 downto 0);
   Q: out std_logic_vector(23 downto 0)
   );
end;

architecture behavioral of ram1024x24 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 10, dbits => 24)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram512x24 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(8 downto 0);
   D: in std_logic_vector(23 downto 0);
   Q: out std_logic_vector(23 downto 0)
   );
end;

architecture behavioral of ram512x24 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 9, dbits => 24)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram256x24 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(7 downto 0);
   D: in std_logic_vector(23 downto 0);
   Q: out std_logic_vector(23 downto 0)
   );
end;

architecture behavioral of ram256x24 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 8, dbits => 24)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram2048x23 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(10 downto 0);
   D: in std_logic_vector(22 downto 0);
   Q: out std_logic_vector(22 downto 0)
   );
end;

architecture behavioral of ram2048x23 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 11, dbits => 23)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram1024x23 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(9 downto 0);
   D: in std_logic_vector(22 downto 0);
   Q: out std_logic_vector(22 downto 0)
   );
end;

architecture behavioral of ram1024x23 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 10, dbits => 23)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram512x23 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(8 downto 0);
   D: in std_logic_vector(22 downto 0);
   Q: out std_logic_vector(22 downto 0)
   );
end;

architecture behavioral of ram512x23 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 9, dbits => 23)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram4096x22 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(11 downto 0);
   D: in std_logic_vector(21 downto 0);
   Q: out std_logic_vector(21 downto 0)
   );
end;

architecture behavioral of ram4096x22 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 12, dbits => 22)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram2048x22 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(10 downto 0);
   D: in std_logic_vector(21 downto 0);
   Q: out std_logic_vector(21 downto 0)
   );
end;

architecture behavioral of ram2048x22 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 11, dbits => 22)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram1024x22 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(9 downto 0);
   D: in std_logic_vector(21 downto 0);
   Q: out std_logic_vector(21 downto 0)
   );
end;

architecture behavioral of ram1024x22 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 10, dbits => 22)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram4096x21 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(11 downto 0);
   D: in std_logic_vector(20 downto 0);
   Q: out std_logic_vector(20 downto 0)
   );
end;

architecture behavioral of ram4096x21 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 12, dbits => 21)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram2048x21 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(10 downto 0);
   D: in std_logic_vector(20 downto 0);
   Q: out std_logic_vector(20 downto 0)
   );
end;

architecture behavioral of ram2048x21 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 11, dbits => 21)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity ram4096x20 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(11 downto 0);
   D: in std_logic_vector(19 downto 0);
   Q: out std_logic_vector(19 downto 0)
   );
end;

architecture behavioral of ram4096x20 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : asic_syncram_ss
    generic map ( abits => 12, dbits => 20)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

-- dpram simulation models

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram16x32 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(3 downto 0);
   DA: in std_logic_vector(31 downto 0);
   QA: out std_logic_vector(31 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(3 downto 0);
   DB: in std_logic_vector(31 downto 0);
   QB: out std_logic_vector(31 downto 0)
   );
end;

architecture behavioral of dpram16x32 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 4,
    dbits => 32,
    words => 16)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram136x32 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(7 downto 0);
   DA: in std_logic_vector(31 downto 0);
   QA: out std_logic_vector(31 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(7 downto 0);
   DB: in std_logic_vector(31 downto 0);
   QB: out std_logic_vector(31 downto 0)
   );
end;

architecture behavioral of dpram136x32 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 8,
    dbits => 32,
    words => 136)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram168x32 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(7 downto 0);
   DA: in std_logic_vector(31 downto 0);
   QA: out std_logic_vector(31 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(7 downto 0);
   DB: in std_logic_vector(31 downto 0);
   QB: out std_logic_vector(31 downto 0)
   );
end;

architecture behavioral of dpram168x32 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 8,
    dbits => 32,
    words => 168)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram2048x32 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(10 downto 0);
   DA: in std_logic_vector(31 downto 0);
   QA: out std_logic_vector(31 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(10 downto 0);
   DB: in std_logic_vector(31 downto 0);
   QB: out std_logic_vector(31 downto 0)
   );
end;

architecture behavioral of dpram2048x32 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 11,
    dbits => 32,
    words => 2048)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram1024x32 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(9 downto 0);
   DA: in std_logic_vector(31 downto 0);
   QA: out std_logic_vector(31 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(9 downto 0);
   DB: in std_logic_vector(31 downto 0);
   QB: out std_logic_vector(31 downto 0)
   );
end;

architecture behavioral of dpram1024x32 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 10,
    dbits => 32,
    words => 1024)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram512x32 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(8 downto 0);
   DA: in std_logic_vector(31 downto 0);
   QA: out std_logic_vector(31 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(8 downto 0);
   DB: in std_logic_vector(31 downto 0);
   QB: out std_logic_vector(31 downto 0)
   );
end;

architecture behavioral of dpram512x32 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 9,
    dbits => 32,
    words => 512)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram256x32 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(7 downto 0);
   DA: in std_logic_vector(31 downto 0);
   QA: out std_logic_vector(31 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(7 downto 0);
   DB: in std_logic_vector(31 downto 0);
   QB: out std_logic_vector(31 downto 0)
   );
end;

architecture behavioral of dpram256x32 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 8,
    dbits => 32,
    words => 256)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram128x32 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(6 downto 0);
   DA: in std_logic_vector(31 downto 0);
   QA: out std_logic_vector(31 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(6 downto 0);
   DB: in std_logic_vector(31 downto 0);
   QB: out std_logic_vector(31 downto 0)
   );
end;

architecture behavioral of dpram128x32 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 7,
    dbits => 32,
    words => 128)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram64x32 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(5 downto 0);
   DA: in std_logic_vector(31 downto 0);
   QA: out std_logic_vector(31 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(5 downto 0);
   DB: in std_logic_vector(31 downto 0);
   QB: out std_logic_vector(31 downto 0)
   );
end;

architecture behavioral of dpram64x32 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 6,
    dbits => 32,
    words => 64)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram32x32 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(4 downto 0);
   DA: in std_logic_vector(31 downto 0);
   QA: out std_logic_vector(31 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(4 downto 0);
   DB: in std_logic_vector(31 downto 0);
   QB: out std_logic_vector(31 downto 0)
   );
end;

architecture behavioral of dpram32x32 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 5,
    dbits => 32,
    words => 32)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram64x31 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(5 downto 0);
   DA: in std_logic_vector(30 downto 0);
   QA: out std_logic_vector(30 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(5 downto 0);
   DB: in std_logic_vector(30 downto 0);
   QB: out std_logic_vector(30 downto 0)
   );
end;

architecture behavioral of dpram64x31 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 6,
    dbits => 31,
    words => 64)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram32x31 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(4 downto 0);
   DA: in std_logic_vector(30 downto 0);
   QA: out std_logic_vector(30 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(4 downto 0);
   DB: in std_logic_vector(30 downto 0);
   QB: out std_logic_vector(30 downto 0)
   );
end;

architecture behavioral of dpram32x31 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 5,
    dbits => 31,
    words => 32)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram128x30 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(6 downto 0);
   DA: in std_logic_vector(29 downto 0);
   QA: out std_logic_vector(29 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(6 downto 0);
   DB: in std_logic_vector(29 downto 0);
   QB: out std_logic_vector(29 downto 0)
   );
end;

architecture behavioral of dpram128x30 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 7,
    dbits => 30,
    words => 128)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram64x30 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(5 downto 0);
   DA: in std_logic_vector(29 downto 0);
   QA: out std_logic_vector(29 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(5 downto 0);
   DB: in std_logic_vector(29 downto 0);
   QB: out std_logic_vector(29 downto 0)
   );
end;

architecture behavioral of dpram64x30 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 6,
    dbits => 30,
    words => 64)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram32x30 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(4 downto 0);
   DA: in std_logic_vector(29 downto 0);
   QA: out std_logic_vector(29 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(4 downto 0);
   DB: in std_logic_vector(29 downto 0);
   QB: out std_logic_vector(29 downto 0)
   );
end;

architecture behavioral of dpram32x30 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 5,
    dbits => 30,
    words => 32)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram256x29 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(7 downto 0);
   DA: in std_logic_vector(28 downto 0);
   QA: out std_logic_vector(28 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(7 downto 0);
   DB: in std_logic_vector(28 downto 0);
   QB: out std_logic_vector(28 downto 0)
   );
end;

architecture behavioral of dpram256x29 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 8,
    dbits => 29,
    words => 256)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram128x29 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(6 downto 0);
   DA: in std_logic_vector(28 downto 0);
   QA: out std_logic_vector(28 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(6 downto 0);
   DB: in std_logic_vector(28 downto 0);
   QB: out std_logic_vector(28 downto 0)
   );
end;

architecture behavioral of dpram128x29 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 7,
    dbits => 29,
    words => 128)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram64x29 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(5 downto 0);
   DA: in std_logic_vector(28 downto 0);
   QA: out std_logic_vector(28 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(5 downto 0);
   DB: in std_logic_vector(28 downto 0);
   QB: out std_logic_vector(28 downto 0)
   );
end;

architecture behavioral of dpram64x29 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 6,
    dbits => 29,
    words => 64)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram512x28 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(8 downto 0);
   DA: in std_logic_vector(27 downto 0);
   QA: out std_logic_vector(27 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(8 downto 0);
   DB: in std_logic_vector(27 downto 0);
   QB: out std_logic_vector(27 downto 0)
   );
end;

architecture behavioral of dpram512x28 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 9,
    dbits => 28,
    words => 512)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram256x28 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(7 downto 0);
   DA: in std_logic_vector(27 downto 0);
   QA: out std_logic_vector(27 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(7 downto 0);
   DB: in std_logic_vector(27 downto 0);
   QB: out std_logic_vector(27 downto 0)
   );
end;

architecture behavioral of dpram256x28 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 8,
    dbits => 28,
    words => 256)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram128x28 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(6 downto 0);
   DA: in std_logic_vector(27 downto 0);
   QA: out std_logic_vector(27 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(6 downto 0);
   DB: in std_logic_vector(27 downto 0);
   QB: out std_logic_vector(27 downto 0)
   );
end;

architecture behavioral of dpram128x28 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 7,
    dbits => 28,
    words => 128)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram64x28 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(5 downto 0);
   DA: in std_logic_vector(27 downto 0);
   QA: out std_logic_vector(27 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(5 downto 0);
   DB: in std_logic_vector(27 downto 0);
   QB: out std_logic_vector(27 downto 0)
   );
end;

architecture behavioral of dpram64x28 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 6,
    dbits => 28,
    words => 64)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram1024x27 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(9 downto 0);
   DA: in std_logic_vector(26 downto 0);
   QA: out std_logic_vector(26 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(9 downto 0);
   DB: in std_logic_vector(26 downto 0);
   QB: out std_logic_vector(26 downto 0)
   );
end;

architecture behavioral of dpram1024x27 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 10,
    dbits => 27,
    words => 1024)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram512x27 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(8 downto 0);
   DA: in std_logic_vector(26 downto 0);
   QA: out std_logic_vector(26 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(8 downto 0);
   DB: in std_logic_vector(26 downto 0);
   QB: out std_logic_vector(26 downto 0)
   );
end;

architecture behavioral of dpram512x27 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 9,
    dbits => 27,
    words => 512)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram256x27 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(7 downto 0);
   DA: in std_logic_vector(26 downto 0);
   QA: out std_logic_vector(26 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(7 downto 0);
   DB: in std_logic_vector(26 downto 0);
   QB: out std_logic_vector(26 downto 0)
   );
end;

architecture behavioral of dpram256x27 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 8,
    dbits => 27,
    words => 256)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram128x27 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(6 downto 0);
   DA: in std_logic_vector(26 downto 0);
   QA: out std_logic_vector(26 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(6 downto 0);
   DB: in std_logic_vector(26 downto 0);
   QB: out std_logic_vector(26 downto 0)
   );
end;

architecture behavioral of dpram128x27 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 7,
    dbits => 27,
    words => 128)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram64x27 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(5 downto 0);
   DA: in std_logic_vector(26 downto 0);
   QA: out std_logic_vector(26 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(5 downto 0);
   DB: in std_logic_vector(26 downto 0);
   QB: out std_logic_vector(26 downto 0)
   );
end;

architecture behavioral of dpram64x27 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 6,
    dbits => 27,
    words => 64)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram2048x26 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(10 downto 0);
   DA: in std_logic_vector(25 downto 0);
   QA: out std_logic_vector(25 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(10 downto 0);
   DB: in std_logic_vector(25 downto 0);
   QB: out std_logic_vector(25 downto 0)
   );
end;

architecture behavioral of dpram2048x26 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 11,
    dbits => 26,
    words => 2048)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram1024x26 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(9 downto 0);
   DA: in std_logic_vector(25 downto 0);
   QA: out std_logic_vector(25 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(9 downto 0);
   DB: in std_logic_vector(25 downto 0);
   QB: out std_logic_vector(25 downto 0)
   );
end;

architecture behavioral of dpram1024x26 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 10,
    dbits => 26,
    words => 1024)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram512x26 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(8 downto 0);
   DA: in std_logic_vector(25 downto 0);
   QA: out std_logic_vector(25 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(8 downto 0);
   DB: in std_logic_vector(25 downto 0);
   QB: out std_logic_vector(25 downto 0)
   );
end;

architecture behavioral of dpram512x26 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 9,
    dbits => 26,
    words => 512)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram256x26 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(7 downto 0);
   DA: in std_logic_vector(25 downto 0);
   QA: out std_logic_vector(25 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(7 downto 0);
   DB: in std_logic_vector(25 downto 0);
   QB: out std_logic_vector(25 downto 0)
   );
end;

architecture behavioral of dpram256x26 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 8,
    dbits => 26,
    words => 256)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram128x26 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(6 downto 0);
   DA: in std_logic_vector(25 downto 0);
   QA: out std_logic_vector(25 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(6 downto 0);
   DB: in std_logic_vector(25 downto 0);
   QB: out std_logic_vector(25 downto 0)
   );
end;

architecture behavioral of dpram128x26 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 7,
    dbits => 26,
    words => 128)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram64x26 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(5 downto 0);
   DA: in std_logic_vector(25 downto 0);
   QA: out std_logic_vector(25 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(5 downto 0);
   DB: in std_logic_vector(25 downto 0);
   QB: out std_logic_vector(25 downto 0)
   );
end;

architecture behavioral of dpram64x26 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 6,
    dbits => 26,
    words => 64)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram2048x25 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(10 downto 0);
   DA: in std_logic_vector(24 downto 0);
   QA: out std_logic_vector(24 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(10 downto 0);
   DB: in std_logic_vector(24 downto 0);
   QB: out std_logic_vector(24 downto 0)
   );
end;

architecture behavioral of dpram2048x25 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 11,
    dbits => 25,
    words => 2048)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram1024x25 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(9 downto 0);
   DA: in std_logic_vector(24 downto 0);
   QA: out std_logic_vector(24 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(9 downto 0);
   DB: in std_logic_vector(24 downto 0);
   QB: out std_logic_vector(24 downto 0)
   );
end;

architecture behavioral of dpram1024x25 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 10,
    dbits => 25,
    words => 1024)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram512x25 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(8 downto 0);
   DA: in std_logic_vector(24 downto 0);
   QA: out std_logic_vector(24 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(8 downto 0);
   DB: in std_logic_vector(24 downto 0);
   QB: out std_logic_vector(24 downto 0)
   );
end;

architecture behavioral of dpram512x25 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 9,
    dbits => 25,
    words => 512)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram256x25 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(7 downto 0);
   DA: in std_logic_vector(24 downto 0);
   QA: out std_logic_vector(24 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(7 downto 0);
   DB: in std_logic_vector(24 downto 0);
   QB: out std_logic_vector(24 downto 0)
   );
end;

architecture behavioral of dpram256x25 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 8,
    dbits => 25,
    words => 256)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram128x25 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(6 downto 0);
   DA: in std_logic_vector(24 downto 0);
   QA: out std_logic_vector(24 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(6 downto 0);
   DB: in std_logic_vector(24 downto 0);
   QB: out std_logic_vector(24 downto 0)
   );
end;

architecture behavioral of dpram128x25 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 7,
    dbits => 25,
    words => 128)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram2048x24 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(10 downto 0);
   DA: in std_logic_vector(23 downto 0);
   QA: out std_logic_vector(23 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(10 downto 0);
   DB: in std_logic_vector(23 downto 0);
   QB: out std_logic_vector(23 downto 0)
   );
end;

architecture behavioral of dpram2048x24 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 11,
    dbits => 24,
    words => 2048)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram1024x24 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(9 downto 0);
   DA: in std_logic_vector(23 downto 0);
   QA: out std_logic_vector(23 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(9 downto 0);
   DB: in std_logic_vector(23 downto 0);
   QB: out std_logic_vector(23 downto 0)
   );
end;

architecture behavioral of dpram1024x24 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 10,
    dbits => 24,
    words => 1024)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram512x24 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(8 downto 0);
   DA: in std_logic_vector(23 downto 0);
   QA: out std_logic_vector(23 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(8 downto 0);
   DB: in std_logic_vector(23 downto 0);
   QB: out std_logic_vector(23 downto 0)
   );
end;

architecture behavioral of dpram512x24 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 9,
    dbits => 24,
    words => 512)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram256x24 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(7 downto 0);
   DA: in std_logic_vector(23 downto 0);
   QA: out std_logic_vector(23 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(7 downto 0);
   DB: in std_logic_vector(23 downto 0);
   QB: out std_logic_vector(23 downto 0)
   );
end;

architecture behavioral of dpram256x24 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 8,
    dbits => 24,
    words => 256)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram2048x23 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(10 downto 0);
   DA: in std_logic_vector(22 downto 0);
   QA: out std_logic_vector(22 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(10 downto 0);
   DB: in std_logic_vector(22 downto 0);
   QB: out std_logic_vector(22 downto 0)
   );
end;

architecture behavioral of dpram2048x23 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 11,
    dbits => 23,
    words => 2048)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram1024x23 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(9 downto 0);
   DA: in std_logic_vector(22 downto 0);
   QA: out std_logic_vector(22 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(9 downto 0);
   DB: in std_logic_vector(22 downto 0);
   QB: out std_logic_vector(22 downto 0)
   );
end;

architecture behavioral of dpram1024x23 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 10,
    dbits => 23,
    words => 1024)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram512x23 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(8 downto 0);
   DA: in std_logic_vector(22 downto 0);
   QA: out std_logic_vector(22 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(8 downto 0);
   DB: in std_logic_vector(22 downto 0);
   QB: out std_logic_vector(22 downto 0)
   );
end;

architecture behavioral of dpram512x23 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 9,
    dbits => 23,
    words => 512)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram4096x22 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(11 downto 0);
   DA: in std_logic_vector(21 downto 0);
   QA: out std_logic_vector(21 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(11 downto 0);
   DB: in std_logic_vector(21 downto 0);
   QB: out std_logic_vector(21 downto 0)
   );
end;

architecture behavioral of dpram4096x22 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 12,
    dbits => 22,
    words => 4096)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram2048x22 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(10 downto 0);
   DA: in std_logic_vector(21 downto 0);
   QA: out std_logic_vector(21 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(10 downto 0);
   DB: in std_logic_vector(21 downto 0);
   QB: out std_logic_vector(21 downto 0)
   );
end;

architecture behavioral of dpram2048x22 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 11,
    dbits => 22,
    words => 2048)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram1024x22 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(9 downto 0);
   DA: in std_logic_vector(21 downto 0);
   QA: out std_logic_vector(21 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(9 downto 0);
   DB: in std_logic_vector(21 downto 0);
   QB: out std_logic_vector(21 downto 0)
   );
end;

architecture behavioral of dpram1024x22 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 10,
    dbits => 22,
    words => 1024)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram4096x21 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(11 downto 0);
   DA: in std_logic_vector(20 downto 0);
   QA: out std_logic_vector(20 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(11 downto 0);
   DB: in std_logic_vector(20 downto 0);
   QB: out std_logic_vector(20 downto 0)
   );
end;

architecture behavioral of dpram4096x21 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 12,
    dbits => 21,
    words => 4096)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram2048x21 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(10 downto 0);
   DA: in std_logic_vector(20 downto 0);
   QA: out std_logic_vector(20 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(10 downto 0);
   DB: in std_logic_vector(20 downto 0);
   QB: out std_logic_vector(20 downto 0)
   );
end;

architecture behavioral of dpram2048x21 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 11,
    dbits => 21,
    words => 2048)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_asic_sim.all;

entity dpram4096x20 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(11 downto 0);
   DA: in std_logic_vector(19 downto 0);
   QA: out std_logic_vector(19 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(11 downto 0);
   DB: in std_logic_vector(19 downto 0);
   QB: out std_logic_vector(19 downto 0)
   );
end;

architecture behavioral of dpram4096x20 is
begin
dpram0: asic_dpram_ss
  generic map(
    abits => 12,
    dbits => 20,
    words => 4096)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;


------------------------------------------------
-- Behavioural models for tie high/low cells
------------------------------------------------

library ieee;
use IEEE.std_logic_1164.all;

entity TIEHI is
  port(
  Y : out std_logic
  );
end;

architecture behavioral of TIEHI is
begin
  Y <= '1';
end behavioral;


library ieee;
use IEEE.std_logic_1164.all;

entity TIELO is
  port(
  Y : out std_logic
  );
end;

architecture behavioral of TIELO is
begin
  Y <= '0';
end behavioral;


  
------------------------------------------------------------------
-- behavioural pad models for TSMC 0.25um : fb_tpz873g_200d ------
------------------------------------------------------------------

-- input pad 5V tolerant
library IEEE;
use IEEE.std_logic_1164.all;
entity PDIDGZ is port (PAD : in std_logic; C : out std_logic); end; 
architecture rtl of PDIDGZ is begin C <= to_x01(PAD) after 1 ns; end;

-- schmitt trigger input pad 5V tolerant
library IEEE;
use IEEE.std_logic_1164.all;
entity PDISDGZ is port (PAD : in std_logic; C : out std_logic); end; 
architecture rtl of PDISDGZ is begin C <= to_x01(PAD) after 1 ns; end;

-- CMOS 3-state output pads 5V tolerant (2,4,8,12,16,24 mA)
library IEEE;
use IEEE.std_logic_1164.all;
entity PDT02DGZ is port (I : in  std_logic; PAD : out  std_logic;
                         OEN: in std_logic); end; 
architecture rtl of PDT02DGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'Z' after 2 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity PDT04DGZ is port (I : in  std_logic; PAD : out  std_logic;
                         OEN: in std_logic); end; 
architecture rtl of PDT04DGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'Z' after 2 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity PDT08DGZ is port (I : in  std_logic; PAD : out  std_logic;
                         OEN: in std_logic); end; 
architecture rtl of PDT08DGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'Z' after 2 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity PDT12DGZ is port (I : in  std_logic; PAD : out  std_logic;
                         OEN: in std_logic); end; 
architecture rtl of PDT12DGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'Z' after 2 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity PDT16DGZ is port (I : in  std_logic; PAD : out  std_logic;
                         OEN: in std_logic); end; 
architecture rtl of PDT16DGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'Z' after 2 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity PDT24DGZ is port (I : in  std_logic; PAD : out  std_logic;
                         OEN: in std_logic); end; 
architecture rtl of PDT24DGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'Z' after 2 ns; end;


-- CMOS 3-state Output pad with input and Pullup 5V tolerant
library IEEE;
use IEEE.std_logic_1164.all;
entity PDU02DGZ is port (I : in  std_logic; PAD : inout  std_logic;
                         OEN: in std_logic; C : out std_logic); end; 
architecture rtl of PDU02DGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'H' after 2 ns;
   C   <= to_x01(PAD) after 1 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity PDU04DGZ is port (I : in  std_logic; PAD : inout  std_logic;
                         OEN: in std_logic; C : out std_logic); end; 
architecture rtl of PDU04DGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'H' after 2 ns;
   C   <= to_x01(PAD) after 1 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity PDU08DGZ is port (I : in  std_logic; PAD : inout  std_logic;
                         OEN: in std_logic; C : out std_logic); end; 
architecture rtl of PDU08DGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'H' after 2 ns;
   C   <= to_x01(PAD) after 1 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity PDU12DGZ is port (I : in  std_logic; PAD : inout  std_logic;
                         OEN: in std_logic; C : out std_logic); end; 
architecture rtl of PDU12DGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'H' after 2 ns;
   C   <= to_x01(PAD) after 1 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity PDU16DGZ is port (I : in  std_logic; PAD : inout  std_logic;
                         OEN: in std_logic; C : out std_logic); end; 
architecture rtl of PDU16DGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'H' after 2 ns;
   C   <= to_x01(PAD) after 1 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity PDU24DGZ is port (I : in  std_logic; PAD : inout  std_logic;
                         OEN: in std_logic; C : out std_logic); end; 
architecture rtl of PDU24DGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'H' after 2 ns;
   C   <= to_x01(PAD) after 1 ns; end;


-- CMOS 3-state Output pad with input 5V tolerant
library IEEE;
use IEEE.std_logic_1164.all;
entity PDB02DGZ is port (I : in  std_logic; PAD : inout  std_logic;
                         OEN: in std_logic; C : out std_logic); end; 
architecture rtl of PDB02DGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'Z' after 2 ns;
   C   <= to_x01(PAD) after 1 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity PDB04DGZ is port (I : in  std_logic; PAD : inout  std_logic;
                         OEN: in std_logic; C : out std_logic); end; 
architecture rtl of PDB04DGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'Z' after 2 ns;
   C   <= to_x01(PAD) after 1 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity PDB08DGZ is port (I : in  std_logic; PAD : inout  std_logic;
                         OEN: in std_logic; C : out std_logic); end; 
architecture rtl of PDB08DGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'Z' after 2 ns;
   C   <= to_x01(PAD) after 1 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity PDB12DGZ is port (I : in  std_logic; PAD : inout  std_logic;
                         OEN: in std_logic; C : out std_logic); end; 
architecture rtl of PDB12DGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'Z' after 2 ns;
   C   <= to_x01(PAD) after 1 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity PDB16DGZ is port (I : in  std_logic; PAD : inout  std_logic;
                         OEN: in std_logic; C : out std_logic); end; 
architecture rtl of PDB16DGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'Z' after 2 ns;
   C   <= to_x01(PAD) after 1 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity PDB24DGZ is port (I : in  std_logic; PAD : inout  std_logic;
                         OEN: in std_logic; C : out std_logic); end; 
architecture rtl of PDB24DGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'Z' after 2 ns;
   C   <= to_x01(PAD) after 1 ns; end;


-- CMOS 3-state Output pad with schmitt trigger input 5V tolerant
library IEEE;
use IEEE.std_logic_1164.all;
entity PDB02SDGZ is port (I : in  std_logic; PAD : inout  std_logic;
                         OEN: in std_logic; C : out std_logic); end; 
architecture rtl of PDB02SDGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'Z' after 2 ns;
   C   <= to_x01(PAD) after 1 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity PDB04SDGZ is port (I : in  std_logic; PAD : inout  std_logic;
                         OEN: in std_logic; C : out std_logic); end; 
architecture rtl of PDB04SDGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'Z' after 2 ns;
   C   <= to_x01(PAD) after 1 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity PDB08SDGZ is port (I : in  std_logic; PAD : inout  std_logic;
                         OEN: in std_logic; C : out std_logic); end; 
architecture rtl of PDB08SDGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'Z' after 2 ns;
   C   <= to_x01(PAD) after 1 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity PDB12SDGZ is port (I : in  std_logic; PAD : inout  std_logic;
                         OEN: in std_logic; C : out std_logic); end; 
architecture rtl of PDB12SDGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'Z' after 2 ns;
   C   <= to_x01(PAD) after 1 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity PDB16SDGZ is port (I : in  std_logic; PAD : inout  std_logic;
                         OEN: in std_logic; C : out std_logic); end; 
architecture rtl of PDB16SDGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'Z' after 2 ns;
   C   <= to_x01(PAD) after 1 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity PDB24SDGZ is port (I : in  std_logic; PAD : inout  std_logic;
                         OEN: in std_logic; C : out std_logic); end; 
architecture rtl of PDB24SDGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'Z' after 2 ns;
   C   <= to_x01(PAD) after 1 ns; end;


library IEEE;
use IEEE.std_logic_1164.all;
entity PRB08DGZ is port (I : in  std_logic; PAD : inout  std_logic;
                         OEN: in std_logic; C : out std_logic); end; 
architecture rtl of PRB08DGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'Z' after 2 ns;
   C   <= to_x01(PAD) after 1 ns; end;

library IEEE;
use IEEE.std_logic_1164.all;
entity PRT08DGZ is port (I : in  std_logic; PAD : out  std_logic;
                         OEN: in std_logic); end; 
architecture rtl of PRT08DGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'Z' after 2 ns; end;

------------------------------------------------------------------
-- End of Behavioural models
------------------------------------------------------------------

-- synopsys translate_on

