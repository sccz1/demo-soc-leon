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
-- Entity: 	charlcd
-- File:	apbcharlcd.vhd
-- Author:	Antti Lukats, OpenChip
-- Description:	Character LCD
--
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.iface.all;
use work.amba.all;

--pragma translate_off
use std.textio.all;
--pragma translate_on

entity apbcharlcd is
  port (
    rst    : in  std_ulogic;
    clk    : in  std_ulogic;
    apbi   : in  apb_slv_in_type;
    apbo   : out apb_slv_out_type;
    lcdi  : in  charlcd_in_type;
    lcdo  : out charlcd_out_type);
end;

architecture rtl of apbcharlcd is

constant REVISION : integer := 0;

type charlcdregs is record
  outreg	:  std_logic_vector(31 downto 0); -- Output Latch Data/Control
  inreg		:  std_logic_vector(7 downto 0);  -- Input Latch, not used
end record;

signal r, rin : charlcdregs;

begin

  comb : process(rst, r, apbi, lcdi )

  variable rdata : std_logic_vector(31 downto 0);
  variable v : charlcdregs;

  begin
    v := r;
    v.inreg := lcdi.d_in;

    rdata := (others => '0');

-- read/write registers

    case apbi.paddr(3 downto 2) is
    when "00" =>
      rdata(31 downto 0) := r.outreg;  -- read Control Reg
    when "01" =>
      rdata(7 downto 0) := r.inreg; -- read back if bidir?
    when others =>
    end case;

    if (apbi.psel and apbi.penable and apbi.pwrite) = '1' then
      case apbi.paddr(3 downto 2) is
      when "00" =>
	v.outreg := apbi.pwdata(31 downto 0);
      when others =>
      end case;
    end if;

-- reset operation

    if rst = '0' then
      v.outreg := (others => '0');
    end if;

-- update registers

    rin <= v;

-- drive outputs

    lcdo.d_out <= r.outreg(7 downto 0);
    lcdo.en <= r.outreg(11 downto 8);
    lcdo.rs <= r.outreg(12);
    lcdo.r_wn <= r.outreg(13);
    lcdo.backlight_en <= r.outreg(14);
    lcdo.d_out_oe <= r.outreg(15);

    apbo.prdata <= rdata;

  end process;


  regs : process(clk)
  begin
    if rising_edge(clk) then
      r <= rin;
    end if;
  end process;

end;
