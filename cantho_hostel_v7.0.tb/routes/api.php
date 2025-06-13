<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\API\PhongController;
use App\Http\Controllers\API\AuthController;
use App\Http\Controllers\API\LichSuNapTienController;
/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/



Route::get('/posts', [PhongController::class, 'getPosts']);
Route::get('/posts/{id}', [PhongController::class, 'getPostDetails']);


Route::middleware('auth:sanctum')->get('/user/posts', [PhongController::class, 'getUserPosts']); // Lấy tin đăng của người dùng

Route::post('/register',[AuthController::class,'register']);
Route::post('/login',[AuthController::class,'login']);
Route::post('/forgot-password', [AuthController::class, 'forgotPassword']);
Route::middleware('auth:sanctum')->group(function(){
    Route::get('/user',[AuthController::class,'user']);
    Route::post('/logout',[AuthController::class,'logout']);
    Route::get('/recharge-history', [LichSuNapTienController::class, 'getUserRechargeHistory']);
});
Route::post('payment','ApiPaymentController@createTransaction');

