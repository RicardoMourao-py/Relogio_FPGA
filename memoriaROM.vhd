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
  constant ADDI  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1111";
  
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
tmp(19) := LDI & R0 & '0' & x"04";   -- Carrega o registrador com o valor quatro
tmp(20) := STA & R0 & '0' & x"04";   -- MEM[4] = R0 = 4
tmp(21) := LDI & R0 & '0' & x"05";   -- Carrega o registrador com o valor cinco
tmp(22) := STA & R0 & '0' & x"05";   -- MEM[5] = R0 = 5
tmp(23) := LDI & R0 & '0' & x"06";   -- Carrega o registrador com o valor seis
tmp(24) := STA & R0 & '0' & x"06";   -- MEM[6] = R0 = 6
tmp(25) := LDI & R0 & '0' & x"09";   -- Carrega o registrador com o valor nove
tmp(26) := STA & R0 & '0' & x"09";   -- MEM[9] = R0 = 9
tmp(27) := LDI & R0 & '0' & x"0A";   -- Carrega o registrador com o valor dez
tmp(28) := STA & R0 & '0' & x"0A";   -- MEM[10] = R0 = 10

tmp(29) := LDI & R1 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(30) := LDI & R2 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(31) := LDI & R3 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(32) := LDI & R4 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(33) := LDI & R5 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(34) := LDI & R6 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(35) := LDI & R7 & '0' & x"00";   -- Carrega o registrador com o valor zero


------------------------------------ LOGICA ---------------------------------------------------------
-- Realiza a leitura do segundo
tmp(36) := LDA & R0 & '1' & x"63";   --lÃª KEY3
tmp(37) := CLT & R0 & '0' & x"01";   -- Se clicou no KEY3 (menor que um)
tmp(38) := JLT & R0 & '0' & x"32";   --pula para a linha 50

tmp(39) := LDA & R0 & '1' & x"62";   -- le KEY2
tmp(40) := CEQ & R0 & '0' & x"01";   -- Se o registrador for igual a 1
tmp(41) := JEQ & R0 & '0' & x"7D";   --pula para a linha 125

tmp(42) := LDA & R0 & '1' & x"64";   --le FPGA_RSET
tmp(43) := CLT & R0 & '0' & x"01";   -- Se clicou no FPGA_RSET
tmp(44) := JLT & R0 & '0' & x"00";   --pula para a linha 0

tmp(45) := LDA & R7 & '1' & x"60";   -- Carrega o registrador com a leitura do segundo (Normal)
tmp(46) := ANDI & R7 & '0' & x"01";   -- Limpa lixo da leitura segundo
tmp(47) := CEQ & R7 & '0' & x"01";   -- Se o registrador for igual a 1
tmp(48) := JEQ & R0 & '0' & x"37";   --pula para a linha 55
tmp(49) := JMP & R0 & '0' & x"24";   --pula para a linha 36

tmp(50) := LDA & R7 & '1' & x"61";   -- Carrega o registrador com a leitura do segundo (Rapido)
tmp(51) := ANDI & R7 & '0' & x"01";   -- Limpa lixo da leitura segundo
tmp(52) := CEQ & R7 & '0' & x"01";   -- Se o registrador for igual a 1
tmp(53) := JEQ & R0 & '0' & x"37";   --pula para a linha 55
tmp(54) := JMP & R0 & '0' & x"24";   --pula para a linha 36

-------- Conta os segundos -------------------------
-- Unidade dos segundos
tmp(55) := LDI & R0 & '0' & x"00";   -- Carrega registrador com zero
tmp(56) := STA & R0 & '1' & x"00";   -- Apaga LEDS
tmp(57) := STA & R0 & '1' & x"FF";   -- Limpa o flipflop dos segundos (KEY0)
tmp(58) := STA & R0 & '1' & x"FE";   -- Limpa o flipflop dos segundos (KEY1)
tmp(59) := STA & R0 & '1' & x"FD";   -- Limpa KEY2

tmp(60) := CEQ & R1 & '0' & x"09";   -- Se o registrador for igual a 9
tmp(61) := JEQ & R0 & '0' & x"41";   --pula para a linha 65

tmp(62) := ADDI & R1 & '0' & x"01";   -- R1 = R1 + MEM[1]
tmp(63) := STA & R1 & '1' & x"20";   -- Armazena o valor do registrador em HEX0
tmp(64) := JMP & R0 & '0' & x"24";   --pula para a linha 36

-- Dezena dos segundos
tmp(65) := CEQ & R2 & '0' & x"05";   -- Se o registrador for igual a 5
tmp(66) := JEQ & R0 & '0' & x"48";   --pula para a linha 72

tmp(67) := LDI & R1 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(68) := STA & R1 & '1' & x"20";   -- Armazena o valor do registrador em HEX0

tmp(69) := ADDI & R2 & '0' & x"01";   -- R2 = R2 + MEM[1]
tmp(70) := STA & R2 & '1' & x"21";   -- Armazena o valor do registrador em HEX1
tmp(71) := JMP & R0 & '0' & x"24";   --pula para a linha 36

-------- Conta os minutos -------------------------
-- Unidade dos Minutos
tmp(72) := CEQ & R3 & '0' & x"09";   -- Se o registrador for igual a 9
tmp(73) := JEQ & R0 & '0' & x"53";   --pula para a linha 83

tmp(74) := LDI & R1 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(75) := STA & R1 & '0' & x"0A";   -- Armazena o valor do registrador em MEM[10] (unidade segundo)
tmp(76) := STA & R1 & '1' & x"20";   -- Armazena o valor do registrador em HEX0

tmp(77) := LDI & R2 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(78) := STA & R2 & '0' & x"0B";   -- Armazena o valor do registrador em MEM[11] (dezena segundo)
tmp(79) := STA & R2 & '1' & x"21";   -- Armazena o valor do registrador em HEX1

tmp(80) := ADDI & R3 & '0' & x"01";   -- R3 = R3 + MEM[1]
tmp(81) := STA & R3 & '1' & x"22";   -- Armazena o valor do registrador em HEX2
tmp(82) := JMP & R0 & '0' & x"24";   --pula para a linha 36

-- Dezenas dos Minutos
tmp(83) := CEQ & R4 & '0' & x"05";   -- Se o registrador for igual a 5
tmp(84) := JEQ & R0 & '0' & x"5E";   --pula para a linha 94

tmp(85) := LDI & R1 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(86) := STA & R1 & '1' & x"20";   -- Armazena o valor do registrador em HEX0

tmp(87) := LDI & R2 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(88) := STA & R2 & '1' & x"21";   -- Armazena o valor do registrador em HEX1

tmp(89) := LDI & R3 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(90) := STA & R3 & '1' & x"22";   -- Armazena o valor do registrador em HEX2

tmp(91) := ADDI & R4 & '0' & x"01";   -- R4 = R4 + MEM[1]
tmp(92) := STA & R4 & '1' & x"23";   -- Armazena o valor do registrador em HEX3
tmp(93) := JMP & R0 & '0' & x"24";   --pula para a linha 36

-------- Conta as Horas -------------------------
-- Unidade das Horas
tmp(94) := CEQ & R5 & '0' & x"09";   -- Se o registrador for igual a 9
tmp(95) := JEQ & R0 & '0' & x"6D";   --pula para a linha 109

tmp(96) := CEQ & R5 & '0' & x"03";   -- Se o registrador for igual a 3
tmp(97) := JEQ & R0 & '0' & x"7A";   --pula para a linha 122

tmp(98) := LDI & R1 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(99) := STA & R1 & '1' & x"20";   -- Armazena o valor do registrador em HEX0

tmp(100) := LDI & R2 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(101) := STA & R2 & '1' & x"21";   -- Armazena o valor do registrador em HEX1

tmp(102) := LDI & R3 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(103) := STA & R3 & '1' & x"22";   -- Armazena o valor do registrador em HEX2

tmp(104) := LDI & R4 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(105) := STA & R4 & '1' & x"23";   -- Armazena o valor do registrador em HEX3

tmp(106) := ADDI & R5 & '0' & x"01";   -- R5 = R5 + MEM[1]
tmp(107) := STA & R5 & '1' & x"24";   -- Armazena o valor do registrador em HEX4
tmp(108) := JMP & R0 & '0' & x"24";   --pula para a linha 36

-- Dezena das Horas
tmp(109) := LDI & R1 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(110) := STA & R1 & '1' & x"20";   -- Armazena o valor do registrador em HEX0

tmp(111) := LDI & R2 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(112) := STA & R2 & '1' & x"21";   -- Armazena o valor do registrador em HEX1

tmp(113) := LDI & R3 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(114) := STA & R3 & '1' & x"22";   -- Armazena o valor do registrador em HEX2

tmp(115) := LDI & R4 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(116) := STA & R4 & '1' & x"23";   -- Armazena o valor do registrador em HEX3

tmp(117) := LDI & R5 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(118) := STA & R5 & '1' & x"24";   -- Armazena o valor do registrador em HEX4

tmp(119) := ADDI & R6 & '0' & x"01";   -- R6 = R6 + MEM[1]
tmp(120) := STA & R6 & '1' & x"25";   -- Armazena o valor do registrador em HEX5
tmp(121) := JMP & R0 & '0' & x"24";   --pula para a linha 36

-- Limite 23:59
tmp(122) := CEQ & R6 & '0' & x"02";   -- Se o registrador for igual a 2
tmp(123) := JEQ & R0 & '0' & x"00";   --pula para a linha 0
tmp(124) := JMP & R0 & '0' & x"62";   --pula para a linha 98

------------------------------------ AJUSTE HORARIO  -----------------------------------------------
-- Ajuste na unidade dos segundos
tmp(125) := LDI & R0 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(126) := STA & R0 & '1' & x"20";   -- Armazena o valor do registrador em HEX0
tmp(127) := STA & R0 & '1' & x"21";   -- Armazena o valor do registrador em HEX1
tmp(128) := STA & R0 & '1' & x"22";   -- Armazena o valor do registrador em HEX2
tmp(129) := STA & R0 & '1' & x"23";   -- Armazena o valor do registrador em HEX3
tmp(130) := STA & R0 & '1' & x"24";   -- Armazena o valor do registrador em HEX4
tmp(131) := STA & R0 & '1' & x"25";   -- Armazena o valor do registrador em HEX5

tmp(132) := STA & R0 & '1' & x"FD";   -- Limpa KEY2
tmp(133) := LDI & R0 & '0' & x"01";   --  Carrega no registrador o valor um
tmp(134) := STA & R0 & '1' & x"00";   -- Acende LEDR0

tmp(135) := LDA & R0 & '1' & x"62";   -- Carrega o acumulador com a leitura do botÃ£o KEY2
tmp(136) := ANDI & R0 & '0' & x"01";   -- LIMPA LIXO KEY2
tmp(137) := CEQ & R0 & '0' & x"01";   -- Compara com valor armazenado em MEM[1]
tmp(138) := JEQ & R0 & '0' & x"8C";   --pula para a linha 140
tmp(139) := JMP & R0 & '0' & x"87";   --pula para a linha 135

-- Ajuste na dezena dos segundos
tmp(140) := STA & R0 & '1' & x"FD";   -- Limpa KEY2
tmp(141) := LDA & R1 & '1' & x"40";   -- Faz a leitura das chaves SW7~SW0
tmp(142) := STA & R1 & '1' & x"20";   -- Escreve em HEX0 o valor do registrador

tmp(143) := LDI & R0 & '0' & x"02";   --  Carrega no registrador o valor dois
tmp(144) := STA & R0 & '1' & x"00";   -- Acende LEDR1

tmp(145) := LDA & R0 & '1' & x"62";   -- Carrega o acumulador com a leitura do botÃ£o KEY2
tmp(146) := ANDI & R0 & '0' & x"01";   -- LIMPA LIXO KEY2
tmp(147) := CEQ & R0 & '0' & x"01";   -- Compara com valor armazenado em MEM[1]
tmp(148) := JEQ & R0 & '0' & x"96";   --pula para a linha 150
tmp(149) := JMP & R0 & '0' & x"8F";   --pula para a linha 143

-- Ajuste na unidade dos minutos
tmp(150) := STA & R0 & '1' & x"FD";   -- Limpa KEY2
tmp(151) := LDA & R2 & '1' & x"40";   -- Faz a leitura das chaves SW7~SW0
tmp(152) := STA & R2 & '1' & x"21";   -- Escreve em HEX1 o valor do registrador

tmp(153) := LDI & R0 & '0' & x"04";   --  Carrega no registrador o valor dois
tmp(154) := STA & R0 & '1' & x"00";   -- Acende LEDR1

tmp(155) := LDA & R0 & '1' & x"62";   -- Carrega o acumulador com a leitura do botÃ£o KEY2
tmp(156) := ANDI & R0 & '0' & x"01";   -- LIMPA LIXO KEY2
tmp(157) := CEQ & R0 & '0' & x"01";   -- Compara com valor armazenado em MEM[1]
tmp(158) := JEQ & R0 & '0' & x"A0";   --pula para a linha 160
tmp(159) := JMP & R0 & '0' & x"99";   --pula para a linha 153

-- Ajuste na dezena dos minutos
tmp(160) := STA & R0 & '1' & x"FD";   -- Limpa KEY2
tmp(161) := LDA & R3 & '1' & x"40";   -- Faz a leitura das chaves SW7~SW0
tmp(162) := STA & R3 & '1' & x"22";   -- Escreve em HEX2 o valor do registrador

tmp(163) := LDI & R0 & '0' & x"08";   --  Carrega no registrador o valor dois
tmp(164) := STA & R0 & '1' & x"00";   -- Acende LEDR1

tmp(165) := LDA & R0 & '1' & x"62";   -- Carrega o acumulador com a leitura do botÃ£o KEY2
tmp(166) := ANDI & R0 & '0' & x"01";   -- LIMPA LIXO KEY2
tmp(167) := CEQ & R0 & '0' & x"01";   -- Compara com valor armazenado em MEM[1]
tmp(168) := JEQ & R0 & '0' & x"AA";   --pula para a linha 170
tmp(169) := JMP & R0 & '0' & x"A3";   --pula para a linha 163

-- Ajuste na unidade das horas
tmp(170) := STA & R0 & '1' & x"FD";   -- Limpa KEY2
tmp(171) := LDA & R4 & '1' & x"40";   -- Faz a leitura das chaves SW7~SW0
tmp(172) := STA & R4 & '1' & x"23";   -- Escreve em HEX3 o valor do registrador

tmp(173) := LDI & R0 & '0' & x"10";   --  Carrega no registrador o valor dezesseis
tmp(174) := STA & R0 & '1' & x"00";   -- Acende LEDR1

tmp(175) := LDA & R0 & '1' & x"62";   -- Carrega o acumulador com a leitura do botÃ£o KEY2
tmp(176) := ANDI & R0 & '0' & x"01";   -- LIMPA LIXO KEY2
tmp(177) := CEQ & R0 & '0' & x"01";   -- Compara com valor armazenado em MEM[1]
tmp(178) := JEQ & R0 & '0' & x"B4";   --pula para a linha 180
tmp(179) := JMP & R0 & '0' & x"AD";   --pula para a linha 173

-- Ajuste na dezena das horas
tmp(180) := STA & R0 & '1' & x"FD";   -- Limpa KEY2
tmp(181) := LDA & R5 & '1' & x"40";   -- Faz a leitura das chaves SW7~SW0
tmp(182) := STA & R5 & '1' & x"24";   -- Escreve em HEX4 o valor do registrador

tmp(183) := LDI & R0 & '0' & x"20";   --  Carrega no registrador o valor trinta e dois
tmp(184) := STA & R0 & '1' & x"00";   -- Acende LEDR1

tmp(185) := LDA & R0 & '1' & x"62";   -- Carrega o acumulador com a leitura do botÃ£o KEY2
tmp(186) := ANDI & R0 & '0' & x"01";   -- LIMPA LIXO KEY2
tmp(187) := CEQ & R0 & '0' & x"01";   -- Compara com valor armazenado em MEM[1]
tmp(188) := JEQ & R0 & '0' & x"BE";   --pula para a linha 190
tmp(189) := JMP & R0 & '0' & x"B7";   --pula para a linha 183

-- Ajuste na dezena das horas 2
tmp(190) := STA & R0 & '1' & x"FD";   -- Limpa KEY2
tmp(191) := LDA & R6 & '1' & x"40";   -- Faz a leitura das chaves SW7~SW0
tmp(192) := STA & R6 & '1' & x"25";   -- Escreve em HEX5 o valor do registrador

tmp(193) := LDI & R0 & '0' & x"40";   --  Carrega no registrador o valor sessenta e quatro
tmp(194) := STA & R0 & '1' & x"00";   -- Acende LEDR1

tmp(195) := LDA & R0 & '1' & x"62";   -- Carrega o acumulador com a leitura do botÃ£o KEY2
tmp(196) := ANDI & R0 & '0' & x"01";   -- LIMPA LIXO KEY2
tmp(197) := CEQ & R0 & '0' & x"01";   -- Compara com valor armazenado em MEM[1]
tmp(198) := JEQ & R0 & '0' & x"37";   --pula para a linha 55
tmp(199) := JMP & R0 & '0' & x"C1";   --pula para a linha 193
        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;