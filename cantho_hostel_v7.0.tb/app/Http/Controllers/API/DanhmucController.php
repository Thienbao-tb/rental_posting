<?php

namespace App\Http\Controllers\API;
use App\Models\DanhMuc;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class DanhmucController extends Controller
{
    public function getDanhmuc() {
    $activeDanhMucs = DanhMuc::where('trangthai', 1)->get();

    return response()->json([
        'status' => true,
        'data' => $activeDanhMucs
    ]);
}
}
