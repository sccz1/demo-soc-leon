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
-- File:        debug.vhd
-- Author:      Jiri Gaisler - ESA/ESTEC
-- Description: Various test bench configurations
------------------------------------------------------------------------------  
-- Version control:
-- 11-09-1998:  : First implemetation
-- 26-09-1999:  : Release 1.0
------------------------------------------------------------------------------  


-- 32-bit prom, 32-bit ram, 0ws

configuration tb_mmu_disas of tbsoc is
  for behav 
    for all: 
      tbgen use entity work.tbgen(behav) generic map ( 
        msg2 => "2x128 kbyte 32-bit ram, 2x64 Mbyte SDRAM",
 	DISASS => 1,
	ramfile => "../../tbench/mmram.dat"
      );
    end for;
  end for;
end tb_mmu_disas;

-- 32-bit prom, 32-bit ram, 0ws

configuration tb_mmu of tbsoc is
  for behav 
    for all: 
      tbgen use entity work.tbgen(behav) generic map ( 
        msg2 => "2x128 kbyte 32-bit ram, 2x64 Mbyte SDRAM",
 	DISASS => 0,
	ramfile => "../../tbench/mmram.dat"
      );
    end for;
  end for;
end tb_mmu;

-- 32-bit prom, 32-bit ram, 0ws

configuration tb_full of tbsoc is
  for behav 
    for all: 
      tbgen use entity work.tbgen(behav) generic map ( 
        msg2 => "2x128 kbyte 32-bit ram, 2x64 Mbyte SDRAM",
 	DISASS => 0,
	ramfile => "../../tbench/fram.dat"
      );
    end for;
  end for;
end tb_full;

-- 32-bit prom, 32-bit ram, 0ws

configuration tb_func32 of tbsoc is
  for behav 
    for all: 
      tbgen use entity work.tbgen(behav) generic map ( 
        msg2 => "2x128 kbyte 32-bit ram, 2x64 Mbyte SDRAM",
 	DISASS => 0
      );
    end for;
  end for;
end tb_func32;

-- 32-bit prom, 32-bit ram, 32-bit sdram, 0ws

configuration tb_func_sdram of tbsoc is
  for behav 
    for all: 
      tbgen use entity work.tbgen(behav) generic map ( 
        msg2 => "2x128 kbyte 32-bit ram, 2x64 Mbyte SDRAM",
	romfile => "../../tbench/romsd.dat",
 	DISASS => 0,
	romdepth => 14
      );
    end for;
  end for;
end tb_func_sdram;

-- 32-bit prom, 32-bit ram, 0ws,

configuration tb_mem of tbsoc is
  for behav 
    for all: 
      tbgen use entity work.tbgen(behav) generic map ( 
 	DISASS => 0,
	ramfile => "../../tbench/mram.dat"
      );
    end for;
  end for;
end tb_mem;


-- 32-bit prom, 32-bit ram, 0ws

configuration tb_full_disas of tbsoc is
  for behav 
    for all: 
      tbgen use entity work.tbgen(behav) generic map ( 
        msg2 => "2x128 kbyte 32-bit ram, 2x64 Mbyte SDRAM",
 	DISASS => 1,
	ramfile => "../../tbench/fram.dat"
      );
    end for;
  end for;
end tb_full_disas;

-- 32-bit prom, 32-bit ram, 0ws

configuration tb_func32_disas of tbsoc is
  for behav 
    for all: 
      tbgen use entity work.tbgen(behav) generic map ( 
        msg2 => "2x128 kbyte 32-bit ram, 2x64 Mbyte SDRAM",
 	DISASS => 1
      );
    end for;
  end for;
end tb_func32_disas;

-- 32-bit prom, 32-bit ram, 32-bit sdram, 0ws

configuration tb_func_sdram_disas of tbsoc is
  for behav 
    for all: 
      tbgen use entity work.tbgen(behav) generic map ( 
        msg2 => "2x128 kbyte 32-bit ram, 2x64 Mbyte SDRAM",
	romfile => "../../tbench/romsd.dat",
 	DISASS => 1,
 	clkperiod => 25,
	romdepth => 14
      );
    end for;
  end for;
end tb_func_sdram_disas;

-- 32-bit prom, 32-bit ram, 0ws,

configuration tb_mem_disas of tbsoc is
  for behav 
    for all: 
      tbgen use entity work.tbgen(behav) generic map ( 
 	DISASS => 1,
	ramfile => "../../tbench/mram.dat"
      );
    end for;
  end for;
end tb_mem_disas;



