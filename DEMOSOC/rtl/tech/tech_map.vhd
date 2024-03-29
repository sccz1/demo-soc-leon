



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
-- Package: 	tech_map
-- File:	tech_map.vhd
-- Author:	Jiri Gaisler - ESA/ESTEC
-- Description:	Technology mapping of cache-rams, regfiles, pads and multiplier
------------------------------------------------------------------------------

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use work.iface.all;
package tech_map is

-- IU three-port regfile
  component regfile_iu
  generic ( 
    rftype : integer := 1;
    abits : integer := 8; dbits : integer := 32; words : integer := 128
  );
  port (
    rst      : in std_logic;
    clk      : in clk_type;
    clkn     : in clk_type;
    rfi      : in rf_in_type;
    rfo      : out rf_out_type);
  end component;

-- CP three-port
  component regfile_cp
  generic ( 
    abits : integer := 4; dbits : integer := 32; words : integer := 16
  );
  port (
    rst      : in std_logic;
    clk      : in clk_type;
    rfi      : in rf_cp_in_type;
    rfo      : out rf_cp_out_type);
  end component;

-- single-port sync ram
  component syncram 
  generic ( abits : integer := 10; dbits : integer := 8);
  port (
    address  : in std_logic_vector((abits -1) downto 0);
    clk      : in clk_type;
    datain   : in std_logic_vector((dbits -1) downto 0);
    dataout  : out std_logic_vector((dbits -1) downto 0);
    enable   : in std_logic;
    write    : in std_logic
  ); 
  end component;     

-- dual-port sync ram
  component dpsyncram 
  generic ( abits : integer := 10; dbits : integer := 8);
  port (
    address1 : in std_logic_vector((abits -1) downto 0);
    clk1     : in clk_type;
    datain1  : in std_logic_vector((dbits -1) downto 0);
    dataout1 : out std_logic_vector((dbits -1) downto 0);
    enable1  : in std_logic;
    write1   : in std_logic;
    address2 : in std_logic_vector((abits -1) downto 0);
    clk2     : in clk_type;
    datain2  : in std_logic_vector((dbits -1) downto 0);
    dataout2 : out std_logic_vector((dbits -1) downto 0);
    enable2  : in std_logic;
    write2   : in std_logic
  ); 
  end component;     

-- 2-port sync ram
  component twopsyncram 
  generic ( abits : integer := 10; dbits : integer := 8);
  port (
    address1 : in std_logic_vector((abits -1) downto 0);
    clk1     : in clk_type;
    dataout1 : out std_logic_vector((dbits -1) downto 0);
    enable1  : in std_logic;
    address2 : in std_logic_vector((abits -1) downto 0);
    clk2     : in clk_type;
    datain2  : in std_logic_vector((dbits -1) downto 0);
    enable2  : in std_logic;
    write2   : in std_logic
  ); 
  end component;     

-- sync prom (used for boot-prom option)
  component bprom
  port (
    clk       : in std_logic;
    cs        : in std_logic;
    addr      : in std_logic_vector(31 downto 0);
    data      : out std_logic_vector(31 downto 0)
  );
  end component;

-- signed multipler

component hw_smult
  generic ( abits : integer := 10; bbits : integer := 8 );
  port (
    clk  : in  clk_type;
    holdn: in  std_logic;
    a    : in  std_logic_vector(abits-1 downto 0);
    b    : in  std_logic_vector(bbits-1 downto 0);
    c    : out std_logic_vector(abits+bbits-1 downto 0)
  ); 
end component; 

component clkgen 
port (
    clkin   : in  std_logic;
    pciclkin: in  std_logic;
    clk     : out std_logic;			-- main clock
    clkn    : out std_logic;			-- inverted main clock
    sdclk   : out std_logic;			-- SDRAM clock
    pciclk  : out std_logic;			-- PCI clock
    cgi     : in clkgen_in_type;
    cgo     : out clkgen_out_type
);
end component;

-- pads

  component inpad 
    generic (updown : integer := 1);
    port (pad : in std_logic; q : out std_logic); 
  end component;

  component smpad 
    generic (updown : integer := 1);
    port (pad : in std_logic; q : out std_logic); 
  end component;

  component outpad
    generic (drive : integer := 1);
    port (d : in std_logic; pad : out std_logic);
  end component;

  component toutpad
    generic (drive : integer := 1 ; updown : integer := 1);
    port (d : in std_logic; pad : out std_logic);
  end component;

  component odpad
    generic (drive : integer := 1 ; updown : integer := 1);
    port (d : in std_logic; pad : out std_logic);
  end component;

  component iodpad
    generic (drive : integer := 1 ; updown : integer := 1);
    port ( d : in std_logic; q : out std_logic; pad : inout std_logic);
  end component;

  component iopad
    generic (drive : integer := 1 ; updown : integer := 1);
    port ( d, en : in  std_logic; q : out std_logic; pad : inout std_logic);
  end component;

  component smiopad 
    generic (drive : integer := 1 ; updown : integer := 1);
    port ( d, en : in  std_logic; q : out std_logic; pad : inout std_logic);
  end component; 

  component pciinpad 
    port (pad : in std_logic; q : out std_logic); 
  end component;

  component pcioutpad 
    port (d : in std_logic; pad : out std_logic); 
  end component;

  component pcitoutpad 
    port (d, en : in std_logic; pad : out std_logic); 
  end component;

  component pciiopad
    port ( d, en : in  std_logic; q : out std_logic; pad : inout std_logic);
  end component;

  component pciiodpad
    port ( d : in  std_logic; q : out std_logic; pad : inout std_logic);
  end component; 
end tech_map;

-- syncronous ram

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.iface.all;
use work.tech_generic.all;
use work.tech_fpga.all;
use work.tech_asic.all;

entity syncram is
  generic ( abits : integer := 8; dbits : integer := 32);
  port (
    address : in std_logic_vector (abits -1 downto 0);
    clk     : in clk_type;
    datain  : in std_logic_vector (dbits -1 downto 0);
    dataout : out std_logic_vector (dbits -1 downto 0);
    enable  : in std_logic;
    write   : in std_logic
  );
end;

architecture behav of syncram is
begin

  inf : if INFER_RAM generate 
    u0 : generic_syncram 
    generic map (abits => abits, dbits => dbits)
    port    map (address, clk , datain, dataout, enable, write);
  end generate;

  hb : if (not INFER_RAM) generate 
    sim : if TARGET_TECH = gen generate
      u0 : generic_syncram 
      generic map (abits => abits, dbits => dbits)
      port    map (address, clk , datain, dataout, enable, write);
    end generate;    

    gfpga : if TARGET_TECH = fpga generate 
      u0 : fpga_syncram 
      generic map (abits => abits, dbits => dbits)
	    port    map (address, clk , datain, dataout, enable, write);
    end generate;

    gasic : if TARGET_TECH = asic generate
      u0 : asic_syncram 
      generic map (abits => abits, dbits => dbits)
      port    map (address, clk , datain, dataout, enable, write);
    end generate;    
  end generate;
end;

-- syncronous dual-port ram

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.iface.all;
use work.tech_generic.all;
use work.tech_fpga.all;
use work.tech_asic.all;

entity dpsyncram is
  generic ( abits : integer := 8; dbits : integer := 32);
  port (
    address1 : in std_logic_vector((abits -1) downto 0);
    clk1     : in clk_type;
    datain1  : in std_logic_vector((dbits -1) downto 0);
    dataout1 : out std_logic_vector((dbits -1) downto 0);
    enable1  : in std_logic;
    write1   : in std_logic;
    address2 : in std_logic_vector((abits -1) downto 0);
    clk2     : in clk_type;
    datain2  : in std_logic_vector((dbits -1) downto 0);
    dataout2 : out std_logic_vector((dbits -1) downto 0);
    enable2  : in std_logic;
    write2   : in std_logic
  );
end;

architecture behav of dpsyncram is
begin

-- pragma translate_off
  inf : if INFER_RAM generate 
    x : process(clk1)
    begin
      assert false report "infering of dual-port rams not supported!"
      severity error;
    end process;
  end generate;
-- pragma translate_on

  hb : if (not INFER_RAM) generate 
    gfpga : if TARGET_TECH = fpga generate 
      u0 : fpga_dpram 
      generic map (abits => abits, dbits => dbits)
	    port    map (address1, clk1, datain1, dataout1, enable1, write1, address2, clk2, datain2, dataout2, enable2, write2);
    end generate;

    gaisc : if TARGET_TECH = asic generate 
      u0 : asic_dpram 
      generic map (abits => abits, dbits => dbits)
	    port    map (address1, clk1, datain1, dataout1, enable1, write1, address2, clk2, datain2, dataout2, enable2, write2);
    end generate;

-- pragma translate_off
    notech : if ((TARGET_TECH /= fpga) and (TARGET_TECH /= asic)) generate 
      x : process(clk1)
      begin
        assert false report "dual-port rams not supported for this technology!"
        severity error;
      end process;
    end generate;
-- pragma translate_on
  end generate;
end;

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.iface.all;
use work.tech_generic.all;
use work.tech_fpga.all;
use work.tech_asic.all;

entity twopsyncram is
  generic ( abits : integer := 8; dbits : integer := 32);
  port (
    address1 : in std_logic_vector((abits -1) downto 0);
    clk1     : in clk_type;
    dataout1 : out std_logic_vector((dbits -1) downto 0);
    enable1  : in std_logic;
    address2 : in std_logic_vector((abits -1) downto 0);
    clk2     : in clk_type;
    datain2  : in std_logic_vector((dbits -1) downto 0);
    enable2  : in std_logic;
    write2   : in std_logic
  );
end;

architecture behav of twopsyncram is
signal zero : std_logic_vector(dbits-1 downto 0);
begin

  zero <= (others => '0');

  gb : if INFER_RAM generate 
    g2p: generic_2pram generic map (abits => abits, dbits => dbits)
    port map (clk1, clk2, address1, address2, datain2, write2, dataout1);
  end generate;

  hb : if (not INFER_RAM) generate 
    gfpga : if TARGET_TECH = fpga generate 
      u0 : fpga_dpram 
      generic map (abits => abits, dbits => dbits)
	    port    map (address1, clk1, zero, dataout1, enable1, zero(0), address2, clk2, datain2, open, enable2, write2);
    end generate;

    gasic : if TARGET_TECH = asic generate 
      u0 : asic_dpram 
      generic map (abits => abits, dbits => dbits)
	    port map (address1, clk1, zero, dataout1, enable1, zero(0), address2, clk2, datain2, open, enable2, write2);
    end generate;
  end generate;

end;


-- IU regfile

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.iface.all;
use work.tech_generic.all;
use work.tech_fpga.all;
use work.tech_asic.all;

entity regfile_iu is
  generic ( 
    rftype : integer := 1;
    abits : integer := 8; dbits : integer := 32; words : integer := 128
  );
  port (
    rst      : in std_logic;
    clk      : in clk_type;
    clkn     : in clk_type;
    rfi      : in rf_in_type;
    rfo      : out rf_out_type);
end;

architecture rtl of regfile_iu is
signal vcc : std_logic;
begin

  vcc <= '1';

  inf : if INFER_REGF generate 
    u0 : generic_regfile_iu 
    generic map (rftype, abits, dbits, words)
    port    map (rst, clk, clkn, rfi, rfo);
  end generate;

  ninf : if not INFER_REGF generate 
    sim : if TARGET_TECH = gen generate
      u0 : generic_regfile_iu 
      generic map (rftype, abits, dbits, words)
	    port    map (rst, clk , clkn , rfi, rfo);
    end generate;

    gfpga : if TARGET_TECH = fpga generate 
      u0 : fpga_regfile 
      generic map (rftype, abits, dbits, words)
	    port    map (rst, clk , clkn , rfi, rfo);
    end generate;

    gasic : if TARGET_TECH = asic generate 
      u0 : asic_regfile_iu 
      generic map (abits, dbits, words)
	    port    map (rst, clk , clkn , rfi, rfo);
    end generate;
  end generate;
end;

-- Parallel FPU/CP regfile

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.iface.all;
use work.tech_generic.all;
use work.tech_fpga.all;
use work.tech_asic.all;

entity regfile_cp is
  generic ( 
    abits : integer := 4; dbits : integer := 32; words : integer := 16
  );
  port (
    rst      : in std_logic;
    clk      : in clk_type;
    rfi      : in rf_cp_in_type;
    rfo      : out rf_cp_out_type);
end;

architecture rtl of regfile_cp is
signal vcc : std_logic;
begin

  vcc <= '1';

  inf : if INFER_REGF generate 
    u0 : generic_regfile_cp 
    generic map (abits, dbits, words)
    port    map (rst, clk, rfi, rfo);
  end generate;

  ninf : if not INFER_REGF generate 
    sim : if TARGET_TECH = gen generate
      u0 : generic_regfile_cp 
      generic map (abits, dbits, words)
	    port    map (rst, clk , rfi, rfo);
    end generate;

    gfpga : if TARGET_TECH = fpga generate 
      u0 : fpga_regfile_cp 
      generic map (abits, dbits, words)
	    port    map (rst, clk , rfi, rfo);
    end generate;

    gasic : if TARGET_TECH = asic generate 
      u0 : asic_regfile_cp 
      generic map (abits, dbits, words)
	    port    map (rst, clk , rfi, rfo);
    end generate;
  end generate;
end;

-- boot-prom

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.tech_generic.all;
use work.tech_fpga.all;
use work.tech_asic.all;

entity bprom is
  port (
    clk       : in std_logic;
    cs        : in std_logic;
    addr      : in std_logic_vector(31 downto 0);
    data      : out std_logic_vector(31 downto 0)
  );
end;

architecture rtl of bprom is
component gen_bprom
  port (
    clk : in std_logic;
    csn : in std_logic;
    addr : in std_logic_vector (29 downto 0);
    data : out std_logic_vector (31 downto 0));
end component;
begin

  b0: if INFER_ROM generate
    u0 : gen_bprom 
    port map (clk, cs, addr(31 downto 2), data);
  end generate;

  b1: if (not INFER_ROM) and (TARGET_TECH = fpga) generate
    u0 : fpga_bprom 
    port map (clk, addr(31 downto 2), data);
  end generate;

end;

-- multiplier 

library ieee;
use ieee.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.iface.all;
use work.multlib.all;
use work.tech_generic.all;
use work.tech_fpga.all;
use work.tech_asic.all;

entity hw_smult is
  generic ( abits : integer := 10; bbits : integer := 8 );
  port (
    clk  : in  clk_type;
    holdn: in  std_logic;
    a    : in  std_logic_vector(abits-1 downto 0);
    b    : in  std_logic_vector(bbits-1 downto 0);
    c    : out std_logic_vector(abits+bbits-1 downto 0)
  ); 
end;

architecture rtl of hw_smult is
begin

  inf : if INFER_MULT generate
    u0 : generic_smult 
    generic map (abits => abits, bbits => bbits)
    port    map (a, b, c);
  end generate;

  mg : if not INFER_MULT generate
    m1717 : if (abits = 17) and (bbits = 17) generate
      u0 : mul_17_17 
      port map (clk, holdn, a, b, c);
    end generate;

    m339 : if (abits = 33) and (bbits = 9) generate
      u0 : mul_33_9 
      port map (a, b, c);
    end generate;

    m3317 : if (abits = 33) and (bbits = 17) generate
      u0 : mul_33_17 
      port map (a, b, c);
    end generate;

    m3333 : if (abits = 33) and (bbits = 33) generate
      u0 : mul_33_33 
      port map (a, b, c);
    end generate;
  end generate;
end;

-- input pad

library IEEE;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.tech_generic.all;
use work.tech_fpga.all;
use work.tech_asic.all;

entity inpad is 
  generic(updown : integer := 1);
  port (pad : in std_logic; q : out std_logic); 
end; 

architecture rtl of inpad is
begin
  inf : if INFER_PADS or TARGET_TECH = gen or TARGET_TECH = fpga  generate
    ginpad0 : geninpad 
    port map (q => q, pad => pad);
  end generate;

  ninf : if not INFER_PADS and TARGET_TECH = asic generate
    asic_ip : asic_inpad 
    generic map(updown => updown)
    port    map(q => q, pad => pad);
  end generate;
end;

-- input schmitt pad

library IEEE;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.tech_generic.all;
use work.tech_fpga.all;
use work.tech_asic.all;

entity smpad is 
  generic (updown : integer := 1);
  port    (pad : in std_logic; q : out std_logic); 
end; 

architecture rtl of smpad is
begin
  inf : if INFER_PADS or TARGET_TECH = gen or TARGET_TECH = fpga generate
    gsmpad0 : gensmpad 
    port map (pad => pad, q => q);
  end generate;

  ninf : if not INFER_PADS generate
    gasic : if TARGET_TECH = asic generate
      asic_sm : asic_smpad 
      generic map(updown => updown)
      port    map(q => q, pad => pad);
    end generate;
  end generate;
end;

-- output pads

library IEEE;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.tech_generic.all;
use work.tech_fpga.all;
use work.tech_asic.all;

entity outpad is
  generic (drive : integer := 1);
  port    (d : in std_logic; pad : out std_logic);
end; 
architecture rtl of outpad is
begin
  inf : if INFER_PADS or TARGET_TECH = gen or TARGET_TECH = fpga generate
    goutpad0 : genoutpad 
    port map (d => d, pad => pad);
  end generate;

  ninf : if not INFER_PADS generate
    gasic : if TARGET_TECH = asic generate
      asic_op : asic_outpad 
      generic map (drive) 
      port    map (d => d, pad => pad);
    end generate;
  end generate;
end;

-- tri-state output pads

library IEEE;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.tech_generic.all;
use work.tech_fpga.all;
use work.tech_asic.all;

entity toutpad is
  generic (drive : integer := 1 ; updown : integer := 1);
  port    (d, en : in std_logic; pad : out std_logic);
end; 
architecture rtl of toutpad is
begin
  inf : if INFER_PADS or TARGET_TECH = gen or TARGET_TECH = fpga generate
    giop0 : gentoutpadu 
    port map (d => d, en => en, pad => pad);
  end generate;

  ninf : if not INFER_PADS generate
    gasic : if TARGET_TECH = asic generate
      asic_top : asic_toutpad 
      generic map (drive,updown) 
      port    map (d => d, en => en, pad => pad);
    end generate;
  end generate;
end;

-- bidirectional pad

library IEEE;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.tech_generic.all;
use work.tech_asic.all;
use work.tech_fpga.all;

entity iopad is
  generic (drive : integer := 1 ; updown : integer := 1);
  port    (
    d     : in  std_logic;
    en    : in  std_logic;
    q     : out std_logic;
    pad   : inout std_logic
  );
end; 

architecture rtl of iopad is
begin
  inf : if INFER_PADS or TARGET_TECH = gen or TARGET_TECH = fpga generate
    giop0 : geniopad 
    port map (d => d, en => en, q => q, pad => pad);
  end generate;

  ninf : if not INFER_PADS generate
    gasic : if TARGET_TECH = asic generate
      asic_io : asic_iopad 
      generic map (drive, updown) 
      port    map (d => d, en => en, q => q, pad => pad);
    end generate;
  end generate;
end;

-- bidirectional pad with schmitt trigger for I/O ports
-- (if available)

library IEEE;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.tech_generic.all;
use work.tech_asic.all;
use work.tech_fpga.all;

entity smiopad is
  generic (drive : integer := 1 ; updown : integer := 1);
  port (
    d     : in  std_logic;
    en    : in  std_logic;
    q     : out std_logic;
    pad   : inout std_logic
  );
end; 

architecture rtl of smiopad is
begin
  inf : if INFER_PADS or TARGET_TECH = gen or TARGET_TECH = fpga generate
    giop0 : geniopad 
    port map (d => d, en => en, q => q, pad => pad);
  end generate;

  ninf : if not INFER_PADS generate
    gasic : if TARGET_TECH = asic generate
      asic_smio : asic_smiopad 
      generic map (drive, updown) 
      port    map (d => d, en => en, q => q, pad => pad);
    end generate;
  end generate;
end;

-- open-drain pad

library IEEE;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.tech_generic.all;
use work.tech_asic.all;
use work.tech_fpga.all;

entity odpad is
  generic (drive : integer := 1 ; updown : integer := 1);
  port    (d : in std_logic; pad : out std_logic);
end; 
architecture rtl of odpad is
begin
  inf : if INFER_PADS or TARGET_TECH = gen or TARGET_TECH = fpga generate
    godpad0 : genodpad 
    port map (d => d, pad => pad);
  end generate;

  ninf : if not INFER_PADS generate
    gasic : if TARGET_TECH = asic generate
      asic_od : asic_odpad 
      generic map (drive,updown) 
      port    map (d => d, pad => pad);
    end generate;
  end generate;
end;

-- bi-directional open-drain
library IEEE;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.tech_generic.all;
use work.tech_fpga.all;
use work.tech_asic.all;

entity iodpad is
  generic (drive : integer := 1 ; updown : integer := 1);
  port    (d : in  std_logic; q : out std_logic; pad : inout std_logic);
end; 

architecture rtl of iodpad is
begin 
  inf : if INFER_PADS or TARGET_TECH = gen or TARGET_TECH = fpga  generate
    giodp0 : geniodpad 
    port map (d => d, q => q, pad => pad);
  end generate;

  ninf : if not INFER_PADS generate
    gasic : if TARGET_TECH = asic generate
      asic_iod : asic_iodpad 
      generic map (drive,updown) 
      port    map (d => d, q => q, pad => pad);
    end generate;
  end generate;
end;

-- PCI input pad

library IEEE;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.tech_fpga.all;
use work.tech_generic.all;
use work.tech_asic.all;
use work.tech_map.all;

entity pciinpad is 
  port (pad : in std_logic; q : out std_logic); 
end; 

architecture rtl of pciinpad is
begin
  inf : if INFER_PCI_PADS generate
    ginpad0 : geninpad 
    port map (q => q, pad => pad);
  end generate;

  ninf : if not INFER_PCI_PADS generate
    gfpga : if TARGET_TECH = fpga generate
      fpga_pci_in : fpga_pciinpad 
      port map (q => q, pad => pad);
    end generate;

    gasic : if TARGET_TECH = asic generate
      asic_pci_in : asic_pciinpad 
      port map (q => q, pad => pad);
    end generate;
  end generate;
end;

-- PCI output pad

library IEEE;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.tech_fpga.all;
use work.tech_generic.all;
use work.tech_asic.all;

entity pcioutpad is 
  port (d : in std_logic; pad : out std_logic); 
end; 

architecture rtl of pcioutpad is
begin
  inf : if INFER_PCI_PADS  generate
    goutpad0 : genoutpad 
    port map (d => d, pad => pad);
  end generate;

  ninf : if not INFER_PCI_PADS generate
    gfpga : if (TARGET_TECH = fpga) generate
      fpga_pci_out : fpga_pcioutpad 
      port map (d => d, pad => pad);
    end generate;

    gasic : if (TARGET_TECH = asic) generate
      asic_pci_out : asic_pcioutpad 
      port map (d => d, pad => pad);
    end generate;
  end generate;
end;

-- PCI tristate output pad
library IEEE;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.tech_fpga.all;
use work.tech_generic.all;
use work.tech_asic.all;

entity pcitoutpad is 
  port (d, en : in std_logic; pad : out std_logic); 
end; 

architecture rtl of pcitoutpad is
begin
  inf : if INFER_PCI_PADS generate
    giop0 : gentoutpadu 
    port map (d => d, en => en, pad => pad);
  end generate;

  ninf : if not INFER_PCI_PADS generate
    gfpga : if TARGET_TECH = fpga generate
      fpga_pci_to : fpga_pcitoutpad 
      port map (d => d, en => en, pad => pad);
    end generate;

    gasic : if TARGET_TECH = asic generate
      asic_pci_to : asic_pcitoutpad 
      port map (d => d, en => en, pad => pad);
    end generate;
  end generate;
end;

-- bidirectional pad
-- PCI bidir pad

library IEEE;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.tech_fpga.all;
use work.tech_generic.all;
use work.tech_asic.all;

entity pciiopad is
  port (
    d     : in  std_logic;
    en    : in  std_logic;
    q     : out std_logic;
    pad   : inout std_logic
  );
end; 

architecture rtl of pciiopad is
begin
  inf : if INFER_PCI_PADS  generate
    giop0 : geniopad 
    port map (d => d, en => en, q => q, pad => pad);
  end generate;

  ninf : if not INFER_PCI_PADS generate
    gfpga : if TARGET_TECH = fpga generate
      fpga_pci_io : fpga_pciiopad 
      port map (d => d, en => en, q => q, pad => pad);
    end generate;

    gasic : if TARGET_TECH = asic generate
      asic_pci_io : asic_pciiopad 
      port map (d => d, en => en, q => q, pad => pad);
    end generate;
  end generate;
end;

-- PCI bi-directional open-drain
library IEEE;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.tech_fpga.all;
use work.tech_generic.all;
use work.tech_asic.all;

entity pciiodpad is
  port ( d : in  std_logic; q : out std_logic; pad : inout std_logic);
end; 

architecture rtl of pciiodpad is
begin 
  inf : if INFER_PCI_PADS generate
    giodp0 : geniodpad 
    port map (d => d, q => q, pad => pad);
  end generate;

  ninf : if not INFER_PCI_PADS generate
    gfpga : if TARGET_TECH = fpga generate
      fpga_pci_iod : fpga_pciiodpad 
      port map (d => d, q => q, pad => pad);
    end generate;

    gasic : if TARGET_TECH = asic generate
      asic_pci_iod : asic_pciiodpad 
      port map (d => d, q => q, pad => pad);
    end generate;
  end generate;
end;


