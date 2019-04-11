# Fuentes de datos

La fuente original de datos para resultados de elecciones nacionales (2003 - 2017) provienen del *Atlas Electoral de Andy Tow*. Se puede acceder a ellas en  las sección de **[descargas de su sitio web](https://www.andytow.com/)**. Para acceder es necesario autenticar la consulta a través de una cuenta de *Twitter*. 

---

### Para el procesamiento de datos de este repositorio seguimos los siguientes pasos: 

**(1)** Descargamos los archivos para cada una de las elecciones del atlas. 

---

**(2)** Pasamos del formato original (`mdb`) de *Microsoft Acces* a un formato compatible para trabajar con *software* no propietario. En este caso *sqlite*. Para hacerlo seguimos los siguientes pasos: 
 -  Descargamos este archivo [`mdb2sqlite.sh`](https://raw.githubusercontent.com/atlaselectoral/elecciones/master/nacionales/fuente/mdb2sqlite.sh).
 -  Renombramos el archivo (uno por uno) de la base de datos que se deseabamos transformar (con extensión `mdb`) de esta manera: `migration-export.mdb` 
 -  Correimos el siguiente comando:  `./mdb2sqlite.sh migration-export.mdb`
 -  Esperar... y esperar un rato más... y un poco más... 
 - Al final del proceso, dentro de la carepta `sqlite` encontrabamos un archivo nuevo (`db.sqlite3`). 

--- 

**(3)** Desde el entorno de `RStudio`corrimos un programa para trabajar con lengauje `SQL` en las múltiples tablas del archivo original (que incluye datos de todos los distritos de Argentina para cada una de las elecciones) y generar un archivo de texto separado por comas (`.csv`) para los datos de interes del distrito Tucumán. 

A modo de ejmplo compartimos abajo el código con el que trabajamos para procesar los datos de las elecciones de 2013. 

* Un [notebook](https://raw.githubusercontent.com/atlaselectoral/elecciones/master/nacionales/fuente/queriesSQL_Tuc2013.Rmd) de `Rmd` que incluye las consultas `SQL` de P.A.S.O. y Generales. 

* Los archivos resultantes (`.csv`) en el [repositorio](https://github.com/atlaselectoral/elecciones/tree/master/nacionales/resultados). 


# EJEMPLO

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

<!-- -->

    SELECT DISTINCT
    depCodigoDepartamento,
    depCodigoProvincia,
    depNombre
    FROM
    Departamento

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

<!-- -->

    SELECT DISTINCT
    vot_parCodigo,
    parDenominacion
    FROM
    VotosCandidaturaDNacionales c INNER JOIN
    Partidos p ON c.vot_parCodigo = p.parCodigo
    WHERE
    vot_proCodigoProvincia = '23'

**(3) SQL chunk con la consulta final de los resultados electorales**

-   Traemos valores absolutos de `listas`, `blancos`, `electores`, y
    `validos`.

-   Traemos tambien codigos de identificacion de las observacioes a
    distintos niveles (`mesa`, `circuito`, `departamento` y `provincia`)
    para poder agrupar.

-   Guardamos con `output.var` como dataframe. Repetimos proceso
    anterior para exportar como `csv`.

<!-- -->

    WITH votos (vot_proCodigoProvincia, vot_depCodigoDepartamento, vot_mesCodigoCircuito, vot_mesCodigoMesa,
    "0064",     
    "0181", 
    "0186", 
    "0501",     
    "0505",         
    "0542", 
    "0543")
    AS
    (SELECT
            vot_proCodigoProvincia,
            vot_depCodigoDepartamento,
            vot_mesCodigoCircuito,
            vot_mesCodigoMesa,
                  max(CASE WHEN vot_parCodigo = "0064"       THEN votVotosPartido END), 
                  max(CASE WHEN vot_parCodigo = "0181"   THEN votVotosPartido END), 
                  max(CASE WHEN vot_parCodigo = "0186"   THEN votVotosPartido END), 
                  max(CASE WHEN vot_parCodigo = "0501"       THEN votVotosPartido END),
                  max(CASE WHEN vot_parCodigo = "0505"           THEN votVotosPartido END), 
                  max(CASE WHEN vot_parCodigo = "0542"   THEN votVotosPartido END), 
                  max(CASE WHEN vot_parCodigo = "0543"       THEN votVotosPartido END)
            FROM
            VotosCandidaturaMesasDNacionales
            WHERE
            vot_proCodigoProvincia = '23' --TUCUMAN
            --AND vot_depCodigoDepartamento = '020' --
            --AND vot_mesCodigoCircuito in ('0304 ') --
            GROUP BY
            vot_proCodigoProvincia,
            vot_depCodigoDepartamento,
            vot_mesCodigoCircuito,
            vot_mesCodigoMesa
            ORDER BY
            vot_proCodigoProvincia,
            vot_depCodigoDepartamento,
            vot_mesCodigoCircuito,
            vot_mesCodigoMesa)
    SELECT
            vot_proCodigoProvincia AS codprov,
            depNombre AS depto,
            mes_depCodigoDepartamento AS coddepto,
             vot_mesCodigoCircuito AS circuito,
             vot_mesCodigoMesa AS mesa,
      --      sum(mesVotosValidos) AS validos,
            sum(mesElectores) AS electores,
            sum(mesVotosEnBlanco) AS blancos,
            sum(mesVotosNulos) AS nulos,
                  sum("0064") AS "0064", 
                  sum("0181") AS "0181", 
                  sum("0186") AS "0186", 
                  sum("0501") AS "0501",
                  sum("0505") AS "0505", 
                  sum("0542") AS "0542", 
                  sum("0543") AS "0543"
            FROM
            votos
               INNER JOIN MesasDNacionales  ON vot_proCodigoProvincia = mes_proCodigoProvincia 
                                    AND vot_depCodigoDepartamento = mes_depCodigoDepartamento
                                    AND vot_mesCodigoCircuito = mesCodigoCircuito
                                    AND vot_mesCodigoMesa = mesCodigoMesa
        INNER JOIN Departamento ON vot_proCodigoProvincia = depCodigoProvincia 
                             AND vot_depCodigoDepartamento = depCodigoDepartamento
         GROUP BY
         vot_proCodigoProvincia,
         vot_depCodigoDepartamento,
         depNombre, 
         vot_mesCodigoCircuito,
         vot_mesCodigoMesa
         ORDER BY
         vot_proCodigoProvincia,
         vot_depCodigoDepartamento,
         depNombre, 
         vot_mesCodigoCircuito,
         vot_mesCodigoMesa;

### PASO

-   Repetimos toda la secuencia anterior para otra elección (que
    necestias de una nueva conexión)

-   Aunque la estructura de estas bases de datos es muy similar entre
    elecciones, de año a año pueden varian algunos nombres de variables.
    Se puede insepccionar la estructura de las tablas en la pestaña
    *Connections* de `RStudio`.

<!-- -->

    SELECT DISTINCT
    vot_parCodigo,
    parDenominacion
    FROM
    VotosCandidaturaDNacionales c INNER JOIN
    Partidos p ON c.vot_parCodigo = p.parCodigo
    WHERE
    vot_proCodigoProvincia = '23'

    WITH votos (vot_proCodigoProvincia, vot_depCodigoDepartamento, vot_mesCodigoCircuito, vot_mesCodigoMesa,
    "0060",     
    "0064",     
    "0181",     
    "0185",     
    "0186",     
    "0188",     
    "0501",     
    "0505",  
    "0542",     
    "0543" )
    AS
    (SELECT
            vot_proCodigoProvincia,
            vot_depCodigoDepartamento,
            vot_mesCodigoCircuito,
            vot_mesCodigoMesa,
                  max(CASE WHEN vot_parCodigo ="0060"        THEN votVotosPartido END), 
                  max(CASE WHEN vot_parCodigo ="0064"    THEN votVotosPartido END), 
                  max(CASE WHEN vot_parCodigo ="0181"    THEN votVotosPartido END), 
                  max(CASE WHEN vot_parCodigo ="0185"        THEN votVotosPartido END),
                  max(CASE WHEN vot_parCodigo ="0186"            THEN votVotosPartido END), 
                  max(CASE WHEN vot_parCodigo ="0188"    THEN votVotosPartido END), 
                  max(CASE WHEN vot_parCodigo ="0501"    THEN votVotosPartido END), 
                  max(CASE WHEN vot_parCodigo ="0505"    THEN votVotosPartido END), 
                  max(CASE WHEN vot_parCodigo ="0542" THEN votVotosPartido END), 
                  max(CASE WHEN vot_parCodigo ="0543" THEN votVotosPartido END)
            FROM
            VotosCandidaturaMesasDNacionales
            WHERE
            vot_proCodigoProvincia = '23' --TUCUMAN
            --AND vot_depCodigoDepartamento = '020' --
            --AND vot_mesCodigoCircuito in ('0304 ') --
            GROUP BY
            vot_proCodigoProvincia,
            vot_depCodigoDepartamento,
            vot_mesCodigoCircuito,
            vot_mesCodigoMesa
            ORDER BY
            vot_proCodigoProvincia,
            vot_depCodigoDepartamento,
            vot_mesCodigoCircuito,
            vot_mesCodigoMesa)
    SELECT
            vot_proCodigoProvincia AS codprov,
            depNombre AS depto,
            mes_depCodigoDepartamento AS coddepto,
             vot_mesCodigoCircuito AS circuito,
             vot_mesCodigoMesa AS mesa,
      --      sum(mesVotosValidos) AS validos,
            sum(mesElectores) AS electores,
            sum(mesVotosEnBlanco) AS blancos,
            sum(mesVotosNulos) AS nulos,
                  sum("0060") AS "0060", 
                  sum("0064") AS "0064", 
                  sum("0181") AS "0181", 
                  sum("0185") AS "0185",
                  sum("0186") AS "0186", 
                  sum("0188") AS "0188", 
                  sum("0501") AS "0501", 
                  sum("0505") AS "0505", 
                  sum("0542") AS "0542", 
                  sum("0543") AS "0543"
            FROM
            votos
               INNER JOIN MesasDNacionales  ON vot_proCodigoProvincia = mes_proCodigoProvincia 
                                    AND vot_depCodigoDepartamento = mes_depCodigoDepartamento
                                    AND vot_mesCodigoCircuito = mesCodigoCircuito
                                    AND vot_mesCodigoMesa = mesCodigoMesa
        INNER JOIN Departamento ON vot_proCodigoProvincia = depCodigoProvincia 
                             AND vot_depCodigoDepartamento = depCodigoDepartamento
         GROUP BY
         vot_proCodigoProvincia,
         vot_depCodigoDepartamento,
         depNombre, 
         vot_mesCodigoCircuito,
         vot_mesCodigoMesa
         ORDER BY
         vot_proCodigoProvincia,
         vot_depCodigoDepartamento,
         depNombre, 
         vot_mesCodigoCircuito,
         vot_mesCodigoMesa;

