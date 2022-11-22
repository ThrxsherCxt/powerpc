
-- CREACION DEL ESQUEMA
CREATE DATABASE IF NOT EXISTS `powerpc` DEFAULT CHARSET=utf8mb4;
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
    `name` TEXT NOT NULL,
    `description` TEXT NOT NULL,
    `price` DOUBLE NOT NULL,
    `image` TEXT NOT NULL,
    `category_id` VARCHAR(20) NOT NULL,
    PRIMARY KEY (`id`),
    KEY `fk_product_category` (`category_id`),
    CONSTRAINT `fk_product_category` FOREIGN KEY (`category_id`)
        REFERENCES `categories` (`id`)
)  ENGINE=INNODB DEFAULT CHARSET=utf8mb4;

-- CREACION DE TABLA DE COMENTARIOS
CREATE TABLE `reviews` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
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
CREATE VIEW `products_reviews` AS
    SELECT 
        reviews.product_id,
        products.name AS 'producto_nombre',
        description,
        price,
        views,
        image,
        categories.name AS 'categoria_nombre',
        reviews,
        average
    FROM
        products
            INNER JOIN
        categories ON categories.id = products.category_id
            INNER JOIN
        (SELECT 
            product_id,
                GROUP_CONCAT(reviews.name, ': ', text
                    SEPARATOR ' | ') AS reviews,
                AVG(RATE) AS average
        FROM
            reviews
        GROUP BY product_id
        ORDER BY AVG(RATE) DESC) reviews ON reviews.product_id = products.id
    ORDER BY average DESC;

-- CREACION DE TRIGGER PARA LOS NUEVOS REGISTROS EN LA TABLA DE PRODUCTOS
DELIMITER //
CREATE TRIGGER `products_insert_metainfo` AFTER INSERT ON `products` FOR EACH ROW
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
CREATE VIEW `random_products` AS
    SELECT 
        products.id,
        products.name,
        description,
        image,
        category_id,
        categories.name AS category,
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
        WHERE id = 'MLM438450' ) categories ON categories.id = products.category_id
    ORDER BY RAND()
    LIMIT 10;

-- CREACION DE PROCEDIMIENTO PARA ACTUALIZAR LA METAINFORMACION CON CADA VISITA AL PRODUCTO

DELIMITER // 
CREATE PROCEDURE `updateMetainfo`(IN product_id_IN VARCHAR(20))
BEGIN

DECLARE var_visits INT;

    SELECT 
        visits
    INTO var_visits FROM
        metainfo
    WHERE
        product_id = product_id_IN;
        
    UPDATE metainfo 
    SET 
        modify_date = NOW(),
        visits = var_visits + 1 
    WHERE
        product_id = product_id_IN;
    
END //
DELIMITER ;


-- INSERCION DE DATOS A SUS RESPECTIVAS TABLAS


-- CATEGORIES

INSERT INTO categories(id, name) VALUES('MLM191082', 'Accesorios de Antiestática');
INSERT INTO categories(id, name, parent_id) VALUES('MLM430684', 'Batas Antiestáticas', 'MLM191082');
INSERT INTO categories(id, name, parent_id) VALUES('MLM191092', 'Bolsas Antiestáticas', 'MLM191082');
INSERT INTO categories(id, name, parent_id) VALUES('MLM191091', 'Guantes Antiestáticos', 'MLM191082');
INSERT INTO categories(id, name, parent_id) VALUES('MLM433456', 'Kits de Antiestática', 'MLM191082');
INSERT INTO categories(id, name, parent_id) VALUES('MLM191191', 'Pinzas Antiestáticas', 'MLM191082');
INSERT INTO categories(id, name, parent_id) VALUES('MLM191083', 'Pulseras Antiestáticas', 'MLM191082');
INSERT INTO categories(id, name, parent_id) VALUES('MLM191086', 'Tapetes Antiestáticos', 'MLM191082');
INSERT INTO categories(id, name, parent_id) VALUES('MLM191084', 'Otros', 'MLM191082');

INSERT INTO categories(id, name) VALUES('MLM447778', 'Accesorios para PC Gaming');
INSERT INTO categories(id, name, parent_id) VALUES('MLM6777', 'Audífonos', 'MLM447778');
INSERT INTO categories(id, name, parent_id) VALUES('MLM2048', 'Controles para Gamers', 'MLM447778');
INSERT INTO categories(id, name, parent_id) VALUES('MLM447780', 'Lentes de Realidad Virtual', 'MLM447778');
INSERT INTO categories(id, name, parent_id) VALUES('MLM10743', 'Micrófonos', 'MLM447778');
INSERT INTO categories(id, name, parent_id) VALUES('MLM447782', 'Sillas Gamer', 'MLM447778');
INSERT INTO categories(id, name, parent_id) VALUES('MLM447783', 'Tarjetas Prepagas para Juegos', 'MLM447778');
INSERT INTO categories(id, name, parent_id) VALUES('MLM447784', 'Otros', 'MLM447778');

INSERT INTO categories(id, name) VALUES('MLM430598', 'Almacenamiento');
INSERT INTO categories(id, name, parent_id) VALUES('MLM429545', 'Cartuchos de Datos', 'MLM430598');
INSERT INTO categories(id, name, parent_id) VALUES('MLM5017', 'Discos y Accesorios', 'MLM430598');
INSERT INTO categories(id, name, parent_id) VALUES('MLM432852', 'Diskettes', 'MLM430598');
INSERT INTO categories(id, name, parent_id) VALUES('MLM430185', 'Emuladores de Disqueteras', 'MLM430598');
INSERT INTO categories(id, name, parent_id) VALUES('MLM4117', 'Memorias Portátiles USB/FLASH', 'MLM430598');
INSERT INTO categories(id, name, parent_id) VALUES('MLM191198', 'USB Padlocks', 'MLM430598');
INSERT INTO categories(id, name, parent_id) VALUES('MLM430604', 'Otros', 'MLM430598');

INSERT INTO categories(id, name) VALUES('MLM10848', 'Cables y Conectores');
INSERT INTO categories(id, name, parent_id) VALUES('MLM437546', 'Cables', 'MLM10848');
INSERT INTO categories(id, name, parent_id) VALUES('MLM439401', 'Hubs USB', 'MLM10848');
INSERT INTO categories(id, name, parent_id) VALUES('MLM430919', 'Otros', 'MLM10848');

INSERT INTO categories(id, name) VALUES('MLM1691', 'Componentes de PC');
INSERT INTO categories(id, name, parent_id) VALUES('MLM430796', 'Discos y Accesorios', 'MLM1691');
INSERT INTO categories(id, name, parent_id) VALUES('MLM430895', 'Emuladores de Disqueteras', 'MLM1691');
INSERT INTO categories(id, name, parent_id) VALUES('MLM430916', 'Fuentes de Alimentación', 'MLM1691');
INSERT INTO categories(id, name, parent_id) VALUES('MLM1696', 'Gabinetes', 'MLM1691');
INSERT INTO categories(id, name, parent_id) VALUES('MLM430462', 'Lectores de Disquetes', 'MLM1691');
INSERT INTO categories(id, name, parent_id) VALUES('MLM1694', 'Memorias RAM', 'MLM1691');
INSERT INTO categories(id, name, parent_id) VALUES('MLM1693', 'Procesadores', 'MLM1691');
INSERT INTO categories(id, name, parent_id) VALUES('MLM455814', 'Tarjetas', 'MLM1691');
INSERT INTO categories(id, name, parent_id) VALUES('MLM9728', 'Tarjetas de TV', 'MLM1691');
INSERT INTO categories(id, name, parent_id) VALUES('MLM2676', 'Ventiladores y Coolers', 'MLM1691');
INSERT INTO categories(id, name, parent_id) VALUES('MLM5014', 'Zip Drives', 'MLM1691');
INSERT INTO categories(id, name, parent_id) VALUES('MLM1699', 'Otros', 'MLM1691');

INSERT INTO categories(id, name) VALUES('MLM1700', 'Conectividad y Redes');
INSERT INTO categories(id, name, parent_id) VALUES('MLM8037', 'Adaptadores USB', 'MLM1700');
INSERT INTO categories(id, name, parent_id) VALUES('MLM7642', 'Antenas', 'MLM1700');
INSERT INTO categories(id, name, parent_id) VALUES('MLM430794', 'Cables de Red y Accesorios', 'MLM1700');
INSERT INTO categories(id, name, parent_id) VALUES('MLM456224', 'Consolas de Sistema Operativo', 'MLM1700');
INSERT INTO categories(id, name, parent_id) VALUES('MLM419856', 'Gabinetes para Servidores', 'MLM1700');
INSERT INTO categories(id, name, parent_id) VALUES('MLM191050', 'Herramientas', 'MLM1700');
INSERT INTO categories(id, name, parent_id) VALUES('MLM1703', 'Hubs', 'MLM1700');
INSERT INTO categories(id, name, parent_id) VALUES('MLM190973', 'Inyectores Poe', 'MLM1700');
INSERT INTO categories(id, name, parent_id) VALUES('MLM189728', 'Modems', 'MLM1700');
INSERT INTO categories(id, name, parent_id) VALUES('MLM189887', 'Patch Panels', 'MLM1700');
INSERT INTO categories(id, name, parent_id) VALUES('MLM5015', 'Routers', 'MLM1700');
INSERT INTO categories(id, name, parent_id) VALUES('MLM37160', 'Servidores de Impresión', 'MLM1700');
INSERT INTO categories(id, name, parent_id) VALUES('MLM1708', 'Switches', 'MLM1700');
INSERT INTO categories(id, name, parent_id) VALUES('MLM4122', 'Tarjetas de Red', 'MLM1700');
INSERT INTO categories(id, name, parent_id) VALUES('MLM438680', 'Telefonía IP', 'MLM1700');
INSERT INTO categories(id, name, parent_id) VALUES('MLM429268', 'Torres Arriostradas', 'MLM1700');
INSERT INTO categories(id, name, parent_id) VALUES('MLM1711', 'Otros', 'MLM1700');

INSERT INTO categories(id, name) VALUES('MLM182235', 'Impresión');
INSERT INTO categories(id, name, parent_id) VALUES('MLM414248', 'Accesorios', 'MLM182235');
INSERT INTO categories(id, name, parent_id) VALUES('MLM182237', 'Impresión 3D', 'MLM182235');
INSERT INTO categories(id, name, parent_id) VALUES('MLM1676', 'Impresoras', 'MLM182235');
INSERT INTO categories(id, name, parent_id) VALUES('MLM2141', 'Insumos de Impresión', 'MLM182235');
INSERT INTO categories(id, name, parent_id) VALUES('MLM430169', 'Máquinas de Recarga', 'MLM182235');
INSERT INTO categories(id, name, parent_id) VALUES('MLM10190', 'Repuestos', 'MLM182235');
INSERT INTO categories(id, name, parent_id) VALUES('MLM10888', 'Sistemas de Tinta Continua', 'MLM182235');
INSERT INTO categories(id, name, parent_id) VALUES('MLM182236', 'Otros', 'MLM182235');

INSERT INTO categories(id, name) VALUES('MLM430687', 'Laptops y Accesorios');
INSERT INTO categories(id, name, parent_id) VALUES('MLM437482', 'Accesorios para Laptops', 'MLM430687');
INSERT INTO categories(id, name, parent_id) VALUES('MLM1652', 'Laptops', 'MLM430687');
INSERT INTO categories(id, name, parent_id) VALUES('MLM419477', 'Netbooks', 'MLM430687');
INSERT INTO categories(id, name, parent_id) VALUES('MLM439472', 'Otros', 'MLM430687');
INSERT INTO categories(id, name, parent_id) VALUES('MLM131444', 'Repuestos para Laptops', 'MLM430687');
INSERT INTO categories(id, name, parent_id) VALUES('MLM122457', 'Ultrabooks', 'MLM430687');

INSERT INTO categories(id, name) VALUES('MLM439434', 'Lectores y Scanners');
INSERT INTO categories(id, name, parent_id) VALUES('MLM191812', 'Colectores de Datos', 'MLM439434');
INSERT INTO categories(id, name, parent_id) VALUES('MLM430639', 'Lectoras y Grabadoras', 'MLM439434');
INSERT INTO categories(id, name, parent_id) VALUES('MLM73758', 'Lectores de Código de Barras', 'MLM439434');
INSERT INTO categories(id, name, parent_id) VALUES('MLM194635', 'Lectores de Huellas Digitales', 'MLM439434');
INSERT INTO categories(id, name, parent_id) VALUES('MLM439473', 'Lectores de Memorias', 'MLM439434');
INSERT INTO categories(id, name, parent_id) VALUES('MLM417029', 'Lectores de Tarjeta Magnética', 'MLM439434');
INSERT INTO categories(id, name, parent_id) VALUES('MLM9714', 'Scanners', 'MLM439434');
INSERT INTO categories(id, name, parent_id) VALUES('MLM439476', 'Otros', 'MLM439434');

INSERT INTO categories(id, name) VALUES('MLM36845', 'Limpieza y Cuidado de PCs');
INSERT INTO categories(id, name, parent_id) VALUES('MLM189507', 'Aires Comprimidos', 'MLM36845');
INSERT INTO categories(id, name, parent_id) VALUES('MLM189508', 'Alcohol Isopropílico', 'MLM36845');
INSERT INTO categories(id, name, parent_id) VALUES('MLM189635', 'Aspiradoras', 'MLM36845');
INSERT INTO categories(id, name, parent_id) VALUES('MLM189676', 'Espuma', 'MLM36845');
INSERT INTO categories(id, name, parent_id) VALUES('MLM191596', 'Gomas Limpiadoras', 'MLM36845');
INSERT INTO categories(id, name, parent_id) VALUES('MLM189678', 'Grasa de Silicon', 'MLM36845');
INSERT INTO categories(id, name, parent_id) VALUES('MLM191230', 'Hisopos de Limpieza', 'MLM36845');
INSERT INTO categories(id, name, parent_id) VALUES('MLM455837', 'Kits de Fundas para PC', 'MLM36845');
INSERT INTO categories(id, name, parent_id) VALUES('MLM189488', 'Kits de Limpieza', 'MLM36845');
INSERT INTO categories(id, name, parent_id) VALUES('MLM191916', 'Limpiadores de Pantallas', 'MLM36845');
INSERT INTO categories(id, name, parent_id) VALUES('MLM416788', 'Localizadores de Fallas', 'MLM36845');
INSERT INTO categories(id, name, parent_id) VALUES('MLM189679', 'Lubricantes para PC', 'MLM36845');
INSERT INTO categories(id, name, parent_id) VALUES('MLM189680', 'Paños Limpiadores', 'MLM36845');
INSERT INTO categories(id, name, parent_id) VALUES('MLM191129', 'Sprays Congelantes', 'MLM36845');
INSERT INTO categories(id, name, parent_id) VALUES('MLM430195', 'Tarjetas de Diagnóstico', 'MLM36845');
INSERT INTO categories(id, name, parent_id) VALUES('MLM189500', 'Otros', 'MLM36845');

INSERT INTO categories(id, name) VALUES('MLM1655', 'Monitores y Accesorios');
INSERT INTO categories(id, name, parent_id) VALUES('MLM432725', 'Bases de Monitores', 'MLM1655');
INSERT INTO categories(id, name, parent_id) VALUES('MLM38967', 'Filtros de Privacidad', 'MLM1655');
INSERT INTO categories(id, name, parent_id) VALUES('MLM416867', 'Fuentes', 'MLM1655');
INSERT INTO categories(id, name, parent_id) VALUES('MLM430627', 'Fundas para Monitores', 'MLM1655');
INSERT INTO categories(id, name, parent_id) VALUES('MLM1656', 'Monitores', 'MLM1655');
INSERT INTO categories(id, name, parent_id) VALUES('MLM187847', 'Racks de pared', 'MLM1655');
INSERT INTO categories(id, name, parent_id) VALUES('MLM194128', 'Soportes', 'MLM1655');
INSERT INTO categories(id, name, parent_id) VALUES('MLM1661', 'Otros', 'MLM1655');

INSERT INTO categories(id, name) VALUES('MLM1651', 'Palms y Pocket PCs');
INSERT INTO categories(id, name, parent_id) VALUES('MLM3308', 'Accesorios', 'MLM1651');
INSERT INTO categories(id, name, parent_id) VALUES('MLM3304', 'Palms', 'MLM1651');
INSERT INTO categories(id, name, parent_id) VALUES('MLM3307', 'Otros', 'MLM1651');

INSERT INTO categories(id, name) VALUES('MLM438450', 'PC de Escritorio');
INSERT INTO categories(id, name, parent_id) VALUES('MLM122506', 'All In One', 'MLM438450');
INSERT INTO categories(id, name, parent_id) VALUES('MLM1649', 'Computadoras y Servidores', 'MLM438450');
INSERT INTO categories(id, name, parent_id) VALUES('MLM187128', 'Mini PC', 'MLM438450');
INSERT INTO categories(id, name, parent_id) VALUES('MLM430638', 'Otros', 'MLM438450');

INSERT INTO categories(id, name) VALUES('MLM454379', 'Periféricos de PC');
INSERT INTO categories(id, name, parent_id) VALUES('MLM3378', 'Bocinas para PC', 'MLM454379');
INSERT INTO categories(id, name, parent_id) VALUES('MLM430630', 'Mouses y Teclados', 'MLM454379');
INSERT INTO categories(id, name, parent_id) VALUES('MLM1667', 'Webcams', 'MLM454379');
INSERT INTO categories(id, name, parent_id) VALUES('MLM454380', 'Otros', 'MLM454379');

INSERT INTO categories(id, name) VALUES('MLM10736', 'Proyectores y Pantallas');
INSERT INTO categories(id, name, parent_id) VALUES('MLM437762', 'Estuches para Proyectores', 'MLM10736');
INSERT INTO categories(id, name, parent_id) VALUES('MLM455835', 'Módulos Led', 'MLM10736');
INSERT INTO categories(id, name, parent_id) VALUES('MLM10721', 'Pantallas para Proyectores', 'MLM10736');
INSERT INTO categories(id, name, parent_id) VALUES('MLM437653', 'Piezas de Reposición', 'MLM10736');
INSERT INTO categories(id, name, parent_id) VALUES('MLM10725', 'Proyectores', 'MLM10736');
INSERT INTO categories(id, name, parent_id) VALUES('MLM431408', 'Retroproyectores', 'MLM10736');
INSERT INTO categories(id, name, parent_id) VALUES('MLM188960', 'Soportes', 'MLM10736');
INSERT INTO categories(id, name, parent_id) VALUES('MLM10718', 'Otros', 'MLM10736');

INSERT INTO categories(id, name) VALUES('MLM1718', 'Reguladores y No Breaks');
INSERT INTO categories(id, name, parent_id) VALUES('MLM189601', 'Baterías UPS', 'MLM1718');
INSERT INTO categories(id, name, parent_id) VALUES('MLM1720', 'No Breaks', 'MLM1718');
INSERT INTO categories(id, name, parent_id) VALUES('MLM1719', 'Reguladores de Voltaje', 'MLM1718');
INSERT INTO categories(id, name, parent_id) VALUES('MLM1722', 'Otros', 'MLM1718');

INSERT INTO categories(id, name) VALUES('MLM1723', 'Software');
INSERT INTO categories(id, name, parent_id) VALUES('MLM1736', 'Antivirus', 'MLM1723');
INSERT INTO categories(id, name, parent_id) VALUES('MLM1731', 'Diseño y Edición', 'MLM1723');
INSERT INTO categories(id, name, parent_id) VALUES('MLM190037', 'Educación y Referencia', 'MLM1723');
INSERT INTO categories(id, name, parent_id) VALUES('MLM430593', 'Redes y Servidores', 'MLM1723');
INSERT INTO categories(id, name, parent_id) VALUES('MLM1737', 'Sistemas Operativos', 'MLM1723');
INSERT INTO categories(id, name, parent_id) VALUES('MLM1728', 'Software Comercial', 'MLM1723');
INSERT INTO categories(id, name, parent_id) VALUES('MLM1733', 'Software de Oficina', 'MLM1723');
INSERT INTO categories(id, name, parent_id) VALUES('MLM191068', 'Softwares para Impresoras', 'MLM1723');
INSERT INTO categories(id, name, parent_id) VALUES('MLM1739', 'Otros', 'MLM1723');

INSERT INTO categories(id, name) VALUES('MLM182456', 'Tablets y Accesorios');
INSERT INTO categories(id, name, parent_id) VALUES('MLM85838', 'Accesorios', 'MLM182456');
INSERT INTO categories(id, name, parent_id) VALUES('MLM188942', 'E-readers', 'MLM182456');
INSERT INTO categories(id, name, parent_id) VALUES('MLM120342', 'Repuestos', 'MLM182456');
INSERT INTO categories(id, name, parent_id) VALUES('MLM82070', 'Tablets', 'MLM182456');
INSERT INTO categories(id, name, parent_id) VALUES('MLM182494', 'Otros', 'MLM182456');

INSERT INTO categories(id, name) VALUES('MLM1912', 'Otros');

-- PRODUCTS Y REVIEWS

INSERT INTO products (id, name, description, price, views, image, category_id) VALUES ('MLM1336873177', 'Hp Allinone 8gb 1tb 2gb Video Dedicado Licencia Windows 10', '<h3>Especificaciones</h3><b>Marca</b> : HP<br><b>Condición del ítem</b> : Nuevo<br><b>Largo</b> : 204.51 mm<br><b>Línea</b> : DESKTOP ALLINONE<br><b>Modelo</b> : 205 G4 22<br><b>Peso</b> : 5.7 kg<br>', 10950,2885, 'http://http2.mlstatic.com/D_604719-MLM51788697170_102022-O.jpg', 'MLM438450');
INSERT INTO products (id, name, description, price, views, image, category_id) VALUES ('MLM921148918', 'Super Computadora Intel Core I7 16gb 500gb Monitor De 24\'\' ', '<h3>Especificaciones</h3><b>Marca</b> : Dell<br><b>Condición del ítem</b> : Reacondicionado<br><b>Modelo</b> : Optiplex<br>', 8730,7354, 'http://http2.mlstatic.com/D_898157-MLM52419704543_112022-O.jpg', 'MLM438450');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('Bueno', 'Podía haber sido excelente, pero lamentablemente un detalle dió al traste. La base que adjuntan para sostener la pantalla, no embona como debiera en la parte de los tornillos. Se ve que no tuvieron la curiosidad de probarla antes y lo hubieran detectado perfectamente. Lo pude solucionar, pero aprendí que no debo comprar usado sin ver el equipo antes bien armado. Por lo demás, ha funcionado bién. Lastima de este importante detalle. Por eso los califico así.', 3, 'MLM921148918');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('BUEN PRODUCTO', 'Hola, te compré super computadora intel core, solo quiero saber si esta tiene antivirus, la instalé pero poco a poco la voy usando, y quiero saber sobre el antivirus por seguridad.', 4, 'MLM921148918');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('Muy malo', 'Ni mercado libre ni el proovedor me hicieron efectiva la garantía a los 2 meces la computadora dejo de funcionar y nadie me ha ofcrecido garantía sobre mi compra.', 1, 'MLM921148918');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('Muy bueno', 'Es excelente muy rapida se los recomiendo es una compañia que si cumple lomque ofrece.', 4, 'MLM921148918');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('Excelente', 'Justo lo que buscaba. Buen producto. Volvería a comprar con pc1.', 5, 'MLM921148918');
INSERT INTO products (id, name, description, price, views, image, category_id) VALUES ('MLM1455590078', 'Mini Pc Intel 11th Gen N5105 12gb 128gb Ssd Windows 11 Pro', '<h3>Especificaciones</h3><b>Marca</b> : CYXPC<br><b>Condición del ítem</b> : Nuevo<br><b>Línea</b> : Mini Pc<br><b>Modelo</b> : AK1-PRO(N5105-12+128)<br><b>Largo del paquete</b> : 22.4 cm<br><b>Peso del paquete</b> : 720 g<br>', 3710.07,5254, 'http://http2.mlstatic.com/D_859080-CBT52058596945_102022-O.jpg', 'MLM438450');
INSERT INTO products (id, name, description, price, views, image, category_id) VALUES ('MLM1425947269', 'Xtreme Pc Geforce Rtx 3050 Ryzen 7 5800x 16gb Ssd 2tb Wifi', '<h3>Especificaciones</h3><b>Marca</b> : XTREME PC GAMING<br><b>Condición del ítem</b> : Nuevo<br><b>Modelo</b> : XTPCR716GB3050B<br><b>Largo del paquete</b> : 52 cm<br><b>Peso del paquete</b> : 10600 g<br>', 20616.47,1936, 'http://http2.mlstatic.com/D_722401-MLM50029709474_052022-O.jpg', 'MLM438450');
INSERT INTO products (id, name, description, price, views, image, category_id) VALUES ('MLM904228176', 'Xtreme Pc Amd Radeon Rx 6700 Xt Ryzen 7 32gb Ssd 3tb Wifi', '<h3>Especificaciones</h3><b>Marca</b> : XTREME PC GAMING<br><b>Condición del ítem</b> : Nuevo<br><b>Modelo</b> : XTPCR732GB6700XTV1<br><b>Largo del paquete</b> : 56 cm<br><b>Peso del paquete</b> : 3320 g<br>', 23499,2964, 'http://http2.mlstatic.com/D_713060-MLM48864160277_012022-O.jpg', 'MLM438450');
INSERT INTO products (id, name, description, price, views, image, category_id) VALUES ('MLM1379479982', 'Potente Equipo Para Diseño Dell Precisión 64gb Ram 8gb Video', '<h3>Especificaciones</h3><b>Marca</b> : Dell<br><b>Condición del ítem</b> : Reacondicionado<br><b>Modelo</b> : Precision T5810<br>', 18480,1622, 'http://http2.mlstatic.com/D_622447-MLM49121754645_022022-O.jpg', 'MLM438450');
INSERT INTO products (id, name, description, price, views, image, category_id) VALUES ('MLM1328018641', 'Xtreme Pc Gamer Amd Radeon Vega Renoir Ryzen 5 5600g 8gb Ssd', '<h3>Especificaciones</h3><b>Marca</b> : XTREME PC GAMING<br><b>Condición del ítem</b> : Nuevo<br><b>Modelo</b> : XTPCR58GBRENOIRM<br><b>Largo del paquete</b> : 47 cm<br><b>Peso del paquete</b> : 12420 g<br>', 9949.5,3263, 'http://http2.mlstatic.com/D_610914-MLM47920948630_102021-O.jpg', 'MLM438450');
INSERT INTO products (id, name, description, price, views, image, category_id) VALUES ('MLM1532154832', 'Lenovo Aio V130-20igm Intel Celeron J4025 Dd 1tb Ram 4gb W10', '<h3>Especificaciones</h3><b>Marca</b> : Lenovo<br><b>Condición del ítem</b> : Nuevo<br><b>Largo</b> : <br><b>Línea</b> : Series V<br><b>Modelo</b> : V130<br><b>Peso</b> : <br>', 6399,6375, 'http://http2.mlstatic.com/D_751987-MLM51905941398_102022-O.jpg', 'MLM438450');
INSERT INTO products (id, name, description, price, views, image, category_id) VALUES ('MLM1478423548', 'Mini Pc Host Chuwi Herobox 8gb 256gb Ssd Intel J4125 Win10', '<h3>Especificaciones</h3><b>Marca</b> : Chuwi<br><b>Condición del ítem</b> : Nuevo<br><b>Línea</b> : Herobox<br><b>Modelo</b> : HeroBox<br><b>Largo del paquete</b> : 27.4 cm<br><b>Peso del paquete</b> : 1220 g<br><b>Peso</b> : 0.59 kg<br>', 3925.89,6880, 'http://http2.mlstatic.com/D_637789-CBT51081680727_082022-O.jpg', 'MLM438450');
INSERT INTO products (id, name, description, price, views, image, category_id) VALUES ('MLM1313268630', 'Computadora Dell Optiplex I5 2da Gen Con 4gb Ram Y 250gb Hdd', '<h3>Especificaciones</h3><b>Marca</b> : Dell<br><b>Condición del ítem</b> : Reacondicionado<br><b>Modelo</b> : Optiplex<br>', 3649,8356, 'http://http2.mlstatic.com/D_632233-MLM48439649298_122021-O.jpg', 'MLM438450');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('Aceptable', 'El cpu bien el monitor regular pero teclado y mouse de muy baja calidad, sin embargo por el precio se comprende, pero si avisaran que por un extra se puede tener todo de la misma marca dell pues podríamos considerarlo.', 3, 'MLM1313268630');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('Excelente', 'Muy bue equipo justo lo que espera a x por el precio! solo un detallito con el teclado que escribía otra letra pero de ahí en fuera todo en buen estado.', 5, 'MLM1313268630');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('Lo mejor de lo mejor ', 'Lo mejor de lo mejor. Yo pregunto poco pero compro mucho hubo un detalle pero me lo resolvieron inmediatamente. Recomendó mucho el producto!!.', 5, 'MLM1313268630');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('Muy bueno', 'Buen producto, cumple con lo prometido y el rendimiento es bueno. Hubo un par de detalles, comprensibles por la naturaleza del producto.', 4, 'MLM1313268630');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('Excelente', 'Muy buena pc y buen precio y para lo que la necesite me funciona a la perfeccion.', 5, 'MLM1313268630');
INSERT INTO products (id, name, description, price, views, image, category_id) VALUES ('MLM688529074', 'Xtreme Pc Intel Quad Core J4105 8gb Ssd 240gb Wifi', '<h3>Especificaciones</h3><b>Marca</b> : XTREME PC GAMER<br><b>Condición del ítem</b> : Nuevo<br><b>Modelo</b> : XTACIC8GBHD610<br><b>Largo del paquete</b> : 51 cm<br><b>Peso del paquete</b> : 940 g<br>', 3699,7137, 'http://http2.mlstatic.com/D_715593-MLM49851889000_052022-O.jpg', 'MLM438450');
INSERT INTO products (id, name, description, price, views, image, category_id) VALUES ('MLM869911682', 'Xtreme Pc Amd Radeon Vega Ryzen 5 4650g 16gb Ssd 3tb Wifi', '<h3>Especificaciones</h3><b>Marca</b> : XTREME PC GAMING<br><b>Condición del ítem</b> : Nuevo<br><b>Modelo</b> : XTPCR516GBRENOIR<br>', 7949.5,5372, 'http://http2.mlstatic.com/D_751354-MLM49684143924_042022-O.jpg', 'MLM438450');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('Cumplió mis expectativas, recomendado', 'De lo mejor que puedes encontrar en relación a calidad/precio. Dado a que en la misma publicación aclaran que los componentes varían, les digo que ese no es el gabinete que trae sino el \"aerocool quartz revo rgb atx negro\" y que la tarjeta madre es una \"gigabyte micro atx a520m ds3h\" la cual trae 4 slots para ram. En cuanto al rendimiento, la grafica integrada del procesador es de 2 gb. Pese a eso, me ha permitido correr juegos en diversas calidades como los siguientes:. Far cry 3 - muy alta. Rise of the tomb raider - alta. Shadow of the tomb raider - alta. Gta v - la mayoría de los ajustes entre alta y normal. Eso sí, no llega a los 60 fps, para eso si hay que bajarle a alguna característica del juego. El encendido y apagado es muy rápido y el gabinete es prácticamente silencioso a menos que se le exija bastante. Otro comentario es que el adaptador wi fi que tiene es muy básico, de corto alcance y apenas alcanza los y su maximo supuestamente es de 150 mbps, así que muy probablemente tendrán que comprar uno de mayor calidad o conectarlo al router.', 4, 'MLM869911682');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('Buena, aunque aún falta darle más uso', 'Buena computadora. Enciende rápido, la uso para cálculos y los realiza en un buen tiempo, sin embargo he sufrido un bloqueo al estar viendo un video y la computadora no reaccionó más, al grado que tuve que reiniciarla. Me está surgiendo la duda de regresarla a garantía por este hecho.', 5, 'MLM869911682');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('Buena', 'La verdad muy recomendado , me sirvio para jugar la mayoria de juegos populares en calidad media a 60 fps , y de parte para la escuela tambien me sirvio bastante ya que en general la computadora es buena en todos los aspectos (recomendada para iniciar).', 5, 'MLM869911682');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('Excelente ', 'Excelente pc, en el mercado no hay nada igual en calidad y precio. Yo desarrollo contenido con ella y puedo decir que es la mejor inversión que pude hacer.', 5, 'MLM869911682');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('Bueno', 'Le daría 5 estrellas pero en la publicación decís dos stocks de 8 gb para el dual chanel y solo traí un stock de 16.', 4, 'MLM869911682');
INSERT INTO products (id, name, description, price, views, image, category_id) VALUES ('MLM883303220', 'Computadora Dell Core I5 6ta Gen 16gb 1tb Monitor 22 Wifi  ', '<h3>Especificaciones</h3><b>Marca</b> : Dell /HP<br><b>Condición del ítem</b> : Reacondicionado<br><b>Modelo</b> : Optiplex 3040 /600G3<br>', 7832,9102, 'http://http2.mlstatic.com/D_949999-MLM42285663467_062020-O.jpg', 'MLM438450');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('Excelente equipo', 'Funciona perfectamente, incluye todo lo que incluía y a un muy buen precio. Lo recomiendo mucho si buscas una computadora potente y no quieres gastar en una nueva.', 5, 'MLM883303220');
INSERT INTO reviews (name, text, rate, product_id) VALUES (' Muy bien exelente producto', 'Me gusto mucho a pesar que no es un producto nuevo esta muy conservada el equipo lo recomiendo es justo lo que necesitaba para mi negocio.', 5, 'MLM883303220');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('No lo recomiendo dinero tirado a la basura ', 'Me empezo a fallar a los dos meses y ahora me dicen que tengo que comprar un disco duro. o se vale que vendan equipos dañados.', 1, 'MLM883303220');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('Bueno', 'Pues el monitor de la carcasa esta rayado, y el cpu esta rayado, y se escucha mucho el disco duro no se si sea normal.', 3, 'MLM883303220');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('Recomendado ', 'Excelente equipo lo recomiendo todo cumplido lo único que les falta es como especificar que equipos quedan de marca.', 5, 'MLM883303220');
INSERT INTO products (id, name, description, price, views, image, category_id) VALUES ('MLM862285641', 'Xtreme Pc Amd Radeon Rx 550 Ryzen 4700s 16gb Monitor 23.8', '<h3>Especificaciones</h3><b>Marca</b> : XTREME PC GAMING<br><b>Condición del ítem</b> : Nuevo<br><b>Modelo</b> : XTPCGR716GBRX550BM<br><b>Largo del paquete</b> : 59.5 cm<br><b>Peso del paquete</b> : 13120 g<br>', 10899,7789, 'http://http2.mlstatic.com/D_689577-MLM49221826110_022022-O.jpg', 'MLM438450');
INSERT INTO products (id, name, description, price, views, image, category_id) VALUES ('MLM1516318885', 'Apple Mac Mini Late 2014 Intel I5 8gb 1tb Ox', '<h3>Especificaciones</h3><b>Marca</b> : Apple<br><b>Condición del ítem</b> : Reacondicionado<br><b>Línea</b> : Mac Mini<br><b>Modelo</b> : Mac Mini 2.5 GHz<br><b>Largo del paquete</b> : 43.2 cm<br><b>Peso del paquete</b> : 1900 g<br>', 5979.08,7648, 'http://http2.mlstatic.com/D_692832-MLM51717361327_092022-O.jpg', 'MLM438450');


-- LA TABLA DE METADATOS SE LLENARA EN AUTOMATICO AL GUARDARSE LA INFORMACION DEL PRODUCTO