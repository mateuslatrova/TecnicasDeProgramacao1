.data
 angulo: .float 150.0 # [-90,90]
 pi: .float 3.1416
 cte_1e_min_4: .float 0.0001
 cte_180: .float 180.0
 
.text
lwc1 $f12, angulo
jal seno
mov.s $f12, $f0
jal cosseno
jal fatorial
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
      
# Função que calcula o seno de um argumento em graus do registrador a0
# - Entrada: $f12: float - Ângulo entre 0 e 360º
# - Saída: $f0: float - Valor de sen($f12)
seno: add $s0, $zero, -1 	# k = s0 = -1
      mtc1 $zero, $f10		# f10: valor de 0 em float
      sub $sp, $sp, 4
      sw $ra, 0($sp)
      
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
	   add $s0, $s0, 1	# Incremento de k: k++
	   add $t1, $s0, $s0	# t1 = 2k
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
	   add $a1, $s0, $zero	# Argumento $a1 = $s0 = k
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
	 lw $ra, 0($sp)		# Recupera-se o valor de $ra
	 add $sp, $sp, 4
	 jr $ra			# Volta-se para a função chamadora

# Função que calcula o cosseno de um dado ângulo
# - Entrada: $f12 : float (o valor do seno do ângulo)
# - Saída: $f0: float (o valor do cosseno do ângulo)
cosseno: sub $sp, $sp, 8	# Reserva-se espaço na pinha e guarda-se $ra e $a1
	 sw $a1, 0($sp)
	 sw $ra, 4($sp)
	 add $a1, $zero, 1	# $a1 = 1
	 add $a1, $a1, $a1	# $a1 = 2
	 jal potencia		# Eleva-se $f12 ao quadrado ($a1), que é equivalente a fazer (sen(x))^2
	 add $t1, $zero, 1	# Inicializa-se o registrador $f6: $f6 = 1
	 mtc1 $t1, $f6
	 cvt.s.w $f6,$f6
	 sub.s $f0, $f6, $f0	# Subtrai-se, de 1, $f0, de modo que o resultado equivale a (1 - (sen(x))^2)
	 abs.s $f0, $f0		# Uma vez que sen(x) é uma aproximação a qual pode exceder o 1, faz-se o módulo de $f0 = (1 - (sen(x))^2)
	 sqrt.s $f0, $f0	# Por fim, retira-se a raiz de $f0 = (1 - (sen(x))^2), de forma que se obtém cox(x) = sqrt(1 - (sen(x))^2)
	 lw $ra, 4($sp)		# Restaura-se o valor de $ra
	 lw $a1, 0($sp)		# Restaura-se o valor de $a1
	 add $sp, $sp, 8	
	 jr $ra			# Retorna-se para a função chamadora
