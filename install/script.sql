
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

INSERT INTO products (id, name, description, price, views, image, category_id) VALUES ('MLM553823064', 'Xtreme Pc Amd Radeon Rx 550 Ryzen 7 4700s 16gb Ssd 480gb', '<h3>Especificaciones</h3>Marca: XTREME PC GAMING<br>Condición del ítem: Nuevo<br>Modelo: XTPCGR716GBRX550B<br>Largo del paquete: 46 cm<br>Peso del paquete: 11490 g<br>', 6999,2388, 'http://http2.mlstatic.com/D_830446-MLM48772106892_012022-O.jpg', 'MLM438450');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('Es un excelente inicio para una pc gaming entrada ', 'Es un producto perfecto para iniciar en el mundo del pc (que es lo que queria) ya que te permite jugar un monton de juegos con calidad intermedia entre xbox 360 y xbox one, eso si, esta se puede mejorar con una tarjeta grafica, si vas a entrar a jugar videojuegos en pc es muy recomendable, en lo demas es una computadora que responde muy bien.', 5, 'MLM553823064');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('Masomenos', 'Yo lo compre en una oferta a 9000 lo cual estaria bien si tuviera 16 de ram pero tiene 8 y al ser una gráfica integrada te limita mucho por lo que recomiendo armar tu la tuya con 10 y te quedaría un poco mejor o con esos 16 gb de ram.', 3, 'MLM553823064');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('Pueden conseguir al mucho mejor con lo que cuesta.', 'No vale la pena costo beneficio te dan cosas nuevas pero viejas a precio de primera linea. Estoy conforme con la compra más no feliz. Y la calidad de la tarjeta de video es la más baja del mercado no usan productos de \"primera\" como dicen.', 2, 'MLM553823064');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('Buena Computadora para el día a día.', 'Me parece una buena computadora a un excelente precio, vale lo que cuesta, y pues es buena para los que empiezan en el mundo del gaming, es buena para ir agregándole nuevo hardware: tarjeta gráfica y ram. Fue una buena compra!.', 5, 'MLM553823064');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('Execelente equipo, me encantó :3??', 'La verdad es muy buen equipo, no necesita gráfica dedicada ya que tiene radeon vega 11, no entiendo por qué dicen que necesita de una gráfica dedicada, por algo el procesador se llama ryzen 5 3400g with radeon graphics.', 5, 'MLM553823064');
INSERT INTO products (id, name, description, price, views, image, category_id) VALUES ('MLM1364492655', 'Pc Gamer Cpu Amd Ryzen 5600g Ram 8gb Ddr4 240gb Ssd Wi-fi', '<h3>Especificaciones</h3>Marca: Acteck<br>Condición del ítem: Nuevo<br>Modelo: Pc 5600g<br>Largo del paquete: 22 cm<br>Peso del paquete: 4560 g<br>', 7479.12,4015, 'http://http2.mlstatic.com/D_779263-MLM50352242237_062022-O.jpg', 'MLM438450');
INSERT INTO products (id, name, description, price, views, image, category_id) VALUES ('MLM1516318885', 'Apple Mac Mini Late 2014 Intel I5 8gb 1tb Ox', '<h3>Especificaciones</h3>Marca: Apple<br>Condición del ítem: Reacondicionado<br>Línea: Mac Mini<br>Modelo: Mac Mini 2.5 GHz<br>Largo del paquete: 43.2 cm<br>Peso del paquete: 1900 g<br>', 5979.08,9125, 'http://http2.mlstatic.com/D_692832-MLM51717361327_092022-O.jpg', 'MLM438450');
INSERT INTO products (id, name, description, price, views, image, category_id) VALUES ('MLM856926162', 'Xtreme Pc Geforce Gtx 1650 I5 11400f 16gb Ssd 480gb Wifi', '<h3>Especificaciones</h3>Marca: XTREME PC GAMING<br>Condición del ítem: Nuevo<br>Modelo: XTPCI516GB1650<br>', 13499,4701, 'http://http2.mlstatic.com/D_853566-MLM49555670668_042022-O.jpg', 'MLM438450');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('Muy buena, pero con 1 falla', 'Super buen producto, yo jamás pude correr el fortnite en la switch anterior a mas de 30 fps pero aquí, no manches, creo que valió la pena en más de 100 fps casi estables haciendo stream de fortnite sin tirones en calidad épica, lo único por lo que no le puedo dar 5 estrellas es que no me sirve el hdmi de la mother board, pero la de la gráfica si, alguien que me pueda dar alguna solución?? escríbame a mi nista @fernando_diego_2006.', 4, 'MLM856926162');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('Excelente', 'Llevo al rededor de un mes con esta computadora, y el rendimiento y sus características son muy buenas. Los componentes parecen ser de marcas reconocidas y con mucha calidad. No soy un experto pero sin duda es una computadora muy rápida, potente y bonita, corre los juegos más rápido que mi laptop dell g3, y se puede usar para photoshop o editores de vídeo sin problema, yo sí recomiendo esta pc.', 5, 'MLM856926162');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('Excelente', 'Llevo 7 meses con el gabinete y es promete lo que viene por el precio, lo conseguí con descuento y la verdad no me arrepiento me sirve para jugar, diseñar en 3d, edición y sobretodo que puedes hacer multitasking sin ningún problema. Vale la pena por el precio.', 5, 'MLM856926162');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('Es bueno ', 'Le doy solo 4 estrellas solo porque para ser gamer le falta espacio en disco.', 4, 'MLM856926162');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('Excelente', 'Excelente. El. Producto muy bueno es lo que yo esperaba cumple con mis espectativas.', 5, 'MLM856926162');
INSERT INTO products (id, name, description, price, views, image, category_id) VALUES ('MLM1451112338', 'Computadora Hp 280 G5 Core I3-10100 Wi 10pro 4gb 1tb 1r2k2la', '<h3>Especificaciones</h3>Marca: HP<br>Condición del ítem: Nuevo<br>Modelo: 1R2K2LA#ABM<br>', 11999,8899, 'http://http2.mlstatic.com/D_629055-MLM50545461455_072022-O.jpg', 'MLM438450');
INSERT INTO products (id, name, description, price, views, image, category_id) VALUES ('MLM921148918', 'Super Computadora Intel Core I7 16gb 500gb Monitor De 24\'\' ', '<h3>Especificaciones</h3>Marca: Dell<br>Condición del ítem: Reacondicionado<br>Modelo: Optiplex<br>', 8730,9001, 'http://http2.mlstatic.com/D_898157-MLM52419704543_112022-O.jpg', 'MLM438450');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('Bueno', 'Podía haber sido excelente, pero lamentablemente un detalle dió al traste. La base que adjuntan para sostener la pantalla, no embona como debiera en la parte de los tornillos. Se ve que no tuvieron la curiosidad de probarla antes y lo hubieran detectado perfectamente. Lo pude solucionar, pero aprendí que no debo comprar usado sin ver el equipo antes bien armado. Por lo demás, ha funcionado bién. Lastima de este importante detalle. Por eso los califico así.', 3, 'MLM921148918');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('BUEN PRODUCTO', 'Hola, te compré super computadora intel core, solo quiero saber si esta tiene antivirus, la instalé pero poco a poco la voy usando, y quiero saber sobre el antivirus por seguridad.', 4, 'MLM921148918');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('Muy malo', 'Ni mercado libre ni el proovedor me hicieron efectiva la garantía a los 2 meces la computadora dejo de funcionar y nadie me ha ofcrecido garantía sobre mi compra.', 1, 'MLM921148918');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('Muy bueno', 'Es excelente muy rapida se los recomiendo es una compañia que si cumple lomque ofrece.', 4, 'MLM921148918');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('Excelente', 'Justo lo que buscaba. Buen producto. Volvería a comprar con pc1.', 5, 'MLM921148918');
INSERT INTO products (id, name, description, price, views, image, category_id) VALUES ('MLM1443815085', 'iMac 21.5 Core I5 5ta 8gb Ram 1tb Hdd', '<h3>Especificaciones</h3>Marca: Apple<br>Condición del ítem: Reacondicionado<br>Largo: <br>Línea: iMac<br>Modelo: 2015  5k<br>Peso: <br>', 7600,7420, 'http://http2.mlstatic.com/D_714430-MLM52184193024_102022-O.jpg', 'MLM438450');
INSERT INTO products (id, name, description, price, views, image, category_id) VALUES ('MLM1425947269', 'Xtreme Pc Geforce Rtx 3050 Ryzen 7 5800x 16gb Ssd 2tb Wifi', '<h3>Especificaciones</h3>Marca: XTREME PC GAMING<br>Condición del ítem: Nuevo<br>Modelo: XTPCR716GB3050B<br>Largo del paquete: 52 cm<br>Peso del paquete: 10600 g<br>', 20616.47,4058, 'http://http2.mlstatic.com/D_722401-MLM50029709474_052022-O.jpg', 'MLM438450');
INSERT INTO products (id, name, description, price, views, image, category_id) VALUES ('MLM1387427482', ' Mini Pc Intel Celeron J4125 8gb Ddr4 128gb Ssd Windows11', '<h3>Especificaciones</h3>Marca: Kamrui<br>Condición del ítem: Nuevo<br>Línea: Mini Pc<br>Modelo: GK3V(8+128)<br>Largo del paquete: 22.4 cm<br>Peso del paquete: 840 g<br>', 3304.71,6925, 'http://http2.mlstatic.com/D_656052-CBT52391926706_112022-O.jpg', 'MLM438450');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('Bueno', 'Llevo una semana usandolo así que no puedo dar una opinion real. Es rapido, solo tiene una entrada o salida de audio es el unico pero que le pongo ya que necesitaria una más para trabajar bien. Por el momento todo bien.', 3, 'MLM1387427482');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('Excelente', 'Bis jetzt bin ich ganz zufrieden, auch wenn es mal einige tage mit dem wlan (wifi) probleme gab. Aber das kann auch wegen windows probleme gegeben haben. Muss nicht am gerät gelegen haben.', 5, 'MLM1387427482');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('Excelente relación calidad /precio ', 'Es un buen producto respecto a calidad y precio, muy fácil de configurar y poner en marcha, es ideal para espacios pequeños, tareas básicas y compatible con muchos dispositivos.', 5, 'MLM1387427482');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('Calidad-precio', 'Excelente producto calidad precio, funciona correctamente de acuerdo al hardware instalado.', 5, 'MLM1387427482');
INSERT INTO products (id, name, description, price, views, image, category_id) VALUES ('MLM904228176', 'Xtreme Pc Amd Radeon Rx 6700 Xt Ryzen 7 32gb Ssd 3tb Wifi', '<h3>Especificaciones</h3>Marca: XTREME PC GAMING<br>Condición del ítem: Nuevo<br>Modelo: XTPCR732GB6700XTV1<br>Largo del paquete: 56 cm<br>Peso del paquete: 3320 g<br>', 24899,5226, 'http://http2.mlstatic.com/D_713060-MLM48864160277_012022-O.jpg', 'MLM438450');
INSERT INTO products (id, name, description, price, views, image, category_id) VALUES ('MLM1379479982', 'Potente Equipo Para Diseño Dell Precisión 64gb Ram 8gb Video', '<h3>Especificaciones</h3>Marca: Dell<br>Condición del ítem: Reacondicionado<br>Modelo: Precision T5810<br>', 18480,3315, 'http://http2.mlstatic.com/D_622447-MLM49121754645_022022-O.jpg', 'MLM438450');
INSERT INTO products (id, name, description, price, views, image, category_id) VALUES ('MLM1313268630', 'Computadora Dell Optiplex I5 2da Gen Con 4gb Ram Y 250gb Hdd', '<h3>Especificaciones</h3>Marca: Dell<br>Condición del ítem: Reacondicionado<br>Modelo: Optiplex<br>', 3649,945, 'http://http2.mlstatic.com/D_632233-MLM48439649298_122021-O.jpg', 'MLM438450');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('Aceptable', 'El cpu bien el monitor regular pero teclado y mouse de muy baja calidad, sin embargo por el precio se comprende, pero si avisaran que por un extra se puede tener todo de la misma marca dell pues podríamos considerarlo.', 3, 'MLM1313268630');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('Excelente', 'Muy bue equipo justo lo que espera a x por el precio! solo un detallito con el teclado que escribía otra letra pero de ahí en fuera todo en buen estado.', 5, 'MLM1313268630');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('Lo mejor de lo mejor ', 'Lo mejor de lo mejor. Yo pregunto poco pero compro mucho hubo un detalle pero me lo resolvieron inmediatamente. Recomendó mucho el producto!!.', 5, 'MLM1313268630');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('Muy bueno', 'Buen producto, cumple con lo prometido y el rendimiento es bueno. Hubo un par de detalles, comprensibles por la naturaleza del producto.', 4, 'MLM1313268630');
INSERT INTO reviews (name, text, rate, product_id) VALUES ('Excelente', 'Muy buena pc y buen precio y para lo que la necesite me funciona a la perfeccion.', 5, 'MLM1313268630');
INSERT INTO products (id, name, description, price, views, image, category_id) VALUES ('MLM1328018641', 'Xtreme Pc Gamer Amd Radeon Vega Renoir Ryzen 5 5600g 8gb Ssd', '<h3>Especificaciones</h3>Marca: XTREME PC GAMING<br>Condición del ítem: Nuevo<br>Modelo: XTPCR58GBRENOIRM<br>Largo del paquete: 47 cm<br>Peso del paquete: 12420 g<br>', 9949.5,6498, 'http://http2.mlstatic.com/D_610914-MLM47920948630_102021-O.jpg', 'MLM438450');
INSERT INTO products (id, name, description, price, views, image, category_id) VALUES ('MLM1555628105', 'Computadora All In One Asus Vivo Aio V241eak 11va Gen Intel Color Blanco De 1920pxx1080px Con Procesador Intel Core I3-1115g4, Memoria Ram De 8gb, Disco Duro De 1tb, Disco Sólido Con Una Capacidad De ', '<h3>Descripción</h3>Con una all in one ahorrar espacio y realizar múltiples tareas es posible.  Es un dispositivo diseñado para satisfacer todas las necesidades informáticas en un solo elemento, el monitor. Tiene integrada la cpu con todos sus complementos, el teclado, mouse y todo lo necesario para cumplir con tus tareas. Pantalla antireflex. La pantalla con protección antireflex reduce la cantidad de luz ambiental y directa, y ayuda así a disminuir la fatiga visual, resaltando la vitalidad de los colores.<br><h3>Especificaciones</h3>Marca: Asus<br>Condición del ítem: Nuevo<br>Largo: 47.9 mm<br>Línea: Vivo AiO<br>Modelo: V241EAK 11va Gen Intel<br>Peso: 5.4 kg<br>', 21699,5340, 'http://http2.mlstatic.com/D_758669-MLA50305165736_062022-O.jpg', 'MLM438450');
INSERT INTO products (id, name, description, price, views, image, category_id) VALUES ('MLM1505452295', 'Mini Pc Host Herobox Intel J4125 8 Gb 256 Gb Ssd Windows 10', '<h3>Especificaciones</h3>Marca: Chuwi<br>Condición del ítem: Nuevo<br>Línea: HeroBox<br>Modelo: HeroBox<br>Largo del paquete: 24 cm<br>Peso del paquete: 1120 g<br>Peso: 0.59 kg<br>', 3803.25,2507, 'http://http2.mlstatic.com/D_634708-CBT52346955137_112022-O.jpg', 'MLM438450');


-- LA TABLA DE METADATOS SE LLENARA EN AUTOMATICO AL GUARDARSE LA INFORMACION DEL PRODUCTO