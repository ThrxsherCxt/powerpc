<?php

include "config.php";
include "../php/libraries/Database.php";
include "../php/libraries/Controller.php";

class Installer extends Controller {
    public $productsModel;
    public $reviewsModel;
    public $categoriesModel;


    public function __construct() {
        $this->productsModel = $this->model('Product');
        $this->reviewsModel = $this->model('Review');
        $this->categoriesModel = $this->model('Category');
    }

    function callAPI($url) {
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_HEADER, 0);
        $response = curl_exec($ch);
        curl_close($ch);

        return json_decode(trim($response), );

    }

    function doQueries($category) {

        $txt = "";

        $resultProducts = $this->callAPI('https://api.mercadolibre.com/sites/MLM/search?category=' . $category . '&&has_pictures=true&limit=30');

        $products = $resultProducts->results;

        foreach ($products as $product) {

            $productDescription = "";
            $productSpecifications = "<h3>Especificaciones</h3>";

            if ($product->catalog_product_id !== null) {
                $resultDescription = $this->callAPI('https://api.mercadolibre.com/products/' . $product->catalog_product_id);
                $productDescription = $resultDescription->short_description->content !== "" ? '<h3>Descripción</h3>' . $resultDescription->short_description->content . '<br>' : "";
            }

            $attributes = $product->attributes;
            foreach ($attributes as $attribute) {
                $productSpecifications .= '<b>' . $attribute->name . '</b> : ' . $attribute->value_name . '<br>';
            }

            $txt.= "INSERT IGNORE INTO products (id, name, description, price, views, image, category_id) VALUES ('$product->id', '" . addslashes($product->title) . "', '" . addslashes($productDescription . $productSpecifications) . "', $product->price," . rand(0, 10000) . ", 'http://http2.mlstatic.com/D_$product->thumbnail_id-O.jpg', '$category');\n";


            do {
                $resultReviews = $this->callAPI('https://api.mercadolibre.com/reviews/item/' . $product->id);

                if (isset($resultReviews->status)) {
                    $status = 409;
                } else {
                    $status = 'OK';
                    $reviews = $resultReviews->reviews;
                    foreach ($reviews as $review) {
                        $txt.= "INSERT IGNORE INTO reviews (name, text, rate, product_id) VALUES ('" . addslashes($review->title) . "', '" . addslashes($review->content) . "', $review->rate, '$product->id');\n";
                    }
                }
            } while ($status === 409);

        }

        echo $txt;

    }

    public function getData() {

        $parent_categories = $this->categoriesModel->getParentCategories();

        $total = count($parent_categories);

        foreach ($parent_categories as $key => $parent_category) {

            $this->doQueries($parent_category->id);

            $children_categories = $this->categoriesModel->getChildCategories($parent_category->id);

            foreach ($children_categories as $children_category) {
                $this->doQueries($children_category->id);
            }

            echo "-- ". $key + 1 ."de $total categorias principales cargadas.<br><br>";

        }

    }
}





?>