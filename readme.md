# Pauta caligráfica en ConTeXt/LMTX

Generador de retículas para caligrafía medieval en [ConTeXt](https://wiki.contextgarden.net/)/Luametatex y [METAPOST](https://wiki.contextgarden.net/MetaPost).

Se incluyen:

- Un archivo principal
  - `pauta.mkxl`
- Dos ejemplos
  - `Carolingia.mkxl`
  - `FoundationalHand.mkxl`

Compilar con `mtxrun --autogenerate --script context [ARCHIVO]`, o `context [ARCHIVO]`.

## Configuración de la retícula

Es bastante simple. Primero importamos la pauta desde nuestro archivo (asumiendo que están en el mismo directorio):

```context
\input pauta.mkxl
```

Luego invocamos la función `\Pauta` tantas veces como páginas queremos. Cada invocación puede tener una configuración diferente. todos los argumentos son opcionales.

```context
\Pauta[
  verMarcas=true,
  marcas=header,
  pluma=2mm,
  ascendentes=3,
  ojoMedio=4,
  descendentes=3,
  ajuste=0,
  colorMarca={s=.6},
  colorLineaSecundaria={s=.8},
  colorLineaPrincipal={s=.6},
  infoIzquierda={Pluma: \unit{2 mm} \quad (3/4/3)},
  infoDerecha={Carolingia \quad Escuela de Tours, siglo VIII},
]
```

# TODO

- [ ] Explicar argumentos de la macro `\Pauta`
- [x] Ajustar áreas del layout, para que siempre quede centrado verticalmante.
- [ ] Mejorar la presentación de información (header/footer)
