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

------------------------------------ AJUSTE HORARIO  -----------------------------------------------
-- Ajuste na unidade dos segundos
tmp(30) := LDI & R0 & '0' & x"01";   --  Carrega no registrador o valor um
tmp(31) := STA & R0 & '1' & x"00";   -- Acende LEDR0

tmp(32) := LDA & R0 & '1' & x"62";   -- Carrega o acumulador com a leitura do botÃ£o KEY2
tmp(33) := ANDI & R0 & '0' & x"01";   -- LIMPA LIXO KEY2
tmp(34) := CEQ & R0 & '0' & x"01";   -- Compara com valor armazenado em MEM[1]
tmp(35) := JEQ & R0 & '0' & x"25";   --pula para a linha 37
tmp(36) := JMP & R0 & '0' & x"1E";   --pula para a linha 30

-- Ajuste na dezena dos segundos
tmp(37) := STA & R0 & '1' & x"FD";   -- Limpa KEY2
tmp(38) := LDA & R1 & '1' & x"40";   -- Faz a leitura das chaves SW7~SW0
tmp(39) := STA & R1 & '1' & x"20";   -- Escreve em HEX0 o valor do registrador

tmp(40) := LDI & R0 & '0' & x"02";   --  Carrega no registrador o valor dois
tmp(41) := STA & R0 & '1' & x"00";   -- Acende LEDR1

tmp(42) := LDA & R0 & '1' & x"62";   -- Carrega o acumulador com a leitura do botÃ£o KEY2
tmp(43) := ANDI & R0 & '0' & x"01";   -- LIMPA LIXO KEY2
tmp(44) := CEQ & R0 & '0' & x"01";   -- Compara com valor armazenado em MEM[1]
tmp(45) := JEQ & R0 & '0' & x"2F";   --pula para a linha 47
tmp(46) := JMP & R0 & '0' & x"28";   --pula para a linha 40

-- Ajuste na unidade dos minutos
tmp(47) := STA & R0 & '1' & x"FD";   -- Limpa KEY2
tmp(48) := LDA & R2 & '1' & x"40";   -- Faz a leitura das chaves SW7~SW0
tmp(49) := STA & R2 & '1' & x"21";   -- Escreve em HEX1 o valor do registrador

tmp(50) := LDI & R0 & '0' & x"04";   --  Carrega no registrador o valor dois
tmp(51) := STA & R0 & '1' & x"00";   -- Acende LEDR1

tmp(52) := LDA & R0 & '1' & x"62";   -- Carrega o acumulador com a leitura do botÃ£o KEY2
tmp(53) := ANDI & R0 & '0' & x"01";   -- LIMPA LIXO KEY2
tmp(54) := CEQ & R0 & '0' & x"01";   -- Compara com valor armazenado em MEM[1]
tmp(55) := JEQ & R0 & '0' & x"49";   --pula para a linha 73
tmp(56) := JMP & R0 & '0' & x"32";   --pula para a linha 50
------------------------------------ LOGICA ---------------------------------------------------------
-- Realiza a leitura do segundo
tmp(57) := LDA & R0 & '1' & x"63";   --lÃª KEY3
tmp(58) := CLT & R0 & '0' & x"01";   -- Se clicou no KEY3 (menor que um)
tmp(59) := JLT & R0 & '0' & x"44";   --pula para a linha 68

tmp(60) := LDA & R0 & '1' & x"64";   --le FPGA_RSET
tmp(61) := CLT & R0 & '0' & x"01";   -- Se clicou no FPGA_RSET
tmp(62) := JLT & R0 & '0' & x"00";   --pula para a linha 0

tmp(63) := LDA & R7 & '1' & x"60";   -- Carrega o registrador com a leitura do segundo (Normal)
tmp(64) := ANDI & R7 & '0' & x"01";   -- Limpa lixo da leitura segundo
tmp(65) := CEQ & R7 & '0' & x"01";   -- Se o registrador for igual a 1
tmp(66) := JEQ & R0 & '0' & x"49";   --pula para a linha 73
tmp(67) := JMP & R0 & '0' & x"39";   --pula para a linha 57

tmp(68) := LDA & R7 & '1' & x"61";   -- Carrega o registrador com a leitura do segundo (Rapido)
tmp(69) := ANDI & R7 & '0' & x"01";   -- Limpa lixo da leitura segundo
tmp(70) := CEQ & R7 & '0' & x"01";   -- Se o registrador for igual a 1
tmp(71) := JEQ & R0 & '0' & x"49";   --pula para a linha 73
tmp(72) := JMP & R0 & '0' & x"39";   --pula para a linha 57

-------- Conta os segundos -------------------------
-- Unidade dos segundos
tmp(73) := STA & R0 & '1' & x"FF";   -- Limpa o flipflop dos segundos (KEY0)
tmp(74) := STA & R0 & '1' & x"FE";   -- Limpa o flipflop dos segundos (KEY1)

tmp(75) := CEQ & R1 & '0' & x"09";   -- Se o registrador for igual a 9
tmp(76) := JEQ & R0 & '0' & x"50";   --pula para a linha 80

tmp(77) := SOMA & R1 & '0' & x"01";   -- R1 = R1 + MEM[1]
tmp(78) := STA & R1 & '1' & x"20";   -- Armazena o valor do registrador em HEX0
tmp(79) := JMP & R0 & '0' & x"39";   --pula para a linha 57

-- Dezena dos segundos
tmp(80) := STA & R0 & '1' & x"FF";   -- Limpa o flipflop dos segundos (KEY0)
tmp(81) := STA & R0 & '1' & x"FE";   -- Limpa o flipflop dos segundos (KEY1)

tmp(82) := CEQ & R2 & '0' & x"05";   -- Se o registrador for igual a 5
tmp(83) := JEQ & R0 & '0' & x"59";   --pula para a linha 89

tmp(84) := LDI & R1 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(85) := STA & R1 & '1' & x"20";   -- Armazena o valor do registrador em HEX0

tmp(86) := SOMA & R2 & '0' & x"01";   -- R2 = R2 + MEM[1]
tmp(87) := STA & R2 & '1' & x"21";   -- Armazena o valor do registrador em HEX1
tmp(88) := JMP & R0 & '0' & x"39";   --pula para a linha 57

-------- Conta os minutos -------------------------
-- Unidade dos Minutos
tmp(89) := LDA & R3 & '0' & x"0C";   -- Carrega o registrador com MEM[12]
tmp(90) := CEQ & R3 & '0' & x"09";   -- Se o registrador for igual a 9
tmp(91) := JEQ & R0 & '0' & x"67";   --pula para a linha 103

tmp(92) := LDI & R1 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(93) := STA & R1 & '0' & x"0A";   -- Armazena o valor do registrador em MEM[10] (unidade segundo)
tmp(94) := STA & R1 & '1' & x"20";   -- Armazena o valor do registrador em HEX0

tmp(95) := LDI & R2 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(96) := STA & R2 & '0' & x"0B";   -- Armazena o valor do registrador em MEM[11] (dezena segundo)
tmp(97) := STA & R2 & '1' & x"21";   -- Armazena o valor do registrador em HEX1

tmp(98) := LDA & R3 & '0' & x"0C";   -- Carrega o registrador com MEM[12]
tmp(99) := SOMA & R3 & '0' & x"01";   -- R3 = R3 + MEM[1]
tmp(100) := STA & R3 & '0' & x"0C";   -- Armazena o valor do registrador em MEM[12] (unidade minuto)
tmp(101) := STA & R3 & '1' & x"22";   -- Armazena o valor do registrador em HEX2
tmp(102) := JMP & R0 & '0' & x"39";   --pula para a linha 57

-- Dezenas dos Minutos
tmp(103) := LDA & R4 & '0' & x"0D";   -- Carrega o registrador com MEM[13]
tmp(104) := CEQ & R4 & '0' & x"05";   -- Se o registrador for igual a 5
tmp(105) := JEQ & R0 & '0' & x"78";   --pula para a linha 120

tmp(106) := LDI & R1 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(107) := STA & R1 & '0' & x"0A";   -- Armazena o valor do registrador em MEM[10] (unidade segundo)
tmp(108) := STA & R1 & '1' & x"20";   -- Armazena o valor do registrador em HEX0

tmp(109) := LDI & R2 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(110) := STA & R2 & '0' & x"0B";   -- Armazena o valor do registrador em MEM[11] (dezena segundo)
tmp(111) := STA & R2 & '1' & x"21";   -- Armazena o valor do registrador em HEX1

tmp(112) := LDI & R3 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(113) := STA & R3 & '0' & x"0C";   -- Armazena o valor do registrador em MEM[12] (unidade minuto)
tmp(114) := STA & R3 & '1' & x"22";   -- Armazena o valor do registrador em HEX2

tmp(115) := LDA & R4 & '0' & x"0D";   -- Carrega o registrador com MEM[13]
tmp(116) := SOMA & R4 & '0' & x"01";   -- R4 = R4 + MEM[1]
tmp(117) := STA & R4 & '0' & x"0D";   -- Armazena o valor do registrador em MEM[13] (dezena minuto)
tmp(118) := STA & R4 & '1' & x"23";   -- Armazena o valor do registrador em HEX3
tmp(119) := JMP & R0 & '0' & x"39";   --pula para a linha 57

-------- Conta as Horas -------------------------
-- Unidade das Horas
tmp(120) := LDA & R5 & '0' & x"0E";   -- Carrega o registrador com MEM[14]
tmp(121) := CEQ & R5 & '0' & x"09";   -- Se o registrador for igual a 9
tmp(122) := JEQ & R0 & '0' & x"8F";   --pula para a linha 143

tmp(123) := LDA & R5 & '0' & x"0E";   -- Carrega o registrador com MEM[14]
tmp(124) := CEQ & R5 & '0' & x"03";   -- Se o registrador for igual a 3
tmp(125) := JEQ & R0 & '0' & x"A3";   --pula para a linha 163

tmp(126) := LDI & R1 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(127) := STA & R1 & '0' & x"0A";   -- Armazena o valor do registrador em MEM[10] (unidade segundo)
tmp(128) := STA & R1 & '1' & x"20";   -- Armazena o valor do registrador em HEX0

tmp(129) := LDI & R2 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(130) := STA & R2 & '0' & x"0B";   -- Armazena o valor do registrador em MEM[11] (dezena segundo)
tmp(131) := STA & R2 & '1' & x"21";   -- Armazena o valor do registrador em HEX1

tmp(132) := LDI & R3 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(133) := STA & R3 & '0' & x"0C";   -- Armazena o valor do registrador em MEM[12] (unidade minuto)
tmp(134) := STA & R3 & '1' & x"22";   -- Armazena o valor do registrador em HEX2

tmp(135) := LDI & R4 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(136) := STA & R4 & '0' & x"0D";   -- Armazena o valor do registrador em MEM[13] (dezena minuto)
tmp(137) := STA & R4 & '1' & x"23";   -- Armazena o valor do registrador em HEX3

tmp(138) := LDA & R5 & '0' & x"0E";   -- Carrega o registrador com MEM[14]
tmp(139) := SOMA & R5 & '0' & x"01";   -- R5 = R5 + MEM[1]
tmp(140) := STA & R5 & '0' & x"0E";   -- Armazena o valor do registrador em MEM[14] (unidade hora)
tmp(141) := STA & R5 & '1' & x"24";   -- Armazena o valor do registrador em HEX4
tmp(142) := JMP & R0 & '0' & x"39";   --pula para a linha 57

-- Dezena das Horas
tmp(143) := LDI & R1 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(144) := STA & R1 & '0' & x"0A";   -- Armazena o valor do registrador em MEM[10] (unidade segundo)
tmp(145) := STA & R1 & '1' & x"20";   -- Armazena o valor do registrador em HEX0

tmp(146) := LDI & R2 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(147) := STA & R2 & '0' & x"0B";   -- Armazena o valor do registrador em MEM[11] (dezena segundo)
tmp(148) := STA & R2 & '1' & x"21";   -- Armazena o valor do registrador em HEX1

tmp(149) := LDI & R3 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(150) := STA & R3 & '0' & x"0C";   -- Armazena o valor do registrador em MEM[12] (unidade minuto)
tmp(151) := STA & R3 & '1' & x"22";   -- Armazena o valor do registrador em HEX2

tmp(152) := LDI & R4 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(153) := STA & R4 & '0' & x"0D";   -- Armazena o valor do registrador em MEM[13] (dezena minuto)
tmp(154) := STA & R4 & '1' & x"23";   -- Armazena o valor do registrador em HEX3

tmp(155) := LDI & R5 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(156) := STA & R5 & '0' & x"0E";   -- Armazena o valor do registrador em MEM[14] (unidade hora)
tmp(157) := STA & R5 & '1' & x"24";   -- Armazena o valor do registrador em HEX4

tmp(158) := LDA & R6 & '0' & x"0F";   -- Carrega o registrador com MEM[15]
tmp(159) := SOMA & R6 & '0' & x"01";   -- R6 = R6 + MEM[1]
tmp(160) := STA & R6 & '0' & x"0F";   -- Armazena o valor do registrador em MEM[14] (unidade hora)
tmp(161) := STA & R6 & '1' & x"25";   -- Armazena o valor do registrador em HEX5
tmp(162) := JMP & R0 & '0' & x"39";   --pula para a linha 57

-- Limite 23:59
tmp(163) := LDA & R6 & '0' & x"0F";   -- Carrega o registrador com MEM[14]
tmp(164) := CEQ & R6 & '0' & x"02";   -- Se o registrador for igual a 2
tmp(165) := JEQ & R0 & '0' & x"00";   --pula para a linha 0
tmp(166) := JMP & R0 & '0' & x"7E";   --pula para a linha 126
        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;