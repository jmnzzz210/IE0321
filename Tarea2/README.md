## Validación de paréntesis

En este código se realiza una función que determina si los paréntesis en un string de caracteres son válidos.
En donde se considera paréntesis los siguientes 6 caracteres.
| `(` | `)` | `[` | `]` | `{` | `}` |
|:--:|:--:|:--:|:--:|:--:|:--:|

Para que se considere que los paréntesis son válidos se necesita cumplir los siguientes 3 aspectos:

- Todo paréntesis que se abre se debe cerrar con el mismo tipo de paréntesis.
- Los paréntesis que se abren se deben cerrar en el mismo orden que se abren.
- Todo paréntesis que cierra tiene un correspondiente paréntesis que abre.
  
La función cuenta con una entrada, la cual es `$a0` la cual es la dirección en memoria del arreglo de carácteres que se desea revisar y la función retorna en la terminal `paréntesis válidos` si el string de caracteres cumple con los 3 aspectos mentcionados anteriormente ó `paréntesis inválidos` si no cumple 1 o más.