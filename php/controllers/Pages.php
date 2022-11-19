<?php
class Pages extends Controller {

    public function __construct() {

    }

    public function index() {
        $this->view('index');
    }

    public function mas_vendidos() {
        $this->view('productos/mas_vendidos');
    }
    public function destacados() {
        $this->view('productos/destacados');
    }

}