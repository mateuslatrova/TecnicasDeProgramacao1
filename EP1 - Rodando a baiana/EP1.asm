# Os registradores $f0-f7 foram usados como argumentos de função.
# Já os registradores $f8-f9 foram usados para o retorno de funções.

# TODO: exemplo de chamada da função rotaciona(v.theta)

.data
mat: .space 16 # alocação de um vetor de 4 elementos, que representará a matriz 2x2
PI: .float 3.1415

.text

rotaciona: la $s0, mat
           lwc1 $f0, PI

multiplicaMatrizVetor: 

sen: 

cos:

fatorial:

potencia: