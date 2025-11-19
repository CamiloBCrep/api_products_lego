-- Sentencias SQL para poblar la tabla 'products' con datos de ejemplo.
-- Puedes ejecutar esto en la pestaña "SQL" de phpMyAdmin para la base de datos 'api_products_lego'.

-- Nota: Asumimos que `inStock: true` = 10 unidades, `inStock: false` = 0 unidades.
-- Los campos `created_at` y `updated_at` se llenan automáticamente con la fecha y hora actuales.

INSERT INTO `products` (`name`, `price`, `image_path`, `category`, `quantity`, `created_at`, `updated_at`) VALUES
('Set de Construcción de Ciudad', 59.99, 'assets/images/lego1.jpg', 'City', 10, NOW(), NOW()),
('Halcón Milenario', 159.99, 'assets/images/lego2.jpg', 'Star Wars', 0, NOW(), NOW()),
('Bugatti Chiron', 349.99, 'assets/images/lego3.jpg', 'Technic', 10, NOW(), NOW()),
('Casa de Amigos', 69.99, 'assets/images/lego4.jpg', 'Friends', 10, NOW(), NOW()),
('Estación de Policía', 79.99, 'assets/images/lego5.jpg', 'City', 10, NOW(), NOW()),
('Microfighter Halcón Milenario', 9.99, 'assets/images/lego6.jpg', 'Star Wars', 10, NOW(), NOW()),
('Excavadora', 99.99, 'assets/images/lego7.jpg', 'Technic', 10, NOW(), NOW()),
('Casa del Árbol de Amigos', 89.99, 'assets/images/lego8.jpg', 'Friends', 10, NOW(), NOW());
