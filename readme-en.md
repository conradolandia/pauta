# Calligraphy Grid in ConTeXt/LMTX

Generator of grids for medieval calligraphy in [ConTeXt/LMTX](https://wiki.contextgarden.net/) and [METAPOST](https://wiki.contextgarden.net/MetaPost).

Includes:

- A main file
 - `pauta.mkxl`
- A MetaPost library
 - `hatching.mp` (can also be downloaded from [CTAN](https://ctan.org/tex-archive/graphics/metapost/contrib/macros/hatching))
- Two examples
 - `Carolingia.mkxl`
 - `FoundationalHand.mkxl`

## Usage Mode

1. `pauta.mkxl`, `hatcha.mp`, and the ConTeXt file to compile must be in the same directory.

2. Include the grid in your ConTeXt file:

3. Compile with `context --mode=carta:h [FILE]` for a carta-sized template in horizontal position, or `context --mode=carta:v [FILE]` for a carta-sized template in vertical position.

4. Then invoke the `\Pauta` macro as many times as you want pages. Each invocation can have a different configuration.

All parameters are optional. However, if you want to invoke the macro without parameters, they must be included in square brackets, like so: `\Pauta[]`.

## Configuration Parameters

```tex
\Pauta[
  verMarcas=true, % Show pen width marks (true / false)
  marcas=header, % Where to show the marks (header | footer)
  pluma=2mm, % Pen width (units can also be passed)
  ascendentes=3, % Number of ascending lines (in pen widths)
  ojoMedio=4, % Number of middle-eye lines (in pen widths)
  descendentes=3, % Number of descending lines (in pen widths)
  ajuste=0, % Sometimes it's necessary to adjust the line height if the last covers the page info
  verAngulo=true, % See the angle of the pen tip
  angulo=35, % Angle of the pen tip in degrees relative to the vertical
  colorPrincipal={s=.7}, % Main color (lines that separate sections)
  colorSecundario={s=.8}, % Secondary color (lines separated by a pen width and dotted lines at angle)
  colorTerciario={s=.9}, % Tertiary color (pen width marks)
  infoIzquierda={Pen: \unit{2 mm} \qquad (3/4/3) \qquad 35\textdegree{}}, % Info on the left side of the page
  infoDerecha={Carolingia \quad School of Tours, 8th century}, % Info on the right side of the page
]
```


