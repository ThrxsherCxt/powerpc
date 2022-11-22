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
        $this->db->close();

        return $results;
    }

    public function setReview($data) {
        $this->db->query('INSERT INTO reviews (name, text, rate, product_id) VALUES (:name, :text, :rate, :product_id);');
        $this->db->bind(':name', $data['name']);
        $this->db->bind(':text', $data['text']);
        $this->db->bind(':rate', $data['rate']);
        $this->db->bind(':product_id', $data['product_id']);

        if ($this->db->execute()) {
            $this->db->close();
            return true;
        } else {
            $this->db->close();
            return false;
        }
    }

}