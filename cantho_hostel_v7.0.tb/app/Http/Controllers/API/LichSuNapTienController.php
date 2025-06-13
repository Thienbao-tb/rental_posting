<?php

namespace App\Http\Controllers\API;
use App\Models\LichSuNapTien;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class LichSuNapTienController extends Controller
{
    /**
     * Lấy danh sách lịch sử nạp tiền của người dùng đã đăng nhập
     */
    public function getUserRechargeHistory(Request $request)
    {
        // Lấy người dùng hiện tại từ token
        $user = $request->user();

        // Lấy danh sách lịch sử nạp tiền theo user_id
        $lichSu = LichSuNapTien::where('nguoidung_id', $user->id)
                                ->orderByDesc('created_at')
                                ->get();

        return response()->json([
            'status' => true,
            'message' => 'Lịch sử nạp tiền đã được lấy thành công.',
            'data' => $lichSu
        ]);
    }
}
