library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoriaROM is
   generic (
          dataWidth: natural := 16;
          addrWidth: natural := 9
    );
   port (
          Endereco : in std_logic_vector (addrWidth-1 DOWNTO 0);
          Dado : out std_logic_vector (dataWidth-1 DOWNTO 0)
    );
end entity;

architecture assincrona of memoriaROM is

  constant NOP  : std_logic_vector(3 downto 0) := "0000";
  constant LDA  : std_logic_vector(3 downto 0) := "0001";
  constant SOMA : std_logic_vector(3 downto 0) := "0010";
  constant SUB  : std_logic_vector(3 downto 0) := "0011";
  constant LDI  : std_logic_vector(3 downto 0) := "0100";
  constant STA  : std_logic_vector(3 downto 0) := "0101";
  constant JMP  : std_logic_vector(3 downto 0) := "0110";
  constant JEQ : std_logic_vector(3 downto 0) := "0111";
  constant CEQ : std_logic_vector(3 downto 0) := "1000";
  constant JSR : std_logic_vector(3 downto 0) := "1001";
  constant RET : std_logic_vector(3 downto 0) := "1010";
  constant ANDI : std_logic_vector(3 downto 0) := "1100";
  
  -- 8 registradores
	constant R0 : std_logic_vector(2 downto 0) := "000";
	constant R1 : std_logic_vector(2 downto 0) := "001";
	constant R2 : std_logic_vector(2 downto 0) := "010";
	constant R3 : std_logic_vector(2 downto 0) := "011";
	constant R4 : std_logic_vector(2 downto 0) := "100";
	constant R5 : std_logic_vector(2 downto 0) := "101";
	constant R6 : std_logic_vector(2 downto 0) := "110";
	constant R7 : std_logic_vector(2 downto 0) := "111";
  
  type blocoMemoria is array(0 TO 2**addrWidth - 1) of std_logic_vector(dataWidth-1 DOWNTO 0);

  function initMemory
        return blocoMemoria is variable tmp : blocoMemoria := (others => (others => '0'));
  begin	
--  INICIALIZAÇÃO DO COMPUTADOR

--  Zerando os displays de sete segmentos
tmp(0) := LDI  & R0 &  '0'  &  x"00";   -- LDI $0       --  Carrega o acumulador com o valor 0
tmp(1) := STA  & R0 &  '1'  &  x"20";   -- STA @288     --  Armazena o valor do acumulador em HEX0
tmp(2) := STA  & R0 &  '1'  &  x"21";   -- STA @289     --  Armazena o valor do acumulador em HEX1
tmp(3) := STA  & R0 &  '1'  &  x"22";   -- STA @290     --  Armazena o valor do acumulador em HEX2
tmp(4) := STA  & R0 &  '1'  &  x"23";   -- STA @291     --  Armazena o valor do acumulador em HEX3
tmp(5) := STA  & R0 &  '1'  &  x"24";   -- STA @292     --  Armazena o valor do acumulador em HEX4
tmp(6) := STA  & R0 &  '1'  &  x"25";   -- STA @293     --  Armazena o valor do acumulador em HEX5

--  Apagando os LEDs
tmp(7)  := LDI  & R0 &  '0'  &  x"00";  -- LDI $0       --  Carrega o acumulador com o valor 0
tmp(8)  := STA  & R0 &  '1'  &  x"00";  -- STA @256     --  Armazena o valor do bit0 do acumulador no LDR0 ~ LEDR7
tmp(9)  := STA  & R0 &  '1'  &  x"01";  -- STA @257     --  Armazena o valor do bit0 do acumulador no LDR8
tmp(10) := STA  & R0 &  '1'  &  x"02";  -- STA @258     --  Armazena o valor do bit0 do acumulador no LDR9


--  Inicializando posicao de constantes imutáveis
tmp(11) := LDI  & R0 &  '0'  &  x"00";  -- LDI $0 --  Constante 0
tmp(12) := STA  & R0 &  '0'  &  x"00";  -- STA @0
tmp(13) := LDI  & R0 &  '0'  &  x"01";  -- LDI $1 --  Constante 1
tmp(14) := STA  & R0 &  '0'  &  x"01";  -- STA @1

-- Zerando registradores
tmp(15)  := LDI & R0 & '0'  &  x"00";  -- LDI R0, $0
tmp(16)  := LDI & R1 & '0'  &  x"00";  -- LDI R1, $0
tmp(17)  := LDI & R2 & '0'  &  x"00";  -- LDI R2, $0
tmp(18)  := LDI & R3 & '0'  &  x"00";  -- LDI R3, $0
tmp(19)  := LDI & R4 & '0'  &  x"00";  -- LDI R4, $0
tmp(20)  := LDI & R5 & '0'  &  x"00";  -- LDI R5, $0
tmp(21)  := LDI & R6 & '0'  &  x"00";  -- LDI R6, $0
tmp(22)  := LDI & R7 & '0'  &  x"00";  -- LDI R7, $0

tmp(23)  := NOP    & R0 & '0' &  x"00";  -- NOP
tmp(24)  := LDA    & R0 & '1' &  x"60";  -- LDA R0, @352  R0 = leitura_segundo
tmp(25)  := ANDI & R0 & '0' &  x"01";  -- LIMPA LIXO Segundo
tmp(26)  := CEQ    & R0 & '0' &  x"01";  -- CEQ R0, @1   R0 = 1 (?)
tmp(27)  := JEQ    & R0 & '0' &  x"1E";  -- JEQ @30  Pula para SUB-rotina 
tmp(28)  := NOP    & R0 & '0' &  x"00";  -- NOP
tmp(29)  := JMP    & R0 & '0' &  x"17";  -- JMP @23


tmp(30)  := STA  & R0 & '1' & x"FF"; -- Limpa flipflop Segundos
tmp(31)  := LDI  & R0 & '0' & x"00"; -- LDI R0, $0
tmp(32)  := SOMA & R1 & '0' & x"01"; -- SOMA R1, @1 Soma R1 = R1 + 1
tmp(33)  := STA  & R1 & '1' & x"20"; -- STA @288 Armazena o valor do acumulador em HEX0
tmp(34)  := JMP  & R0 & '0' & x"17"; -- JMP @23
        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;