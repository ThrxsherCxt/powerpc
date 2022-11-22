<?php

set_time_limit(0);

include "Installer.php";

$products = new Installer();
$products->getData();