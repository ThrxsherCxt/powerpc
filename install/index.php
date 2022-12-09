<?php

set_time_limit(0);
ini_set('max_execution_time', 0);

include "Installer.php";

$products = new Installer();
$products->createProducts();