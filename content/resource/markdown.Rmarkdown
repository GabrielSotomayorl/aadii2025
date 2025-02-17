---
title: ¿Qué es Markdown?
date: "2021-08-11"
menu:
  resource:
    parent: Material complementario
    weight: 2
type: docs
toc: true
# output:
#   blogdown::html_page:
#       toc: TRUE
#       fig_caption: yes
---

[Markdown](https://daringfireball.net/projects/markdown/) es una clase especial de lenguaje que permite darle formato a texto simple. Por ejemplo, poder hacer cursivas, negritas, incorporar links, etc.

Para que el formato que se le ha dado pueda ser visto, el archivo en Markdown (*.md*) pasa por un convertidor universal llamado [pandoc](https://pandoc.org/). Este, a diferencia de procesadores como los que ocupa Office no es pagado. Por ello, para no solo para editar tus archivos de texto no necesitarás un software, sino que para crear PDF, archivos .doc (Word), presentación (como las de Power Point) o HTML (para hacer sitios web) es **completamente gratis**. Solo debes encontrar un editor que pueda hacer esto.

La buena noticia es que ya lo conoces: ¡nuestro amigo RStudio!

## Formatos básicos de Markdown

<table>
<colgroup>
<col width="40%" />
<col width="21%" />
<col width="38%" />
</colgroup>
<thead>
<tr class="header">
<th>Escribe…</th>
<th>…o…</th>
<th>…para obtener</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><pre>Algo de texto en el párrafo.<br>
Más texto
espacio entre lineas.</pre></td>
<td></td>
<td><p>Algo de texto.</p>
<p>Algo de texto en el párrafo. Siempre utilizando
espacios para dividir párrafos</p></td>
</tr>
<tr class="even">
<td><code>*Cursivas*</code></td>
<td><code>_Cursivas_</code></td>
<td><em>Cursivas</em></td>
</tr>
<tr class="odd">
<td><code>**Negrita**</code></td>
<td><code>__Negrita__</code></td>
<td><strong>Negrita</strong></td>
</tr>
<tr class="even">
<td><code># Título 1</code></td>
<td></td>
<td><h1 class="smaller-h1">
Título 1
</h1></td>
</tr>
<tr class="odd">
<td><code>## Título 2</code></td>
<td></td>
<td><h2 class="smaller-h2">
Título 2
</h2></td>
</tr>
<tr class="even">
<td><code>### Título 3</code></td>
<td></td>
<td><h3 class="smaller-h3">
Título 3
</h3></td>
</tr>
<tr class="odd">
<td>(puedes llegar hasta un título N° 6 con <code>######</code>)</td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><code>[Link text](http://www.example.com)</code></td>
<td></td>
<td><a href="http://www.example.com">Link text</a></td>
</tr>
<tr class="odd">
<td><code>![Image caption](/path/to/image.png)</code></td>
<td></td>
<td><img src="/img/mstile-144x144.png" title="fig:" alt="Class logo" /></td>
</tr>
<tr class="even">
<td>`<code>Inline code` with backticks</code></td>
<td></td>
<td><code>Inline code</code> with backticks</td>
</tr>
<tr class="odd">
<td><code>&gt; Citas</code></td>
<td></td>
<td><blockquote>
<p>Citas</p>
</blockquote></td>
</tr>
<tr class="even">
<td><pre>- Cosas en
- listas
- desordenadas</pre></td>
<td><pre>* Cosas en
* listas
* desordenadas</pre></td>
<td><ul>
<li>Cosas en</li>
<li>listas</li>
<li>desordenadas</li>
</ul></td>
</tr>
<tr class="odd">
<td><pre>1. Cosas en
2. listas
3. ordenadas</pre></td>
<td><pre>1) Cosas en
2) listas
3) ordenadas</pre></td>
<td><ol style="list-style-type: decimal">
<li>Cosas en</li>
<li>listas</li>
<li>ordenadas</li>
</ol></td>
</tr>
<tr class="even">
<td><pre>Línea horizontal

---</pre></td>
<td><pre>Línea horizontal

***</pre></td>
<td><p>Línea horizontal</p>
<hr /></td>
</tr>
</tbody>
</table>

## Expresiones matemáticas

Markdown también utiliza *LaTeX* para crear ecuaciones matemáticas (y no nos complica tanto la vida como el editor de Word). Si para tu tesis o un proyecto las utilizas te dejo esta [guía de comando básicos para crear ecuaciones matemáticas](http://www.malinc.se/math/latex/basiccodeen.php).

Para introducir una ecuación debes poner los símbolos de peso (\$)

```text
La ecuación cuadratica es la siguiente

$x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}$

```

**Con ello obtendremos: **

> La ecuación cuadratica es la siguiente
> 
> $$
> x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}
> $$
> 

---

Evidentemente como el símbolo peso sirve para hacer ecuaciones matemáticas, no lo puedes utilizar en un archivo escrito en Markdown para hacer referencia **realmente** al símbolo peso. Para ello, debes escribir el símbolo antecedido con un (`\`). Así obtendrás una frase escrita como " `Te hago la tarea de R por \$100.000.` En caso contrario, si pones el símbólo pesos solo y sin `\` entenderá la oración como una ecuación. 


## Tablas


Hacer tablas es muy fácil. Mira el siguiente ejemplo


**Se escribe así**

```text
| Right | Left | Default | Center |
|------:|:-----|---------|:------:|
|   12  |  12  |    12   |    12  |
|  123  |  123 |   123   |   123  |
|    1  |    1 |     1   |     1  |

Tabla: Descripción de la tabla
```

**…to get…**

| Right | Left | Default | Center |
|------:|:-----|---------|:------:|
|   12  |  12  |    12   |    12  |
|  123  |  123 |   123   |   123  |
|    1  |    1 |     1   |     1  |

Tabla: Descripción de la tabla


## Pies de página

Para hacer pies de página debes saber cuál es su (1) identificador y (2) lo que quieres escribir en el pie de página. El identificador puede ser lo que tu quieras: pueden ser números como `[^1]`, pero también pueden ser letras. 

**Debes escribir…**

```text
Aquí escribo una referencia de mi tesis[^1] y aquí otra más [^note-sobre-marx].

[^1]: Esta es una nota

[^note-sobre-marx]: Marx, lo más genial. 

Y bueno, aquí sigo escribiendo
```

**Para obtener**

> Aquí escribo una referencia de mi tesis<a href="#fn1" class="footnote-ref" id="fnref1"><sup>1</sup></a>  y aquí otra más.<a href="#fn2" class="footnote-ref" id="fnref2"><sup>2</sup></a>
>
> Y bueno, aquí sigo escribiendo
>
> <hr />
> 
> <div class="footnotes">
> <ol>
> <li id="fn1"><p>Esta es una nota.<a href="#fnref1" class="footnote-back">↩︎</a></p></li>
> <li id="fn2"><p>Marx, lo más genial.<a href="#fnref2" class="footnote-back">↩︎</a></p></li>
> </ol>
> </div>


## La "cabeza" del Markdown 

Al inicio del Markdown siempre debemos poner algunas informaciones sobre el documento, por ejemeplo, el título, la fecha, autor, etc. Esta parte del Markdown se llama [YAML](https://learn.getgrav.org/16/advanced/yaml). Básicamente, con esto establecemos las "configuraciones" del texto.

Por ejemplo, si queremos que nuestro archivo esté en PDF, colores, si queremos que incluya bibliografía, entre otros. La "cabeza" del Markdown o **YAMLS** está dividida del resto del cuerpo del texto al inicio y al final con tres líneas (`---`).

```yaml
---
title: Título de mi tesis
date: "13 de Agosto, 2021"
author: "Estudiante UAH"
---
```
Debes poner este texto entre comillas. Si quieres ocupar comillas dentro de tu título, puedes utilizar comillas simples (e.g. mi tesis se titula  `Mi tesis: la más "genial" de Chile`), entonces ponemos

```yaml
---
title: `Mi tesis: la más "genial" de Chile`
---
```


## Otros recursos que te recomendamos revisar

En estos links podrás encontrar distintos ejemplos para practicar. También si quieres conocer más sobre quién creó esta maravilla, revisa sobre [Aaron Swartz](https://www.youtube.com/watch?v=mT8FJcIx3HI).

- [**CommonMark's Markdown tutorial**](https://commonmark.org/help/tutorial/): A quick interactive Markdown tutorial.
- [**Markdown tutorial**](https://www.markdowntutorial.com/): Another interactive tutorial to practice using Markdown.
- [**Markdown cheatsheet**](http://packetlife.net/media/library/16/Markdown.pdf): Useful one-page reminder of Markdown syntax.
- [**The Plain Person’s Guide to Plain Text Social Science**](http://plain-text.co/): A comprehensive explanation and tutorial about why you should write data-based reports in Markdown.
