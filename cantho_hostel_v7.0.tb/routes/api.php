<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\API\PhongController;
use App\Http\Controllers\API\AuthController;
use App\Http\Controllers\API\DanhmucController;
use App\Http\Controllers\API\DetailImageController;
use App\Http\Controllers\API\LichSuNapTienController;
use App\Http\Controllers\API\LocationController;
use App\Http\Controllers\API\BlogController;
use App\Http\Controllers\API\LichSuThanhToanController;
use App\Http\Controllers\API\NapTienController;
use App\Models\LichSuThanhToan;
use App\Models\Phong;

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


//Post
Route::get('/posts', [PhongController::class, 'getPosts']);
Route::get('/posts/{id}', [PhongController::class, 'getPostDetails']);
Route::get('/posts/{postId}/user', [PhongController::class, 'userByPostId']);
Route::get('/posts/{postId}/similar', [PhongController::class, 'getSimilarPosts']);
Route::put('/posts/{id}/status', [PhongController::class, 'updateStatus']);
//Category
Route::get('/categories', [DanhmucController::class, 'getDanhmuc']);



//Location
Route::get('/locations', [LocationController::class, 'getLocation']);
Route::get('/locations/phuongxa-by-qhuyen', [LocationController::class, 'getPhuongXaByQhuyen']);

//Detail Image
Route::get('/detailImage/{id}', [DetailImageController::class, 'getImageById']);


//Blog
Route::get('/blogs', [BlogController::class, 'index']);


Route::middleware('auth:sanctum')->get('/user/posts', [PhongController::class, 'getUserPosts']); // Lấy tin đăng của người dùng
Route::post('/register',[AuthController::class,'register']);
Route::post('/login',[AuthController::class,'login']);
Route::post('/forgot-password', [AuthController::class, 'forgotPassword']);
Route::middleware('auth:sanctum')->group(function(){
    Route::get('/user',[AuthController::class,'user']);
    Route::post('/logout',[AuthController::class,'logout']);
    Route::post('/update-user', [AuthController::class, 'updateUserInfo']);
    Route::post('/update-password', [AuthController::class, 'updatePassword']);
    Route::get('/recharge-history', [LichSuNapTienController::class, 'getUserRechargeHistory']);
    Route::get('/payment-history', [LichSuThanhToanController::class, 'getUserPaymentHistory']);
    Route::put('/posts/{id}/status', [PhongController::class, 'updateStatus']);
    Route::post('/posts/{id}/pay', [PhongController::class, 'apiPayRoom']);
    Route::post('/posts/store', [PhongController::class, 'store']);
    Route::post('/posts/{id}/update', [PhongController::class, 'update']);
    Route::post('/vnpay/create', [NapTienController::class, 'createTransaction']);
});
Route::get('/vnpay-return', [NapTienController::class, 'handleReturn']);

Route::post('payment','ApiPaymentController@createTransaction');

