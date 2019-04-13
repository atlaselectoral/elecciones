# Fuentes de datos

La fuente original de datos para resultados de elecciones nacionales (2003 - 2017) provienen del **_Atlas Electoral de Andy Tow_**. Se puede acceder a ellas en  las sección de **[descargas de su sitio web](https://www.andytow.com/)**. Para acceder es necesario autenticar la consulta a través de una cuenta de *Twitter*. 

---

### Para el procesamiento de datos de este repositorio seguimos los siguientes pasos: 

**(1)** Descargamos los archivos para cada una de las elecciones del atlas. 

**(2)** Pasamos del formato original (`mdb`) de *Microsoft Acces* a un formato compatible para trabajar con *software* no propietario. En este caso *sqlite*. Para hacerlo seguimos los siguientes pasos: 
 -  Descargamos este archivo [`mdb2sqlite.sh`](https://raw.githubusercontent.com/atlaselectoral/elecciones/master/nacionales/fuente/mdb2sqlite.sh).
 -  Renombramos el archivo (uno por uno) de la base de datos que se deseabamos transformar (con extensión `mdb`) de esta manera: `migration-export.mdb` 
 -  Corrimos el siguiente comando:  `./mdb2sqlite.sh migration-export.mdb`
 -  Esperar... y esperar un rato más... y un poco más... 
 - Al final del proceso, dentro de la carepta `sqlite` encontrabamos un archivo nuevo (`db.sqlite3`). 

**(3)** Desde el entorno de `RStudio`corrimos un programa para trabajar con lengauje `SQL` en las múltiples tablas del archivo original (que incluye datos de todos los distritos de Argentina para cada una de las elecciones) y generar un archivo de texto separado por comas (`.csv`) para los datos de interes del distrito Tucumán. 

Es importante primero instalar y configurar los `drivers` de las bases de datos para poder generar la conexión entre `RStudio`y las mismas y poder hacer las consultas (en esta caso de `sql`). 

- Instructivo general del paquete `db` de [RStudio](https://db.rstudio.com), [los *drivers*](https://db.rstudio.com/best-practices/drivers/) necesarios y datos específicos para el caso particular de conexiones de [`sqlite`](https://db.rstudio.com/databases/sqlite/).


# EJEMPLOS

A modo de ejmplo compartimos abajo el código con el que trabajamos para procesar los datos de las elecciones de 2013. 

* Un [notebook](https://raw.githubusercontent.com/atlaselectoral/elecciones/master/nacionales/fuente/queriesSQL_Tuc2013.Rmd) de `Rmd` que incluye las consultas `SQL` de P.A.S.O. y Generales. 

* Los archivos resultantes (`.csv`) en el [repositorio](https://github.com/atlaselectoral/elecciones/tree/master/nacionales/resultados). 

## El _notebook_ incluye:

**(1) `R` chunk para establacer la conexión con las bases de datos de
`SQLite` con resultados electorales**

-   Cargamos las librerias
-   Establecimos la ruta donde se encuentran los archivos
-   Generamos la conexión con las bases de datos

**(2) SQL chunk para consultar código y nombre de departamentos de cada
provincia**

-   Guardados como `data.frame` en el entorno (`enviroment`de `RStudio`): `*Deptos_Provincias*`

-   La columna `depNombre` incluye el nombre de las provinicas, cuyo
    `depCodigoDepartamento == 999`, y nos permite ver rápidamente el código de cada provincia.

**(3) SQL chunk para obtener los nombres de partidos (y sus codigos) para una
eleccion particular**

-   En las opciones de `sql` la **`connection`** lleva el nombre
    correspondiente a la base de datos de la elección.

-   El código de la provincia - `vot_pro_CodigoProvincia`- para la provincia de Tucumán es el `23`(del *chunk* previo).

-   Si quiero guardar la consulta como `data.frame` de `R` tengo que agregar
    opción `output.var = "NombreDataFrame"` en el *chunk* de `sql`.

-   Luego podemos exportar a `csv` con el siguiente comando desde la consola:
    `readr::write_csv(NombreDataFrame, "NombreDataFrame.csv")`


**(4) SQL chunk con la consulta final de los resultados electorales**

-   Obtuvimos los valores absolutos de `listas`, `blancos`, `electores`, y `validos`.

-   Tambien extrajimos los códigos de identificación de las observaciones (`mesa`, `circuito`, `departamento` y `provincia`)
    para poder agrupar a distintos niveles. Cada fila corresponde a los resultados de una mesa electoral de una elección determinada. 

-   Guardamos con `output.var` como dataframe. Repetimos proceso de `(3)`para exportar como `csv`.


