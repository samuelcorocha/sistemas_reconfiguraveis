# Projeto de Recriação do Microcontrolador PIC16F648A

Este projeto visa recriar o microcontrolador PIC16F648A na plataforma Cyclone II usando o software Quartus II (versão 9.1sp2). Ambos os projetos foram configurados para funcionar com a placa Terasic DE2, utilizando o FPGA Cyclone II (EP2C35F672C6).

## Requisitos

- Software Quartus II, versão 9.1sp2
- Placa Terasic DE2 com FPGA Cyclone II (EP2C35F672C6)

Recomenda-se utilizar o mesmo hardware e software para evitar possíveis incompatibilidades.

## Estrutura do Repositório

O repositório está organizado da seguinte forma:

```bash
|-- src
| |-- Addr_mux
| |-- ALU
| |-- Control
| |-- FSR_reg
| |-- PC_reg
| |-- PIC16F648A
| |-- Port_io
| |-- RAM_mem
| |-- Stack
| |-- Status_reg
| |-- W_reg
```

Dentro da pasta "src," você encontrará subpastas correspondentes a cada módulo do projeto, utilizados no Quartus II. Aqui está uma breve descrição de cada um deles:

- **Addr_mux:** Módulo para seleção de endereço.
- **ALU:** Unidade Lógica Aritmética.
- **Control:** Módulo de controle do microcontrolador.
- **FSR_reg:** Registrador para o registrador de status do microcontrolador.
- **PC_reg:** Registrador de Contador de Programa.
- **PIC16F648A:** Módulo principal representando o microcontrolador recriado.
- **Port_io:** Módulo para entrada/saída de portas.
- **RAM_mem:** Módulo de memória RAM.
- **Stack:** Implementação da pilha.
- **Status_reg:** Registrador de Status.
- **W_reg:** Registrador de trabalho.

## Instruções de Uso

1. Clone o repositório para o seu ambiente de desenvolvimento.
2. Abra os projetos no Quartus II.
3. Configure os projetos para a placa Terasic DE2 com o FPGA Cyclone II (EP2C35F672C6).
4. Compile os projetos no Quartus II.
5. Carregue o bitstream gerado na placa Terasic DE2.

Certifique-se de seguir as práticas recomendadas para garantir uma implementação bem-sucedida.

**Nota:** Este projeto foi desenvolvido e testado na versão 9.1sp2 do Quartus II com a placa Terasic DE2 usando o FPGA Cyclone II (EP2C35F672C6). Utilizar versões diferentes do software ou hardware pode levar a incompatibilidades.

## Contribuições

Contribuições são bem-vindas! Sinta-se à vontade para abrir problemas (issues) ou enviar pull requests para melhorar este projeto.
