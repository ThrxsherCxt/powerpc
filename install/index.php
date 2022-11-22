<?php

set_time_limit(0);

$log = fopen("scriptLog.txt", "w") or die("No se puede abrir/crear el archivo log. Revise la configuración de su servidor.");

// function callAPI($url) {
//     $ch = curl_init();
//     curl_setopt($ch, CURLOPT_URL, $url);
//     curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
//     curl_setopt($ch, CURLOPT_HEADER, 0);
//     $response = curl_exec($ch);
//     curl_close($ch);

//     return json_decode(trim($response), );

// }

// Obtener las categorías de los productos de Computación

// $resultCategories = callAPI('https://api.mercadolibre.com/categories/MLM1648');
// $categories = $resultCategories->children_categories;

// foreach ($categories as $category) {

//     echo "INSERT INTO categories(id, name) VALUES('$category->id', '$category->name');<br>";

//     $resultChildren_categories = callAPI('https://api.mercadolibre.com/categories/'. $category->id);
//     $children_categories = $resultChildren_categories->children_categories;

//     foreach ($children_categories as $children_category) {
//         echo "INSERT INTO categories(id, name, parent_id) VALUES('$children_category->id', '$children_category->name', '$category->id');<br>";
//     }

//     echo "<br><br>";

// }





// $category = 'MLM438450';

// $resultProducts = callAPI('https://api.mercadolibre.com/sites/MLM/search?category=' . $category . '&offset=100&has_pictures=true&limit=15');

// $products = $resultProducts->results;

// foreach ($products as $product) {

//     $productDescription = "";
//     $productSpecifications = "<h3>Especificaciones</h3>";

//     if ($product->catalog_product_id !== null) {
//         $resultDescription = callAPI('https://api.mercadolibre.com/products/' . $product->catalog_product_id);
//         $productDescription = $resultDescription->short_description->content !== "" ? '<h3>Descripción</h3>' . $resultDescription->short_description->content . '<br>' : "";
//     }

//     $attributes = $product->attributes;
//     foreach ($attributes as $attribute) {
//         $productSpecifications .= '<b>'.$attribute->name .'</b> : ' . $attribute->value_name . '<br>';
//     }

//     $txt = "INSERT INTO products (id, name, description, price, views, image, category_id) VALUES ('$product->id', '".addslashes($product->title)."', '".addslashes($productDescription.$productSpecifications)."', $product->price," . rand(0, 10000) . ", 'http://http2.mlstatic.com/D_$product->thumbnail_id-O.jpg', '$category');\n";
//     fwrite($log, $txt);

//     do {
//         $resultReviews = callAPI('https://api.mercadolibre.com/reviews/item/' . $product->id);

//         if (isset($resultReviews->status)) {
//             $status = 409;
//         } else {
//             $status = 'OK';
//             $reviews = $resultReviews->reviews;
//             foreach ($reviews as $review) {
//                 $txt = "INSERT INTO reviews (name, text, rate, product_id) VALUES ('".addslashes($review->title)."', '".addslashes($review->content)."', $review->rate, '$product->id');\n";
//                 fwrite($log, $txt);
//             }
//         }
//     } while ($status === 409);

// }



include "Installer.php";

$products = new Installer();
$products->getData();

