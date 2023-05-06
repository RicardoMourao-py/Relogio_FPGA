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

tmp(23) := LDI & R1 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(24) := LDI & R2 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(25) := LDI & R3 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(26) := LDI & R4 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(27) := LDI & R5 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(28) := LDI & R6 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(29) := LDI & R7 & '0' & x"00";   -- Carrega o registrador com o valor zero


------------------------------------ LOGICA ---------------------------------------------------------
-- Realiza a leitura do segundo
tmp(30) := LDA & R0 & '1' & x"63";   --lÃª KEY3
tmp(31) := CLT & R0 & '0' & x"01";   -- Se clicou no KEY3 (menor que um)
tmp(32) := JLT & R0 & '0' & x"2C";   --pula para a linha 44

tmp(33) := LDA & R0 & '1' & x"62";   -- le KEY2
tmp(34) := CEQ & R0 & '0' & x"01";   -- Se o registrador for igual a 1
tmp(35) := JEQ & R0 & '0' & x"75";   --pula para a linha 117

tmp(36) := LDA & R0 & '1' & x"64";   --le FPGA_RSET
tmp(37) := CLT & R0 & '0' & x"01";   -- Se clicou no FPGA_RSET
tmp(38) := JLT & R0 & '0' & x"00";   --pula para a linha 0

tmp(39) := LDA & R7 & '1' & x"60";   -- Carrega o registrador com a leitura do segundo (Normal)
tmp(40) := ANDI & R7 & '0' & x"01";   -- Limpa lixo da leitura segundo
tmp(41) := CEQ & R7 & '0' & x"01";   -- Se o registrador for igual a 1
tmp(42) := JEQ & R0 & '0' & x"31";   --pula para a linha 49
tmp(43) := JMP & R0 & '0' & x"1E";   --pula para a linha 30

tmp(44) := LDA & R7 & '1' & x"61";   -- Carrega o registrador com a leitura do segundo (Rapido)
tmp(45) := ANDI & R7 & '0' & x"01";   -- Limpa lixo da leitura segundo
tmp(46) := CEQ & R7 & '0' & x"01";   -- Se o registrador for igual a 1
tmp(47) := JEQ & R0 & '0' & x"31";   --pula para a linha 49
tmp(48) := JMP & R0 & '0' & x"1E";   --pula para a linha 30

-------- Conta os segundos -------------------------
-- Unidade dos segundos
tmp(49) := STA & R0 & '1' & x"FF";   -- Limpa o flipflop dos segundos (KEY0)
tmp(50) := STA & R0 & '1' & x"FE";   -- Limpa o flipflop dos segundos (KEY1)
tmp(51) := STA & R0 & '1' & x"FD";   -- Limpa KEY2

tmp(52) := CEQ & R1 & '0' & x"09";   -- Se o registrador for igual a 9
tmp(53) := JEQ & R0 & '0' & x"39";   --pula para a linha 57

tmp(54) := SOMA & R1 & '0' & x"01";   -- R1 = R1 + MEM[1]
tmp(55) := STA & R1 & '1' & x"20";   -- Armazena o valor do registrador em HEX0
tmp(56) := JMP & R0 & '0' & x"1E";   --pula para a linha 30

-- Dezena dos segundos
tmp(57) := CEQ & R2 & '0' & x"05";   -- Se o registrador for igual a 5
tmp(58) := JEQ & R0 & '0' & x"40";   --pula para a linha 64

tmp(59) := LDI & R1 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(60) := STA & R1 & '1' & x"20";   -- Armazena o valor do registrador em HEX0

tmp(61) := SOMA & R2 & '0' & x"01";   -- R2 = R2 + MEM[1]
tmp(62) := STA & R2 & '1' & x"21";   -- Armazena o valor do registrador em HEX1
tmp(63) := JMP & R0 & '0' & x"1E";   --pula para a linha 30

-------- Conta os minutos -------------------------
-- Unidade dos Minutos
tmp(64) := CEQ & R3 & '0' & x"09";   -- Se o registrador for igual a 9
tmp(65) := JEQ & R0 & '0' & x"4B";   --pula para a linha 75

tmp(66) := LDI & R1 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(67) := STA & R1 & '0' & x"0A";   -- Armazena o valor do registrador em MEM[10] (unidade segundo)
tmp(68) := STA & R1 & '1' & x"20";   -- Armazena o valor do registrador em HEX0

tmp(69) := LDI & R2 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(70) := STA & R2 & '0' & x"0B";   -- Armazena o valor do registrador em MEM[11] (dezena segundo)
tmp(71) := STA & R2 & '1' & x"21";   -- Armazena o valor do registrador em HEX1

tmp(72) := SOMA & R3 & '0' & x"01";   -- R3 = R3 + MEM[1]
tmp(73) := STA & R3 & '1' & x"22";   -- Armazena o valor do registrador em HEX2
tmp(74) := JMP & R0 & '0' & x"1E";   --pula para a linha 30

-- Dezenas dos Minutos
tmp(75) := CEQ & R4 & '0' & x"05";   -- Se o registrador for igual a 5
tmp(76) := JEQ & R0 & '0' & x"56";   --pula para a linha 86

tmp(77) := LDI & R1 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(78) := STA & R1 & '1' & x"20";   -- Armazena o valor do registrador em HEX0

tmp(79) := LDI & R2 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(80) := STA & R2 & '1' & x"21";   -- Armazena o valor do registrador em HEX1

tmp(81) := LDI & R3 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(82) := STA & R3 & '1' & x"22";   -- Armazena o valor do registrador em HEX2

tmp(83) := SOMA & R4 & '0' & x"01";   -- R4 = R4 + MEM[1]
tmp(84) := STA & R4 & '1' & x"23";   -- Armazena o valor do registrador em HEX3
tmp(85) := JMP & R0 & '0' & x"1E";   --pula para a linha 30

-------- Conta as Horas -------------------------
-- Unidade das Horas
tmp(86) := CEQ & R5 & '0' & x"09";   -- Se o registrador for igual a 9
tmp(87) := JEQ & R0 & '0' & x"65";   --pula para a linha 101

tmp(88) := CEQ & R5 & '0' & x"03";   -- Se o registrador for igual a 3
tmp(89) := JEQ & R0 & '0' & x"72";   --pula para a linha 114

tmp(90) := LDI & R1 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(91) := STA & R1 & '1' & x"20";   -- Armazena o valor do registrador em HEX0

tmp(92) := LDI & R2 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(93) := STA & R2 & '1' & x"21";   -- Armazena o valor do registrador em HEX1

tmp(94) := LDI & R3 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(95) := STA & R3 & '1' & x"22";   -- Armazena o valor do registrador em HEX2

tmp(96) := LDI & R4 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(97) := STA & R4 & '1' & x"23";   -- Armazena o valor do registrador em HEX3

tmp(98) := SOMA & R5 & '0' & x"01";   -- R5 = R5 + MEM[1]
tmp(99) := STA & R5 & '1' & x"24";   -- Armazena o valor do registrador em HEX4
tmp(100) := JMP & R0 & '0' & x"1E";   --pula para a linha 30

-- Dezena das Horas
tmp(101) := LDI & R1 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(102) := STA & R1 & '1' & x"20";   -- Armazena o valor do registrador em HEX0

tmp(103) := LDI & R2 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(104) := STA & R2 & '1' & x"21";   -- Armazena o valor do registrador em HEX1

tmp(105) := LDI & R3 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(106) := STA & R3 & '1' & x"22";   -- Armazena o valor do registrador em HEX2

tmp(107) := LDI & R4 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(108) := STA & R4 & '1' & x"23";   -- Armazena o valor do registrador em HEX3

tmp(109) := LDI & R5 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(110) := STA & R5 & '1' & x"24";   -- Armazena o valor do registrador em HEX4

tmp(111) := SOMA & R6 & '0' & x"01";   -- R6 = R6 + MEM[1]
tmp(112) := STA & R6 & '1' & x"25";   -- Armazena o valor do registrador em HEX5
tmp(113) := JMP & R0 & '0' & x"1E";   --pula para a linha 30

-- Limite 23:59
tmp(114) := CEQ & R6 & '0' & x"02";   -- Se o registrador for igual a 2
tmp(115) := JEQ & R0 & '0' & x"00";   --pula para a linha 0
tmp(116) := JMP & R0 & '0' & x"5A";   --pula para a linha 90

------------------------------------ AJUSTE HORARIO  -----------------------------------------------
-- Ajuste na unidade dos segundos
tmp(117) := STA & R0 & '1' & x"FD";   -- Limpa KEY2

tmp(118) := LDI & R0 & '0' & x"01";   --  Carrega no registrador o valor um
tmp(119) := STA & R0 & '1' & x"00";   -- Acende LEDR0

tmp(120) := LDA & R0 & '1' & x"62";   -- Carrega o acumulador com a leitura do botÃ£o KEY2
tmp(121) := ANDI & R0 & '0' & x"01";   -- LIMPA LIXO KEY2
tmp(122) := CEQ & R0 & '0' & x"01";   -- Compara com valor armazenado em MEM[1]
tmp(123) := JEQ & R0 & '0' & x"7D";   --pula para a linha 125
tmp(124) := JMP & R0 & '0' & x"75";   --pula para a linha 117

-- Ajuste na dezena dos segundos
tmp(125) := STA & R0 & '1' & x"FD";   -- Limpa KEY2
tmp(126) := LDA & R1 & '1' & x"40";   -- Faz a leitura das chaves SW7~SW0
tmp(127) := STA & R1 & '1' & x"20";   -- Escreve em HEX0 o valor do registrador

tmp(128) := LDI & R0 & '0' & x"02";   --  Carrega no registrador o valor dois
tmp(129) := STA & R0 & '1' & x"00";   -- Acende LEDR1

tmp(130) := LDA & R0 & '1' & x"62";   -- Carrega o acumulador com a leitura do botÃ£o KEY2
tmp(131) := ANDI & R0 & '0' & x"01";   -- LIMPA LIXO KEY2
tmp(132) := CEQ & R0 & '0' & x"01";   -- Compara com valor armazenado em MEM[1]
tmp(133) := JEQ & R0 & '0' & x"87";   --pula para a linha 135
tmp(134) := JMP & R0 & '0' & x"80";   --pula para a linha 128

-- Ajuste na unidade dos minutos
tmp(135) := STA & R0 & '1' & x"FD";   -- Limpa KEY2
tmp(136) := LDA & R2 & '1' & x"40";   -- Faz a leitura das chaves SW7~SW0
tmp(137) := STA & R2 & '1' & x"21";   -- Escreve em HEX1 o valor do registrador

tmp(138) := LDI & R0 & '0' & x"04";   --  Carrega no registrador o valor dois
tmp(139) := STA & R0 & '1' & x"00";   -- Acende LEDR1

tmp(140) := LDA & R0 & '1' & x"62";   -- Carrega o acumulador com a leitura do botÃ£o KEY2
tmp(141) := ANDI & R0 & '0' & x"01";   -- LIMPA LIXO KEY2
tmp(142) := CEQ & R0 & '0' & x"01";   -- Compara com valor armazenado em MEM[1]
tmp(143) := JEQ & R0 & '0' & x"91";   --pula para a linha 145
tmp(144) := JMP & R0 & '0' & x"8A";   --pula para a linha 138

-- Ajuste na dezena dos minutos
tmp(145) := STA & R0 & '1' & x"FD";   -- Limpa KEY2
tmp(146) := LDA & R3 & '1' & x"40";   -- Faz a leitura das chaves SW7~SW0
tmp(147) := STA & R3 & '1' & x"22";   -- Escreve em HEX2 o valor do registrador

tmp(148) := LDI & R0 & '0' & x"08";   --  Carrega no registrador o valor dois
tmp(149) := STA & R0 & '1' & x"00";   -- Acende LEDR1

tmp(150) := LDA & R0 & '1' & x"62";   -- Carrega o acumulador com a leitura do botÃ£o KEY2
tmp(151) := ANDI & R0 & '0' & x"01";   -- LIMPA LIXO KEY2
tmp(152) := CEQ & R0 & '0' & x"01";   -- Compara com valor armazenado em MEM[1]
tmp(153) := JEQ & R0 & '0' & x"9B";   --pula para a linha 155
tmp(154) := JMP & R0 & '0' & x"94";   --pula para a linha 148

-- Ajuste na unidade das horas
tmp(155) := STA & R0 & '1' & x"FD";   -- Limpa KEY2
tmp(156) := LDA & R4 & '1' & x"40";   -- Faz a leitura das chaves SW7~SW0
tmp(157) := STA & R4 & '1' & x"23";   -- Escreve em HEX3 o valor do registrador

tmp(158) := LDI & R0 & '0' & x"10";   --  Carrega no registrador o valor dezesseis
tmp(159) := STA & R0 & '1' & x"00";   -- Acende LEDR1

tmp(160) := LDA & R0 & '1' & x"62";   -- Carrega o acumulador com a leitura do botÃ£o KEY2
tmp(161) := ANDI & R0 & '0' & x"01";   -- LIMPA LIXO KEY2
tmp(162) := CEQ & R0 & '0' & x"01";   -- Compara com valor armazenado em MEM[1]
tmp(163) := JEQ & R0 & '0' & x"A5";   --pula para a linha 165
tmp(164) := JMP & R0 & '0' & x"9E";   --pula para a linha 158

-- Ajuste na dezena das horas
tmp(165) := STA & R0 & '1' & x"FD";   -- Limpa KEY2
tmp(166) := LDA & R5 & '1' & x"40";   -- Faz a leitura das chaves SW7~SW0
tmp(167) := STA & R5 & '1' & x"24";   -- Escreve em HEX4 o valor do registrador

tmp(168) := LDI & R0 & '0' & x"20";   --  Carrega no registrador o valor trinta e dois
tmp(169) := STA & R0 & '1' & x"00";   -- Acende LEDR1

tmp(170) := LDA & R0 & '1' & x"62";   -- Carrega o acumulador com a leitura do botÃ£o KEY2
tmp(171) := ANDI & R0 & '0' & x"01";   -- LIMPA LIXO KEY2
tmp(172) := CEQ & R0 & '0' & x"01";   -- Compara com valor armazenado em MEM[1]
tmp(173) := JEQ & R0 & '0' & x"AF";   --pula para a linha 175
tmp(174) := JMP & R0 & '0' & x"A8";   --pula para a linha 168

-- Ajuste na dezena das horas 2
tmp(175) := STA & R0 & '1' & x"FD";   -- Limpa KEY2
tmp(176) := LDA & R6 & '1' & x"40";   -- Faz a leitura das chaves SW7~SW0
tmp(177) := STA & R6 & '1' & x"25";   -- Escreve em HEX5 o valor do registrador

tmp(178) := LDI & R0 & '0' & x"40";   --  Carrega no registrador o valor sessenta e quatro
tmp(179) := STA & R0 & '1' & x"00";   -- Acende LEDR1

tmp(180) := LDA & R0 & '1' & x"62";   -- Carrega o acumulador com a leitura do botÃ£o KEY2
tmp(181) := ANDI & R0 & '0' & x"01";   -- LIMPA LIXO KEY2
tmp(182) := CEQ & R0 & '0' & x"01";   -- Compara com valor armazenado em MEM[1]
tmp(183) := JEQ & R0 & '0' & x"31";   --pula para a linha 49
tmp(184) := JMP & R0 & '0' & x"B2";   --pula para a linha 178
        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;