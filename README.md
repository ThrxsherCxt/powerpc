<div align="right">
  <h1>Mario Alberto Rivera Aguilar</h1>
    mxrio.riverx@gmail.com<br>
    55 6208 2302
</div>

<div align="center">
  <h2><b>PROCESO DE SELECCIÓN</b><br></h2>
  <h3>Assessment de nivel de habilidades</h3>
  <h3>Para desarrollador Full-Stack - Nivel AVANZADO</h3>
</div>
<hr>

### <h1>Tecnologías utilizadas y de conocimiento</h1>

<details>
  <summary>Back-End</summary>
  <ul>
    <li><a href="https://www.php.net/">PHP</a> - 80% de dominio</li>
  </ul>
</details>

<details>
  <summary>Server</summary>
  <ul>
    <li><a href="https://httpd.apache.org/">Apache</a> - 75% de dominio</li>

  </ul>
</details>

<details>
<summary>Database</summary>
  <ul>
    <li><a href="https://www.mysql.com/">MySQL</a> - 85% de dominio</li>
  </ul>
</details>

<details>
<summary>Front-End</summary>
  <ul>
    <li><a href="https://developer.mozilla.org/es/docs/Web/HTML">HTML</a> - 90% de dominio</li>
    <li><a href="https://developer.mozilla.org/es/docs/Web/CSS">CSS</a> - 90% de dominio</li>
    <li><a href="https://developer.mozilla.org/es/docs/Web/JavaScript">JavaScript</a> - 85% de dominio</li>
  </ul>
</details>
<br>

<!-- Getting Started -->
## <h1>Guía de Instalación</h1>

<!-- Prerequisites -->
### Pre-requisitos

Este proyecto necesita tener instalado alguna tecnología LAMP, MAMP o WAMP, de prefeerencia PHP versión 7.4 o superior. En mi caso utilicé XAMPP, el cuál se puede descargar del siguiente enlace:
<br>

```bash
https://www.apachefriends.org/es/
```

### Instalación

Descargar el zip o clonar el proyecto en la carpeta deseada, de preferencia en la carpeta public_html (o www en ocasiones) del servidor de Apache.

```bash
  git clone https://github.com/ThrxsherCxt/powerpc.git
```
No hace falta descargar más archivos, por lo que procedemos a configurar las variables de entorno del sistema.

Poner la carpeta del proyecto en la estructura adecuada, en mi caso es la siguiente:

```bash
  C:\xampp\htdocs\powerpc
```

Iniciar el servidor de Apache y MySQL, se pueden abrir desde el Centro de Control de XAMPP.

## Configuración

Necesitamos ajustar las variables de entorno, por lo que procederemos para empezar, yendo a la ruta
```bash
  powerpc\install\config.php
```

Dentro de la ruta ajustaremos las siguientes variables de entorno

```php
define('DB_HOST', 'localhost'); //Aquí colocamos nuestro hostname para la base de datos
define('DB_USER', 'root'); // Escribimos nuestro usuario de la base de datos
define('DB_PASS', ''); // Ingresamos la contraseña en caso de contar con ella
define('DB_NAME', 'powerpc'); // Este es el nombre que lleva nuestro esquema de base de datos, en caso de necesitar cambiarlo, también se tendrá que modificar (más adelante se explica cómo)

// App Root
define('APPROOT', dirname(dirname(__FILE__))); // No es necesario mosificarlo
// URL Root
define('URLROOT', 'http://'. $_SERVER['HTTP_HOST'] .'/powerpc'); // En caso de que el proyecto esté dentro de la carpeta de powerpc y no en public_html, se debe conservar. Si la carpeta powerpc está dentro de múltiples carpetas, deberá ser necesario añadir las carpetas a la ruta.
// Nombre del sitio
define('SITENAME', 'Power PC'); // Éste es el nombre que creé para mi assessment, si se desea configurar, este es el lugar.
```

Si se cambió el nombre del esquema de la base de datos, será necesario también configurarlo en el siguiente archivo
```bash
  powerpc\install\script.sql
```

```sql
-- CREACION DEL ESQUEMA
CREATE DATABASE IF NOT EXISTS `powerpc` DEFAULT CHARSET = utf8mb4; -- El nombre tiene que coincidir con el anteriormente mencionado

USE `powerpc`; -- Tenemos que seleccionar el esquema a utilizar
```
<br>

Una vez configurado el archivo, ejecutamos el script SQL en nuestro gestor de base de datos favorito, en mi caso utilicé MySQL Workbench.<br><br>
<b>NOTA:<b> En mi caso no me dejó importar el script de SQl directamente, si no que tuve abrirlo como una hoja de trabajo, seleccionar tod el código y ejecutarlo.

<br>
<h1>Correr Script de creación de datos</h1>
Iremos a la siguiente ruta en el navegador

```bash
  http://localhost/powerpc/install/
```

La página se quedará en este estado por varios minutos <br>

<img src="public_html\assets\img\readme\loading.png" />
<br>

<strong>ESTO ES TOTALMENTE NORMAL, TARDARÁ MÁS DE 10 MINUTOS. NO CIERRES LA PESTAÑA O EL NAVEGADOR.</strong>

Al finalizar, imprimirá una serie de mensajes, como son los siguientes
<br>


<img src="public_html\assets\img\readme\Captura de pantalla (3).png" />
<img src="public_html\assets\img\readme\Captura de pantalla (4).png" />

Cuando encuentres el mensaje de Carga finalizada, significa que el script se ejecutó correctamente. Puedes revisar en la base de datos para comprobar los registros agregados. Ahora si puedes cerrar la pestaña o el navegador.

## <h1>Tareas pendientes por realizar</h1>

<h3>Considero que son áreas de oportunidad en dónde se pueden afinar detalles, ya que se tiene que considerar que en ocasiones la planeación llega a fallar y toma más tiempo de lo estimado.</h3>
<br>

* &#10060; Cada producto deberá estar dividido en 3 categorías distintas: Se tiene jerarquía, sin embargo solamente son dos niveles (padre e hijo).

* &#10060; Cuando se dé click en una categoría, se abrirán categorías hijas y se mostrarán los dos
listados, tanto destacados como de más vendidos filtrados por la categoría seleccionada: La categorías hijas se muestran por defecto cuando movemos el cursor a "Categorías" sin embargo una vez dentro de las categorías, no se visualiza la rama de jerarquía de las categorías disponibles.

* &#10060; Agregar un campo y funcionalidad de búsqueda: Me hubiera gustado realizar esta parte, sin embargo mi planeación estimada no me permitió implementarlo, sin embargo pienso que es de las funcionalidades más utiles dentro de un sistema de ventas.

* &#10060; Generar el log de Instalación: realicé una prueba, sin embargo por el tiempo ya no me fue suficiente implementarlo como me hubiera gustado.

<br>

## <h1>Capturas de pantalla</h1>
<h2>Desktop</h2>

<h4>* Inicio</h4>
<img src="public_html\assets\img\readme\localhost_powerpc_.png" width="800"/><br>
<img src="public_html\assets\img\readme\localhost_powerpc_ (2).png" width="800" /><br>
<h4>* Menú de categorías</h4>
<img src="public_html\assets\img\readme\localhost_powerpc_ (1).png" width="800" /><br>

<h4>* Destacados</h4>
<img src="public_html\assets\img\readme\localhost_powerpc_productos_destacados.png" width="800" /><br>

<h4>* Categoría</h4>
<img src="public_html\assets\img\readme\localhost_powerpc_categoria_MLM1691.png" width="800" /><br>

<h4>* Producto</h4>
<img src="public_html\assets\img\readme\localhost_powerpc_producto_MLM1427771667.png" width="800" /><br>

<h4>* Reseñas</h4>
<img src="public_html\assets\img\readme\localhost_powerpc_producto_MLM1427771667 (1).png" width="800" /><br>

<h4>* Recomendaciones</h4>
<img src="public_html\assets\img\readme\localhost_powerpc_producto_MLM1427771667 (2).png" width="800" /><br>


<h2>Mobile</h2>

<div align="center">



<h4>Inicio</h4>
<img src="public_html\assets\img\readme\localhost_powerpc_(Nexus 5X) (1).png" width="350"/><br>
<h4>Menú</h4>
<img src="public_html\assets\img\readme\localhost_powerpc_(Nexus 5X) (2).png"  width="350"/><br>
<h4>Menú de categorías</h4>
<img src="public_html\assets\img\readme\localhost_powerpc_(Nexus 5X) (3).png"  width="350"/><br>

<h4>Producto</h4>
<img src="public_html\assets\img\readme\localhost_powerpc_producto_MLM914418073(Nexus 5X).png" width="350"/><br>

<h4>Especificaciones y Reseñas</h4>
<img src="public_html\assets\img\readme\localhost_powerpc_producto_MLM914418073(Nexus 5X) (1).png" width="350"/><br>

<h4>Recomendaciones</h4>
<img src="public_html\assets\img\readme\localhost_powerpc_producto_MLM914418073(Nexus 5X) (2).png" width="350"/><br>

<h4>Pie de Página</h4>
<img src="public_html\assets\img\readme\localhost_powerpc_producto_MLM914418073(Nexus 5X) (3).png" width="350"/><br>

</div>
