------------------------------------------------------------------
-- component declarations from true tech library
------------------------------------------------------------------
LIBRARY ieee;
use IEEE.std_logic_1164.all;

package tech_asic_syn is

-- Sync single-port RAM cells for instr/data cache & scratch-pad RAM
component ram16384x32
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(13 downto 0);
   D: in std_logic_vector(31 downto 0);
   Q: out std_logic_vector(31 downto 0)
   );
end component; 

component ram8192x32
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(12 downto 0);
   D: in std_logic_vector(31 downto 0);
   Q: out std_logic_vector(31 downto 0)
   );
end component; 

component ram4096x32
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic_vector(3 downto 0);
   A: in std_logic_vector(11 downto 0);
   D: in std_logic_vector(31 downto 0);
   Q: out std_logic_vector(31 downto 0)
   );
end component; 

component ram2400x32
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(11 downto 0);
   D: in std_logic_vector(31 downto 0);
   Q: out std_logic_vector(31 downto 0)
   );
end component; 
   
component ram2048x32
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic_vector(3 downto 0);
   A: in std_logic_vector(10 downto 0);
   D: in std_logic_vector(31 downto 0);
   Q: out std_logic_vector(31 downto 0)
   );
end component; 

component ram1024x32
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic_vector(3 downto 0);
   A: in std_logic_vector(9 downto 0);
   D: in std_logic_vector(31 downto 0);
   Q: out std_logic_vector(31 downto 0)
   );
end component; 

component ram512x32
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(8 downto 0);
   D: in std_logic_vector(31 downto 0);
   Q: out std_logic_vector(31 downto 0)
   );
end component; 

component ram256x32
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(7 downto 0);
   D: in std_logic_vector(31 downto 0);
   Q: out std_logic_vector(31 downto 0)
   );
end component; 

component ram128x32
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(6 downto 0);
   D: in std_logic_vector(31 downto 0);
   Q: out std_logic_vector(31 downto 0)
   );
end component; 

component ram64x32
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(5 downto 0);
   D: in std_logic_vector(31 downto 0);
   Q: out std_logic_vector(31 downto 0)
   );
end component; 

component ram32x32
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(4 downto 0);
   D: in std_logic_vector(31 downto 0);
   Q: out std_logic_vector(31 downto 0)
   );
end component; 

component ram64x31
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(5 downto 0);
   D: in std_logic_vector(30 downto 0);
   Q: out std_logic_vector(30 downto 0)
   );
end component; 

component ram32x31
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(4 downto 0);
   D: in std_logic_vector(30 downto 0);
   Q: out std_logic_vector(30 downto 0)
   );
end component; 

component ram128x30
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(6 downto 0);
   D: in std_logic_vector(29 downto 0);
   Q: out std_logic_vector(29 downto 0)
   );
end component; 

component ram64x30
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(5 downto 0);
   D: in std_logic_vector(29 downto 0);
   Q: out std_logic_vector(29 downto 0)
   );
end component; 

component ram32x30
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(4 downto 0);
   D: in std_logic_vector(29 downto 0);
   Q: out std_logic_vector(29 downto 0)
   );
end component; 

component ram256x29
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(7 downto 0);
   D: in std_logic_vector(28 downto 0);
   Q: out std_logic_vector(28 downto 0)
   );
end component; 

component ram128x29
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(6 downto 0);
   D: in std_logic_vector(28 downto 0);
   Q: out std_logic_vector(28 downto 0)
   );
end component; 

component ram64x29
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(5 downto 0);
   D: in std_logic_vector(28 downto 0);
   Q: out std_logic_vector(28 downto 0)
   );
end component; 

component ram512x28
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(8 downto 0);
   D: in std_logic_vector(27 downto 0);
   Q: out std_logic_vector(27 downto 0)
   );
end component; 

component ram256x28
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(7 downto 0);
   D: in std_logic_vector(27 downto 0);
   Q: out std_logic_vector(27 downto 0)
   );
end component; 

component ram128x28
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(6 downto 0);
   D: in std_logic_vector(27 downto 0);
   Q: out std_logic_vector(27 downto 0)
   );
end component; 

component ram64x28
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(5 downto 0);
   D: in std_logic_vector(27 downto 0);
   Q: out std_logic_vector(27 downto 0)
   );
end component; 

component ram1024x27
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(9 downto 0);
   D: in std_logic_vector(26 downto 0);
   Q: out std_logic_vector(26 downto 0)
   );
end component; 

component ram512x27
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(8 downto 0);
   D: in std_logic_vector(26 downto 0);
   Q: out std_logic_vector(26 downto 0)
   );
end component; 

component ram256x27
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(7 downto 0);
   D: in std_logic_vector(26 downto 0);
   Q: out std_logic_vector(26 downto 0)
   );
end component; 

component ram128x27
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(6 downto 0);
   D: in std_logic_vector(26 downto 0);
   Q: out std_logic_vector(26 downto 0)
   );
end component; 

component ram64x27
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(5 downto 0);
   D: in std_logic_vector(26 downto 0);
   Q: out std_logic_vector(26 downto 0)
   );
end component; 

component ram2048x26
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(10 downto 0);
   D: in std_logic_vector(25 downto 0);
   Q: out std_logic_vector(25 downto 0)
   );
end component; 

component ram1024x26
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(9 downto 0);
   D: in std_logic_vector(25 downto 0);
   Q: out std_logic_vector(25 downto 0)
   );
end component; 

component ram512x26
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(8 downto 0);
   D: in std_logic_vector(25 downto 0);
   Q: out std_logic_vector(25 downto 0)
   );
end component; 

component ram256x26
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(7 downto 0);
   D: in std_logic_vector(25 downto 0);
   Q: out std_logic_vector(25 downto 0)
   );
end component; 

component ram128x26
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(6 downto 0);
   D: in std_logic_vector(25 downto 0);
   Q: out std_logic_vector(25 downto 0)
   );
end component; 

component ram64x26
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(5 downto 0);
   D: in std_logic_vector(25 downto 0);
   Q: out std_logic_vector(25 downto 0)
   );
end component; 

component ram2048x25
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(10 downto 0);
   D: in std_logic_vector(24 downto 0);
   Q: out std_logic_vector(24 downto 0)
   );
end component; 

component ram1024x25
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(9 downto 0);
   D: in std_logic_vector(24 downto 0);
   Q: out std_logic_vector(24 downto 0)
   );
end component; 

component ram512x25
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(8 downto 0);
   D: in std_logic_vector(24 downto 0);
   Q: out std_logic_vector(24 downto 0)
   );
end component; 

component ram256x25
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(7 downto 0);
   D: in std_logic_vector(24 downto 0);
   Q: out std_logic_vector(24 downto 0)
   );
end component; 

component ram128x25
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(6 downto 0);
   D: in std_logic_vector(24 downto 0);
   Q: out std_logic_vector(24 downto 0)
   );
end component; 

component ram2048x24
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(10 downto 0);
   D: in std_logic_vector(23 downto 0);
   Q: out std_logic_vector(23 downto 0)
   );
end component; 

component ram1024x24
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(9 downto 0);
   D: in std_logic_vector(23 downto 0);
   Q: out std_logic_vector(23 downto 0)
   );
end component; 

component ram512x24
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(8 downto 0);
   D: in std_logic_vector(23 downto 0);
   Q: out std_logic_vector(23 downto 0)
   );
end component; 

component ram256x24
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(7 downto 0);
   D: in std_logic_vector(23 downto 0);
   Q: out std_logic_vector(23 downto 0)
   );
end component; 

component ram2048x23
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(10 downto 0);
   D: in std_logic_vector(22 downto 0);
   Q: out std_logic_vector(22 downto 0)
   );
end component; 

component ram1024x23
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(9 downto 0);
   D: in std_logic_vector(22 downto 0);
   Q: out std_logic_vector(22 downto 0)
   );
end component; 

component ram512x23
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(8 downto 0);
   D: in std_logic_vector(22 downto 0);
   Q: out std_logic_vector(22 downto 0)
   );
end component; 

component ram4096x22
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(11 downto 0);
   D: in std_logic_vector(21 downto 0);
   Q: out std_logic_vector(21 downto 0)
   );
end component; 

component ram2048x22
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(10 downto 0);
   D: in std_logic_vector(21 downto 0);
   Q: out std_logic_vector(21 downto 0)
   );
end component; 

component ram1024x22
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(9 downto 0);
   D: in std_logic_vector(21 downto 0);
   Q: out std_logic_vector(21 downto 0)
   );
end component; 

component ram4096x21
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(11 downto 0);
   D: in std_logic_vector(20 downto 0);
   Q: out std_logic_vector(20 downto 0)
   );
end component; 

component ram2048x21
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(10 downto 0);
   D: in std_logic_vector(20 downto 0);
   Q: out std_logic_vector(20 downto 0)
   );
end component; 

component ram4096x20
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(11 downto 0);
   D: in std_logic_vector(19 downto 0);
   Q: out std_logic_vector(19 downto 0)
   );
end component; 







-- Sync dpram cell for regfile iu & cp
component dpram16x32
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
end component; 

component dpram136x32
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
end component; 

component dpram168x32
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
end component; 

-- Sync dpram cells for tags when snooping is enabled or DSU trace buffer
component dpram2048x32
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
end component; 

component dpram1024x32
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
end component; 

component dpram512x32
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
end component; 

component dpram256x32
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
end component; 

component dpram128x32
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
end component; 

component dpram64x32
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
end component; 

component dpram32x32
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
end component; 

component dpram64x31
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
end component; 

component dpram32x31
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
end component; 

component dpram128x30
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
end component; 

component dpram64x30
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
end component; 

component dpram32x30
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
end component; 

component dpram256x29
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
end component; 

component dpram128x29
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
end component; 

component dpram64x29
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
end component; 

component dpram512x28
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
end component; 

component dpram256x28
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
end component; 

component dpram128x28
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
end component; 

component dpram64x28
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
end component; 

component dpram1024x27
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
end component; 

component dpram512x27
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
end component; 

component dpram256x27
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
end component; 

component dpram128x27
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
end component; 

component dpram64x27
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
end component; 

component dpram2048x26
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
end component; 

component dpram1024x26
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
end component; 

component dpram512x26
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
end component; 

component dpram256x26
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
end component; 

component dpram128x26
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
end component; 

component dpram64x26
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
end component; 

component dpram2048x25
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
end component; 

component dpram1024x25
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
end component; 

component dpram512x25
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
end component; 

component dpram256x25
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
end component; 

component dpram128x25
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
end component; 

component dpram2048x24
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
end component; 

component dpram1024x24
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
end component; 

component dpram512x24
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
end component; 

component dpram256x24
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
end component; 

component dpram2048x23
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
end component; 

component dpram1024x23
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
end component; 

component dpram512x23
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
end component; 

component dpram4096x22
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
end component; 

component dpram2048x22
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
end component; 

component dpram1024x22
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
end component; 

component dpram4096x21
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
end component; 

component dpram2048x21
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
end component; 

component dpram4096x20
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
end component; 


-- Tie high/low cells

component TIEHI
   port(
   Y : out std_logic
   );
end component; 

component TIELO
   port(
   Y : out std_logic
   );
end component; 

-- high drive clock input pad 5V tolerant
component PDCH0DGZ  port (CLK : in std_logic; CP : out std_logic); end component; 
component PDCH1DGZ  port (CLK : in std_logic; CP : out std_logic); end component; 
component PDCH2DGZ  port (CLK : in std_logic; CP : out std_logic); end component; 
component PDCH3DGZ  port (CLK : in std_logic; CP : out std_logic); end component; 

-- input pad 5V tolerant
component PDIDGZ  port (PAD : in std_logic; C : out std_logic); end component; 

-- schmitt trigger input pad 5V tolerant
component PDISDGZ port (PAD : in std_logic; C : out std_logic); end component; 

-- CMOS 3-state output pads 5V tolerant (2,4,8,12,16,24 mA)
component PDT02DGZ port (I  : in std_logic; PAD : out  std_logic;
                            OEN: in std_logic); end component; 
component PDT04DGZ port (I  : in std_logic; PAD : out  std_logic;
                            OEN: in std_logic); end component; 
component PDT08DGZ port (I  : in std_logic; PAD : out  std_logic;
                            OEN: in std_logic); end component; 
component PDT12DGZ port (I  : in std_logic; PAD : out  std_logic;
                            OEN: in std_logic); end component; 
component PDT16DGZ port (I  : in std_logic; PAD : out  std_logic;
                            OEN: in std_logic); end component; 
component PDT24DGZ port (I  : in std_logic; PAD : out  std_logic;
                            OEN: in std_logic); end component; 

-- CMOS 3-state Output pad with input and Pullup 5V tolerant
component PDU02DGZ port (I  : in std_logic; PAD : inout std_logic;
                            OEN: in std_logic; C   : out std_logic); end component; 
component PDU04DGZ port (I  : in std_logic; PAD : inout  std_logic;
                            OEN: in std_logic; C   : out std_logic); end component; 
component PDU08DGZ port (I  : in std_logic; PAD : inout  std_logic;
                            OEN: in std_logic; C   : out std_logic); end component; 
component PDU12DGZ port (I  : in std_logic; PAD : inout  std_logic;
                            OEN: in std_logic; C   : out std_logic); end component; 
component PDU16DGZ port (I  : in std_logic; PAD : inout  std_logic;
                            OEN: in std_logic; C   : out std_logic); end component; 
component PDU24DGZ port (I  : in std_logic; PAD : inout  std_logic;
                            OEN: in std_logic; C   : out std_logic); end component; 

-- CMOS 3-state Output pad with input 5V tolerant
component PDB02DGZ port (I  : in std_logic; PAD : inout  std_logic;
                            OEN: in std_logic; C : out std_logic); end component; 
component PDB04DGZ port (I  : in std_logic; PAD : inout  std_logic;
                            OEN: in std_logic; C : out std_logic); end component; 
component PDB08DGZ port (I  : in std_logic; PAD : inout  std_logic;
                            OEN: in std_logic; C : out std_logic); end component; 
component PDB12DGZ port (I  : in std_logic; PAD : inout  std_logic;
                            OEN: in std_logic; C : out std_logic); end component; 
component PDB16DGZ port (I  : in std_logic; PAD : inout  std_logic;
                            OEN: in std_logic; C : out std_logic); end component; 
component PDB24DGZ port (I  : in std_logic; PAD : inout  std_logic;
                            OEN: in std_logic; C : out std_logic); end component; 

-- CMOS 3-state Output pad with schmitt trigger input 5V tolerant
component PDB02SDGZ port (I  : in std_logic; PAD : inout  std_logic;
                             OEN: in std_logic; C : out std_logic); end component; 
component PDB04SDGZ port (I  : in std_logic; PAD : inout  std_logic;
                             OEN: in std_logic; C : out std_logic); end component; 
component PDB08SDGZ port (I  : in std_logic; PAD : inout  std_logic;
                             OEN: in std_logic; C : out std_logic); end component; 
component PDB12SDGZ port (I  : in std_logic; PAD : inout  std_logic;
                             OEN: in std_logic; C : out std_logic); end component; 
component PDB16SDGZ port (I  : in std_logic; PAD : inout  std_logic;
                             OEN: in std_logic; C : out std_logic); end component; 
component PDB24SDGZ port (I  : in std_logic; PAD : inout  std_logic;
                             OEN: in std_logic; C : out std_logic); end component; 

-- CMOS 3-state output pads with limited slew rate 5V tolerant (8,12,16,24 mA)
component PRT08DGZ port (I  : in std_logic; PAD : out  std_logic;
                            OEN: in std_logic); end component; 
component PRT12DGZ port (I  : in std_logic; PAD : out  std_logic;
                            OEN: in std_logic); end component; 
component PRT16DGZ port (I  : in std_logic; PAD : out  std_logic;
                            OEN: in std_logic); end component; 
component PRT24DGZ port (I  : in std_logic; PAD : out  std_logic;
                            OEN: in std_logic); end component; 

-- CMOS 3-state Output pad qith input and limited slew rate 5V tolerant (8,12,16,24 mA)
component PRB08DGZ port (I  : in std_logic; PAD : inout  std_logic;
                             OEN: in std_logic; C : out std_logic); end component; 
component PRB12DGZ port (I  : in std_logic; PAD : inout  std_logic;
                             OEN: in std_logic; C : out std_logic); end component; 
component PRB16DGZ port (I  : in std_logic; PAD : inout  std_logic;
                             OEN: in std_logic; C : out std_logic); end component; 
component PRB24DGZ port (I  : in std_logic; PAD : inout  std_logic;
                             OEN: in std_logic; C : out std_logic); end component; 

end;
