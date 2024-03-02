# Pauta caligráfica en ConTeXt/LMTX

Generador de retículas para caligrafía medieval en [ConTeXt/LMTX](https://wiki.contextgarden.net/) y [METAPOST](https://wiki.contextgarden.net/MetaPost).

Se incluyen:

- Un archivo principal
  - `pauta.mkxl`
- Una librería de metapost
  - `hatching.mp` (se puede descargar tambien de [CTAN](https://ctan.org/tex-archive/graphics/metapost/contrib/macros/hatching))
- Dos ejemplos
  - `Carolingia.mkxl`
  - `FoundationalHand.mkxl`

## Modo de empleo

1. Incluir la pauta en su archivo de ConTeXt:
   ```tex
   \input pauta.mkxl
   ```

Compilar con `mtxrun --autogenerate --script context [ARCHIVO]`, o `context [ARCHIVO]`.

## Configuración de la retícula

Es bastante simple. Primero importamos la pauta desde nuestro archivo (asumiendo que están en el mismo directorio):

```tex
\input pauta.mkxl
```

Luego invocamos la macro `\Pauta` tantas veces como páginas queremos. Cada invocación puede tener una configuración diferente.

Todos los parámetros son opcionales. Sin embargo, si se desea invocar la macro sin parámetros, deben incluirse los paréntesis cuadrados, así: `\Pauta[]`.

```tex
\Pauta[
  verMarcas=true, % Mostrar marcas de anchos de pluma (true / false)
  pluma=2mm, % Ancho de pluma (se le pueden pasar las unidades también)
  ascendentes=3, % Cantidad de líneas ascendentes (en anchos de pluma)
  ojoMedio=4, % Cantidad de líneas de ojo medio (en anchos de pluma)
  descendentes=3, % Cantidad de líneas descendentes (en anchos de pluma)
  ajuste=0, % A veces es necesario ajustar la altura del renglón si el último cubre la info
  verAngulo=true, % Ver el ángulo de la punta de la pluna
  angulo=35, % Ángulo de la punta de la pluma en grados respecto de la vertical
  colorPrincipal={s=.7}, % Color principal (líneas que separan secciones)
  colorSecundario={s=.8}, % Color secundario (líneas separadas por una anchura de pluma y líneas punteadas de ángulo)
  colorTerciario={s=.9}, % Color terciario (marcas de anchos de pluma que separan secciones)
  infoIzquierda={Pluma: \unit{2 mm} \qquad (3/4/3) \qquad 35\textdegree{}}, % Info a la izquierda de la página
  infoDerecha={Carolingia \quad Escuela de Tours, siglo VIII}, % Info a la derecha de la página
]
```

# TODO

- [ ] Mejorar la presentación de información (header/footer)
