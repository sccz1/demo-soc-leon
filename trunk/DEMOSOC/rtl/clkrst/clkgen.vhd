library IEEE;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.iface.all;
use work.config.all;
use work.tech_generic.all;

entity clkgen is
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
end;

architecture rtl of clkgen is
begin

  cgo.clklock <= '1'; cgo.pcilock <= '1';

  cp : process (clkin, pciclkin)
  begin
    clk <= clkin; clkn <= not clkin; pciclk <= pciclkin;
    if SDINVCLK then sdclk <= not clkin; else sdclk <= clkin; end if;
  end process;

end;
