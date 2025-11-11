<?php

namespace App\Http\Controllers;

use App\Models\Product; // Importante: Hay que "usar" el modelo Product
use Illuminate\Http\Request; // Importante: Para manejar los datos que llegan (ej: JSON)

class ProductController extends Controller
{
    /**
     * Display a listing of the resource.
     * Muestra una lista de todos los productos.
     */
    public function index()
    {
        // Lógica como en tu imagen: Carga todos los productos.
        $products = Product::all();
        return $products;
    }

    /**
     * Store a newly created resource in storage.
     * Almacena un producto nuevo.
     */
    public function store(Request $request)
    {
        // --- Validación (¡MUY RECOMENDADO!) ---
        // Esto valida que los datos que envía tu app Flutter sean correctos
        // antes de intentar guardar.
        $validatedData = $request->validate([
            'name' => 'required|string|max:255',
            'price' => 'required|numeric|min:0',
            'category' => 'required|string|max:100',
            'quantity' => 'required|integer|min:0',
            'image_path' => 'nullable|string', // 'nullable' significa que es opcional
        ]);

        // Lógica como en tu imagen: Crea un nuevo producto usando
        // los datos validados. Gracias al '$fillable' en tu Modelo,
        // esto funciona de forma segura.
        $product = Product::create($validatedData);

        // Devuelve el producto que se acaba de crear (con su nuevo ID)
        // El '201' significa 'Recurso Creado'.
        return response()->json($product, 201);
    }

    /**
     * Display the specified resource.
     * Muestra un producto específico.
     */
    public function show(Product $product)
    {
        // Lógica como en tu imagen:
        // Gracias a la magia de Laravel (Route-Model Binding),
        // Laravel automáticamente busca el producto por su ID (ej: /api/products/5)
        // y te lo entrega en la variable $product.
        return $product;
    }

    /**
     * Update the specified resource in storage.
     * Actualiza un producto específico.
     */
    public function update(Request $request, Product $product)
    {
        // Validación (igual que en store, pero a veces 'required' no es necesario
        // si permites actualizaciones parciales, pero lo mantendremos simple).
        $validatedData = $request->validate([
            'name' => 'sometimes|required|string|max:255',
            'price' => 'sometimes|required|numeric|min:0',
            'category' => 'sometimes|required|string|max:100',
            'quantity' => 'sometimes|required|integer|min:0',
            'image_path' => 'nullable|string',
        ]);

        // Lógica como en tu imagen (adaptada):
        // Actualiza el producto que Laravel ya encontró por nosotros ($product)
        // con los nuevos datos validados.
        $product->update($validatedData);

        // Devuelve el producto ya actualizado.
        return $product;
    }

    /**
     * Remove the specified resource from storage.
     * Elimina un producto específico.
     */
    public function destroy(Product $product)
    {
        // Lógica como en tu imagen:
        // Laravel encuentra el producto por su ID y $product->delete() lo borra.
        $product->delete();

        // Devuelve una respuesta vacía con el código '204 No Content'
        // que significa "Lo borré exitosamente, no hay nada más que decir".
        return response()->noContent();
    }
}