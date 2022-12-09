<?php

class Controller {

    public function model($model) {
        require_once '../php/models/' . $model . '.php';
        return new $model();
    }

    public function view($view, $data = []) {
        if (file_exists('../public_html/views/' . $view . '.php')) {
            require_once '../public_html/views/' . $view . '.php';
        } else {
            die('La vista no existe.');
        }
    }
}