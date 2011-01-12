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
-- Entity:      tbgen
-- File:        tbgen.vhd
-- Author:      Jiri Gaisler - ESA/ESTEC
-- Description: Generic test bench for LEON. The test bench uses generate
--		statements to build a LEON system with the desired memory
--		size and data width.
------------------------------------------------------------------------------
-- Version control:
-- 11-08-1999:  First implemetation
-- 26-09-1999:  Release 1.0
------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.config.all;
use work.iface.all;
use work.debug.all;
use STD.TEXTIO.all;

entity tbgen is
  generic (

    msg1      : string := "32 kbyte 32-bit rom, 0-ws";
    msg2      : string := "2x128 kbyte 32-bit ram, 0-ws";
    pcihost   : boolean := false;	-- be PCI host
    DISASS    : integer := 0;	-- enable disassembly to stdout
    clkperiod : integer := 20;		-- system clock period
    romfile   : string := "../../tbench/rom.dat";  -- rom contents
    ramfile   : string := "../../tbench/ram.dat";  -- ram contents
    sdramfile : string := "../../tbench/sdram.rec";  -- sdram contents
    romdepth  : integer := 13;		-- rom address depth
    romtacc   : integer := 10;		-- rom access time (ns)
    ramdepth  : integer := 15;		-- ram address depth
    rambanks  : integer := 2;		-- number of ram banks
    bytewrite : boolean := true;	-- individual byte write strobes
    ramtacc   : integer := 10;		-- ram access time (ns)
    sd64      : boolean := false	-- 64-bit sdram bus
  );
end; 

architecture behav of tbgen is

component demo_soc
  port (
    resetn   : in    std_logic; 			-- system signals
    clk      : in    std_logic;
    --pllref   : in    std_logic;
    --plllock  : out   std_logic;

    errorn   : out   std_logic;
    address  : out   std_logic_vector(27 downto 0); 	-- memory bus

    data     : inout std_logic_vector(31 downto 0);

    ramsn    : out   std_logic_vector(4 downto 0);
    ramoen   : out   std_logic_vector(4 downto 0);
    ramwen   : inout std_logic_vector(3 downto 0);
    romsn    : out   std_logic_vector(1 downto 0);
    iosn     : out   std_logic;
    oen      : out   std_logic;
    read     : out   std_logic;
    writen   : inout std_logic;

    brdyn    : in    std_logic;
    bexcn    : in    std_logic;

-- sdram i/f
    sdcke    : out std_logic_vector ( 1 downto 0);  -- clk en
    sdcsn    : out std_logic_vector ( 1 downto 0);  -- chip sel
    sdwen    : out std_logic;                       -- write en
    sdrasn   : out std_logic;                       -- row addr stb
    sdcasn   : out std_logic;                       -- col addr stb
    sddqm    : out std_logic_vector ( 7 downto 0);  -- data i/o mask
    sdclk    : out std_logic;                       -- sdram clk output
    --sa       : out std_logic_vector(14 downto 0); 	-- optional sdram address
    --sd       : inout std_logic_vector(63 downto 0); 	-- optional sdram data

    gpio      : inout std_logic_vector(31 downto 0); 	-- I/O port

    ext_irq   : in std_logic_vector(3 downto 0) ;

    rxd2    	: in  std_logic;
    ctsn2   	: in  std_logic;
    rtsn2   	: out std_logic;
    txd2    	: out std_logic;

    rxd1    	: in  std_logic;
    ctsn1   	: in  std_logic;
    rtsn1   	: out std_logic;
    txd1    	: out std_logic;

    wdogn    : out   std_logic;				-- watchdog output

    dsuen    : in    std_logic;
    dsutx    : out   std_logic;
    dsurx    : in    std_logic;
    dsubre   : in    std_logic;
    dsuact   : out   std_logic;

    test     : in    std_logic;

    pci_rst_in_n   : in std_logic;		-- PCI bus
    pci_clk_in 	   : in std_logic;
    pci_gnt_in_n   : in std_logic;
    pci_idsel_in   : in std_logic;  -- ignored in host bridge core
    pci_lock_n     : inout std_logic;  -- Phoenix core: input only
    pci_ad 	   : inout std_logic_vector(31 downto 0);
    pci_cbe_n 	   : inout std_logic_vector(3 downto 0);
    pci_frame_n    : inout std_logic;
    pci_irdy_n 	   : inout std_logic;
    pci_trdy_n 	   : inout std_logic;
    pci_devsel_n   : inout std_logic;
    pci_stop_n 	   : inout std_logic;
    pci_perr_n 	   : inout std_logic;
    pci_par 	   : inout std_logic;    
    pci_req_n 	   : inout std_logic;  -- tristate pad but never read
    pci_serr_n     : inout std_logic;  -- open drain output
    pci_host   	   : in std_logic;
    --pci_66	   : in std_logic;

    pci_arb_req_n  : in  std_logic_vector(0 to 3);
    pci_arb_gnt_n  : out std_logic_vector(0 to 3);

    --power_state    : out std_logic_vector(1 downto 0);
    --pme_enable     : out std_logic;
    --pme_clear      : out std_logic;
    --pme_status     : in  std_logic;

-- ethernet
    emdio     : inout std_logic;
    etx_clk : in std_logic;
    erx_clk : in std_logic;
    erxd    : in std_logic_vector(3 downto 0);   
    erx_dv  : in std_logic; 
    erx_er  : in std_logic; 
    erx_col : in std_logic;
    erx_crs : in std_logic;

    etxd : out std_logic_vector(3 downto 0);   
    etx_en : out std_logic; 
    etx_er : out std_logic; 
    emdc : out std_logic;    

    emddis : out std_logic;    
    epwrdwn : out std_logic;
    ereset : out std_logic;
    esleep : out std_logic;
    epause : out std_logic
  );
end component;


component iram
      generic (index : integer := 0;		-- Byte lane (0 - 3)
	       Abits: Positive := 10;		-- Default 10 address bits (1 Kbyte)
	       echk : integer := 0;		-- Generate EDAC checksum
	       tacc : integer := 10;		-- access time (ns)
	       fname : string := "../../tbench/ram.dat");	-- File to read from
      port (  
	A : in std_logic_vector;
        D : inout std_logic_vector(7 downto 0);
        CE1 : in std_logic;
        WE : in std_logic;
        OE : in std_logic

); end component;

component testmod
  port (
	clk   	: in   	 std_logic;
	dsurx 	: in   	 std_logic;
	dsutx  	: out    std_logic;
	error	: in   	 std_logic;
	iosn 	: in   	 std_logic;
	oen  	: in   	 std_logic;
	read 	: in   	 std_logic;
	writen	: in   	 std_logic;
	brdyn  	: out    std_logic;
	bexcn  	: out    std_logic;
	address : in     std_logic_vector(7 downto 0);
	data	: inout  std_logic_vector(31 downto 0);
	ioport  : out     std_logic_vector(15 downto 0)
	);
end component;

component mt48lc16m16a2
   generic (index : integer := 0;		-- Byte lane (0 - 3)
	    fname : string := "../../tbench/sdram.rec");	-- File to read from
    PORT (
        Dq    : INOUT STD_LOGIC_VECTOR (15 DOWNTO 0);
        Addr  : IN    STD_LOGIC_VECTOR (12 DOWNTO 0);
        Ba    : IN    STD_LOGIC_VECTOR (1 downto 0);
        Clk   : IN    STD_LOGIC;
        Cke   : IN    STD_LOGIC;
        Cs_n  : IN    STD_LOGIC;
        Ras_n : IN    STD_LOGIC;
        Cas_n : IN    STD_LOGIC;
        We_n  : IN    STD_LOGIC;
        Dqm   : IN    STD_LOGIC_VECTOR (1 DOWNTO 0)
    );
END component;

  function to_xlhz(i : std_logic) return std_logic is
  begin
    case to_X01Z(i) is
    when 'Z' => return('Z');
    when '0' => return('L');
    when '1' => return('H');
    when others => return('X');
    end case;
  end;

TYPE logic_xlhz_table IS ARRAY (std_logic'LOW TO std_logic'HIGH) OF std_logic;

CONSTANT cvt_to_xlhz : logic_xlhz_table := (
                         'Z',  -- 'U'
                         'Z',  -- 'X'
                         'L',  -- '0'
                         'H',  -- '1'
                         'Z',  -- 'Z'
                         'Z',  -- 'W'
                         'Z',  -- 'L'
                         'Z',  -- 'H'
                         'Z'   -- '-'
                        );
function buskeep (v : in std_logic_vector) return std_logic_vector is
variable res : std_logic_vector(v'range);
begin
  for i in v'range loop res(i) := cvt_to_xlhz(v(i)); end loop;
  return(res);
end;


signal clk : std_logic := '0';
signal Rst    : std_logic := '0';			-- Reset
constant ct : integer := clkperiod/2;

signal address  : std_logic_vector(27 downto 0);
signal data     : std_logic_vector(31 downto 0);
signal sa       : std_logic_vector(14 downto 0);
signal sd       : std_logic_vector(63 downto 0);

signal ramsn    : std_logic_vector(4 downto 0);
signal ramoen   : std_logic_vector(4 downto 0);
signal ramwen   : std_logic_vector(3 downto 0);
signal rwenx    : std_logic_vector(3 downto 0);
signal romsn    : std_logic_vector(1 downto 0);
signal iosn     : std_logic;
signal oen      : std_logic;
signal read     : std_logic;
signal writen   : std_logic;
signal lbrdyn    : std_logic;
signal brdyn    : std_logic;
signal bexcn    : std_logic;
signal wdog     : std_logic;
signal dsuen, dsutx, dsurx, dsubre, dsuact : std_logic;
signal test     : std_logic;
signal error    : std_logic;
signal GND      : std_logic := '0';
signal VCC      : std_logic := '1';
signal NC       : std_logic := 'Z';
signal clk2     : std_logic := '1';

signal gpio     :  std_logic_vector(31 downto 0); 	-- I/O port
signal ext_irq  :  std_logic_vector(3 downto 0) ;
signal rxd2    	:  std_logic;
signal ctsn2   	:  std_logic;
signal rtsn2   	:  std_logic;
signal txd2    	:  std_logic;

signal rxd1    	:  std_logic;
signal ctsn1   	:  std_logic;
signal rtsn1   	:  std_logic;
signal txd1    	:  std_logic;
 
signal pci_rst_n   : std_logic := '0';
signal pci_clk	   : std_logic := '0';
signal pci_gnt_in_n: std_logic := '0';
signal pci_ad 	   : std_logic_vector(31 downto 0);
signal pci_cbe_n   : std_logic_vector(3 downto 0);
signal pci_frame_n : std_logic;
signal pci_irdy_n  : std_logic;
signal pci_trdy_n  : std_logic;
signal pci_devsel_n: std_logic;
signal pci_stop_n  : std_logic;
signal pci_perr_n  : std_logic;
signal pci_par 	   : std_logic;    
signal pci_req_n   : std_logic;
signal pci_serr_n  : std_logic;
signal pci_idsel_in: std_logic;
signal pci_lock_n  : std_logic;
signal pci_host    : std_logic;
signal pci_arb_req_n   : std_logic_vector(0 to 3);
signal pci_arb_gnt_n   : std_logic_vector(0 to 3);
signal power_state : std_logic_vector(1 downto 0);
signal pci_66      : std_logic;
signal pme_enable  : std_logic;
signal pme_clear   : std_logic;
signal pme_status  : std_logic;

signal sdcke    : std_logic_vector ( 1 downto 0);  -- clk en
signal sdcsn    : std_logic_vector ( 1 downto 0);  -- chip sel
signal sdwen    : std_logic;                       -- write en
signal sdrasn   : std_logic;                       -- row addr stb
signal sdcasn   : std_logic;                       -- col addr stb
signal sddqm    : std_logic_vector ( 7 downto 0);  -- data i/o mask
signal sdclk    : std_logic;       
signal plllock    : std_logic;       

signal emdio   : std_logic;
signal etx_clk : std_logic := '0';
signal erx_clk : std_logic := '0';
signal erxd    : std_logic_vector(3 downto 0);   
signal erx_dv  : std_logic; 
signal erx_er  : std_logic; 
signal erx_col : std_logic;
signal erx_crs : std_logic;
signal etxd    : std_logic_vector(3 downto 0);   
signal etx_en  : std_logic; 
signal etx_er  : std_logic; 
signal emdc    : std_logic;    
signal emddis  : std_logic;    
signal epwrdwn : std_logic;
signal ereset  : std_logic;
signal esleep  : std_logic;
signal epause  : std_logic;

begin

-- clock and reset

  clk <= not clk after ct * 1 ns;
  rst <= '0', '1' after clkperiod*10 * 1 ns;
  dsuen <= '1'; dsubre <= '0';

  etx_clk <= not etx_clk after 25 ns when ETHEN else '0';
  erx_clk <= not etx_clk after 25 ns when ETHEN else '0';
  emdio <= 'H'; erxd <= "0011"; erx_dv <= '0'; erx_er <= '0';
  erx_col <= '0';  erx_crs <= '0'; 

  pci_clk <= not pci_clk after 15 ns when PCIEN else '0';
  pci_rst_n <= '0', '1' after clkperiod*10 * 1 ns;
  pci_frame_n      <= 'H';
  pci_ad           <= (others => 'H');
  pci_cbe_n        <= (others => 'H');
  pci_par          <= 'H';
  pci_req_n        <= 'H';
  pci_idsel_in     <= 'H';
  pci_lock_n       <= 'H';
  pci_irdy_n       <= 'H';
  pci_trdy_n       <= 'H';
  pci_devsel_n     <= 'H';
  pci_stop_n       <= 'H';
  pci_perr_n       <= 'H';
  pci_serr_n   <= 'H';
  pci_host <= '1' when pcihost else '0';


-- soc (processor, PCI, ethernet)
      soc0: demo_soc port map (rst, clk, --sdclk, plllock, 

		error, address, data, 

	ramsn, ramoen, rwenx, romsn, iosn, oen, read, writen, brdyn, 
	bexcn, sdcke, sdcsn, sdwen, sdrasn, sdcasn, sddqm, sdclk, --sa, sd,
	gpio, ext_irq , rxd2, ctsn2, rtsn2, txd2 , rxd1 , ctsn1, rtsn1, txd1 , 
  wdog, dsuen, dsutx, dsurx, dsubre, dsuact, test, 
        pci_rst_n, pci_clk, pci_gnt_in_n, pci_idsel_in, pci_lock_n, 
        pci_ad, pci_cbe_n, pci_frame_n, pci_irdy_n,
	pci_trdy_n, pci_devsel_n, pci_stop_n, pci_perr_n, pci_par,
	pci_req_n, pci_serr_n, pci_host, --pci_66, 
  pci_arb_req_n, pci_arb_gnt_n, --power_state, pme_enable, pme_clear, pme_status,
        emdio, etx_clk, erx_clk, erxd, erx_dv, erx_er, erx_col, erx_crs,
        etxd, etx_en, etx_er, emdc,
        emddis, epwrdwn, ereset, esleep, epause);

-- write strobes

  ramwen <= rwenx when bytewrite else (rwenx(0) & rwenx(0) & rwenx(0) & rwenx(0));

-- 32-bit rom 

    data(31 downto 0) <= "00000001001000110100010101100111" when (romsn(1) or not writen) = '0' else (others => 'Z');

    romarr : for i in 0 to 3 generate
      rom0 : iram 
	    generic map (index => i, abits => romdepth, echk => 0, tacc => romtacc,fname => romfile)
      port map (A => address(romdepth+1 downto 2), D => data((31 - i*8) downto (24-i*8)), CE1 => romsn(0),WE => VCC, OE => oen);
    end generate;

-- 32-bit ram

    rambnk : for i in 0 to rambanks-1 generate
      ramarr : for j in 0 to 3 generate
        ram0 : iram 
	      generic map (index => j, abits => ramdepth, echk => 0, tacc => ramtacc, fname => ramfile)
        port map (A => address(ramdepth+1 downto 2), D => data((31 - j*8) downto (24-j*8)), CE1 => ramsn(i), WE => ramwen(j), OE => ramoen(i));
      end generate;
    end generate;

-- boot message

--    bootmsg : process(rst)
    bootmsg :  process
    begin
--      if rst'event and (rst = '1') then --'
        print("LEON-2 generic testbench (leon2-"& LEON_VERSION & ")");
        print("Bug reports to Jiri Gaisler, jiri@gaisler.com");
	print("");
        print("Testbench configuration:");
        print(msg1); print(msg2); print("");
--      end if;
      wait;
    end process;

-- optional sdram

  sdram : if SDRAMEN generate
    sb : if SDSEPBUS generate
      u0: mt48lc16m16a2 generic map (index => 0, fname => sdramfile)
	PORT MAP(
            Dq => sd(31 downto 16), Addr => sa(12 downto 0),
            Ba => sa(14 downto 13), Clk => sdclk, Cke => sdcke(0),
            Cs_n => sdcsn(0), Ras_n => sdrasn, Cas_n => sdcasn, We_n => sdwen,
            Dqm => sddqm(3 downto 2));
      u1: mt48lc16m16a2 generic map (index => 16, fname => sdramfile)
	PORT MAP(
            Dq => sd(15 downto 0), Addr => sa(12 downto 0),
            Ba => sa(14 downto 13), Clk => sdclk, Cke => sdcke(0),
            Cs_n => sdcsn(0), Ras_n => sdrasn, Cas_n => sdcasn, We_n => sdwen,
            Dqm => sddqm(1 downto 0));
      u2: mt48lc16m16a2 generic map (index => 0, fname => sdramfile)
	PORT MAP(
            Dq => sd(31 downto 16), Addr => sa(12 downto 0),
            Ba => sa(14 downto 13), Clk => sdclk, Cke => sdcke(0),
            Cs_n => sdcsn(1), Ras_n => sdrasn, Cas_n => sdcasn, We_n => sdwen,
            Dqm => sddqm(3 downto 2));
      u3: mt48lc16m16a2 generic map (index => 16, fname => sdramfile)
	PORT MAP(
            Dq => sd(15 downto 0), Addr => sa(12 downto 0),
            Ba => sa(14 downto 13), Clk => sdclk, Cke => sdcke(0),
            Cs_n => sdcsn(1), Ras_n => sdrasn, Cas_n => sdcasn, We_n => sdwen,
            Dqm => sddqm(1 downto 0));
    end generate;
    sb64 : if SDSEPBUS and BUS64 generate
      u0: mt48lc16m16a2 generic map (index => 0, fname => sdramfile)
	PORT MAP(
            Dq => sd(63 downto 48), Addr => sa(12 downto 0),
            Ba => sa(14 downto 13), Clk => sdclk, Cke => sdcke(0),
            Cs_n => sdcsn(0), Ras_n => sdrasn, Cas_n => sdcasn, We_n => sdwen,
            Dqm => sddqm(7 downto 6));
      u1: mt48lc16m16a2 generic map (index => 16, fname => sdramfile)
	PORT MAP(
            Dq => sd(47 downto 32), Addr => sa(12 downto 0),
            Ba => sa(14 downto 13), Clk => sdclk, Cke => sdcke(0),
            Cs_n => sdcsn(0), Ras_n => sdrasn, Cas_n => sdcasn, We_n => sdwen,
            Dqm => sddqm(5 downto 4));
      u2: mt48lc16m16a2 generic map (index => 0, fname => sdramfile)
	PORT MAP(
            Dq => sd(63 downto 48), Addr => sa(12 downto 0),
            Ba => sa(14 downto 13), Clk => sdclk, Cke => sdcke(0),
            Cs_n => sdcsn(1), Ras_n => sdrasn, Cas_n => sdcasn, We_n => sdwen,
            Dqm => sddqm(7 downto 6));
      u3: mt48lc16m16a2 generic map (index => 16, fname => sdramfile)
	PORT MAP(
            Dq => sd(47 downto 32), Addr => sa(12 downto 0),
            Ba => sa(14 downto 13), Clk => sdclk, Cke => sdcke(0),
            Cs_n => sdcsn(1), Ras_n => sdrasn, Cas_n => sdcasn, We_n => sdwen,
            Dqm => sddqm(5 downto 4));
    end generate;
    nsb : if not SDSEPBUS generate
      u0: mt48lc16m16a2 generic map (index => 0, fname => sdramfile)
	PORT MAP(
            Dq => data(31 downto 16), Addr => address(14 downto 2),
            Ba => address(16 downto 15), Clk => sdclk, Cke => sdcke(0),
            Cs_n => sdcsn(0), Ras_n => sdrasn, Cas_n => sdcasn, We_n => sdwen,
            Dqm => sddqm(3 downto 2));
      u1: mt48lc16m16a2 generic map (index => 16, fname => sdramfile)
	PORT MAP(
            Dq => data(15 downto 0), Addr => address(14 downto 2),
            Ba => address(16 downto 15), Clk => sdclk, Cke => sdcke(0),
            Cs_n => sdcsn(0), Ras_n => sdrasn, Cas_n => sdcasn, We_n => sdwen,
            Dqm => sddqm(1 downto 0));
      u2: mt48lc16m16a2 generic map (index => 0, fname => sdramfile)
	PORT MAP(
            Dq => data(31 downto 16), Addr => address(14 downto 2),
            Ba => address(16 downto 15), Clk => sdclk, Cke => sdcke(0),
            Cs_n => sdcsn(1), Ras_n => sdrasn, Cas_n => sdcasn, We_n => sdwen,
            Dqm => sddqm(3 downto 2));
      u3: mt48lc16m16a2 generic map (index => 16, fname => sdramfile)
	PORT MAP(
            Dq => data(15 downto 0), Addr => address(14 downto 2),
            Ba => address(16 downto 15), Clk => sdclk, Cke => sdcke(0),
            Cs_n => sdcsn(1), Ras_n => sdrasn, Cas_n => sdcasn, We_n => sdwen,
            Dqm => sddqm(1 downto 0));

    end generate;
  end generate;

-- test module

--  testmod0 : testmod port map (clk, dsutx, dsurx, error, iosn, oen, read, 
--		writen, lbrdyn, bexcn, address(7 downto 0), data , gpio);

  test <= '1' when DISASS > 0 else '0';

  brdyn <= lbrdyn when ramsn(4) = '1' else 
	'0' after 100 ns when brdyn = '1' else
	'1' after 30 ns;

-- cross-strap UARTs
  rxd1  <= txd2  ; -- RX1 <- TX2
  rxd2  <= txd1  ; -- RX2 <- TX1
  ctsn1 <= rtsn2 ; -- CTS1 <- RTS2
  ctsn2 <= rtsn1 ; -- CTS2 <- RTS1

  wdog <= 'H';			  -- WDOG pull-up
  error <= 'H';			  -- ERROR pull-up
  data <= (others => 'H');

  bk : process(data)
  begin data <= buskeep(data) after 5 ns; end process;


end ;

