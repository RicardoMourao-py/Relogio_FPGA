# Relogio_FPGA
Projeto consiste em implementar funcionalidades de um relógio na FPGA.

## Funcionalidades da Placa
- Contagem das 24h do dia;
- Botão KEY3 de Acelerar os segundos (serve para teste);
- Botão para resetar a contagem;
- Botão KEY2 para fazer ajuste da hora com a leitura das chaves.

## Enderaçamento
- Botão KEY0 (limpeza 511) e KEY1 (limpeza 510) foram usados para endereçar a leitura dos segundos, um de forma rapida e outro de forma adequada. Portanto, foi instanciado duas interfaces de base tempo pra tal feito;
- Botão KEY2 utiliza o endereço 509 para a limpeza.

## Debounce
- KEY2, apenas, utiliza debounce.
