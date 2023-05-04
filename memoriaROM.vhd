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
  constant CLT  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1011";
  constant JLT  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1110";
  
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
------------------------------------------- SETUP -----------------------------------------
-- Zera os displays de sete segmentos
tmp(0) := LDI & R0 & '0' & x"00";   -- Carrega o registrador com o valor zero 
tmp(1) := STA & R0 & '1' & x"20";   -- Armazena o valor do registrador em HEX0
tmp(2) := STA & R0 & '1' & x"21";   -- Armazena o valor do registrador em HEX1
tmp(3) := STA & R0 & '1' & x"22";   -- Armazena o valor do registrador em HEX2
tmp(4) := STA & R0 & '1' & x"23";   -- Armazena o valor do registrador em HEX3
tmp(5) := STA & R0 & '1' & x"24";   -- Armazena o valor do registrador em HEX4
tmp(6) := STA & R0 & '1' & x"25";   -- Armazena o valor do registrador em HEX5

-- Apaga os LED's
tmp(7) := LDI & R0 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(8) := STA & R0 & '1' & x"00";   -- Armazena o valor do registrador em LEDR0 - LEDR7
tmp(9) := STA & R0 & '1' & x"01";   -- Armazena o valor do registrador em LEDR8
tmp(10) := STA & R0 & '1' & x"02";   -- Armazena o valor do registrador em LEDR9

-- Inicializa constantes
tmp(11) := LDI & R0 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(12) := STA & R0 & '0' & x"00";   -- MEM[0] = R0 = 0
tmp(13) := LDI & R0 & '0' & x"01";   -- Carrega o registrador com o valor um
tmp(14) := STA & R0 & '0' & x"01";   -- MEM[1] = R0 = 1
tmp(15) := LDI & R0 & '0' & x"02";   -- Carrega o registrador com o valor dois
tmp(16) := STA & R0 & '0' & x"02";   -- MEM[2] = R0 = 2
tmp(17) := LDI & R0 & '0' & x"03";   -- Carrega o registrador com o valor tres
tmp(18) := STA & R0 & '0' & x"03";   -- MEM[3] = R0 = 3
tmp(19) := LDI & R0 & '0' & x"05";   -- Carrega o registrador com o valor cinco
tmp(20) := STA & R0 & '0' & x"05";   -- MEM[5] = R0 = 5
tmp(21) := LDI & R0 & '0' & x"09";   -- Carrega o registrador com o valor nove
tmp(22) := STA & R0 & '0' & x"09";   -- MEM[9] = R0 = 9
tmp(23) := LDI & R0 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(24) := STA & R0 & '0' & x"0A";   -- MEM[10] = R0 = 0
tmp(25) := STA & R0 & '0' & x"0B";   -- MEM[11] = R0 = 0
tmp(26) := STA & R0 & '0' & x"0C";   -- MEM[12] = R0 = 0
tmp(27) := STA & R0 & '0' & x"0D";   -- MEM[13] = R0 = 0
tmp(28) := STA & R0 & '0' & x"0E";   -- MEM[14] = R0 = 0
tmp(29) := STA & R0 & '0' & x"0F";   -- MEM[15] = R0 = 0

------------------------------------ LOGICA ---------------------------------------------------------
-- Realiza a leitura do segundo
tmp(30) := LDA & R0 & '1' & x"63";   --lÃª KEY3
tmp(31) := CLT & R0 & '0' & x"01";   -- Se clicou no KEY3 (menor que um)
tmp(32) := JLT & R0 & '0' & x"29";   --pula para a linha 41

tmp(33) := LDA & R0 & '1' & x"64";   --le FPGA_RSET
tmp(34) := CEQ & R0 & '0' & x"00";   -- Se clicou no FPGA_RSET
tmp(35) := JEQ & R0 & '0' & x"00";   --pula para a linha 0

tmp(36) := LDA & R7 & '1' & x"60";   -- Carrega o registrador com a leitura do segundo (Lento)
tmp(37) := ANDI & R7 & '0' & x"01";   -- Limpa lixo da leitura segundo
tmp(38) := CEQ & R7 & '0' & x"01";   -- Se o registrador for igual a 1
tmp(39) := JEQ & R0 & '0' & x"2E";   --pula para a linha 46
tmp(40) := JMP & R0 & '0' & x"1E";   --pula para a linha 30

tmp(41) := LDA & R7 & '1' & x"61";   -- Carrega o registrador com a leitura do segundo (Rapido)
tmp(42) := ANDI & R7 & '0' & x"01";   -- Limpa lixo da leitura segundo
tmp(43) := CEQ & R7 & '0' & x"01";   -- Se o registrador for igual a 1
tmp(44) := JEQ & R0 & '0' & x"2E";   --pula para a linha 46
tmp(45) := JMP & R0 & '0' & x"1E";   --pula para a linha 30

-------- Conta os segundos -------------------------
-- Unidade dos segundos
tmp(46) := STA & R0 & '1' & x"FF";   -- Limpa o flipflop dos segundos (KEY0)
tmp(47) := STA & R0 & '1' & x"FE";   -- Limpa o flipflop dos segundos (KEY1)
tmp(48) := LDA & R1 & '0' & x"0A";   -- Carrega o registrador com MEM[10]

tmp(49) := CEQ & R1 & '0' & x"09";   -- Se o registrador for igual a 9
tmp(50) := JEQ & R0 & '0' & x"37";   --pula para a linha 55

tmp(51) := SOMA & R1 & '0' & x"01";   -- R1 = R1 + MEM[1]
tmp(52) := STA & R1 & '0' & x"0A";   -- Armazena o valor do registrador em MEM[10] (unidade segundo)
tmp(53) := STA & R1 & '1' & x"20";   -- Armazena o valor do registrador em HEX0
tmp(54) := JMP & R0 & '0' & x"1E";   --pula para a linha 30

-- Dezena dos segundos
tmp(55) := LDA & R2 & '0' & x"0B";   -- Carrega o registrador com MEM[11]
tmp(56) := CEQ & R2 & '0' & x"05";   -- Se o registrador for igual a 5
tmp(57) := JEQ & R0 & '0' & x"42";   --pula para a linha 66

tmp(58) := LDI & R1 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(59) := STA & R1 & '0' & x"0A";   -- Armazena o valor do registrador em MEM[10] (unidade segundo)
tmp(60) := STA & R1 & '1' & x"20";   -- Armazena o valor do registrador em HEX0

tmp(61) := LDA & R2 & '0' & x"0B";   -- Carrega o registrador com MEM[11]
tmp(62) := SOMA & R2 & '0' & x"01";   -- R2 = R2 + MEM[1]
tmp(63) := STA & R2 & '0' & x"0B";   -- Armazena o valor do registrador em MEM[11] (dezena segundo)
tmp(64) := STA & R2 & '1' & x"21";   -- Armazena o valor do registrador em HEX1
tmp(65) := JMP & R0 & '0' & x"1E";   --pula para a linha 30

-------- Conta os minutos -------------------------
-- Unidade dos Minutos
tmp(66) := LDA & R3 & '0' & x"0C";   -- Carrega o registrador com MEM[12]
tmp(67) := CEQ & R3 & '0' & x"09";   -- Se o registrador for igual a 9
tmp(68) := JEQ & R0 & '0' & x"50";   --pula para a linha 80

tmp(69) := LDI & R1 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(70) := STA & R1 & '0' & x"0A";   -- Armazena o valor do registrador em MEM[10] (unidade segundo)
tmp(71) := STA & R1 & '1' & x"20";   -- Armazena o valor do registrador em HEX0

tmp(72) := LDI & R2 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(73) := STA & R2 & '0' & x"0B";   -- Armazena o valor do registrador em MEM[11] (dezena segundo)
tmp(74) := STA & R2 & '1' & x"21";   -- Armazena o valor do registrador em HEX1

tmp(75) := LDA & R3 & '0' & x"0C";   -- Carrega o registrador com MEM[12]
tmp(76) := SOMA & R3 & '0' & x"01";   -- R3 = R3 + MEM[1]
tmp(77) := STA & R3 & '0' & x"0C";   -- Armazena o valor do registrador em MEM[12] (unidade minuto)
tmp(78) := STA & R3 & '1' & x"22";   -- Armazena o valor do registrador em HEX2
tmp(79) := JMP & R0 & '0' & x"1E";   --pula para a linha 30

-- Dezenas dos Minutos
tmp(80) := LDA & R4 & '0' & x"0D";   -- Carrega o registrador com MEM[13]
tmp(81) := CEQ & R4 & '0' & x"05";   -- Se o registrador for igual a 5
tmp(82) := JEQ & R0 & '0' & x"61";   --pula para a linha 97

tmp(83) := LDI & R1 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(84) := STA & R1 & '0' & x"0A";   -- Armazena o valor do registrador em MEM[10] (unidade segundo)
tmp(85) := STA & R1 & '1' & x"20";   -- Armazena o valor do registrador em HEX0

tmp(86) := LDI & R2 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(87) := STA & R2 & '0' & x"0B";   -- Armazena o valor do registrador em MEM[11] (dezena segundo)
tmp(88) := STA & R2 & '1' & x"21";   -- Armazena o valor do registrador em HEX1

tmp(89) := LDI & R3 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(90) := STA & R3 & '0' & x"0C";   -- Armazena o valor do registrador em MEM[12] (unidade minuto)
tmp(91) := STA & R3 & '1' & x"22";   -- Armazena o valor do registrador em HEX2

tmp(92) := LDA & R4 & '0' & x"0D";   -- Carrega o registrador com MEM[13]
tmp(93) := SOMA & R4 & '0' & x"01";   -- R4 = R4 + MEM[1]
tmp(94) := STA & R4 & '0' & x"0D";   -- Armazena o valor do registrador em MEM[13] (dezena minuto)
tmp(95) := STA & R4 & '1' & x"23";   -- Armazena o valor do registrador em HEX3
tmp(96) := JMP & R0 & '0' & x"1E";   --pula para a linha 30

-------- Conta as Horas -------------------------
-- Unidade das Horas
tmp(97) := LDA & R5 & '0' & x"0E";   -- Carrega o registrador com MEM[14]
tmp(98) := CEQ & R5 & '0' & x"09";   -- Se o registrador for igual a 9
tmp(99) := JEQ & R0 & '0' & x"78";   --pula para a linha 120

tmp(100) := LDA & R5 & '0' & x"0E";   -- Carrega o registrador com MEM[14]
tmp(101) := CEQ & R5 & '0' & x"03";   -- Se o registrador for igual a 3
tmp(102) := JEQ & R0 & '0' & x"8C";   --pula para a linha 140

tmp(103) := LDI & R1 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(104) := STA & R1 & '0' & x"0A";   -- Armazena o valor do registrador em MEM[10] (unidade segundo)
tmp(105) := STA & R1 & '1' & x"20";   -- Armazena o valor do registrador em HEX0

tmp(106) := LDI & R2 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(107) := STA & R2 & '0' & x"0B";   -- Armazena o valor do registrador em MEM[11] (dezena segundo)
tmp(108) := STA & R2 & '1' & x"21";   -- Armazena o valor do registrador em HEX1

tmp(109) := LDI & R3 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(110) := STA & R3 & '0' & x"0C";   -- Armazena o valor do registrador em MEM[12] (unidade minuto)
tmp(111) := STA & R3 & '1' & x"22";   -- Armazena o valor do registrador em HEX2

tmp(112) := LDI & R4 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(113) := STA & R4 & '0' & x"0D";   -- Armazena o valor do registrador em MEM[13] (dezena minuto)
tmp(114) := STA & R4 & '1' & x"23";   -- Armazena o valor do registrador em HEX3

tmp(115) := LDA & R5 & '0' & x"0E";   -- Carrega o registrador com MEM[14]
tmp(116) := SOMA & R5 & '0' & x"01";   -- R5 = R5 + MEM[1]
tmp(117) := STA & R5 & '0' & x"0E";   -- Armazena o valor do registrador em MEM[14] (unidade hora)
tmp(118) := STA & R5 & '1' & x"24";   -- Armazena o valor do registrador em HEX4
tmp(119) := JMP & R0 & '0' & x"1E";   --pula para a linha 30

-- Dezena das Horas
tmp(120) := LDI & R1 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(121) := STA & R1 & '0' & x"0A";   -- Armazena o valor do registrador em MEM[10] (unidade segundo)
tmp(122) := STA & R1 & '1' & x"20";   -- Armazena o valor do registrador em HEX0

tmp(123) := LDI & R2 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(124) := STA & R2 & '0' & x"0B";   -- Armazena o valor do registrador em MEM[11] (dezena segundo)
tmp(125) := STA & R2 & '1' & x"21";   -- Armazena o valor do registrador em HEX1

tmp(126) := LDI & R3 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(127) := STA & R3 & '0' & x"0C";   -- Armazena o valor do registrador em MEM[12] (unidade minuto)
tmp(128) := STA & R3 & '1' & x"22";   -- Armazena o valor do registrador em HEX2

tmp(129) := LDI & R4 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(130) := STA & R4 & '0' & x"0D";   -- Armazena o valor do registrador em MEM[13] (dezena minuto)
tmp(131) := STA & R4 & '1' & x"23";   -- Armazena o valor do registrador em HEX3

tmp(132) := LDI & R5 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(133) := STA & R5 & '0' & x"0E";   -- Armazena o valor do registrador em MEM[14] (unidade hora)
tmp(134) := STA & R5 & '1' & x"24";   -- Armazena o valor do registrador em HEX4

tmp(135) := LDA & R6 & '0' & x"0F";   -- Carrega o registrador com MEM[15]
tmp(136) := SOMA & R6 & '0' & x"01";   -- R6 = R6 + MEM[1]
tmp(137) := STA & R6 & '0' & x"0F";   -- Armazena o valor do registrador em MEM[14] (unidade hora)
tmp(138) := STA & R6 & '1' & x"25";   -- Armazena o valor do registrador em HEX5
tmp(139) := JMP & R0 & '0' & x"1E";   --pula para a linha 30

-- Limite 23:59
tmp(140) := LDA & R6 & '0' & x"0F";   -- Carrega o registrador com MEM[14]
tmp(141) := CEQ & R6 & '0' & x"02";   -- Se o registrador for igual a 2
tmp(142) := JEQ & R0 & '0' & x"00";   --pula para a linha 0
tmp(143) := JMP & R0 & '0' & x"67";   --pula para a linha 103
        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;