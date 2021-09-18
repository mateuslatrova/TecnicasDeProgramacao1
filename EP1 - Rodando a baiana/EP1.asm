########### EP1 - Rodando a baiana ##############

# Dupla:
# Mateus Latrova Stephanin - NUSP 12542821
# Guilherme Mota Pereira - NUSP ...

#### Convenções utilizadas ####

# O registrador $f0 foi usado como valor de retorno.
# Já os registradores $f1-f5 foram usados como valores permanentes.
# Além disso, $f6-$f10 foram usados como valores temporários.
# Por fim, os registradores $f12-$f13 foram usados como argumento para as funções.

# TODO: exemplo de chamada da função rotaciona(v.theta)!

.data
R: .space 16 # alocação de um vetor de 4 elementos, que representará a matriz R(de rotação) 2x2
v: .space 8 # alocação do vetor v que será rotacionado.
vRotacionado: .space 8 # alocação do vetor v rotacionado por um ângulo theta.
i: .word 0 # índice do vetor 
theta: .float # ângulo de rotação
PI: .float 3.1415
nLinhas: .word 2
nCols: .word 2

.text

# Função principal, a qual realiza diversos testes unitários para verificação do funcionamento do programa.
main:      lwc1  $f1, PI # constante PI
           la    $a0, v
           la    $s0, R
           la    $s1, vRotacionado

           # 1o teste: v = (4,0) e theta = PI
           lwc1  $f1, 4.0
           sw    $f1, 0($a0)
           lwc1  $f2, 0.0
           sw    $f2, 4($a0)
           lwc1  $f3, $f1 
           jal   testeUnitario
           
           # 2o teste: v = (0,7) e theta = PI/2
           lwc1  $f1, 0.0
           sw    $f1, 0($a0)
           lwc1  $f2, 7.0
           sw    $f2, 4($a0)
           lwc1  $f3, $f11
           lwc1  $f16, 2.0
           div.s $f3, $f3, $f16
           jal   testeUnitario
           
           # 3o teste: v = (1, 0.5) e theta = 4*PI/3
           lwc1  $f1, 1.0
           sw    $f1, 0($a0)
           lwc1  $f2, 0.5
           sw    $f1, 4($a0)
           lwc1  $f3, $f11
           lwc1  $f16, 4.0
           lwc1  $f17, 3.0
           mul.s $f3, $f3, $f16
           div.s $f3, $f3, $f17
           jal   testeUnitario
           
           # 4o teste: v = (-1, -2) e theta = PI/6
           lwc1  $f1, -1.0
           sw    $f1, 0($a0)
           lwc1  $f2, -2.0
           sw    $f2, 4($a0)
           lwc1  $f3, $f11
           lwc1  $f16, 6.0
           div.s $f3, $f3, $f16
           jal   testeUnitario
           
           # return 0:
           li    $v0, 0
           j     fim
         
# Função que testa a função rotaciona implementada mais abaixo, mostrando também o resultado da rotação.
# - Entrada: $a0(ponteiro para o início do vetor) e $f12(ângulo de rotação em radianos)
# - Saída: nenhuma(função do tipo void)
testeUnitario:   

           # Rotacionar vetor
           jal   rotaciona

           # Imprimir o vetor rotacionado                        
           li    $v0, 2
           lwc1  $f12, 0($a0)
           syscall
           
           li    $a0, ' '
           li    $v0, 11
           syscall
           
           li    $v0, 2
           lwc1  $f12, 4($a0)
           syscall
           
           li    $a0, ' '
           li    $v0, 11
           syscall
           
           jr    $ra
          
# Função que realiza a rotação de um vetor por um dado ângulo.
# - Entrada: $a0(ponteiro para o início do vetor) e $f12(ângulo de rotação em radianos)
# - Saída: $v0(ponteiro para o início do vetor rotacionado)
rotaciona:

           # Montar a matriz de rotação e armazená-la em R:
           jal   matrizDeRotacao
           la    $t1, R
           
           la    $a0, R
           la    $a1, v
           jal   multiplicaMatrizVetor # coloca o endereço do vetor rotacionado em $v0
           
           jr    $ra
    
# Função que monta a matriz de rotação para um dado ângulo.
# - Entrada: $f12(ângulo de rotação em radianos)    
# - Saída: $v0(ponteiro para o início da matriz)
matrizDeRotacao:
           
           jal   seno
           move  $f6, $f0
           
           jal   cosseno
           move  $f7, $f0
           
           move  $f8, $f6 # seno
           mul.s $f8, $f8, -1 # -seno
          
           sw    $f7, 0($s0)
           sw    $f8, 4($s0)          
           sw    $f6, 8($s0)           
           sw    $f7, 12($s0)
           
           la    $v0, $s0
           
           jr    $ra

# Função que realiza a multiplicação de uma matriz(à esquerda) por um vetor(à direita).
# - Entrada: $a0(ponteiro para o início da matriz) e $a1(ponteiro para o início do vetor)
# - Saída: $v0(ponteiro para o início do vetor resultado da multiplicação)
multiplicaMatrizVetor: 

           # Inicializar o vetor rotacionado:
           sw $zero, 0($s1)
           sw $zero, 4($s1)
           
           # Realizar a multiplicação com 2 loops aninhados:
           sw $zero, $s0 # i = 0
           sw $zero, $s1 # j = 0
           
loopi:     bge $s0, nLinhas, endloopi  
           
loopj:     bge $s1, nCols, endloopj
           
           add $t0, $s0, $s0           
           add $t0, $t0, $t0 # $t0 = 4 * i
           
           add $t1, $s1, $s1           
           add $t1, $t1, $t1 # $t0 = 4 * j
           
           # endereço de vRotacionado está em $s0
           # fazer i*nCols+j
           mul $t2, $t0, nCols # $t2 = i*nCols
           add $t2, $t2, $t1 # $t2 = i*nCols + j
           
           lw $f6, $t2($a0) # $f6 = R[i*nCols+j]
           lw $f7, $t1($a1) # $f7 = v[j]
           mul.s $f8, $f6, $f7 # $f8 = R[i*nCols+j]
           
           lw $f9, $t0($s0) # $f9 = vRotacionado[i]
           
           add.s $f8, $f8, $f9 # $f8 = vRotacionado[i] + R[i*nCols+j]*v[j]
           
           sw $f8, $t0($s0)
           
           addi $s1, 1
           
           j loopj
            
endloopj:  addi $s0, 1
 
endloopi:           
     
              
seno: 

cosseno:

fatorial:

potencia:

fim:
