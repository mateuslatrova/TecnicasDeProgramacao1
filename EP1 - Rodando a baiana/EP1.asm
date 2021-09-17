# Os registradores $f1-f8 foram usados como argumentos de função.
# Já os registradores $f9-f10 foram usados para o retorno de funções.
# Registradores $f11-$f15 foram usados como permanentes.
# Registradores $f16-$f20 foram usados como temporários.

# TODO: exemplo de chamada da função rotaciona(v.theta)

.data
#R: .space 16 # alocação de um vetor de 4 elementos, que representará a matriz R(de rotação) 2x2
v: .space 8 # alocação do vetor v que será rotacionado.
i: .word 0 # índice do vetor 
x: .float # abscissa de v
y: .float # ordenada de v
theta: .float # ângulo de rotação
PI: .float 3.1415

.text

# Função principal, a qual realiza diversos testes unitários para
# verificação do funcionamento do programa.
main:      lwc1 $f11, PI # constante PI
           la $f12, v
           lw $s0, i
           
           
           lwc1 $f1, 4.0
           lwc1 $f2, 0.0
           lwc1 $f3, $f11
           jal testeUnitario
           
           lwc1 $f1, 0.0
           lwc1 $f2, 7.0
           lwc1 $f3, $f11
           lwc1 $f16, 2.0
           div.s $f3, $f3, $f16
           jal testeUnitario
           
           lwc1 $f1, 1.0
           lwc1 $f2, 0.5
           lwc1 $f3, $f11
           lwc1 $f16, 4.0
           lwc1 $f17, 3.0
           mul.s $f3, $f3, $f16
           div.s $f3, $f3, $f17
           jal testeUnitario
           
           lwc1 $f1, -1.0
           lwc1 $f2, -2.0
           lwc1 $f3, $f11
           lwc1 $f16, 6.0
           div.s $f3, $f3, $f16
           jal testeUnitario
           
           j fim
         
testeUnitario:               
      
rotaciona:
           
matrizDeRotacao:

multiplicaMatrizVetor: 

sen: 

cos:

fatorial:

potencia:

fim:
