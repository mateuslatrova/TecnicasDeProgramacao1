# Função que calcula o cosseno de um dado ângulo
# - Entrada: $f12 : float (ângulo) 
# - Saída: $f0: float (o valor do cosseno do ângulo)
cosseno: add $s0, $zero, -1 	# k = s0 = -1
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
	   add $s0, $s0, 1	# Incremento de k: k++
	   add $t1, $s0, $s0	# t1 = 2k
	   
	   # 2) Cálculo de (x)^(2k)
	   # argumento $f12 do seno é o mesmo daquele para a potência. (f12_seno = f12_base_potencia)
	   move $a1, $t1	# argumento da função "potencia" a1: t1 = 2k
	   jal potencia		# Cálculo de ($f12)^($a1) = (x)^(2k)
	   add.s $f6, $f6, $f0	# f6: (x)^(2k)
	   
	   # 3) Cálculo de (-1)^(k) através da função "potencia"
	   li $t2, -1		# "Coloca-se", no registrador $f12, o valor -1.0
	   mtc1 $t2, $f12
	   cvt.s.w $f12, $f12
	   add $a1, $s0, $zero	# Argumento $a1 = $s0 = k
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
	 add $sp, $sp, 4
	 jr $ra			# Volta-se para a função chamadora