# Usamos la imagen oficial de PHP con Apache (versión 8.2 recomendada para Laravel moderno)
FROM php:8.2-apache

# 1. Instalar dependencias del sistema necesarias
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# 2. Limpiar caché de apt para reducir el tamaño de la imagen
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# 3. Instalar extensiones de PHP requeridas por Laravel
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# 4. Habilitar el módulo rewrite de Apache (Vital para las rutas de Laravel)
RUN a2enmod rewrite

# 5. Instalar Composer (copiándolo desde la imagen oficial)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 6. Establecer directorio de trabajo
WORKDIR /var/www/html

# 7. Copiar todo el código del proyecto al contenedor
COPY . /var/www/html

# 8. Ajustar la configuración de Apache para que apunte a la carpeta /public
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# 9. Instalar dependencias de Composer
# Usamos --no-dev para producción (quita esto si es para desarrollo)
RUN composer install --optimize-autoloader --no-dev

# 10. Asignar permisos (CRÍTICO en Laravel)
# Apache corre como www-data, así que le damos propiedad de las carpetas storage y cache
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# 11. Exponer el puerto 80
EXPOSE 80

# El comando por defecto de la imagen base ya arranca Apache, no hace falta poner CMD