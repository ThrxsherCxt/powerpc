<?php
class Review {
    private $db;

    public function __construct() {
        $this->db = new Database;
    }

    public function getReviews($product) {
        $this->db->query('SELECT 
                            name, text, rate
                        FROM
                            reviews
                        WHERE
                            product_id = :id;');

        $this->db->bind(':id', $product);
        $results = $this->db->resultSet();

        return $results;
    }

}