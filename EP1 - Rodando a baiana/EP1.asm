########### EP1 - Rodando a baiana #############

# Dupla:
# Mateus Latrova Stephanin - NUSP 12542821
# Guilherme Mota Pereira - NUSP 12543307

#### Convenções utilizadas ####

# - Em relação aos registradores de float:
# O registrador $f0 foi usado como valor de retorno.
# Já os registradores $f1-$f5 foram usados como valores permanentes.
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

# Variáveis globais:
R:             .space   16 # alocação de um vetor de 4 elementos, que representará a matriz R(de rotação) 2x2
v:             .space   8 # alocação do vetor v que será rotacionado.
v_rotacionado: .space   8 # alocação do vetor v rotacionado por um ângulo theta.
n_linhas:      .word    2 # número de linhas da matriz
n_cols:        .word    2 # número de colunas da matriz
menos_um:      .float  -1.0
angulo:        .float 150.0 # [-90,90]
pi:            .float 3.1416 # constante que representa o número irracional PI
cte_1e_min_4:  .float 0.0001
 
# Variáveis usadas para auxiliar nos testes realizados na função principal
# (x é a abscissa do vetor, y é a sua ordenada e theta é o ângulo de rotação):
teste1_x:      .float  4.0
teste1_y:      .float  0.0
teste1_theta:  .float  180.0 # graus

teste2_x:      .float  0.0
teste2_y:      .float  7.0
teste2_theta:  .float  90.0 # graus

teste3_x:      .float  1.0
teste3_y:      .float  2.0
teste3_theta:  .float  240.0 # graus

teste4_x:      .float  0.0
teste4_y:      .float -2.0
teste4_theta:  .float  30.0 # graus

.text

# Função principal, a qual realiza diversos testes unitários para verificação do funcionamento do programa.
principal: li    $t7, -1
           mtc1  $t7, $f28
           cvt.s.w $f28, $f28
           la    $a0,  v
           la    $s0,  R
           la    $s1,  v_rotacionado
           lw    $s2,  n_linhas
           lw    $s3,  n_cols
           
           #### 1o teste: v = (4,0) e theta = PI ####
           l.s   $f6,  teste1_x
           s.s   $f6,  0($a0)
           l.s   $f7,  teste1_y
           s.s   $f7,  4($a0)
           l.s   $f12, teste1_theta 
           
           sub   $sp,  $sp,  16  # ajuste do sp para empilhar $a0, $f6, $f7, $f12
          
            # Empilhando variáveis:
           sw    $a0,  12($sp)
           s.s   $f6,  8($sp)
           s.s   $f7,  4($sp)
           s.s   $f12, 0($sp)
           
           jal   teste_unitario
           
           # Desempilhando variáveis:
           l.s   $f12, 0($sp)
           l.s   $f7,  4($sp)
           l.s   $f6,  8($sp)
           lw    $a0,  12($sp)
           
           add   $sp,  $sp,  16  # ajuste do sp para desempilhar $a0, $f6, $f7, $f12
           
           #### 2o teste: v = (0,7) e theta = PI/2 ####
           l.s   $f6,  teste2_x
           s.s   $f6,  0($a0)
           l.s   $f7,  teste2_y
           s.s   $f7,  4($a0)
           l.s   $f12, teste2_theta
           
           sub   $sp,  $sp,  16  # ajuste do sp para empilhar $a0, $f6, $f7, $f12
           
           # Empilhando variáveis:
           sw    $a0,  12($sp)
           s.s   $f6,  8($sp)
           s.s   $f7,  4($sp)
           s.s   $f12, 0($sp)
           
           jal   teste_unitario
           
           # Desempilhando variáveis:
           l.s   $f12, 0($sp)
           l.s   $f7,  4($sp)
           l.s   $f6,  8($sp)
           lw    $a0,  12($sp)
           add   $sp,  $sp,  16
           
           #### 3o teste: v = (1, 2) e theta = 4*PI/3 ####
           l.s   $f6,  teste3_x
           s.s   $f6,  0($a0)
           l.s   $f7,  teste3_y
           s.s   $f7,  4($a0)
           l.s   $f12, teste3_theta
           
           sub   $sp, $sp, 16  # ajuste do sp para empilhar $a0, $f6, $f7, $f12
           
           # Empilhando variáveis:
           sw    $a0,  12($sp)
           s.s   $f6,  8($sp)
           s.s   $f7,  4($sp)
           s.s   $f12, 0($sp)
           
           jal   teste_unitario
           
           # Desempilhando variáveis:
           l.s   $f12, 0($sp)
           l.s   $f7,  4($sp)
           l.s   $f6,  8($sp)
           lw    $a0,  12($sp)
           add   $sp,  $sp,  16
           
           #### 4o teste: v = (0, -2) e theta = PI/6 ####
           l.s   $f6,  teste4_x
           s.s   $f6,  0($a0)
           l.s   $f7,  teste4_y
           s.s   $f7,  4($a0)
           l.s   $f12, teste4_theta
           
           sub   $sp,  $sp,  16  # ajuste do sp para empilhar $a0, $f6, $f7, $f12
           
           # Empilhando variáveis:
           sw    $a0,  12($sp)
           s.s   $f6,  8($sp)
           s.s   $f7,  4($sp)
           s.s   $f12, 0($sp)
           
           jal   teste_unitario
           
           # Desempilhando variáveis:
           l.s   $f12, 0($sp)
           l.s   $f7,  4($sp)
           l.s   $f6,  8($sp)
           lw    $a0,  12($sp)
          
           add   $sp,  $sp,  16
           
           # Terminar o programa.
           li $v0, 10
           syscall
         
# Função que testa a função rotaciona implementada mais abaixo, mostrando também o resultado da rotação.
# - Entrada: $a0(ponteiro para o início do vetor) e $f12(ângulo de rotação em radianos)
# - Saída: nenhuma(função do tipo void)
teste_unitario:   

           sub   $sp,  $sp,  12  # ajuste do sp para empilhar $a0, $f12 e $ra.
           
           # Empilhar variáveis:
           sw    $ra,  8($sp)
           sw    $a0,  4($sp)
           s.s   $f12, 0($sp)
           
           # Rotacionar vetor
           jal   rotaciona
           
           # Desempilhar variáveis:
           l.s   $f12, 0($sp)
           lw    $a0,  4($sp)
           lw    $ra,  8($sp)
           
           add   $sp,  $sp,  12 # ajuste do sp para desempilhar $a0, $f12 e $ra.
           
           # Imprimir o vetor rotacionado   
           
           sub   $sp,  $sp,  4
           sw    $a0,  0($sp)                     
                                                                          
           li    $v0,  2
           lwc1  $f12, 0($s1)
           syscall
           
           li    $a0,  ' '
           li    $v0,  11
           syscall
           
           li    $v0,  2
           lwc1  $f12, 4($s1)
           syscall
           
           li    $a0,  ' '
           li    $v0,  11
           syscall
           
           li    $a0,  '\n'
           li    $v0,  11
           syscall
           
           lw    $a0,  0($sp)
           add   $sp,  $sp,  4 
           
           # Voltar à função chamadora
           jr    $ra
          
# Função que realiza a rotação de um vetor por um dado ângulo.
# - Entrada: $a0(ponteiro para o início do vetor) e $f12(ângulo de rotação em radianos)
# - Saída: $v0(ponteiro para o início do vetor rotacionado)
rotaciona:
           
           #### Gerar a matriz de rotação ####
           
           sub   $sp,  $sp,  24  # ajuste do sp para empilhar $f6, $f7, $f8, $f12, $v0 e $ra.
           
           # Empilhar variáveis:
           sw    $ra,  20($sp)
           s.s   $f6,  16($sp)
           s.s   $f7,  12($sp)
           s.s   $f8,  8($sp)
           s.s   $f12, 4($sp)
           sw    $v0,  0($sp)           
           
           # Montar a matriz de rotação e armazená-la em R:
           jal   matriz_de_rotacao
           
           # Desempilhar variáveis:
           lw    $v0,  0($sp)
           l.s   $f12, 4($sp)
           l.s   $f8,  8($sp)
           l.s   $f7,  12($sp)
           l.s   $f6,  16($sp)  
           lw    $ra,  20($sp)         
           
           add   $sp,  $sp,  24 # ajuste do sp para desempilhar $f6, $f7, $f8, $f12, $v0 e $ra.
           
           #### Multiplicação da matriz de rotação pelo vetor ####
           
           sub   $sp,  $sp,  24  # ajuste do sp para empilhar $ra, $a0, $a1, $f6, $f7, e $f8.
           
           # Empilhar variáveis:
           sw    $ra,  20($sp)
           sw    $a0,  16($sp)
           sw    $a1,  12($sp)
           s.s   $f6,  8($sp)
           s.s   $f7,  4($sp)
           s.s   $f8,  0($sp)  
           
           la    $a0,  R
           la    $a1,  v
           jal   mult_matriz_vetor # coloca o endereço do vetor rotacionado em $v0
           
           # Desempilhar variáveis:
           l.s   $f8,  0($sp)
           l.s   $f7,  4($sp)
           l.s   $f6,  8($sp)
           lw    $a1,  12($sp)
           lw    $a0,  16($sp)  
           lw    $ra,  20($sp)         
           
           add   $sp,  $sp,  24 # ajuste do sp para desempilhar $ra, $a0, $a1, $f6, $f7, e $f8.
           
           la    $v0,  v_rotacionado
           jr    $ra
    
# Função que monta a matriz de rotação para um dado ângulo.
# - Entrada: $f12(ângulo de rotação em radianos)    
# - Saída: $v0(ponteiro para o início da matriz)
matriz_de_rotacao:
           
           #### Calcular o seno de theta ####
           
           sub   $sp,  $sp,  16
           
           # Empilhar variáveis:
           sw    $ra,   12($sp)
           s.s   $f6,   8($sp)
           s.s   $f8,   4($sp)
           s.s   $f12,  0($sp)  
           
           jal   seno # argumento $f12
           
           mov.s $f7,  $f0 # $f7 = seno
                
           #mov.s $f12, $f7
           l.s   $f12,  0($sp)
           jal   cosseno  # f12 = seno
           mov.s $f10,  $f0 # $f10 = cosseno
           
           # Desempilhar variáveis:
           l.s   $f12,  0($sp)
           l.s   $f8,   4($sp)
           l.s   $f6,   8($sp)  
           lw    $ra,   12($sp) 
           
           add   $sp,  $sp,  16 # ajuste do sp para desempilhar $ra, $a0, $a1, $f6, $f7, e $f8.
           
           mov.s $f8, $f7 
           mul.s $f8, $f8, $f28 # $f8 = -seno
          
           # Montar a matriz de rotação:
           s.s   $f10,  0($s0)  # R[0] = cosseno
           s.s   $f8,   4($s0)  # R[1] = -seno         
           s.s   $f7,   8($s0)  # R[2] = seno         
           s.s   $f10,  12($s0) # R[3] = cosseno
           
           la    $v0, R
           
           jr    $ra

# Função que realiza a multiplicação de uma matriz(à esquerda) por um vetor(à direita).
# - Entrada: $a0(ponteiro para o início da matriz) e $a1(ponteiro para o início do vetor)
# - Saída: $v0(ponteiro para o início do vetor resultado da multiplicação)
mult_matriz_vetor: 

           # Inicializar o vetor rotacionado:
           sw    $zero, 0($s1)
           sw    $zero, 4($s1)
           
           # Realizar a multiplicação com 2 loops aninhados:
           li    $s4, 0 # i = 0
           li    $s5, 0 # j = 0
           
           # $s2 contém nLinhas(2) e $s3 contém nCols(2)
laço_i:    bge   $s4, $s2, termino_laço_i  # branch if i >= nLinhas
           li    $s5, 0
           
laço_j:    bge   $s5, $s3, termino_laço_j # branch if j >= nCols
           
           add   $t0, $s4, $s4           
           add   $t0, $t0, $t0 # $t0 = 4 * i
           
           add   $t1, $s5, $s5           
           add   $t1, $t1, $t1 # $t0 = 4 * j
           
           # endereço de vRotacionado está em $s1
           mul   $t2, $t0, $s3 # $t2 = 4*i*nCols
           add   $t2, $t2, $t1 # $t2 = 4*i*nCols + 4*j
           
           add   $t3, $t2, $s0 # $t3 = endereço da posição da matriz que queremos acessar
           add   $t4, $t1, $a1 # $t4 = endereço da posição do vetor que queremos acessar
           
           l.s   $f6, ($t3) # $f6 = R[i*nCols+j]
           l.s   $f7, ($t4) # $f7 = v[j]
           mul.s $f8, $f6, $f7 # $f8 = R[i*nCols+j]*v[j]
           
           add   $t5, $t0, $s1
           l.s   $f9, ($t5) # $f9 = vRotacionado[i]
           
           add.s $f8, $f8, $f9 # $f8 = vRotacionado[i] + R[i*nCols+j]*v[j]
           
           s.s   $f8, ($t5)
           
           addi  $s5, $s5, 1
 
           j     laço_j
            
termino_laço_j:  addi  $s4, $s4, 1
                 j     laço_i
 
termino_laço_i:  la    $v0, v_rotacionado
             
                 jr    $ra 
            
# Função que calcula o seno de um argumento em graus do registrador a0
# - Entrada: $f12: float - Ângulo entre 0 e 360º
# - Saída: $f0: float - Valor de sen($f12)
seno: mtc1 $zero, $f10		# f10: valor de 0 em float
      sub $sp, $sp, 8
      sw $ra, 0($sp)
      sw $s6, 4($sp)
      
      add $s6, $zero, -1 	# k = s0 = -1
      
      # 0) Adequação do argumento de graus para radianos
      lwc1 $f2, pi		# Carrega-se o valor aproximado da constante "pi" para $f2
      li $t2, 180		# Coloca-se o valor de 180 no registrador $t2
      mtc1 $t2, $f11
      cvt.s.w $f11, $f11
      # O valor de $f12 será o do ângulo em radianos
      div.s  $f12, $f12, $f11 	# valor em radianos = (valor em graus)/180
      mul.s $f12, $f12, $f2	# valor em radianos = pi*(valor em graus)/180
      
      # Usar-se-á $f3 para a aproximação de sen(x) por meio da série de Taylor
      
      lwc1 $f4, cte_1e_min_4	# Constante (1e-4) para a aproximação de sen(x)	
      jal loop_seno
loop_seno: sub $sp, $sp, 4
	   swc1 $f12, 0($sp)	# Salva-se o valor do argumento ($f12)
	   
	   add.s $f6, $f10, $f10# Resetamento do registrador $f6: f6 = 0
	   
	   # 1) Incremento de k e calculo de (2k + 1)
	   add $s6, $s6, 1	# Incremento de k: k++
	   add $t1, $s6, $s6	# t1 = 2k
	   add $t1, $t1, 1	# t1: 2k + 1 (para o fatorial e o expooente)
	   
	   # 2) Cálculo de (x)^(2k+1)
	   # argumento $f12 do seno é o mesmo daquele para a potência. (f12_seno = f12_base_potencia)
	   move $a1, $t1	# argumento da função "potencia" a1: t1 = 2k + 1
	   jal potencia		# Cálculo de ($f12)^($a1) = (x)^(2k+1)
	   add.s $f6, $f6, $f0	# f6: (x)^(2k+1)
	   
	   # 3) Cálculo de (-1)^(k) através da função "potencia"
	   li $t2, -1		# "Coloca-se", no registrador $f12, o valor -1.0
	   mtc1 $t2, $f12
	   cvt.s.w $f12, $f12
	   add $a1, $s6, $zero	# Argumento $a1 = $s0 = k
	   jal potencia		# Cálculo de (-1)^(k)
	   mul.s $f6, $f6, $f0	# $f6 = ((-1)^(k) * (x)^(2k+1))
	   
	   # 4) Cálculo de (2k+1)! por meio da função "fatorial"
	   lwc1 $f12, 0($sp) 	# Recupera-se, da pilha, $f12, cujo valor é o argumento da função.
	   add $sp, $sp, 4	
	   mtc1 $t1, $f13	# Passa-se $t1 = (2k + 1) como argumento da função fatorial
	   cvt.s.w $f13, $f13	
	   jal fatorial		# Calcula-se (2k + 1)!
	   mov.s $f9, $f0	# Move-se o resultado da função "fatorial" para o registrador $f9
	   div.s $f6, $f6, $f9	# ENFIM, calcula-se ((-1)^(k) * (x)^(2k+1))/(2k + 1)!
	   
	   # 5) Checa-se se o termo calculado ($f6) é maior que 1e-4 ($f4).
	   abs.s $f8, $f6	# Calcula-se o módulo do termo calculado
	   c.lt.s $f4, $f8 	# Checa-se se o módulo de $f6 é maior que 1e-4 ($f4).
	   bc1f end_seno	# Se não for, termina-se a execução da função seno.
	   add.s $f3, $f3, $f6	# Caso contrário, adiciona-se o termo à soma e...
	   j loop_seno		# ... repete-se a iteração.
end_seno:mov.s $f0, $f3		# Ao se acabar a execução da função, retornar-se-á a soma obtida ($f3)
         lw $s6, 4($sp)
	 lw $ra, 0($sp)		# Recupera-se o valor de $ra
	 
	 add $sp, $sp, 8
	 jr $ra			# Volta-se para a função chamadora

# Função que calcula o cosseno de um dado ângulo
# - Entrada: $f12 : float (ângulo) 
# - Saída: $f0: float (o valor do cosseno do ângulo)
cosseno: add $s6, $zero, -1 	# k = s0 = -1
      mtc1 $zero, $f10		# f10: valor de 0 em float
      sub $sp, $sp, 8
      sw $ra, 0($sp)
      swc1 $f3, 4($sp)
      
      # 0) Adequação do argumento de graus para radianos
      lwc1 $f2, pi		# Carrega-se o valor aproximado da constante "pi" para $f2
      li $t2, 180		# Coloca-se o valor de 180 no registrador $t2
      mtc1 $t2, $f11
      cvt.s.w $f11, $f11
      # O valor de $f12 será o do ângulo em radianos
      div.s  $f12, $f12, $f11 	# valor em radianos = (valor em graus)/180
      mul.s $f12, $f12, $f2	# valor em radianos = pi*(valor em graus)/180
      
      # Usar-se-á $f3 para a aproximação de sen(x) por meio da série de Taylor
      mtc1 $zero, $f3
      
      lwc1 $f4, cte_1e_min_4	# Constante (1e-4) para a aproximação de sen(x)	
      jal loop_cosseno
loop_cosseno: sub $sp, $sp, 4
	   swc1 $f12, 0($sp)	# Salva-se o valor do argumento ($f12)
	   
	   add.s $f6, $f10, $f10# Resetamento do registrador $f6: f6 = 0
	   
	   # 1) Incremento de k e calculo de (2k + 1)
	   add $s6, $s6, 1	# Incremento de k: k++
	   add $t1, $s6, $s6	# t1 = 2k
	   
	   # 2) Cálculo de (x)^(2k)
	   # argumento $f12 do seno é o mesmo daquele para a potência. (f12_seno = f12_base_potencia)
	   move $a1, $t1	# argumento da função "potencia" a1: t1 = 2k
	   jal potencia		# Cálculo de ($f12)^($a1) = (x)^(2k)
	   add.s $f6, $f6, $f0	# f6: (x)^(2k)
	   
	   # 3) Cálculo de (-1)^(k) através da função "potencia"
	   li $t2, -1		# "Coloca-se", no registrador $f12, o valor -1.0
	   mtc1 $t2, $f12
	   cvt.s.w $f12, $f12
	   add $a1, $s6, $zero	# Argumento $a1 = $s0 = k
	   jal potencia		# Cálculo de (-1)^(k)
	   mul.s $f6, $f6, $f0	# $f6 = ((-1)^(k) * (x)^(2k+1))
	   
	   # 4) Cálculo de (2k)! por meio da função "fatorial"
	   lwc1 $f12, 0($sp) 	# Recupera-se, da pilha, $f12, cujo valor é o argumento da função.
	   add $sp, $sp, 4	
	   mtc1 $t1, $f13	# Passa-se $t1 = (2k) como argumento da função fatorial
	   cvt.s.w $f13, $f13	
	   jal fatorial		# Calcula-se (2k)!
	   mov.s $f9, $f0	# Move-se o resultado da função "fatorial" para o registrador $f9
	   div.s $f6, $f6, $f9	# ENFIM, calcula-se ((-1)^(k) * (x)^(2k))/(2k)!
	   
	   # 5) Checa-se se o termo calculado ($f6) é maior que 1e-4 ($f4).
	   abs.s $f8, $f6	# Calcula-se o módulo do termo calculado
	   c.lt.s $f4, $f8 	# Checa-se se o módulo de $f6 é maior que 1e-4 ($f4).
	   bc1f end_cosseno	# Se não for, termina-se a execução da função cosseno.
	   add.s $f3, $f3, $f6	# Caso contrário, adiciona-se o termo à soma e...
	   j loop_cosseno		# ... repete-se a iteração.
end_cosseno:mov.s $f0, $f3		# Ao se acabar a execução da função, retornar-se-á a soma obtida ($f3)
         lwc1 $f3, 4($sp)
	 lw $ra, 0($sp)		# Recupera-se o valor de $ra
	 add $sp, $sp, 8
	 jr $ra			# Volta-se para a função chamadora

# Função que calcula $a0 fatorial: ($a0)!
# Entrada: $f13 (n): float
# saida: $f0: float
fatorial: sub $sp, $sp, 8	# Armazena-se o valor de $ra...
	  sw $ra, 4($sp)
	  swc1 $f13, 0($sp)	# ...e do argumento $f13
	  li $t0, 1
	  mtc1 $t0, $f8		# f8 = 1
	  cvt.s.w $f8, $f8
	  c.lt.s $f13, $f8	# Teste se n < 1
	  
	  # Caso n >= 1, faz-se a recursão
	  bc1f else
	  
	  # Caso n == 0, retorna-se 1:	
	  mov.s $f0, $f8	# retorno do valor 1
	  add $sp, $sp, 8 	# Reseta-se a pilha (fim da recursão)
	  jr $ra 		# Retorna-se para a função chamadora
# Passo da recursão
else: li $t0, 1			# "Inicializa-se" o registrador $f8 com 1.0
      mtc1 $t0, $f8
      cvt.s.w $f8, $f8
      sub.s $f13, $f13, $f8 	# Caso n >= 1, Subtrai-se 1 de n
      jal fatorial 		# Faz-se o fatorial de n-1 (recursão)
      lwc1 $f13, 0($sp) 	# Feita a recursão para (n-1), a função chamada recupera os valores de $f13...
      lw $ra, 4($sp)		#...de $ra. E ...
      add $sp, $sp, 8		
      mul.s $f0, $f0, $f13	# enfim, retorna o valor de n * (n-1)! 
      jr $ra			# Volta-se para a função chamadora

# Função que calcula $a0 elevado a $a1
# - Entradas: $f12: float (base) e # a1: int (expoente)
# - Sáida: #f0: float
potencia: sub $sp, $sp, 4	# Reserva-se o valor de $ra
	  sw $ra, 0($sp)
	  jal aux_potencia	# Faz-se a recursão da potenciação
	  lw $ra, 0($sp)
	  add $sp, $sp, 4
	  slti $t0, $a1, 0 	# Checa-se se a potência é negativa
	  beq $t0, 1, inv_pot 	# Caso a potência seja negativa, inverte-se o valor obtido por aux_potencia
	  jr $ra		# Caso contrário, retorna o valor de inv_pot
inv_pot: add $t1, $zero, 1
	 mtc1 $t1, $f10
  	 div.s $f12, $f10, $f12  #
	 jr $ra
# aux_potencia: Calcula Função a qual calcula ($a0)^(abs($a1)), em que abs() é a função módulo
aux_potencia: sub $sp, $sp, 12	# Guarda-se os valores de $ra, $a1 e $f12
	  sw $ra, 8($sp)
	  swc1 $f12, 4($sp)	 # $f12: base
	  sw $a1, 0($sp)	 # $a1: expoente
	  abs $a1, $a1
	  
	  # Caso o expoente ($a1) é >= 0, faz-se a recursão,
	  bgt  $a1, 0, recur_pot
	  
	  # Caso contrário, se o expoente ($a1) é 0, retorna-se 1.0
	  li $t0, 1		# Coloca-se o valor de 1 no registrador de retorno $f0
	  mtc1 $t0, $f0
	  cvt.s.w $f0, $f0	
	  lw $a1, 0($sp)	# Recuprera-se, no caso base, os valores de $a1, $f12 e de $ra
 	  lwc1 $f12, 4($sp)
 	  lw $ra, 8($sp)
	  add $sp, $sp, 12
	  jr $ra		# Volta-se para a função chamadora
# Passo da recursão
recur_pot: sub $a1, $a1, 1 	 # Subtrai-se um do expoente ($a1)
	   jal aux_potencia	 # Faz-se a recursão por meio de: "potencia($f12, $a1 - 1)"
	   mul.s $f0, $f0, $f12  # Retorna-se a multiplicação do valor obtido pela recursão pela base (a0)
	   lw $a1, 0($sp)	 # Recupera-se, após o passo da recursão, os valoures de $a1, $ f12 e $ra 
	   lwc1 $f12, 4($sp)
	   lw $ra, 8($sp)
	   add $sp, $sp, 12
 	   jr $ra		# Retorna-se para a função chamadora
