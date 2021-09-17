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
    
    while (fabs(parcela) > 10e-4) {
        seno += parcela; 
        k++;
        parcela = (potencia(-1,k)*potencia(x,2*k+1))/fatorial(2*k+1);
    }

    return seno;
}

float cos(float senx) {
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
    float* M = (float*) malloc(4*sizeof(float));
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

void testeUnitario(float* v, float theta) {

    float* vRotacionado = rotaciona(v,theta);

    printf("%f %f", vRotacionado[0], vRotacionado[1]);
}

int main() {
    
    float PI = 3.1415;
    float v[2];

    // Testes:

    v[0] = 4.0, v[1] = 0.0;
    testeUnitario(v, PI);

    v[0] = 0.0, v[1] = 7.0;
    testeUnitario(v, PI/2);

    v[0] = 1.0, v[1] = 0.5;
    testeUnitario(v, 4*PI/3);
    
    v[0] = -1.0, v[1] = -2.0;
    testeUnitario(v, PI/6);

    return 0;
}