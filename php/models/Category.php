<?php
class Category {
    private $db;

    public function __construct() {
        $this->db = new Database;
    }

    public function getParentCategories() {
        $this->db->query('SELECT 
                            id, name
                        FROM
                            categories
                        WHERE
                            parent_id IS NULL;');

        $results = $this->db->resultSet();

        return $results;
    }

    public function getChildCategories($parent_id) {
        $this->db->query('SELECT 
                            id, name
                        FROM
                            categories
                        WHERE
                            parent_id = :id;');

        $this->db->bind(':id', $parent_id);
        $results = $this->db->resultSet();

        return $results;
    }

}