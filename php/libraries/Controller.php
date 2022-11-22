<?php

class Controller {

    public function model($model) {
        require_once '../php/models/' . $model . '.php';
        return new $model();
    }

    public function view($view, $data = []) {
        if (file_exists('../php/views/' . $view . '.php')) {
            require_once '../php/views/' . $view . '.php';
        } else {
            die('La vista no existe.');
        }
    }
}