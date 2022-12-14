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
                        ORDER BY RAND()
                        LIMIT 10;');

        $results = $this->db->resultSet();
        $this->db->close();

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
                        ORDER BY RAND()
                        LIMIT 50;');

        $results = $this->db->resultSet();
        $this->db->close();

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
        $this->db->close();

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
        $this->db->close();

        return $results;
    }

    public function addProduct($data) {
        $this->db->query("INSERT INTO products (name, description, price, views, image, category_id) VALUES (:name, :description, :price, :views, :image, :category_id);");

        $this->db->bind(':name', $data['name']);
        $this->db->bind(':description', $data['description']);
        $this->db->bind(':price', $data['price']);
        $this->db->bind(':views', $data['views']);
        $this->db->bind(':image', $data['image']);
        $this->db->bind(':category_id', $data['category_id']);

        if ($this->db->execute()) {
            $this->db->close();
            return $this->db->insertedID();
        } else {
            $this->db->close();
            return false;
        }
    }

    // public function lastProductID(){
    //     return $this->db->insertedID();
    // }
    public function updateMetainfo($id) {
        $this->db->query('CALL updateMetainfo(:id);');
        $this->db->bind(':id', $id);

        if ($this->db->execute()) {
            $this->db->close();
            return true;
        } else {
            $this->db->close();
            return false;
        }
    }

    public function getProductById($id) {
        $this->updateMetainfo($id);
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
        $this->db->close();

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
        $this->db->close();

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

        $this->db->bind(':search', '%' . $word . '%');
        $results = $this->db->resultSet();
        $this->db->close();

        return $results;
    }

    public function monthlyPayment($id, $months) {
        $this->db->query('CALL powerpc.calc_monthly_payments(:id, :months);');
        $this->db->bind(':id', $id);
        $this->db->bind(':months', $months);

        $results = $this->db->resultSet();
        $this->db->close();

        return $results;
    }

}