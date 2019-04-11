# Fuentes de datos

La fuente original de datos para resultados de elecciones nacionales (2003 - 2017) provienen del **_Atlas Electoral de Andy Tow_**. Se puede acceder a ellas en  las sección de **[descargas de su sitio web](https://www.andytow.com/)**. Para acceder es necesario autenticar la consulta a través de una cuenta de *Twitter*. 

---

### Para el procesamiento de datos de este repositorio seguimos los siguientes pasos: 

**(1)** Descargamos los archivos para cada una de las elecciones del atlas. 

---

**(2)** Pasamos del formato original (`mdb`) de *Microsoft Acces* a un formato compatible para trabajar con *software* no propietario. En este caso *sqlite*. Para hacerlo seguimos los siguientes pasos: 
 -  Descargamos este archivo [`mdb2sqlite.sh`](https://raw.githubusercontent.com/atlaselectoral/elecciones/master/nacionales/fuente/mdb2sqlite.sh).
 -  Renombramos el archivo (uno por uno) de la base de datos que se deseabamos transformar (con extensión `mdb`) de esta manera: `migration-export.mdb` 
 -  Corrimos el siguiente comando:  `./mdb2sqlite.sh migration-export.mdb`
 -  Esperar... y esperar un rato más... y un poco más... 
 - Al final del proceso, dentro de la carepta `sqlite` encontrabamos un archivo nuevo (`db.sqlite3`). 

--- 

**(3)** Desde el entorno de `RStudio`corrimos un programa para trabajar con lengauje `SQL` en las múltiples tablas del archivo original (que incluye datos de todos los distritos de Argentina para cada una de las elecciones) y generar un archivo de texto separado por comas (`.csv`) para los datos de interes del distrito Tucumán. 

Es importante primero instalar y configurar los `drivers` de las bases de datos para poder generar la conexión entre `RStudio`y las mismas y poder hacer las consultas (en esta caso de `sql`). 

- Instructivo general del paquete `db` de [RStudio](https://db.rstudio.com/best-practices/drivers/) y para el caso particular de conexiones de [`sqlite`](https://db.rstudio.com/databases/sqlite/).

A modo de ejmplo compartimos abajo el código con el que trabajamos para procesar los datos de las elecciones de 2013. 

* Un [notebook](https://raw.githubusercontent.com/atlaselectoral/elecciones/master/nacionales/fuente/queriesSQL_Tuc2013.Rmd) de `Rmd` que incluye las consultas `SQL` de P.A.S.O. y Generales. 

* Los archivos resultantes (`.csv`) en el [repositorio](https://github.com/atlaselectoral/elecciones/tree/master/nacionales/resultados). 


# EJEMPLOS

El _notebook_ incluye:

**(1) `R` chunk para establacer la conexion con las bases de datos de
`SQLite` con resultados electorales**

-El codigo para prender las bases de datos no fue ejecutado en el
preview (`include=FLASE`)

-   Primero cargamos las librerias
-   Establecemos la ruta donde se encuentran los archivos
-   Establecemos la conexión con las bases de datos

**(2) SQL chunk para tener codigo y nombre de departamentos de cada
provincia**

-   Los guardo como `data.frame`: `*Deptos_Provincias*`

-   La columna `depNombre` incluye el nombre de las provinicas, cuyo
    `deoCodigoDepartamento == 999`.

**(3) SQL chunk para traer los partidos (y sus codigos) para una
eleccion particular**

-   En las opciones de `sql` la **`connection`** lleva el nombre
    correspondiente a la base de datos de la eleccion.

-   `vot_pro_CodigoProvincia` (de la tabla anterior, guardada en el
    enviroment de `R`) para la provincia de Tucumán es el `23`.

-   Si quiero guardarla como `data.frame` de `R` tengo que agregar
    opcion `output.var = "NombreDataFrame"` en el chunk de `sql`.

-   Luego podemos exportar a `csv` con el siguiente comando:
    `readr::write_csv(NombreDataFrame, "NombreDataFrame.csv")`

-   Filtrar datos de listas de generales 2013 en Tucunám

**(4) SQL chunk con la consulta final de los resultados electorales**

-   Traemos valores absolutos de `listas`, `blancos`, `electores`, y
    `validos`.

-   Traemos tambien codigos de identificacion de las observacioes a
    distintos niveles (`mesa`, `circuito`, `departamento` y `provincia`)
    para poder agrupar.

-   Guardamos con `output.var` como dataframe. Repetimos proceso
    anterior para exportar como `csv`.


