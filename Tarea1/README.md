# Tarea 1
En esta tarea se realizó la siguiente función de C
```c
void ReLU(int A[], int lenA){
    int i = 0;
    while (i < lenA) {
        if (A[i] < 0) {
            A[i] = 0;
        }
        i++;
    }
}
```
Esta es una función que lo que hace es reemplazar los números negativos del arreglo por ceros, y los valores positivos los manetiene, esta función es comúnmente utilizada como función de activación de redes neuronales.
Además, en el código de MIPS, también viene un programa principal, una función para imprimir y una función en donde se genera la impresión de los arreglos y una función que realiza el ReLU, llamada app_ReLU. Esto con el fin de poder observar que funciona correctamente, además de agregar strings, esto con el fin de separa el arreglo original, con el arreglo pasado por la función ReLU.