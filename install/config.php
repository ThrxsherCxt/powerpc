<?php
// Parámetros DB
define('DB_HOST', 'localhost');
define('DB_USER', 'root');
define('DB_PASS', '');
define('DB_NAME', 'powerpc');

// App Root
define('APPROOT', dirname(dirname(__FILE__)));
// URL Root
define('URLROOT', 'http://'. $_SERVER['HTTP_HOST'] .'/powerpc');
// Nombre del sitio
define('SITENAME', 'Power PC');