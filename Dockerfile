# Usamos la imagen oficial de PHP con Apache
FROM php:8.2-apache

# 1. Instalar dependencias Y Extensiones PHP (FUSIONADOS)
# SonarQube pedía unir estos pasos. Instalamos libs del sistema, luego extensiones PHP, y al final limpiamos.
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    libonig-dev \
    libpng-dev \
    libxml2-dev \
    unzip \
    zip \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 2. Configurar Apache (Puerto 8080 + Rewrite)
RUN a2enmod rewrite \
    && sed -i 's/80/8080/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

# 3. Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 4. Directorio de trabajo
WORKDIR /var/www/html

# 5. CACHÉ: Copiar dependencias
COPY composer.json composer.lock ./

# 6. Instalar dependencias
RUN composer install --no-dev --no-scripts --no-autoloader

# 7. COPIA EXPLÍCITA (Seguridad)
COPY artisan ./
COPY app ./app
COPY bootstrap ./bootstrap
COPY config ./config
COPY database ./database
COPY public ./public
COPY resources ./resources
COPY routes ./routes
COPY storage ./storage

# 8. Configurar DocumentRoot (FUSIONADO)
# Aquí corregimos el segundo error: Unimos los dos comandos 'sed' en un solo RUN
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
    && sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# 9. Finalizar y Permisos
RUN composer dump-autoload --optimize \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# 10. Cambiar usuario
USER www-data

# 11. Exponer puerto
EXPOSE 8080