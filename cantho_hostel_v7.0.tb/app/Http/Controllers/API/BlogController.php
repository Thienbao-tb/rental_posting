<?php

namespace App\Http\Controllers\API;
use App\Models\BaiViet;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class BlogController extends Controller
{
    public static function index(Request $request)
{
    $perPage = $request->input('per_page', 10);
    $baiVietId = $request->input('baiviet_id');

    // Nếu có truyền baiviet_id thì trả về chi tiết
    if ($baiVietId) {
        $post = BaiViet::find($baiVietId);

        if (!$post) {
            return response()->json([
                'success' => false,
                'message' => 'Bài viết không tồn tại',
            ], 404);
        }

        return response()->json([
            'success' => true,
            'message' => 'Chi tiết bài viết',
            'data' => $post,
        ]);
    }

    $posts = BaiViet::orderBy('created_at', 'desc')->paginate($perPage);

    return response()->json([
        'success' => true,
        'message' => 'Danh sách bài viết',
        'total' => $posts->total(),
        'data' => $posts->items(),
        'current_page' => $posts->currentPage(),
        'last_page' => $posts->lastPage(),
    ]);
}


}
