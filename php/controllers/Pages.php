<?php

class Pages extends Controller {

    public $productsModel;
    public $reviewsModel;
    public $categoriesModel;

    public function __construct() {
        $this->productsModel = $this->model('Product');
        $this->reviewsModel = $this->model('Review');
        $this->categoriesModel = $this->model('Category');
        $this->navbar();
    }

    public function index($id = []) {

        if ($id === []) {

            $random_products = $this->productsModel->getIndexRandomProducts();
            $best_rating = $this->productsModel->getIndexBestRating();

            $data = [
                'random_products' => $random_products,
                'best_rating' => $best_rating,
            ];

            $this->view('pages/index', $data);

        } else {

            if (str_contains($_SERVER['REQUEST_URI'], 'producto')) {


                $id = substr($_SERVER['REQUEST_URI'], strrpos($_SERVER['REQUEST_URI'], '/') + 1);

                $product = $this->productsModel->getProductById($id);
                $sixPayments = $this->productsModel->monthlyPayment($id, 6);
                $twelvePayments = $this->productsModel->monthlyPayment($id, 12);
                $reviews = $this->reviewsModel->getReviews($id);
                $random_products = $this->productsModel->getIndexRandomProducts();

                $data = [
                    'product' => $product,
                    'sixPayments' => $sixPayments,
                    'twelvePayments' => $twelvePayments,
                    'reviews' => $reviews,
                    'random_products' => $random_products
                ];

                $this->view('producto/index', $data);

            } else if (str_contains($_SERVER['REQUEST_URI'], 'categoria')) {

                $id = substr($_SERVER['REQUEST_URI'], strrpos($_SERVER['REQUEST_URI'], '/') + 1);
                $products = $this->productsModel->getProductsByCategory($id);
                $category = $this->categoriesModel->getCategoryName($id);

                $data = [
                    'products' => $products,
                    'category_name' => $category
                ];

                $this->view('categoria/index', $data);

            }

        }
    }

    public function mas_vendidos() {

        $best_rating = $this->productsModel->getBestRating();

        $data = [
            'best_rating' => $best_rating
        ];

        $this->view('productos/mas_vendidos', $data);
    }

    public function destacados() {

        $random_products = $this->productsModel->getRandomProducts();

        $data = [
            'random_products' => $random_products
        ];

        $this->view('productos/destacados', $data);
    }

    public function navbar() {

        $parent_categories = $this->categoriesModel->getParentCategories();

        $categories = [];

        foreach ($parent_categories as $key => $parent_category) {
            array_push($categories, $parent_category);
            $children_categories = $this->categoriesModel->getChildCategories($parent_category->id);

            foreach ($children_categories as $keyC => $children_category) {
                $categories[$key]->children[$keyC] = $children_category;
            }

        }

        define('CATEGORIES', $categories);

    }

}