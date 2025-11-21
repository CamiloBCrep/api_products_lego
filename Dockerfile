# Usamos la imagen oficial de PHP con Apache
FROM php:8.2-apache

# 1. Instalar dependencias del sistema y limpiar caché en una sola capa (Correction for SonarQube)
# Se ordenan alfabéticamente y se une el 'rm -rf' al final para no dejar basura en la imagen
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    libonig-dev \
    libpng-dev \
    libxml2-dev \
    unzip \
    zip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 2. Instalar extensiones de PHP requeridas por Laravel
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# 3. Habilitar el módulo rewrite de Apache (Vital para rutas Laravel)
RUN a2enmod rewrite

# 4. Instalar Composer (copiándolo desde la imagen oficial)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 5. Establecer directorio de trabajo
WORKDIR /var/www/html

# 6. Copiar todo el código del proyecto al contenedor
COPY . /var/www/html

# 7. Ajustar la configuración de Apache para que apunte a la carpeta /public
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# 8. Instalar dependencias de Composer (Optimizado para producción)
RUN composer install --optimize-autoloader --no-dev

# 9. Asignar permisos a las carpetas de escritura de Laravel
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# 10. Exponer el puerto 80
EXPOSE 80