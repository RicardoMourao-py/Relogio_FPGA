library ieee;
use ieee.std_logic_1164.all;

entity logicaDesvio is
  -- Total de bits das entradas e saidas
  port (
	 JMP, RET, JSR, JEQ, JLT: in std_logic;
	 Flag_igual, Flag_menor: in std_logic;
    saida_Desvio : out std_logic_vector (1 downto 0)
  );
end entity;

architecture comportamento of logicaDesvio is
  begin
		saida_Desvio <= RET & ((JEQ and Flag_igual) or JMP or JSR or (JLT and Flag_menor));
end architecture;