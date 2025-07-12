<?php

namespace App\Http\Controllers\API;

use App\Models\DiaChi;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class LocationController extends Controller
{
    /**
     * Lấy danh sách địa chỉ.
     * - Nếu ?noibat=true → lọc theo hot và giới hạn 3
     * - Nếu ?qhuyen=true → lọc loai = 1 (quận/huyện)
     * - Nếu ?phuongxa=true → lọc loai = 2 (phường/xã)
     * - Không truyền gì → lấy toàn bộ
     */
    public function getLocation(Request $request)
    {
        try {
            $query = DiaChi::withCount('rooms')
                ->orderByDesc('rooms_count');

            // Nếu có ?noibat=true → chỉ lấy 3 địa chỉ nổi bật
            if ($request->boolean('noibat')) {
                $query->where('hot', 1)->limit(3);
            }

            // Nếu có ?qhuyen=true → lọc theo quận/huyện
            if ($request->boolean('qhuyen')) {
                $query->where('loai', 1);
            }

            // Nếu có ?phuongxa=true → lọc theo phường/xã
            if ($request->boolean('phuongxa')) {
                $query->where('loai', 2);
            }

            $diachis = $query->get();

            return response()->json([
                'status' => true,
                'message' => 'Lấy danh sách địa chỉ thành công',
                'data' => $diachis
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Lỗi khi lấy địa chỉ: ' . $e->getMessage()
            ], 500);
        }
    }



    public function getPhuongXaByQhuyen(Request $request)
    {
        try {
            $qhuyenId = $request->input('id');
            if (!$qhuyenId) {
                return response()->json([
                    'status' => false,
                    'message' => 'Thiếu id quận/huyện.'
                ], 400);
            }

            $phuongxas = DiaChi::withCount('rooms')
                ->where('loai', 2)
                ->where('parent_id', $qhuyenId)
                ->orderByDesc('rooms_count')
                ->get();

            return response()->json([
                'status' => true,
                'message' => 'Lấy danh sách phường/xã thành công',
                'data' => $phuongxas
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Lỗi khi lấy phường/xã: ' . $e->getMessage()
            ], 500);
        }
    }
}
