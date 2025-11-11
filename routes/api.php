<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ProductController; // <-- 1. Importamos tu controlador

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Aquí es donde registras las rutas API para tu aplicación.
|
*/

// Esta ruta la añade Breeze (para autenticación)
Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

// --- NUESTRAS RUTAS DE PRODUCTOS LEGO ---

// Tu tutorial te muestra cómo añadir UNA ruta (la de 'index'):
// Route::get('/products', [ProductController::class, 'index']);

// Pero como tu ProductController tiene 5 métodos (index, store, show, update, destroy),
// esta es la forma moderna de Laravel para registrar las 5 rutas de golpe.
// Es mucho más limpio y es la práctica recomendada.
Route::apiResource('products', ProductController::class);

// Esta sola línea (apiResource) crea automáticamente todo esto por ti:
//   GET    /api/products          -> (index)   Ver todos los productos
//   POST   /api/products          -> (store)   Crear un producto
//   GET    /api/products/{id}     -> (show)    Ver un producto
//   PUT    /api/products/{id}     -> (update)  Actualizar un producto
//   DELETE /api/products/{id}     -> (destroy) Borrar un producto