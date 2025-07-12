<?php

namespace App\Http\Controllers\API;
use App\Models\LichSuThanhToan;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class LichSuThanhToanController extends Controller
{
    public function getUserPaymentHistory(Request $request)
    {
        // Lấy người dùng hiện tại từ token
        $user = $request->user();


        if (!$user) {
            return response()->json([
                'status' => false,
                'message' => 'Không xác thực người dùng.',
            ], 401);
        }
        // Lấy danh sách lịch sử nạp tiền theo user_id
        $lichSu = LichSuThanhToan::where('nguoidung_id', $user->id)
                                ->orderByDesc('created_at')
                                ->get();

        return response()->json([
            'status' => true,
            'message' => 'Lịch sử thanh toán đã được lấy thành công.',
            'data' => $lichSu
        ]);
    }
}
