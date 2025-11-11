<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // Crea la tabla 'products' para almacenar los sets de Lego
        Schema::create('products', function (Blueprint $table) {
            $table->id(); // ID único para cada producto (ej: 1, 2, 3)

            // name: "Set de Construcción de Ciudad"
            $table->string('name');

            // price: 59.99
            // Usamos 'decimal' para precisión financiera. 8 dígitos totales, 2 después del punto.
            $table->decimal('price', 8, 2);

            // imageAsset: "assets/images/lego1.jpg"
            // Almacenamos la ruta a la imagen como un string.
            // 'nullable' significa que puede estar vacío si no hay imagen.
            $table->string('image_path')->nullable();

            // category: "City"
            $table->string('category');

            // inStock: true
            // Almacenamos si está en stock. Por defecto (default),
            // asumimos que un producto nuevo sí está en stock.
            //$table->boolean('in_stock')->default(true);

            // quantity: 10, 50, 0
            // Es mucho mejor almacenar la cantidad exacta para evitar sobreventa.
            // Usamos 'unsignedInteger' (entero sin signo) para la cantidad.
            // Por defecto, un nuevo producto tiene 0 stock hasta que se añada inventario.
            $table->unsignedInteger('quantity')->default(0);

            // $table->timestamps() crea automáticamente 'created_at' y 'updated_at'
            // Es estándar de Laravel y muy útil.
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('products');
    }
};