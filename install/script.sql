
-- CREACION DEL ESQUEMA
CREATE DATABASE `powerpc` DEFAULT CHARSET=utf8mb4;
USE `powerpc`;

-- CREACION DE TABLA DE CATEGORIAS
CREATE TABLE `categories` (
    `id` VARCHAR(20) NOT NULL,
    `name` TEXT NOT NULL,
    `parent_id` VARCHAR(20) DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `fk_category_parent` (`parent_id`),
    CONSTRAINT `fk_category_parent` FOREIGN KEY (`parent_id`)
        REFERENCES `categories` (`id`)
)  ENGINE=INNODB DEFAULT CHARSET=utf8mb4;

-- CREACION DE TABLA DE PRODUCTOS
CREATE TABLE `products` (
    `id` VARCHAR(20) NOT NULL,
    `model` TEXT NOT NULL,
    `specification` TEXT NOT NULL,
    `price` DOUBLE NOT NULL,
    `thumbnail` TEXT NOT NULL,
    `image` TEXT NOT NULL,
    `category_id` VARCHAR(20) NOT NULL,
    PRIMARY KEY (`id`),
    KEY `fk_product_category` (`category_id`),
    CONSTRAINT `fk_product_category` FOREIGN KEY (`category_id`)
        REFERENCES `categories` (`id`)
)  ENGINE=INNODB DEFAULT CHARSET=utf8mb4;

-- CREACION DE TABLA DE COMENTARIOS
CREATE TABLE `reviews` (
  `id` int(11) NOT NULL,
  `name` text DEFAULT NULL,
  `text` text NOT NULL,
  `rate` int(1) NOT NULL,
  `product_id` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_product_review` (`product_id`),
  CONSTRAINT `fk_product_review` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- CREACION DE TABLA DE METAINFORMACION
CREATE TABLE `metainfo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `register_date` datetime DEFAULT current_timestamp(),
  `modify_date` datetime DEFAULT NULL,
  `visits` int(11) DEFAULT 0,
  `product_id` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_product_metainfo` (`product_id`),
  CONSTRAINT `fk_product_metainfo` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

-- MODIFICACION DE LA TABLA DE PRODUCTOS, AGREGANDO LA COLUMNA DE VISTAS
ALTER TABLE `products` 
ADD COLUMN `views` INT NOT NULL DEFAULT 0 AFTER `price`;

-- CREACION DE VISTA DE PRODUCTOS ORDENADOS POR MEJOR CALIFICACION, JUNTO A SUS COMENTARIOS AGRUPADOS
DELIMITER //
CREATE VIEW `products_reviews` AS
    SELECT 
        reviews.product_id,
        model,
        specification,
        price,
        views,
        thumbnail,
        image,
        categories.name,
        reviews,
        average
    FROM
        products
            INNER JOIN
        categories ON categories.id = products.category_id
            INNER JOIN
        (SELECT 
            product_id,
                GROUP_CONCAT(name, ': ', text
                    SEPARATOR ' | ') AS reviews,
                AVG(RATE) AS average
        FROM
            reviews
        GROUP BY product_id
        ORDER BY AVG(RATE) DESC) reviews ON reviews.product_id = products.id
    ORDER BY average DESC;
DELIMITER ;

-- CREACION DE TRIGGER PARA LOS NUEVOS REGISTROS EN LA TABLA DE PRODUCTOS
DELIMITER //
CREATE DEFINER = CURRENT_USER TRIGGER `products_insert_metainfo` AFTER INSERT ON `products` FOR EACH ROW
BEGIN

    INSERT INTO metainfo (product_id)
    VALUES (NEW.id);

END //
DELIMITER ;

-- CREACION DE PROCEDIMIENTO PARA CALCULAR LOS PAGOS MENSUALES DE CADA PRODUCTO (SE PUEDEN CALCULAR A CUALQUIER MENSUALIDAD)
DELIMITER // 
CREATE PROCEDURE `calc_monthly_payments` ( IN product_id VARCHAR(20), IN total_payments INT )
BEGIN

	SELECT 
    ROUND(((price * ((10 / 100) / 12)) / (1 - POWER(1 + (10 / 100) / 12, - total_payments))),
            2) AS monthly_payment
FROM
    products
WHERE id = product_id;

END //
DELIMITER ;

-- CREACION DE VISTA DE PRODUCTOS ALEATORIOS CORRESPONDIENTES A UNA CATEGORIA ALEATORIA, JUNTO A LOS PAGOS POR MES DE 6 Y 12 MENSUALIDADES
DELIMITER //
CREATE VIEW `random_products` AS
    SELECT 
        products.id,
        model,
        specification,
        thumbnail,
        image,
        category_id,
        name AS category,
        price,
        ROUND(((price * ((10 / 100) / 12)) / (1 - POWER(1 + (10 / 100) / 12, - 6))),
                2) AS payment_for_six_months,
        ROUND(((price * ((10 / 100) / 12)) / (1 - POWER(1 + (10 / 100) / 12, - 12))),
                2) AS payment_for_twelve_months
    FROM
        products
            INNER JOIN
        (SELECT 
            id, name
        FROM
            categories
        ORDER BY RAND()
        LIMIT 1) categories ON categories.id = products.category_id
    ORDER BY RAND()
    LIMIT 10;
DELIMITER ;