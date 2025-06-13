<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Phong;
use Illuminate\Http\Request;

class PhongController extends Controller
{
    /**
     * Lấy danh sách tin đăng phòng trọ theo query parameters
     * Hỗ trợ lọc theo: user_id, trangthai, danhmuc_id, từ khóa, phân trang
     */
    public function getPosts(Request $request)
    {
        $query = Phong::with(['category', 'district', 'wards', 'city'])
                      ->orderByDesc('created_at');

        // Lọc theo user_id (nếu có)
        if ($request->has('user_id')) {
            $query->where('xacthuc_id', $request->user_id);
        }

        // Lọc theo trạng thái tin (trangthai)
        if ($request->has('trangthai')) {
            $query->where('trangthai', $request->trangthai);
        }

        // Lọc theo danh mục (danhmuc_id)
        if ($request->has('danhmuc_id')) {
            $query->where('danhmuc_id', $request->danhmuc_id);
        }

        // Lọc theo từ khóa tìm kiếm (ví dụ: tiêu đề, mô tả)
        if ($request->has('keyword')) {
            $keyword = $request->keyword;
            $query->where(function ($q) use ($keyword) {
                $q->where('tieude', 'LIKE', "%$keyword%")
                  ->orWhere('mota', 'LIKE', "%$keyword%");
            });
        }

        // Phân trang: mặc định 10 bản ghi/trang
        $perPage = $request->get('per_page', 10);
        $posts = $query->paginate($perPage);

        return response()->json([
            'status' => true,
            'message' => 'Posts retrieved successfully',
            'posts' => $posts
        ], 200);
    }

    /**
     * Lấy chi tiết một tin đăng phòng trọ
     */
    public function getPostDetails($id)
    {
        $phong = Phong::with(['category', 'district', 'wards', 'city'])->find($id);

        if (!$phong) {
            return response()->json([
                'status' => false,
                'message' => 'Post not found'
            ], 404);
        }

        return response()->json([
            'status' => true,
            'message' => 'Post details retrieved successfully',
            'post' => $phong
        ], 200);
    }
}
