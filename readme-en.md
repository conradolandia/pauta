# Calligraphy Grid in ConTeXt/LMTX

This project is a generator of grids for medieval calligraphy in [ConTeXt/LMTX](https://wiki.contextgarden.net/) and [METAPOST](https://wiki.contextgarden.net/MetaPost). It includes a main file, `pauta.mkxl`, a MetaPost library, `hatching.mp`, and two examples, `Carolingia.mkxl` and `FoundationalHand.mkxl`.

## Usage Mode

1. Ensure `pauta.mkxl`, `hatching.mp`, and the ConTeXt file to compile are in the same directory.
2. Include the grid in your ConTeXt file.
3. Compile with `context [FILE]`.
4. Invoke the `\Pauta` macro as many times as you want pages. Each invocation can have a different configuration.

## Configuration Parameters

All parameters are optional. Defaults (except `hand` and `handInfo`, empty by default) are as follows:

```tex
\Pauta[
 hand={Carolingian}, % Hand name
 handInfo={Tours school, VIII\high{th} century}, % Some extra info for the hand
 infoPosition=header, % Where to show the extra info (header | footer)
 displayNibs=true, % Show pen width marks (true | false)
 displayAngleMarks=true, % Display dotted guides for the nib angle
 nibWidth=3mm, % Pen nib width (with units)
 ascenders=3, % Number of ascender lines (in nib widths)
 xHeight=4, % Number of x-height lines (in nib widths)
 descenders=3, % Number of descending lines (in nib widths)
 adjustment=0, % Sometimes it's necessary to adjust the line height if the last one covers the page info
 mainColor={s=.5}, % Main color (lines that separate sections)
 secondaryColor={s=.6}, % Secondary color (lines separated by a nib width and dotted angle lines)
 tertiaryColor={s=.7}, % Tertiary color (nib width marks on the left margin)
]
```

## Code Examples

### Example 1: Basic Usage

```tex
\usemodule[pauta]

\startdocument
\Pauta[
 hand={Carolingian},
 handInfo={Tours school, VIII\high{th} century},
 infoPosition=header,
 displayNibs=true,
 displayAngleMarks=true,
 nibWidth=3mm,
 ascenders=3,
 xHeight=4,
 descenders=3,
 adjustment=0,
 mainColor={s=.5},
 secondaryColor={s=.6},
 tertiaryColor={s=.7},
]
\stopdocument
```

### Example 2: Multiple Pauta Instances

```tex
\usemodule[pauta]

\startdocument
\Pauta[
 hand={Carolingian},
 handInfo={Tours school, VIII\high{th} century},
 infoPosition=header,
 displayNibs=true,
 displayAngleMarks=true,
 nibWidth=3mm,
 ascenders=3,
 xHeight=4,
 descenders=3,
 adjustment=0,
 mainColor={s=.5},
 secondaryColor={s=.6},
 tertiaryColor={s=.7},
]

% Overriding the hader / footer info:

\Pauta[
 infoLeft={An excercise in Visigothic script},
 infoRight={from an Spanish manuscript, VII\high{th} century},
 infoPosition=footer,
 displayNibs=true,
 displayAngleMarks=false,
 nibWidth=2mm,
 ascenders=2,
 xHeight=3,
 descenders=2,
 adjustment=1,
 mainColor={s=.3},
 secondaryColor={s=.4},
 tertiaryColor={s=.5},
]
\stopdocument
```

This project aims to provide a flexible and efficient tool for creating calligraphy practice templates, leveraging the power of ConTeXt and MetaPost.
