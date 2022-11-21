<?php
class Product {
    private $db;

    public function __construct() {
        $this->db = new Database;
    }

    public function getIndexRandomProducts() {
        $this->db->query('SELECT 
                            products.id AS product_id,
                            products.name AS product_name,
                            FORMAT(products.price, 2) AS product_price,
                            products.image AS product_image,
                            CASE
                                WHEN average IS NOT NULL THEN (ROUND(average))
                                ELSE 0
                            END AS product_rating
                        FROM
                            products
                                LEFT JOIN
                            products_reviews ON products_reviews.product_id = products.id
                        ORDER BY average DESC , RAND()
                        LIMIT 10;');

        $results = $this->db->resultSet();

        return $results;
    }
    public function getRandomProducts() {
        $this->db->query('SELECT 
                            products.id AS product_id,
                            products.name AS product_name,
                            FORMAT(products.price, 2) AS product_price,
                            products.image AS product_image,
                            CASE
                                WHEN average IS NOT NULL THEN (ROUND(average))
                                ELSE 0
                            END AS product_rating
                        FROM
                            products
                                LEFT JOIN
                            products_reviews ON products_reviews.product_id = products.id
                        ORDER BY average DESC , RAND()
                        LIMIT 50;');

        $results = $this->db->resultSet();

        return $results;
    }

    public function getIndexBestRating() {
        $this->db->query('SELECT 
                            product_id,
                            producto_nombre AS product_name,
                            FORMAT(price, 2) AS product_price,
                            image AS product_image,
                            (ROUND(average)) AS product_rating
                        FROM
                            products_reviews
                        LIMIT 10;');

        $results = $this->db->resultSet();

        return $results;
    }
    public function getBestRating() {
        $this->db->query('SELECT 
                            product_id,
                            producto_nombre AS product_name,
                            FORMAT(price, 2) AS product_price,
                            image AS product_image,
                            (ROUND(average)) AS product_rating
                        FROM
                            products_reviews
                        LIMIT 50;');

        $results = $this->db->resultSet();

        return $results;
    }

    public function addProduct($data) {
        $this->db->query("INSERT INTO products (id, name, description, price, views, image, category_id) VALUES (:id, :description, :price, :views, :image, :category_id);");

        $this->db->bind(':id', $data['id']);
        $this->db->bind(':description', $data['description']);
        $this->db->bind(':price', $data['price']);
        $this->db->bind(':views', $data['views']);
        $this->db->bind(':image', $data['image']);
        $this->db->bind(':category_id', $data['category_id']);

        if ($this->db->execute()) {
            return true;
        } else {
            return false;
        }
    }

    public function getProductById($id) {
        $this->db->query('SELECT 
                            products.id AS product_id,
                            products.name AS product_name,
                            products.description AS product_description,
                            FORMAT(products.price, 2) AS product_price,
                            products.category_id AS product_category,
                            products.image AS product_image,
                            CASE
                                WHEN average IS NOT NULL THEN (ROUND(average))
                                ELSE 0
                            END AS product_rating
                        FROM
                            products
                                LEFT JOIN
                            products_reviews ON products_reviews.product_id = products.id
                        WHERE products.id = :id;');

        $this->db->bind(':id', $id);
        $row = $this->db->single();

        return $row;
    }
    public function getProductsByCategory($category) {
        $this->db->query('SELECT 
                            products.id AS product_id,
                            products.name AS product_name,
                            FORMAT(products.price, 2) AS product_price,
                            products.image AS product_image,
                            CASE
                                WHEN average IS NOT NULL THEN (ROUND(average))
                                ELSE 0
                            END AS product_rating
                        FROM
                            products
                                LEFT JOIN
                            products_reviews ON products_reviews.product_id = products.id
                        WHERE products.category_id = :id;');

        $this->db->bind(':id', $category);
        $results = $this->db->resultSet();

        return $results;
    }

    public function searchProducts($word) {
        $this->db->query('SELECT 
                        products.id AS product_id,
                        products.name AS product_name,
                        FORMAT(products.price, 2) AS product_price,
                        products.image AS product_image,
                        CASE
                            WHEN average IS NOT NULL THEN (ROUND(average))
                            ELSE 0
                        END AS product_rating
                    FROM
                        products
                            LEFT JOIN
                        products_reviews ON products_reviews.product_id = products.id
                    WHERE products.name LIKE :search;');

        $this->db->bind(':search', '%'.$word.'%');
        $results = $this->db->resultSet();

        return $results;
    }

}