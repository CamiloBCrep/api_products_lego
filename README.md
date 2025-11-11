# **Levantamiento API**

Aquí está el "checklist" completo y correcto de 10 pasos para clonar y ejecutar tu proyecto en cualquier máquina nueva:

**1. Clonar el Repositorio**

```bash
git clone https://github.com/tu-usuario/api_products_lego.git
```

**2. Entrar a la Carpeta**

```bash
cd api_products_lego
```

**3. Instalar Dependencias de Laravel (¡Paso clave 1!)**

Esto lee tu archivo composer.json y descarga Laravel, Breeze, y todas las librerías necesarias en la carpeta vendor/.

```bash
composer install
```

**4. Crear el Archivo de Entorno (¡Paso clave 2!)**

Copia el archivo de ejemplo para crear tu propio archivo .env local.

```bash
cp .env.example .env
```

*(Si estás en Windows y ese comando no funciona, simplemente copia y renombra el archivo manualmente).*

**5. Generar la Llave de la App (¡Paso clave 3!)**

Esto rellena la línea APP_KEY= en tu nuevo archivo .env, lo cual es vital para la seguridad.

```bash
php artisan key:generate
```

**6. Iniciar MySQL y Crear la Base de Datos**

Este es tu paso. Ve a phpMyAdmin (o tu herramienta) y crea la base de datos vacía llamada api_products_lego.

**7. Editar el Archivo .env**

Abre tu nuevo archivo .env y rellena los datos de conexión a tu base de datos (igual que hicimos antes):

```bash
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_DATABASE=api_products_lego
DB_USERNAME=root
DB_PASSWORD=
```

*(Y asegúrate de que `CACHE_STORE=file` para evitar problemas).*

**8. Ejecutar las Migraciones**

Este es tu paso. Ahora Laravel se conectará a la BD vacía y creará todas las tablas (users, products, etc.).

```bash
php artisan migrate
```

**9. Poblar la Base de Datos**

Tu base de datos ahora tiene tablas, pero no tiene datos. Para cargar los Legos que escribimos, ve a phpMyAdmin, abre la pestaña "SQL" y pega el contenido de tu archivo database/seed_products.sql.

**10. Iniciar el Servidor**

Este es tu paso final.

```bash
php artisan serve
```
