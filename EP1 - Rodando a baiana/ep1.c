#include "stdlib.h"
#include "stdio.h"
#include "math.h"

int fatorial(int n) {
    if (n == 0) return 1;
    int fat = 1;
    for (int i = n; i > 1; i--) {
        fat *= i;
    }
    return fat;
}

int potencia(int base, int exp) {
    if (exp == 0) return 1;
    else return base*potencia(base,exp-1);
}

float sen(float x) {
    int k = 0;
    float parcela = x;
    float seno = 0;
    
    while (parcela > 10e-4) {
        seno += parcela; 
        k++;
        parcela = (potencia(-1,k)*potencia(x,2*k+1))/fatorial(2*k+1);
    }

    return seno;
}

float cos(float senx) {
    // TODO: conferir tratamento do sinal.
    float cos = sqrt(1-pow(senx,2));
    return cos; 
}

float* multiplicaMatrizVetor(float* m, float* v) {
    float* resultado = malloc(2*sizeof(float));
    
    resultado[0] = m[0]*v[0] + m[1]*v[1];
    resultado[1] = m[2]*v[0] + m[3]*v[1];

    return resultado;
}

float* matrizDeRotacao(float theta) {
    float seno = sen(theta);
    float cosseno = cos(seno);
    float* M = malloc(4*sizeof(float));
    M[0] = cosseno;
    M[1] = -seno;
    M[2] = seno;
    M[3] = cosseno;
    return M;
}

float* rotaciona(float* v, float theta) { 
    
    float* R = matrizDeRotacao(theta);

    float* vRotacionado = multiplicaMatrizVetor(R,v);

    return vRotacionado;
}