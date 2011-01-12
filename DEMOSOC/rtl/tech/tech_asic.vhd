----------------------------------------------------------------------------
--  This file is a part of the LEON VHDL model
--  Copyright (C) 1999  European Space Agency (ESA)
--
--  This library is free software; you can redistribute it and/or
--  modify it under the terms of the GNU Lesser General Public
--  License as published by the Free Software Foundation; either
--  version 2 of the License, or (at your option) any later version.
--
--  See the file COPYING.LGPL for the full details of the license.


-----------------------------------------------------------------------------
-- Entity:      tech_asic
-- File:        tech_asic.vhd
-- Author:      Jiri Gaisler - Gaisler Research
-- Author:      Daniel Mok - Institute for Communications Research
-- Description: Contains TSMC 0.25um process specific pads and ram generators
--              from Artisan libraries (http: 
--              
------------------------------------------------------------------------------

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use work.iface.all;

package tech_asic is

-- sync ram generator

component asic_syncram
  generic ( abits : integer := 10; dbits : integer := 8 );
  port (
    address  : in std_logic_vector(abits -1 downto 0);
    clk      : in std_logic;
    datain   : in std_logic_vector(dbits -1 downto 0);
    dataout  : out std_logic_vector(dbits -1 downto 0);
    enable   : in std_logic;
    write    : in std_logic);
  end component;

-- regfile generator

component asic_regfile_iu
  generic ( abits : integer := 8; dbits : integer := 32; words : integer := 128);
  port (
    rst      : in std_logic;
    clk      : in std_logic;
    clkn     : in std_logic;
    rfi      : in rf_in_type;
    rfo      : out rf_out_type);
end component;

component asic_regfile_cp
  generic ( 
    abits : integer := 4;
    dbits : integer := 32;
    words : integer := 16
  );
  port (
    rst      : in std_logic;
    clk      : in std_logic;
    rfi      : in rf_cp_in_type;
    rfo      : out rf_cp_out_type);
end component;

component asic_dpram
  generic ( abits : integer := 10; dbits : integer := 8 );
  port (
    address1 : in std_logic_vector((abits -1) downto 0);
    clk1     : in std_logic;
    datain1  : in std_logic_vector((dbits -1) downto 0);
    dataout1 : out std_logic_vector((dbits -1) downto 0);
    enable1  : in std_logic;
    write1   : in std_logic;
    address2 : in std_logic_vector((abits -1) downto 0);
    clk2     : in std_logic;
    datain2  : in std_logic_vector((dbits -1) downto 0);
    dataout2 : out std_logic_vector((dbits -1) downto 0);
    enable2  : in std_logic;
    write2   : in std_logic
   ); 
end component;
 
-- pads

  component asic_inpad 
    generic (updown : integer := 1);
    port (pad : in std_logic; q : out std_logic);
  end component; 

  component asic_smpad
    generic (updown : integer := 1);
    port (pad : in std_logic; q : out std_logic);
  end component;

  component asic_outpad
    generic (drive : integer := 2);
    port (d : in  std_logic; pad : out  std_logic);
  end component; 

  component asic_toutpad
    generic (drive : integer := 2 ; updown : integer := 1);
    port (d, en : in  std_logic; pad : out  std_logic);
  end component; 

  component asic_iopad
    generic (drive : integer := 2 ; updown : integer := 1);
    port ( d, en : in std_logic; q : out std_logic; pad : inout std_logic);
  end component;

  component asic_iodpad 
    generic (drive : integer := 2 ; updown : integer := 1);
    port ( d : in std_logic; q : out std_logic; pad : inout std_logic);
  end component;

  component asic_odpad
    generic (drive : integer := 2 ; updown : integer := 1);
    port ( d : in std_logic; pad : out std_logic);
  end component;

  component asic_smiopad
    generic (drive : integer := 2 ; updown : integer := 1);
    port ( d, en : in std_logic; q : out std_logic; pad : inout std_logic);
  end component;

  component asic_pciinpad 
    port (q : out std_ulogic; pad : in std_logic); 
  end component; 

  component asic_pcitoutpad 
    port (d, en : in  std_logic; pad : out  std_logic); 
  end component; 

  component asic_pcioutpad 
    port (d : in  std_logic; pad : out  std_logic); 
  end component; 

  component asic_pciiopad
    port (d, en : in  std_logic; q : out std_ulogic; pad : inout  std_logic); 
  end component; 

  component asic_pciiodpad
    port (d : in  std_logic; q : out std_ulogic; pad : inout  std_logic); 
  end component; 

end;

------------------------------------------------------------------
-- sync ram generator --------------------------------------------
------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_asic_syn.all;

entity asic_syncram is
  generic ( abits : integer := 10; dbits : integer := 8 );
  port (
    address  : in std_logic_vector(abits -1 downto 0);
    clk      : in std_logic;
    datain   : in std_logic_vector(dbits -1 downto 0);
    dataout  : out std_logic_vector(dbits -1 downto 0);
    enable   : in std_logic;
    write    : in std_logic
  );
end;

architecture rtl of asic_syncram is
  signal cen  : std_logic;
  signal wen  : std_logic_vector(3 downto 0);
  signal a    : std_logic_vector(19 downto 0);
  signal d, q : std_logic_vector(34 downto 0);
  constant synopsys_bug : std_logic_vector(37 downto 0) := (others => '0');
begin

  wen(0) <= not write; 
  wen(1) <= not write; 
  wen(2) <= not write; 
  wen(3) <= not write; 
  cen <= not enable;
  a(abits -1 downto 0) <= address; 
  a(abits+1 downto abits) <= synopsys_bug(abits+1 downto abits);
  d(dbits -1 downto 0) <= datain; 
  d(dbits+1 downto dbits) <= synopsys_bug(dbits+1 downto dbits);

  dataout <= q(dbits -1 downto 0);

a14d32: if (abits = 14) and (dbits = 32) generate
   id0: ram16384x32
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a(13 downto 0),
        D => d(31 downto 0),
        Q => q(31 downto 0)
        );
end generate;

a13d32: if (abits = 13) and (dbits = 32) generate
   id0: ram8192x32
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a(12 downto 0),
        D => d(31 downto 0),
        Q => q(31 downto 0)
        );
end generate;


a12d32: if (abits = 12) and (dbits = 32) generate
   id0: ram4096x32
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen,
        A => a(11 downto 0),
        D => d(31 downto 0),
        Q => q(31 downto 0)
        );
end generate;

a11d32: if (abits = 11) and (dbits = 32) generate
   id0: ram2048x32
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen,
        A => a(10 downto 0),
        D => d(31 downto 0),
        Q => q(31 downto 0)
        );
end generate;

a10d32: if (abits = 10) and (dbits = 32) generate
   id0: ram1024x32
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen,
        A => a( 9 downto 0),
        D => d(31 downto 0),
        Q => q(31 downto 0)
        );
end generate;

a9d32: if (abits = 9) and (dbits = 32) generate
   id0: ram512x32
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a( 8 downto 0),
        D => d(31 downto 0),
        Q => q(31 downto 0)
        );
end generate;

a8d32: if (abits = 8) and (dbits = 32) generate
   id0: ram256x32
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a( 7 downto 0),
        D => d(31 downto 0),
        Q => q(31 downto 0)
        );
end generate;

a7d32: if (abits = 7) and (dbits = 32) generate
   id0: ram128x32
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a( 6 downto 0),
        D => d(31 downto 0),
        Q => q(31 downto 0)
        );
end generate;

a6d32: if (abits = 6) and (dbits = 32) generate
   id0: ram64x32
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a( 5 downto 0),
        D => d(31 downto 0),
        Q => q(31 downto 0)
        );
end generate;

a5d32: if (abits = 5) and (dbits = 32) generate
   id0: ram32x32
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a( 4 downto 0),
        D => d(31 downto 0),
        Q => q(31 downto 0)
        );
end generate;

a6d31: if (abits = 6) and (dbits = 31) generate
   id0: ram64x31
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a( 5 downto 0),
        D => d(30 downto 0),
        Q => q(30 downto 0)
        );
end generate;

a5d31: if (abits = 5) and (dbits = 31) generate
   id0: ram32x31
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a( 4 downto 0),
        D => d(30 downto 0),
        Q => q(30 downto 0)
        );
end generate;

a7d30: if (abits = 7) and (dbits = 30) generate
   id0: ram128x30
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a( 6 downto 0),
        D => d(29 downto 0),
        Q => q(29 downto 0)
        );
end generate;

a6d30: if (abits = 6) and (dbits = 30) generate
   id0: ram64x30
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a( 5 downto 0),
        D => d(29 downto 0),
        Q => q(29 downto 0)
        );
end generate;

a5d30: if (abits = 5) and (dbits = 30) generate
   id0: ram32x30
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a( 4 downto 0),
        D => d(29 downto 0),
        Q => q(29 downto 0)
        );
end generate;

a8d29: if (abits = 8) and (dbits = 29) generate
   id0: ram256x29
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a( 7 downto 0),
        D => d(28 downto 0),
        Q => q(28 downto 0)
        );
end generate;

a7d29: if (abits = 7) and (dbits = 29) generate
   id0: ram128x29
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a( 6 downto 0),
        D => d(28 downto 0),
        Q => q(28 downto 0)
        );
end generate;

a6d29: if (abits = 6) and (dbits = 29) generate
   id0: ram64x29
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a( 5 downto 0),
        D => d(28 downto 0),
        Q => q(28 downto 0)
        );
end generate;

a9d28: if (abits = 9) and (dbits = 28) generate
   id0: ram512x28
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a( 8 downto 0),
        D => d(27 downto 0),
        Q => q(27 downto 0)
        );
end generate;

a8d28: if (abits = 8) and (dbits = 28) generate
   id0: ram256x28
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a( 7 downto 0),
        D => d(27 downto 0),
        Q => q(27 downto 0)
        );
end generate;

a7d28: if (abits = 7) and (dbits = 28) generate
   id0: ram128x28
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a( 6 downto 0),
        D => d(27 downto 0),
        Q => q(27 downto 0)
        );
end generate;

a6d28: if (abits = 6) and (dbits = 28) generate
   id0: ram64x28
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a( 5 downto 0),
        D => d(27 downto 0),
        Q => q(27 downto 0)
        );
end generate;

a10d27: if (abits = 10) and (dbits = 27) generate
   id0: ram1024x27
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a( 9 downto 0),
        D => d(26 downto 0),
        Q => q(26 downto 0)
        );
end generate;

a9d27: if (abits = 9) and (dbits = 27) generate
   id0: ram512x27
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a( 8 downto 0),
        D => d(26 downto 0),
        Q => q(26 downto 0)
        );
end generate;

a8d27: if (abits = 8) and (dbits = 27) generate
   id0: ram256x27
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a( 7 downto 0),
        D => d(26 downto 0),
        Q => q(26 downto 0)
        );
end generate;

a7d27: if (abits = 7) and (dbits = 27) generate
   id0: ram128x27
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a( 6 downto 0),
        D => d(26 downto 0),
        Q => q(26 downto 0)
        );
end generate;

a6d27: if (abits = 6) and (dbits = 27) generate
   id0: ram64x27
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a( 5 downto 0),
        D => d(26 downto 0),
        Q => q(26 downto 0)
        );
end generate;

a11d26: if (abits = 11) and (dbits = 26) generate
   id0: ram2048x26
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a(10 downto 0),
        D => d(25 downto 0),
        Q => q(25 downto 0)
        );
end generate;

a10d26: if (abits = 10) and (dbits = 26) generate
   id0: ram1024x26
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a( 9 downto 0),
        D => d(25 downto 0),
        Q => q(25 downto 0)
        );
end generate;

a9d26: if (abits = 9) and (dbits = 26) generate
   id0: ram512x26
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a( 8 downto 0),
        D => d(25 downto 0),
        Q => q(25 downto 0)
        );
end generate;

a8d26: if (abits = 8) and (dbits = 26) generate
   id0: ram256x26
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a( 7 downto 0),
        D => d(25 downto 0),
        Q => q(25 downto 0)
        );
end generate;

a7d26: if (abits = 7) and (dbits = 26) generate
   id0: ram128x26
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a( 6 downto 0),
        D => d(25 downto 0),
        Q => q(25 downto 0)
        );
end generate;

a6d26: if (abits = 6) and (dbits = 26) generate
   id0: ram64x26
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a( 5 downto 0),
        D => d(25 downto 0),
        Q => q(25 downto 0)
        );
end generate;

a11d25: if (abits = 11) and (dbits = 25) generate
   id0: ram2048x25
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a(10 downto 0),
        D => d(24 downto 0),
        Q => q(24 downto 0)
        );
end generate;

a10d25: if (abits = 10) and (dbits = 25) generate
   id0: ram1024x25
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a( 9 downto 0),
        D => d(24 downto 0),
        Q => q(24 downto 0)
        );
end generate;

a9d25: if (abits = 9) and (dbits = 25) generate
   id0: ram512x25
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a( 8 downto 0),
        D => d(24 downto 0),
        Q => q(24 downto 0)
        );
end generate;

a8d25: if (abits = 8) and (dbits = 25) generate
   id0: ram256x25
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a( 7 downto 0),
        D => d(24 downto 0),
        Q => q(24 downto 0)
        );
end generate;

a7d25: if (abits = 7) and (dbits = 25) generate
   id0: ram128x25
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a( 6 downto 0),
        D => d(24 downto 0),
        Q => q(24 downto 0)
        );
end generate;

a11d24: if (abits = 11) and (dbits = 24) generate
   id0: ram2048x24
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a(10 downto 0),
        D => d(23 downto 0),
        Q => q(23 downto 0)
        );
end generate;

a10d24: if (abits = 10) and (dbits = 24) generate
   id0: ram1024x24
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a( 9 downto 0),
        D => d(23 downto 0),
        Q => q(23 downto 0)
        );
end generate;

a9d24: if (abits = 9) and (dbits = 24) generate
   id0: ram512x24
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a( 8 downto 0),
        D => d(23 downto 0),
        Q => q(23 downto 0)
        );
end generate;

a8d24: if (abits = 8) and (dbits = 24) generate
   id0: ram256x24
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a( 7 downto 0),
        D => d(23 downto 0),
        Q => q(23 downto 0)
        );
end generate;

a11d23: if (abits = 11) and (dbits = 23) generate
   id0: ram2048x23
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a(10 downto 0),
        D => d(22 downto 0),
        Q => q(22 downto 0)
        );
end generate;

a10d23: if (abits = 10) and (dbits = 23) generate
   id0: ram1024x23
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a( 9 downto 0),
        D => d(22 downto 0),
        Q => q(22 downto 0)
        );
end generate;

a9d23: if (abits = 9) and (dbits = 23) generate
   id0: ram512x23
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a( 8 downto 0),
        D => d(22 downto 0),
        Q => q(22 downto 0)
        );
end generate;

a12d22: if (abits = 12) and (dbits = 22) generate
   id0: ram4096x22
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a(11 downto 0),
        D => d(21 downto 0),
        Q => q(21 downto 0)
        );
end generate;

a11d22: if (abits = 11) and (dbits = 22) generate
   id0: ram2048x22
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a(10 downto 0),
        D => d(21 downto 0),
        Q => q(21 downto 0)
        );
end generate;

a10d22: if (abits = 10) and (dbits = 22) generate
   id0: ram1024x22
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a( 9 downto 0),
        D => d(21 downto 0),
        Q => q(21 downto 0)
        );
end generate;

a12d21: if (abits = 12) and (dbits = 21) generate
   id0: ram4096x21
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a(11 downto 0),
        D => d(20 downto 0),
        Q => q(20 downto 0)
        );
end generate;

a11d21: if (abits = 11) and (dbits = 21) generate
   id0: ram2048x21
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a(10 downto 0),
        D => d(20 downto 0),
        Q => q(20 downto 0)
        );
end generate;

a12d20: if (abits = 12) and (dbits = 20) generate
   id0: ram4096x20
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a(11 downto 0),
        D => d(19 downto 0),
        Q => q(19 downto 0)
        );
end generate;

end rtl;


------------------------------------------------------------------
-- sync dpram generator --------------------------------------------
------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_asic_syn.all;
use work.iface.all;


entity asic_dpram is
  generic ( abits : integer := 10; dbits : integer := 8 );
  port (
    address1 : in std_logic_vector((abits -1) downto 0);
    clk1     : in std_logic;
    datain1  : in std_logic_vector((dbits -1) downto 0);
    dataout1 : out std_logic_vector((dbits -1) downto 0);
    enable1  : in std_logic;
    write1   : in std_logic;
    address2 : in std_logic_vector((abits -1) downto 0);
    clk2     : in std_logic;
    datain2  : in std_logic_vector((dbits -1) downto 0);
    dataout2 : out std_logic_vector((dbits -1) downto 0);
    enable2  : in std_logic;
    write2   : in std_logic
   ); 
end;

architecture rtl of asic_dpram is

signal cena, cenb, wena, wenb : std_logic;

begin
  cena <= not enable1;
  cenb <= not enable2;
  wena <= not write1;
  wenb <= not write2;

  dp2048x32 : if (abits = 11) and (dbits = 32) generate
    dp0:dpram2048x32
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp1024x32 : if (abits = 10) and (dbits = 32) generate
    dp0:dpram1024x32
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp512x32 : if (abits = 9) and (dbits = 32) generate
    dp0:dpram512x32
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp256x32 : if (abits = 8) and (dbits = 32) generate
    dp0:dpram256x32
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp128x32 : if (abits = 7) and (dbits = 32) generate
    dp0:dpram128x32
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp64x32 : if (abits = 6) and (dbits = 32) generate
    dp0:dpram64x32
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp32x32 : if (abits = 5) and (dbits = 32) generate
    dp0:dpram32x32
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp64x31 : if (abits = 6) and (dbits = 31) generate
    dp0:dpram64x31
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp32x31 : if (abits = 5) and (dbits = 31) generate
    dp0:dpram32x31
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp128x30 : if (abits = 7) and (dbits = 30) generate
    dp0:dpram128x30
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp64x30 : if (abits = 6) and (dbits = 30) generate
    dp0:dpram64x30
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp32x30 : if (abits = 5) and (dbits = 30) generate
    dp0:dpram32x30
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp256x29 : if (abits = 8) and (dbits = 29) generate
    dp0:dpram256x29
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp128x29 : if (abits = 7) and (dbits = 29) generate
    dp0:dpram128x29
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp64x29 : if (abits = 6) and (dbits = 29) generate
    dp0:dpram64x29
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp512x28 : if (abits = 9) and (dbits = 28) generate
    dp0:dpram512x28
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp256x28 : if (abits = 8) and (dbits = 28) generate
    dp0:dpram256x28
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp128x28 : if (abits = 7) and (dbits = 28) generate
    dp0:dpram128x28
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp64x28 : if (abits = 6) and (dbits = 28) generate
    dp0:dpram64x28
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp1024x27 : if (abits = 10) and (dbits = 27) generate
    dp0:dpram1024x27
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp512x27 : if (abits = 9) and (dbits = 27) generate
    dp0:dpram512x27
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp256x27 : if (abits = 8) and (dbits = 27) generate
    dp0:dpram256x27
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp128x27 : if (abits = 7) and (dbits = 27) generate
    dp0:dpram128x27
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp64x27 : if (abits = 6) and (dbits = 27) generate
    dp0:dpram64x27
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp2048x26 : if (abits = 11) and (dbits = 26) generate
    dp0:dpram2048x26
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp1024x26 : if (abits = 10) and (dbits = 26) generate
    dp0:dpram1024x26
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp512x26 : if (abits = 9) and (dbits = 26) generate
    dp0:dpram512x26
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp256x26 : if (abits = 8) and (dbits = 26) generate
    dp0:dpram256x26
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp128x26 : if (abits = 7) and (dbits = 26) generate
    dp0:dpram128x26
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp64x26 : if (abits = 6) and (dbits = 26) generate
    dp0:dpram64x26
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp2048x25 : if (abits = 11) and (dbits = 25) generate
    dp0:dpram2048x25
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp1024x25 : if (abits = 10) and (dbits = 25) generate
    dp0:dpram1024x25
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp512x25 : if (abits = 9) and (dbits = 25) generate
    dp0:dpram512x25
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp256x25 : if (abits = 8) and (dbits = 25) generate
    dp0:dpram256x25
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp128x25 : if (abits = 7) and (dbits = 25) generate
    dp0:dpram128x25
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp2048x24 : if (abits = 11) and (dbits = 24) generate
    dp0:dpram2048x24
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp1024x24 : if (abits = 10) and (dbits = 24) generate
    dp0:dpram1024x24
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp512x24 : if (abits = 9) and (dbits = 24) generate
    dp0:dpram512x24
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp256x24 : if (abits = 8) and (dbits = 24) generate
    dp0:dpram256x24
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp2048x23 : if (abits = 11) and (dbits = 23) generate
    dp0:dpram2048x23
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp1024x23 : if (abits = 10) and (dbits = 23) generate
    dp0:dpram1024x23
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp512x23 : if (abits = 9) and (dbits = 23) generate
    dp0:dpram512x23
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp4096x22 : if (abits = 12) and (dbits = 22) generate
    dp0:dpram4096x22
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp2048x22 : if (abits = 11) and (dbits = 22) generate
    dp0:dpram2048x22
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp1024x22 : if (abits = 10) and (dbits = 22) generate
    dp0:dpram1024x22
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp4096x21 : if (abits = 12) and (dbits = 21) generate
    dp0:dpram4096x21
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp2048x21 : if (abits = 11) and (dbits = 21) generate
    dp0:dpram2048x21
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

  dp4096x20 : if (abits = 12) and (dbits = 20) generate
    dp0:dpram4096x20
        port map( 
        CLKA => clk1, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk2, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
  end generate;

end rtl;

------------------------------------------------------------------
-- regfile generator for iu & cp ---------------------------------
------------------------------------------------------------------

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.iface.all;
use work.tech_asic_syn.all;

entity asic_regfile_iu is
  generic ( 
    abits : integer := 8;
    dbits : integer := 32;
    words : integer := 128
  );
  port (
    rst   : in std_logic;
    clk   : in std_logic;
    clkn  : in std_logic;
    rfi   : in rf_in_type;
    rfo   : out rf_out_type);
end;

architecture rtl of asic_regfile_iu is

signal qq0, qq1 : std_logic_vector(dbits-1 downto 0);
signal wen, ren1, ren2 : std_logic;
signal high0, high1 : std_logic;
signal low0, low1 : std_logic;
signal qa0 : std_logic_vector(31 downto 0);
signal qa1 : std_logic_vector(31 downto 0);
signal db0 : std_logic_vector(31 downto 0);
signal db1 : std_logic_vector(31 downto 0);
signal ra1, ra2, wa : std_logic_vector(12 downto 0);

begin
  ren1 <= not rfi.ren1;
  ren2 <= not rfi.ren2;
  wen  <= not rfi.wren;
  db0  <= (others => low0);
  db1  <= (others => low1);

  ra1(abits-1 downto 0) <= rfi.rd1addr;
  ra1(12 downto abits) <= (others => '0');
  ra2(abits-1 downto 0) <= rfi.rd2addr;
  ra2(12 downto abits) <= (others => '0');
  wa(abits-1 downto 0) <= rfi.wraddr;
  wa(12 downto abits) <= (others => '0');

  dp136x32 : if (words = 136) and (dbits = 32) generate
    u0: dpram136x32
        port map( 
        CLKA => clk, CENA => wen, WENA => wen,
        AA   => wa(abits -1 downto 0),
        DA   => rfi.wrdata(dbits -1 downto 0),
        QA   => qa0,
        CLKB => clkn, CENB => ren1, WENB => high0,
        AB   => ra1(abits -1 downto 0),
        DB   => db0,
        QB   => qq0
        );
    u1: dpram136x32
        port map( 
        CLKA => clk, CENA => wen, WENA => wen,
        AA   => wa(abits -1 downto 0),
        DA   => rfi.wrdata(dbits -1 downto 0),
        QA   => qa1,
        CLKB => clkn, CENB => ren2, WENB => high1,
        AB   => ra2(abits -1 downto 0),
        DB   => db1,
        QB   => qq1
        );
  end generate;

  dp168x32 : if (words = 168) and (dbits = 32) generate
    u0: dpram168x32
        port map( 
        CLKA => clk, CENA => wen, WENA => wen,
        AA   => wa(abits -1 downto 0),
        DA   => ra1(dbits -1 downto 0),
        QA   => qa0,
        CLKB => clkn, CENB => ren1, WENB => high0,
        AB   => rfi.rd1addr(abits -1 downto 0),
        DB   => db0,
        QB   => qq0
        );
    u1: dpram168x32
        port map( 
        CLKA => clk, CENA => wen, WENA => wen,
        AA   => wa(abits -1 downto 0),
        DA   => rfi.wrdata(dbits -1 downto 0),
        QA   => qa1,
        CLKB => clkn, CENB => ren2, WENB => high1,
        AB   => ra2(abits -1 downto 0),
        DB   => db1,
        QB   => qq1
        );
  end generate;

  rfo.data1 <= qq0(dbits-1 downto 0);
  rfo.data2 <= qq1(dbits-1 downto 0);

  th0: TIEHI
       port map(
       Y => high0
       );

  th1: TIEHI
       port map(
       Y => high1
       );

  tl0: TIELO
       port map(
       Y => low0
       );
   
  tl1: TIELO
       port map(
       Y => low1
       );

end;

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.iface.all;
use work.tech_asic_syn.all;

entity asic_regfile_cp is
  generic ( 
    abits : integer := 4;
    dbits : integer := 32;
    words : integer := 16
  );
  port (
    rst      : in std_logic;
    clk      : in std_logic;
    rfi      : in rf_cp_in_type;
    rfo      : out rf_cp_out_type);
end;

architecture rtl of asic_regfile_cp is

signal qq0, qq1 : std_logic_vector(dbits-1 downto 0);
signal wen, ren1, ren2 : std_logic;
signal high0, high1 : std_logic;
signal low0, low1   : std_logic;
signal qa0 : std_logic_vector(31 downto 0);
signal qa1 : std_logic_vector(31 downto 0);
signal db0 : std_logic_vector(31 downto 0);
signal db1 : std_logic_vector(31 downto 0);
signal ra1, ra2, wa : std_logic_vector(12 downto 0);

begin
  ren1 <= not rfi.ren1;
  ren2 <= not rfi.ren2;
  wen  <= not rfi.wren;
  db0  <= (others => low0);
  db1  <= (others => low1);

  ra1(abits-1 downto 0) <= rfi.rd1addr;
  ra1(12 downto abits)  <= (others => '0');
  ra2(abits-1 downto 0) <= rfi.rd2addr;
  ra2(12 downto abits)  <= (others => '0');
  wa(abits-1 downto 0)  <= rfi.wraddr;
  wa(12 downto abits)   <= (others => '0');
  
  -- Port A: write port, B: read port
  dp16x32 : if (words = 16) and (dbits = 32) generate
    u0: dpram16x32
        port map( 
        CLKA => clk, CENA => wen, WENA => wen,
        AA   => wa(3 downto 0),
        DA   => rfi.wrdata(dbits -1 downto 0),
        QA   => qa0,
        CLKB => clk, CENB => ren1, WENB => high0,
        AB   => ra1(3 downto 0),
        DB   => db0,
        QB   => qq0
        );
    u1: dpram16x32
        port map( 
        CLKA => clk, CENA => wen, WENA => wen,
        AA   => wa(3 downto 0),
        DA   => rfi.wrdata(dbits -1 downto 0),
        QA   => qa1,
        CLKB => clk, CENB => ren2, WENB => high1,
        AB   => ra2(3 downto 0),
        DB   => db1,
        QB   => qq1
        );
  end generate;

  rfo.data1 <= qq0(dbits-1 downto 0);
  rfo.data2 <= qq1(dbits-1 downto 0);

  th0: TIEHI
       port map(
       Y => high0
       );

  th1: TIEHI
       port map(
       Y => high1
       );

  tl0: TIELO
       port map(
       Y => low0
       );
   
  tl1: TIELO
       port map(
       Y => low1
       );

end;

      
------------------------------------------------------------------
-- mapping generic pads on tech pads -----------------------------
------------------------------------------------------------------

-- input pad
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_asic_syn.all;
entity asic_inpad is 
  generic (updown : integer := 1);
  port    (pad : in std_logic; q : out std_logic); 
end; 

architecture syn of asic_inpad is begin 
  i0 : PDIDGZ port map (PAD => pad, C => q); 
end;

-- input schmitt pad
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_asic_syn.all;
entity asic_smpad is 
  generic (updown : integer := 1);
  port    (pad : in std_logic; q : out std_logic); 
end; 

architecture syn of asic_smpad is begin 
  i0 : PDISDGZ port map (PAD => pad, C => q); 
end;

-- output pads
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_asic_syn.all;
entity asic_outpad is
  generic (drive : integer := 2);  --2,4,8,12,16,24 mA
  port (d : in std_logic; pad : out std_logic);
 end; 
architecture syn of asic_outpad is 
signal en : std_logic;
begin
  d2 : if drive = 1 generate
    i0 : PDT02DGZ port map (I => d, PAD => pad, OEN => en );
  end generate;
  d4 : if drive = 2 generate
    i0 : PDT04DGZ port map (I => d, PAD => pad, OEN => en );
  end generate;
  d8 : if drive = 3 generate
    i0 : PDT08DGZ port map (I => d, PAD => pad, OEN => en );
  end generate;
  d12: if drive = 4 generate
    i0 : PDT12DGZ port map (I => d, PAD => pad, OEN => en );
  end generate;
  d16: if drive = 5 generate
    i0 : PDT16DGZ port map (I => d, PAD => pad, OEN => en );
  end generate;
  d24: if drive >= 5 generate
    i0 : PDT24DGZ port map (I => d, PAD => pad, OEN => en );
  end generate;

  tl0: TIELO
       port map(
       Y => en
       );

end;

-- tri-state output pads with pull-up
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_asic_syn.all;
entity asic_toutpad is 
  generic (drive : integer := 2 ; updown : integer := 1);   --2,4,8,12,16,24 mA
  port (d, en : in  std_logic; pad : out  std_logic);
end; 
architecture syn of asic_toutpad is 
signal nc, q: std_logic;
begin
pad <= q;
  d2 : if drive = 1 generate
    i0 : PDU02DGZ port map (I => d, PAD => q, OEN => en, C => nc);
  end generate;
  d4 : if drive = 2 generate
    i0 : PDU04DGZ port map (I => d, PAD => q, OEN => en, C => nc);
  end generate;
  d8: if drive = 3 generate
    i0 : PDU08DGZ port map (I => d, PAD => q, OEN => en, C => nc);
  end generate;
  d12: if drive = 4 generate
    i0 : PDU12DGZ port map (I => d, PAD => q, OEN => en, C => nc);
  end generate;
  d16: if drive = 5 generate
    i0 : PDU16DGZ port map (I => d, PAD => q, OEN => en, C => nc);
  end generate;
  d24: if drive >= 5 generate
    i0 : PDU24DGZ port map (I => d, PAD => q, OEN => en, C => nc);
  end generate;
end;

-- bidirectional pads
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_asic_syn.all;
entity asic_iopad is
  generic (drive : integer := 2 ; updown : integer := 1);   --2,4,8,12,16,24 mA
  port ( d, en : in std_logic; q : out std_logic; pad : inout std_logic);
end;
architecture syn of asic_iopad is 
begin 
  d2 : if drive = 1 generate
    i0 : PDB02DGZ port map (I => d, PAD => pad, OEN => en, C => q);
  end generate;
  d4 : if drive = 2 generate
    i0 : PDB04DGZ port map (I => d, PAD => pad, OEN => en, C => q);
  end generate;
  d8 : if drive = 3 generate
    i0 : PDB08DGZ port map (I => d, PAD => pad, OEN => en, C => q);
  end generate;
  d12: if drive = 4 generate
    i0 : PDB12DGZ port map (I => d, PAD => pad, OEN => en, C => q);
  end generate;
  d16: if drive = 5 generate
    i0 : PDB16DGZ port map (I => d, PAD => pad, OEN => en, C => q);
  end generate;
  d24: if drive >= 5 generate
    i0 : PDB24DGZ port map (I => d, PAD => pad, OEN => en, C => q);
  end generate;
end;

-- bidirectional open-drain pads
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_asic_syn.all;
entity asic_iodpad is
  generic (drive : integer := 2 ; updown : integer := 1);   --2,4,8,12,16,24 mA
  port ( d : in std_logic; q : out std_logic; pad : inout std_logic);
end;
architecture syn of asic_iodpad is 
signal dis : std_logic;
begin
  d2 : if drive = 1 generate
    i0 : PDB02DGZ port map (I => dis, PAD => pad, OEN => d, C => q);
  end generate;
  d4 : if drive = 2 generate
    i0 : PDB04DGZ port map (I => dis, PAD => pad, OEN => d, C => q);
  end generate;
  d8 : if drive = 3 generate
    i0 : PDB08DGZ port map (I => dis, PAD => pad, OEN => d, C => q);
  end generate;
  d12: if drive = 4 generate
    i0 : PDB12DGZ port map (I => dis, PAD => pad, OEN => d, C => q);
  end generate;
  d16: if drive = 5 generate
    i0 : PDB16DGZ port map (I => dis, PAD => pad, OEN => d, C => q);
  end generate;
  d24: if drive >= 5 generate
    i0 : PDB24DGZ port map (I => dis, PAD => pad, OEN => d, C => q);
  end generate;

  tl0: TIELO
       port map(
       Y => dis
       );
end;

-- output open-drain pads
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_asic_syn.all;
entity asic_odpad is
  generic (drive : integer := 2 ; updown : integer := 1);   --2,4,8,12,16,24 mA
  port (d : in std_logic; pad : out std_logic);
end;
architecture syn of asic_odpad is 
signal dis : std_logic;
begin

  d2 : if drive = 1 generate
    i0 : PDT02DGZ port map (I => dis, PAD => pad, OEN => d);
  end generate;
  d4 : if drive = 2 generate
    i0 : PDT04DGZ port map (I => dis, PAD => pad, OEN => d);
  end generate;
  d8 : if drive = 3 generate
    i0 : PDT08DGZ port map (I => dis, PAD => pad, OEN => d);
  end generate;
  d12: if drive = 4 generate
    i0 : PDT12DGZ port map (I => dis, PAD => pad, OEN => d);
  end generate;
  d16: if drive = 5 generate
    i0 : PDT16DGZ port map (I => dis, PAD => pad, OEN => d);
  end generate;
  d24: if drive >= 5 generate
    i0 : PDT24DGZ port map (I => dis, PAD => pad, OEN => d);
  end generate;

  tl0: TIELO
       port map(
       Y => dis
       );
end;

-- bidirectional I/O pads with schmitt trigger
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_asic_syn.all;
entity asic_smiopad is
  generic (drive : integer := 2 ; updown : integer := 1);   --2,4,8,12,16,24 mA
  port ( d, en : in std_logic; q : out std_logic; pad : inout std_logic);
end;
architecture syn of asic_smiopad is 
signal dis : std_logic;
begin
  d2 : if drive = 1 generate
    i0 : PDB02SDGZ port map (I => d, PAD => pad, OEN => en, C => q);
  end generate;
  d4 : if drive = 2 generate
    i0 : PDB04SDGZ port map (I => d, PAD => pad, OEN => en, C => q);
  end generate;
  d8: if drive = 3 generate
    i0 : PDB08SDGZ port map (I => d, PAD => pad, OEN => en, C => q);
  end generate;
  d12: if drive = 4 generate
    i0 : PDB12SDGZ port map (I => d, PAD => pad, OEN => en, C => q);
  end generate;
  d16: if drive = 5 generate
    i0 : PDB16SDGZ port map (I => d, PAD => pad, OEN => en, C => q);
  end generate;
  d24: if drive >= 5 generate
    i0 : PDB24SDGZ port map (I => d, PAD => pad, OEN => en, C => q);
  end generate;
end;

-- input PCI pad
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_asic_syn.all;

entity asic_pciinpad is 
  port (q : out std_ulogic; pad : in std_logic); 
end; 

architecture rtl of asic_pciinpad is 
begin 
  ip : PDIDGZ port map (PAD => pad, C => q); 
end;

-- output PCI pad
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_asic_syn.all;

entity asic_pcioutpad is 
  port (d : in  std_logic; pad : out  std_logic); 
end; 

architecture rtl of asic_pcioutpad is 
begin 
  op : PDT08DGZ port map (I => d, PAD => pad, OEN => '0');
end;

-- tri-state output PCI pad
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_asic_syn.all;

entity asic_pcitoutpad is 
  port (d, en : in  std_logic; pad : out  std_logic); 
end; 

architecture rtl of asic_pcitoutpad is 
  signal nc, q: std_logic;
begin 
  pad <= q ;
  tp : PDU08DGZ port map (I => d, PAD => q, OEN => en, C => nc);
end;

-- bi-directional PCI pad
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_asic_syn.all;

entity asic_pciiopad is 
  port (d, en : in  std_logic; q : out std_ulogic; pad : inout  std_logic); 
end; 

architecture rtl of asic_pciiopad is 
begin
  bp  : PDB08DGZ port map (I => d, PAD => pad, OEN => en, C => q);
end;

-- bi-directional open-drain PCI pad
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_asic_syn.all;

entity asic_pciiodpad is 
  port (d : in  std_logic; q : out std_ulogic; pad : inout  std_logic); 
end; 

architecture rtl of asic_pciiodpad is 
  signal dis : std_logic;
begin
  dp : PDB08DGZ port map (I => dis, PAD => pad, OEN => d, C => q);
end;





