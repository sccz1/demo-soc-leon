----------------------------------------------------------------------------
--  This file is a part of the GRLIB VHDL IP LIBRARY
--  Copyright (C) 2004 GAISLER RESEARCH
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  See the file COPYING for the full details of the license.
--
-----------------------------------------------------------------------------
-- Entity: 	gpio
-- File:	apbgpio.vhd
-- Author:	Antti Lukats, OpenChip
-- Description:	General Purpose I/O
--
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.iface.all;
use work.amba.all;

--pragma translate_off
use std.textio.all;
--pragma translate_on

entity apbgpio is
  port (
    rst    : in  std_ulogic;
    clk    : in  std_ulogic;
    apbi   : in  apb_slv_in_type;
    apbo   : out apb_slv_out_type;
    gpioi  : in  gpio_in_type;
    gpioo  : out gpio_out_type);
end;

architecture rtl of apbgpio is

constant REVISION : integer := 0;

type gpioregs is record
  outreg	:  std_logic_vector(31 downto 0); -- Output Latch
  dirreg	:  std_logic_vector(31 downto 0); -- Direction Register
  inreg		:  std_logic_vector(31 downto 0); -- Input Latch
end record;

signal r, rin : gpioregs;

begin

  comb : process(rst, r, apbi, gpioi )

  variable rdata : std_logic_vector(31 downto 0);
  variable v : gpioregs;

  begin
    v := r;
    v.inreg := gpioi.d_in;

    rdata := (others => '0');

-- read/write registers

    case apbi.paddr(3 downto 2) is
    when "00" =>
      rdata(31 downto 0) := r.inreg;  -- read IO pin
    when "01" =>
      rdata(31 downto 0) := r.dirreg; -- read back of direction reg ?
    when others =>
    end case;

    if (apbi.psel and apbi.penable and apbi.pwrite) = '1' then
      case apbi.paddr(3 downto 2) is
      when "00" =>
	v.outreg := apbi.pwdata(31 downto 0);
      when "01" =>
	v.dirreg := apbi.pwdata(31 downto 0);
      when others =>
      end case;
    end if;

-- reset operation

    if rst = '0' then
      v.outreg := (others => '0');
      v.dirreg := (others => '0');
    end if;

-- update registers

    rin <= v;

-- drive outputs


    gpioo.d_out <= r.outreg;
    gpioo.t_out <= r.dirreg;

    apbo.prdata <= rdata;

  end process;


  regs : process(clk)
  begin
    if rising_edge(clk) then
      r <= rin;
    end if;
  end process;

end;
