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
tmp(30) := LDA & R7 & '1' & x"60";   -- Carrega o registrador com a leitura do segundo
tmp(31) := ANDI & R7 & '0' & x"01";   -- Limpa lixo da leitura segundo
tmp(32) := CEQ & R7 & '0' & x"01";   -- Se o registrador for igual a 1
tmp(33) := JEQ & R0 & '0' & x"23";   --pula para a linha 35
tmp(34) := JMP & R0 & '0' & x"1E";   --pula para a linha 30

-------- Conta os segundos -------------------------
-- Unidade dos segundos
tmp(35) := STA & R0 & '1' & x"FF";   -- Limpa o flipflop dos segundos
tmp(36) := LDA & R1 & '0' & x"0A";   -- Carrega o registrador com MEM[10]

tmp(37) := CEQ & R1 & '0' & x"09";   -- Se o registrador for igual a 9
tmp(38) := JEQ & R0 & '0' & x"2B";   --pula para a linha 43

tmp(39) := SOMA & R1 & '0' & x"01";   -- R1 = R1 + MEM[1]
tmp(40) := STA & R1 & '0' & x"0A";   -- Armazena o valor do registrador em MEM[10] (unidade segundo)
tmp(41) := STA & R1 & '1' & x"20";   -- Armazena o valor do registrador em HEX0
tmp(42) := JMP & R0 & '0' & x"1E";   --pula para a linha 30

-- Dezena dos segundos
tmp(43) := LDA & R2 & '0' & x"0B";   -- Carrega o registrador com MEM[11]
tmp(44) := CEQ & R2 & '0' & x"05";   -- Se o registrador for igual a 5
tmp(45) := JEQ & R0 & '0' & x"36";   --pula para a linha 54

tmp(46) := LDI & R1 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(47) := STA & R1 & '0' & x"0A";   -- Armazena o valor do registrador em MEM[10] (unidade segundo)
tmp(48) := STA & R1 & '1' & x"20";   -- Armazena o valor do registrador em HEX0

tmp(49) := LDA & R2 & '0' & x"0B";   -- Carrega o registrador com MEM[11]
tmp(50) := SOMA & R2 & '0' & x"01";   -- R2 = R2 + MEM[1]
tmp(51) := STA & R2 & '0' & x"0B";   -- Armazena o valor do registrador em MEM[11] (dezena segundo)
tmp(52) := STA & R2 & '1' & x"21";   -- Armazena o valor do registrador em HEX1
tmp(53) := JMP & R0 & '0' & x"1E";   --pula para a linha 30

-------- Conta os minutos -------------------------
-- Unidade dos Minutos
tmp(54) := LDA & R3 & '0' & x"0C";   -- Carrega o registrador com MEM[12]
tmp(55) := CEQ & R3 & '0' & x"09";   -- Se o registrador for igual a 9
tmp(56) := JEQ & R0 & '0' & x"44";   --pula para a linha 68

tmp(57) := LDI & R1 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(58) := STA & R1 & '0' & x"0A";   -- Armazena o valor do registrador em MEM[10] (unidade segundo)
tmp(59) := STA & R1 & '1' & x"20";   -- Armazena o valor do registrador em HEX0

tmp(60) := LDI & R2 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(61) := STA & R2 & '0' & x"0B";   -- Armazena o valor do registrador em MEM[11] (dezena segundo)
tmp(62) := STA & R2 & '1' & x"21";   -- Armazena o valor do registrador em HEX1

tmp(63) := LDA & R3 & '0' & x"0C";   -- Carrega o registrador com MEM[12]
tmp(64) := SOMA & R3 & '0' & x"01";   -- R3 = R3 + MEM[1]
tmp(65) := STA & R3 & '0' & x"0C";   -- Armazena o valor do registrador em MEM[12] (unidade minuto)
tmp(66) := STA & R3 & '1' & x"22";   -- Armazena o valor do registrador em HEX2
tmp(67) := JMP & R0 & '0' & x"1E";   --pula para a linha 30

-- Dezenas dos Minutos
tmp(68) := LDA & R4 & '0' & x"0D";   -- Carrega o registrador com MEM[13]
tmp(69) := CEQ & R4 & '0' & x"05";   -- Se o registrador for igual a 5
tmp(70) := JEQ & R0 & '0' & x"55";   --pula para a linha 85

tmp(71) := LDI & R1 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(72) := STA & R1 & '0' & x"0A";   -- Armazena o valor do registrador em MEM[10] (unidade segundo)
tmp(73) := STA & R1 & '1' & x"20";   -- Armazena o valor do registrador em HEX0

tmp(74) := LDI & R2 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(75) := STA & R2 & '0' & x"0B";   -- Armazena o valor do registrador em MEM[11] (dezena segundo)
tmp(76) := STA & R2 & '1' & x"21";   -- Armazena o valor do registrador em HEX1

tmp(77) := LDI & R3 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(78) := STA & R3 & '0' & x"0C";   -- Armazena o valor do registrador em MEM[12] (unidade minuto)
tmp(79) := STA & R3 & '1' & x"22";   -- Armazena o valor do registrador em HEX2

tmp(80) := LDA & R4 & '0' & x"0D";   -- Carrega o registrador com MEM[13]
tmp(81) := SOMA & R4 & '0' & x"01";   -- R4 = R4 + MEM[1]
tmp(82) := STA & R4 & '0' & x"0D";   -- Armazena o valor do registrador em MEM[13] (dezena minuto)
tmp(83) := STA & R4 & '1' & x"23";   -- Armazena o valor do registrador em HEX3
tmp(84) := JMP & R0 & '0' & x"1E";   --pula para a linha 30

-------- Conta as Horas -------------------------
-- Unidade das Horas
tmp(85) := LDA & R5 & '0' & x"0E";   -- Carrega o registrador com MEM[14]
tmp(86) := CEQ & R5 & '0' & x"09";   -- Se o registrador for igual a 9
tmp(87) := JEQ & R0 & '0' & x"6C";   --pula para a linha 108

tmp(88) := LDA & R5 & '0' & x"0E";   -- Carrega o registrador com MEM[14]
tmp(89) := CEQ & R5 & '0' & x"03";   -- Se o registrador for igual a 3
tmp(90) := JEQ & R0 & '0' & x"80";   --pula para a linha 128

tmp(91) := LDI & R1 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(92) := STA & R1 & '0' & x"0A";   -- Armazena o valor do registrador em MEM[10] (unidade segundo)
tmp(93) := STA & R1 & '1' & x"20";   -- Armazena o valor do registrador em HEX0

tmp(94) := LDI & R2 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(95) := STA & R2 & '0' & x"0B";   -- Armazena o valor do registrador em MEM[11] (dezena segundo)
tmp(96) := STA & R2 & '1' & x"21";   -- Armazena o valor do registrador em HEX1

tmp(97) := LDI & R3 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(98) := STA & R3 & '0' & x"0C";   -- Armazena o valor do registrador em MEM[12] (unidade minuto)
tmp(99) := STA & R3 & '1' & x"22";   -- Armazena o valor do registrador em HEX2

tmp(100) := LDI & R4 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(101) := STA & R4 & '0' & x"0D";   -- Armazena o valor do registrador em MEM[13] (dezena minuto)
tmp(102) := STA & R4 & '1' & x"23";   -- Armazena o valor do registrador em HEX3

tmp(103) := LDA & R5 & '0' & x"0E";   -- Carrega o registrador com MEM[14]
tmp(104) := SOMA & R5 & '0' & x"01";   -- R5 = R5 + MEM[1]
tmp(105) := STA & R5 & '0' & x"0E";   -- Armazena o valor do registrador em MEM[14] (unidade hora)
tmp(106) := STA & R5 & '1' & x"24";   -- Armazena o valor do registrador em HEX4
tmp(107) := JMP & R0 & '0' & x"1E";   --pula para a linha 30

-- Dezena das Horas
-- LDA R6, @15   -- Carrega o registrador com MEM[15]
-- CEQ R6, @2    -- Se o registrador for igual a 2
-- JEQ @VERIFICA_4

tmp(108) := LDI & R1 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(109) := STA & R1 & '0' & x"0A";   -- Armazena o valor do registrador em MEM[10] (unidade segundo)
tmp(110) := STA & R1 & '1' & x"20";   -- Armazena o valor do registrador em HEX0

tmp(111) := LDI & R2 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(112) := STA & R2 & '0' & x"0B";   -- Armazena o valor do registrador em MEM[11] (dezena segundo)
tmp(113) := STA & R2 & '1' & x"21";   -- Armazena o valor do registrador em HEX1

tmp(114) := LDI & R3 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(115) := STA & R3 & '0' & x"0C";   -- Armazena o valor do registrador em MEM[12] (unidade minuto)
tmp(116) := STA & R3 & '1' & x"22";   -- Armazena o valor do registrador em HEX2

tmp(117) := LDI & R4 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(118) := STA & R4 & '0' & x"0D";   -- Armazena o valor do registrador em MEM[13] (dezena minuto)
tmp(119) := STA & R4 & '1' & x"23";   -- Armazena o valor do registrador em HEX3

tmp(120) := LDI & R5 & '0' & x"00";   -- Carrega o registrador com o valor zero
tmp(121) := STA & R5 & '0' & x"0E";   -- Armazena o valor do registrador em MEM[14] (unidade hora)
tmp(122) := STA & R5 & '1' & x"24";   -- Armazena o valor do registrador em HEX4

tmp(123) := LDA & R6 & '0' & x"0F";   -- Carrega o registrador com MEM[15]
tmp(124) := SOMA & R6 & '0' & x"01";   -- R6 = R6 + MEM[1]
tmp(125) := STA & R6 & '0' & x"0F";   -- Armazena o valor do registrador em MEM[14] (unidade hora)
tmp(126) := STA & R6 & '1' & x"25";   -- Armazena o valor do registrador em HEX5
tmp(127) := JMP & R0 & '0' & x"1E";   --pula para a linha 30

tmp(128) := LDA & R6 & '0' & x"0F";   -- Carrega o registrador com MEM[14]
tmp(129) := CEQ & R6 & '0' & x"02";   -- Se o registrador for igual a 2
tmp(130) := JEQ & R0 & '0' & x"00";   --pula para a linha 0
tmp(131) := JMP & R0 & '0' & x"5B";   --pula para a linha 91
        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;