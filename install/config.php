<?php
// Parámetros DB
define('DB_HOST', '127.0.0.1');
define('DB_PORT', 3306);
define('DB_USER', 'root');
define('DB_PASS', 'root');
define('DB_NAME', 'powerpc');

// App Root
define('APPROOT', dirname(dirname(__FILE__)));
// URL Root
define('URLROOT', 'http://'. $_SERVER['HTTP_HOST'] .'/powerpc');
// Nombre del sitio
define('SITENAME', 'Power PC');