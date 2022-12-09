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

        $resultProducts = $this->callAPI('https://api.mercadolibre.com/sites/MLM/search?category=' . $category . '&has_pictures=true&limit=15');

        $products = $resultProducts->results;

        foreach ($products as $product) {

            $data = [];
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

            $data['id'] = $product->id;
            $data['name'] = addslashes($product->title);
            $data['description'] = addslashes($productDescription . $productSpecifications);
            $data['price'] = $product->price;
            $data['views'] = rand(0, 10000);
            $data['image'] = 'http://http2.mlstatic.com/D_' . $product->thumbnail_id . '-O.jpg';
            $data['category_id'] = $category;

            $this->productsModel->addProduct($data);

            do {
                $dataResult = [];
                $resultReviews = $this->callAPI('https://api.mercadolibre.com/reviews/item/' . $product->id);

                if (isset($resultReviews->status)) {
                    $status = 409;
                } else {
                    $status = 'OK';
                    $reviews = $resultReviews->reviews;
                    foreach ($reviews as $review) {
                        $dataResult['name'] = addslashes($review->title);
                        $dataResult['text'] = addslashes($review->content);
                        $dataResult['rate'] = $review->rate;
                        $dataResult['product_id'] = $product->id;

                        $this->reviewsModel->setReview($dataResult);
                    }
                }
            } while ($status === 409);

        }

    }

    public function getData() {

        echo "<h3>Por favor, no cierres esta ventana hasta que el script finalice.</h3>";

        $parent_categories = $this->categoriesModel->getParentCategories();

        $total = count($parent_categories);

        foreach ($parent_categories as $key => $parent_category) {

            $this->doQueries($parent_category->id);

            $children_categories = $this->categoriesModel->getChildCategories($parent_category->id);

            foreach ($children_categories as $children_category) {
                $this->doQueries($children_category->id);
            }

            echo '<h4>'. ($key + 1) . " de $total categorias principales cargadas.</h4><br><br>";

        }

        echo "<b>Carga finalizada.</b>";

    }
}

?>