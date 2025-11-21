# Usamos la imagen oficial de PHP con Apache
FROM php:8.2-apache

# 1. Instalar dependencias (Optimizado)
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

# 2. Extensiones PHP
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# 3. Configurar Apache (Puerto 8080 + Rewrite)
RUN a2enmod rewrite \
    && sed -i 's/80/8080/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

# 4. Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 5. Directorio de trabajo
WORKDIR /var/www/html

# 6. CACHÉ: Copiar solo dependencias primero
COPY composer.json composer.lock ./

# 7. Instalar dependencias
RUN composer install --no-dev --no-scripts --no-autoloader

# 8. COPIA EXPLÍCITA (Aquí es donde matamos el error de Sonar)
# En lugar de "COPY .", listamos solo lo seguro.
COPY artisan ./
COPY app ./app
COPY bootstrap ./bootstrap
COPY config ./config
COPY database ./database
COPY public ./public
COPY resources ./resources
COPY routes ./routes
COPY storage ./storage
# Nota: No copiamos 'tests', ni '.env', ni '.git' explícitamente.

# 9. Configurar DocumentRoot
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# 10. Finalizar y Permisos
RUN composer dump-autoload --optimize \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# 11. Cambiar usuario
USER www-data

# 12. Exponer puerto
EXPOSE 8080