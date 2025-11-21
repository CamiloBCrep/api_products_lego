# Usamos la imagen oficial de PHP con Apache
FROM php:8.2-apache

# 1. Instalar dependencias y limpiar (Optimizada)
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

# 2. Instalar extensiones PHP
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# 3. Habilitar rewrite
RUN a2enmod rewrite

# 4. Configurar Apache para usar puerto 8080 (Necesario para usuario no-root)
# Cambiamos el puerto de escucha de 80 a 8080 en la configuración de Apache
RUN sed -i 's/80/8080/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

# 5. Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 6. Directorio de trabajo
WORKDIR /var/www/html

# 7. Copiar código
COPY . /var/www/html

# 8. Configurar DocumentRoot
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# 9. Instalar dependencias de Composer y ajustar permisos
# Es crucial dar permisos a www-data ANTES de cambiar de usuario
RUN composer install --optimize-autoloader --no-dev \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# 10. SOLUCIÓN SONAR: Cambiar a usuario no-root
USER www-data

# 11. Exponer puerto 8080 (ya no es el 80)
EXPOSE 8080