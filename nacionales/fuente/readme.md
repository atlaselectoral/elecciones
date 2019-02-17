# Fuentes de datos

La fuente original de datos para resultados de elecciones nacionales (2003 - 2017) provienen del *Atlas Electoral de Andy Tow*. Se puede acceder a ellas en  las sección de **descargas de su [sitio web](https://www.andytow.com/atlas/totalpais/downloads.html)**. Para acceder es necesario autenticar la consulta a través de una cuenta de *Twitter*. 

---

### Para el procesamiento de datos de este repositorio seguimos los siguientes pasos: 

**(1)** Descargamos los archivos para cada una de las elecciones. 

**(2)** Pasamos del formato original (`mdb`) de *Microsoft Acces* a formato compatible para trabajar con *software* no propietario. En este caso *sqlite*. 

**(3)** Desde el entorno de `RStudio`corrimos un programa para trabajar con lengauje `SQL` en las múltiples tablas del archivo original (que incluye datos de todos los distritos de Argentina para cada una de las elecciones) y generar un archivo de texto separado por comas (`.csv`) para los datos de interes del distrito Tucumán. 
