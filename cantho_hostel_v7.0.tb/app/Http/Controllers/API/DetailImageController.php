<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class DetailImageController extends Controller
{
    /**
     * Trả về danh sách ảnh chi tiết của một phòng.
     *
     * @param Request $request
     * @param int $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function getImageById(Request $request, int $id)
    {
        try {
            $images = DB::table('hinhanh_ct')
                ->where('phong_id', $id)
                ->select('duongdan')
                ->get();

            return response()->json([
                'status' => true,
                'message' => 'Lấy danh sách hình ảnh thành công',
                'data' => $images
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Lỗi khi lấy hình ảnh: ' . $e->getMessage()
            ], 500);
        }
    }
}
