<?php

include "config.php";
include "../php/libraries/Database.php";
include "../php/libraries/Controller.php";

class Installer extends Controller {
    public $productsModel;
    public $reviewsModel;


    public function __construct() {
        $this->productsModel = $this->model('Product');
        $this->reviewsModel = $this->model('Review');
    }

    public function createProducts() {

        $marcas = ['Dell', 'HP', 'Lenovo', 'Acer', 'Asus', 'Microsoft', 'Samsung'];
        $modelos = ['Inspiron', 'Envy', 'ThinkPad', 'Nitro', 'ZenBook', 'Surface', 'Galaxy Book'];
        $procesadores = ['Intel Core i5', 'Intel Core i7', 'AMD Ryzen 5', 'AMD Ryzen 7', 'Intel Core M3', 'Intel Core i9'];
        $tarjetas_graficas = ['NVIDIA GeForce GTX 1660', 'AMD Radeon RX 580', 'Intel UHD Graphics 630', 'AMD Radeon RX Vega 10', 'NVIDIA GeForce GTX 1650'];
        $ram = ['4GB', '8GB', '16GB', '32GB', '64GB'];
        $categorias = ["MLM430687", "MLM438450", "MLM122506", "MLM1649", "MLM187128", "MLM419477", "MLM1651", "MLM122457"];
        $disco_duro = ['1TB', '2TB', '256GB SSD', '512GB SSD', '1TB SSD'];
        $imagen = ["http://http2.mlstatic.com/D_632233-MLM48439649298_122021-O.jpg", "http://http2.mlstatic.com/D_610914-MLM47920948630_102021-O.jpg", "http://http2.mlstatic.com/D_751987-MLM51905941398_102022-O.jpg", "http://http2.mlstatic.com/D_604719-MLM51788697170_102022-O.jpg", "http://http2.mlstatic.com/D_722401-MLM50029709474_052022-O.jpg", "http://http2.mlstatic.com/D_715593-MLM49851889000_052022-O.jpg", "http://http2.mlstatic.com/D_898157-MLM52419704543_112022-O.jpg", "http://http2.mlstatic.com/D_713060-MLM48864160277_012022-O.jpg", "http://http2.mlstatic.com/D_949999-MLM42285663467_062020-O.jpg", "http://http2.mlstatic.com/D_751354-MLM49684143924_042022-O.jpg"];

        $adjetivos = ["Buena", "Excelente", "Impresionante", "Maravillosa", "Increíble", "Fantástica", "Sorprendente", "Excepcional", "Magnífica", "Asombrosa"];
        $sustantivos = ["calidad", "durabilidad", "funcionalidad", "precio", "diseño", "performance", "eficiencia", "versatilidad", "facilidad de uso", "comodidad"];
        $verbos = ["Lo recomiendo", "Lo compraría de nuevo", "Lo volvería a adquirir", "Lo volvería a elegir", "No dudaría en recomendar", "Definitivamente volvería a comprar", "Sin lugar a dudas lo recomendaría", "Sin duda alguna lo compraría de nuevo", "Definitivamente lo elegiría de nuevo", "Sin duda lo volvería a adquirir"];

        for ($i = 0; $i < 200; $i++) {

            $data = [];

            $marcaIndex = array_rand($marcas);
            $modeloIndex = array_rand($modelos);
            $procesadorIndex = array_rand($procesadores);
            $tarjeta_graficaIndex = array_rand($tarjetas_graficas);
            $ramIndex = array_rand($ram);
            $categoriaIndex = array_rand($categorias);
            $disco_duroIndex = array_rand($disco_duro);
            $imagenIndex = array_rand($imagen);
            $vistas = rand(0, 10000);

            $data['name'] = $marcas[$marcaIndex] . ' ' . $modelos[$modeloIndex] . ' ' . $procesadores[$procesadorIndex] . ' ' . $tarjetas_graficas[$tarjeta_graficaIndex] . ' ' . $ram[$ramIndex] . ' ' . $disco_duro[$disco_duroIndex];
            $data['description'] = '<h3>Especificaciones</h3>Marca: ' . $marcas[$marcaIndex] . '<br>Modelo: ' . $modelos[$modeloIndex] . '<br>Familia de procesador: ' . $procesadores[$procesadorIndex] . '<br>Tarjeta Gráfica: ' . $tarjetas_graficas[$tarjeta_graficaIndex] . '<br>Memoria RAM: ' . $ram[$ramIndex] . '<br>Capacidad de almacenamiento: ' . $disco_duro[$disco_duroIndex];
            $data['price'] = mt_rand(10000, 60000);
            $data['views'] = rand(0, 10000);
            $data['image'] = $imagen[$imagenIndex];
            $data['category_id'] = $categorias[$categoriaIndex];

            $product_id = $this->productsModel->addProduct($data);
            $dataReview = [];

            for ($j = 0; $j < 5; $j++) {
                $adjectiveIndex = array_rand($adjetivos);
                $nounIndex = array_rand($sustantivos);
                $verbIndex = array_rand($verbos);
                $rating = $precio = mt_rand(3, 5);
                $dataReview['name'] = $verbos[$verbIndex];
                $dataReview['text'] = $adjetivos[$adjectiveIndex] . " " . $sustantivos[$nounIndex] . ".  " . $verbos[$verbIndex] . ".";
                $dataReview['rate'] = $rating;
                $dataReview['product_id'] = $product_id;

                $this->reviewsModel->setReview($dataReview);
            }

        }

        echo "Productos creados, ya puedes cerrar esta página.";

    }
}

?>