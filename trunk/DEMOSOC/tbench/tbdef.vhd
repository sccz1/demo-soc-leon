-----------------------------------------------------------------------------
--  This file is a part of the LEON VHDL model
--  Copyright (C) 1999  European Space Agency (ESA)
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  See the file COPYING for the full details of the license.
-----------------------------------------------------------------------------   
-- Entity:      tbdef
-- File:        tbdef.vhd
-- Author:      Jiri Gaisler - ESA/ESTEC
-- Description: Default generic test bench
------------------------------------------------------------------------------  
-- Version control:
-- 17-09-1998:  : First implemetation
-- 26-09-1999:  : Release 1.0
------------------------------------------------------------------------------  

-- standard testbench
--library IEEE;
--use IEEE.std_logic_1164.all;
--library work;
--use work.pkg.all;

entity tbsoc is end;

architecture behav of tbsoc is 
  component tbgen
  end component; 
begin 
  tb : tbgen; 
  --process
  --begin
  --   fsdbDumpfile("../waves/soc.fsdb");
  --   fsdbDumpvars(0, "tbsoc");
  --   wait ;
  --end process;

end;
                                                                 

-- default config: 32-bit prom, 32-bit ram, EDAC, 0ws

configuration tbdef of tbsoc is
  for behav 
    for all: 
      tbgen use entity work.tbgen(behav);
    end for;
  end for;
end tbdef;

