########### EP1 - Rodando a baiana #############

# Dupla:
# Mateus Latrova Stephanin - NUSP 12542821
# Guilherme Mota Pereira - NUSP 12543307

#### Convenções utilizadas ####

# - Em relação aos registradores de float:
# O registrador $f0 foi usado como valor de retorno.
# Já os registradores $f1-f5 foram usados como valores permanentes.
# Além disso, $f6-$f10 foram usados como valores temporários.
# Por fim, os registradores $f12-$f13 foram usados como argumento para as funções.

# - Em relação ao empilhamento/desempilhamento na chamada de funções:
# Empilhamos os valores dos registradores de variáveis temporárias, de argumento e de retorno 
# sempre na função chamadora. Já os valores registradores de variáveis permanentes e de ende-
# reço de retorno foram empilhados na função chamada. Essa convenção foi retirada do seguinte
# conjunto de slides: https://courses.cs.washington.edu/courses/cse378/10sp/lectures/lec05-new.pdf

# - Em relação aos demais registradores:
# Foram utilizados segundo as convenções padrão do MIPS.

.data
R: .space 16 # alocação de um vetor de 4 elementos, que representará a matriz R(de rotação) 2x2
v: .space 8 # alocação do vetor v que será rotacionado.
vRotacionado: .space 8 # alocação do vetor v rotacionado por um ângulo theta.
PI: .float 3.1415
nLinhas: .word 2
nCols: .word 2

.text

# Função principal, a qual realiza diversos testes unitários para verificação do funcionamento do programa.
principal:      
           lwc1  $f1, PI # constante PI
           la    $a0, v
           la    $s0, R
           la    $s1, vRotacionado

           #### 1o teste: v = (4,0) e theta = PI ####
           lwc1  $f6, 4.0
           sw    $f6, 0($a0)
           lwc1  $f7, 0.0
           sw    $f7, 4($a0)
           lwc1  $f12, $f1 
           
           sub   $sp, $sp, 16  # ajuste do sp para empilhar $a0, $f6, $f7, $f12
           # Empilhando variáveis:
           sw    $a0, 12($sp)
           sw    $f6, 8($sp)
           sw    $f7, 4($sp)
           sw    $f12, 0($sp)
           
           jal   testeUnitario
           
           # Desempilhando variáveis:
           lw    $f12, 0($sp)
           lw    $f7, 4($sp)
           lw    $f6, 8($sp)
           lw    $a0, 12($sp)
           add   $sp, $sp, 16
           
           #### 2o teste: v = (0,7) e theta = PI/2 ####
           lwc1  $f6, 0.0
           sw    $f6, 0($a0)
           lwc1  $f7, 7.0
           sw    $f7, 4($a0)
           lwc1  $f12, $f1
           div.s $f12, $f12, 2.0
           
           sub   $sp, $sp, 16  # ajuste do sp para empilhar $a0, $f6, $f7, $f12
           
           # Empilhando variáveis:
           sw    $a0, 12($sp)
           sw    $f6, 8($sp)
           sw    $f7, 4($sp)
           sw    $f12, 0($sp)
           
           jal   testeUnitario
           
           # Desempilhando variáveis:
           lw    $f12, 0($sp)
           lw    $f7, 4($sp)
           lw    $f6, 8($sp)
           lw    $a0, 12($sp)
           add   $sp, $sp, 16
           
           #### 3o teste: v = (1, 0.5) e theta = 4*PI/3 ####
           lwc1  $f6, 1.0
           sw    $f6, 0($a0)
           lwc1  $f7, 0.5
           sw    $f7, 4($a0)
           lwc1  $f12, $f1
           mul.s $f12, $f12, 4.0
           div.s $f12, $f12, 3.0
           
           sub   $sp, $sp, 16  # ajuste do sp para empilhar $a0, $f6, $f7, $f12
           
           # Empilhando variáveis:
           sw    $a0, 12($sp)
           sw    $f6, 8($sp)
           sw    $f7, 4($sp)
           sw    $f12, 0($sp)
           
           jal   testeUnitario
           
           # Desempilhando variáveis:
           lw    $f12, 0($sp)
           lw    $f7, 4($sp)
           lw    $f6, 8($sp)
           lw    $a0, 12($sp)
           add   $sp, $sp, 16
           
           #### 4o teste: v = (-1, -2) e theta = PI/6 ####
           lwc1  $f6, -1.0
           sw    $f6, 0($a0)
           lwc1  $f7, -2.0
           sw    $f7, 4($a0)
           lwc1  $f12, $f1
           div.s $f12, $f12, 6.0
           
           sub   $sp, $sp, 16  # ajuste do sp para empilhar $a0, $f6, $f7, $f12
           
           # Empilhando variáveis:
           sw    $a0, 12($sp)
           sw    $f6, 8($sp)
           sw    $f7, 4($sp)
           sw    $f12, 0($sp)
           
           jal   testeUnitario
           
           # Desempilhando variáveis:
           lw    $f12, 0($sp)
           lw    $f7, 4($sp)
           lw    $f6, 8($sp)
           lw    $a0, 12($sp)
           add   $sp, $sp, 16
           
           # Fim da função principal, retorne 0.
           li    $v0, 0
           j     fim
         
# Função que testa a função rotaciona implementada mais abaixo, mostrando também o resultado da rotação.
# - Entrada: $a0(ponteiro para o início do vetor) e $f12(ângulo de rotação em radianos)
# - Saída: nenhuma(função do tipo void)
testeUnitario:   

           sub   $sp, $sp, 12  # ajuste do sp para empilhar $a0, $f12 e $ra.
           
           # Empilhar variáveis:
           sw    $ra, 8($sp)
           sw    $a0, 4($sp)
           sw    $f12, 0($sp)
           
           # Rotacionar vetor
           jal   rotaciona
           
           # Desempilhar variáveis:
           lw    $f12, 0($sp)
           lw    $a0, 4($sp)
           lw    $ra, 8($sp)
           
           add   $sp, $sp, 12 # ajuste do sp para desempilhar $a0, $f12 e $ra.
           
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
           
           # Volta à função chamadora
           jr    $ra
          
# Função que realiza a rotação de um vetor por um dado ângulo.
# - Entrada: $a0(ponteiro para o início do vetor) e $f12(ângulo de rotação em radianos)
# - Saída: $v0(ponteiro para o início do vetor rotacionado)
rotaciona:
           
           #### Gerar a matriz de rotação ####
           
           sub   $sp, $sp, 24  # ajuste do sp para empilhar $f6, $f7, $f8, $f12, $v0 e $ra.
           
           # Empilhar variáveis:
           sw    $ra, 20($sp)
           sw    $f6, 16($sp)
           sw    $f7, 12($sp)
           sw    $f8, 8($sp)
           sw    $f12, 4($sp)
           sw    $v0, 0($sp)           
           
           # Montar a matriz de rotação e armazená-la em R:
           jal   matrizDeRotacao
           
           # Desempilhar variáveis:
           lw    $v0, 0($sp)
           lw    $f12, 4($sp)
           lw    $f8, 8($sp)
           lw    $f7, 12($sp)
           lw    $f6, 16($sp)  
           lw    $ra, 20($sp)         
           
           add   $sp, $sp, 24 # ajuste do sp para desempilhar $f6, $f7, $f8, $f12, $v0 e $ra.
           
           #### Multiplicação ####
           
           sub   $sp, $sp, 24  # ajuste do sp para empilhar $ra, $a0, $a1, $f6, $f7, e $f8.
           
           # Empilhar variáveis:
           sw    $ra, 20($sp)
           sw    $a0, 16($sp)
           sw    $a1, 12($sp)
           sw    $f6, 8($sp)
           sw    $f7, 4($sp)
           sw    $f8, 0($sp)  
           
           la    $a0, R
           la    $a1, v
           jal   multiplicaMatrizVetor # coloca o endereço do vetor rotacionado em $v0
           
           # Desempilhar variáveis:
           lw    $ra, 0($sp)
           lw    $a0, 4($sp)
           lw    $a1, 8($sp)
           lw    $f6, 12($sp)
           lw    $f7, 16($sp)  
           lw    $f8, 20($sp)         
           
           add   $sp, $sp, 24 # ajuste do sp para desempilhar $ra, $a0, $a1, $f6, $f7, e $f8.
           
           la    $v0, $s0 # ponteiro para o início da matriz.
           jr    $ra
    
# Função que monta a matriz de rotação para um dado ângulo.
# - Entrada: $f12(ângulo de rotação em radianos)    
# - Saída: $v0(ponteiro para o início da matriz)
matrizDeRotacao:
           
           #### Calcular o seno de theta ####
           
           # TODO: terminar quando juntar com o código do Gui.
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

           # Empilhar variáveis:
           sub   $sp, $sp, 8  # ajuste do sp para empilhar $s0 e $s1.
           
           # Empilhar variáveis:
           sw    $s0, 4($sp)
           sw    $s1, 0($sp)

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
 
endloopi:  la $v0, $s1
           
           # Desempilhar variáveis usadas:
           lw    $s1, 0($sp)  
           lw    $s0, 4($sp)         
           
           add   $sp, $sp, 8 # ajuste do sp para desempilhar $s0 e $s1.
           
           jr $ra 
     
              
seno: 

cosseno:

fatorial:

potencia:

fim:
