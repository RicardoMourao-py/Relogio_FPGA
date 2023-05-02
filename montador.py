# abre o arquivo "exemplo.txt" para leitura
arquivo = open("C:/DESCOMP/RELOGIO_FPGA/input/input.txt", "r")

# lê todas as linhas do arquivo
linhas = arquivo.readlines()

# Converte decimal para hexadecimal
def dec_to_hex(num):
    hex_num = hex(num)[2:].upper() # converte para hexadecimal e remove o prefixo "0x"
    hex_num = hex_num.zfill(3) # preenche com zeros à esquerda até ter três dígitos
    return hex_num

# limpa instruções do arquivo e guarda
armazena_labels = {}
cont=0
for i in linhas:
    linha = i.replace('\n', '')
    # Verifica se a linha é um comentario ou espaço em branco
    if len(linha)==0 or linha[0]=='-':
        pass
    # Verifica se a linha é uma label
    elif linha[-1] == ":":
        # Guarda label e seu endereço
        armazena_labels[linha[:-1]]=cont
    # Verifica instrução
    else:
        cont+=1

cont=0
for i in linhas:
    linha = i.replace('\n', '')
    # Verifica se a linha é um comentario ou espaço em branco
    if len(linha)==0 or linha[0]=='-':
        print(linha)
    # Verifica se a linha é uma label
    elif linha[-1] == ":":
        pass
    # Verifica instrução
    else:
        instrucao, reg_label = linha.split(',')[0].split(' ')[0], linha.split(',')[0].split(' ')[1]
        resultado = f'temp({cont}) := {instrucao} & '

        # verificar se reg_label é registrador ou label
        if reg_label[0] == 'R':
            resultado += f'{reg_label} & '
        
        if reg_label[0] == '@':
            # converte endereço da label e NAO ACEITA COMENTARIOS
            conv = dec_to_hex(armazena_labels[reg_label[1:]])
            resultado = f"temp({cont}) := {instrucao} & R0 & '{conv[0]}' & x\"{conv[1:]}\";   --pula para a linha {armazena_labels[reg_label[1:]]}"
        
        if reg_label[0] != '@' and reg_label[0] == 'R':
            # OBRIGATORIO TER COMENTARIOS EM CADA INSTRUCAO
            comentario=linha.split(',')[1].split('--')[1]
            valor=linha.split(',')[1].split('--')[0].replace(' ','')[1:]
            conv = dec_to_hex(int(valor))
            resultado += f"'{conv[0]}' & x\"{conv[1:]}\";   --{comentario}"
        print(resultado)
        cont+=1

# fecha o arquivo
arquivo.close()