<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Phong;
use App\Models\LichSuThanhToan;
use App\Models\NguoiDung;
use Illuminate\Support\Facades\Log;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Auth;
class PhongController extends Controller
{
    // Hàm normalize hỗ trợ nhận cả array và chuỗi CSV
    private function normalizeToArray($input)
    {
        if (is_array($input)) return $input;
        if (is_string($input)) return explode(',', $input);
        return [];
    }

    public function getPosts(Request $request)
    {
        $query = Phong::with(['category', 'district', 'wards', 'city'])
                      ->orderByDesc('created_at');

        // Lọc theo user_id
        if ($request->has('user_id')) {
            $query->where('xacthuc_id', $request->user_id);
        }

        // Lọc tin nổi bật
        if ($request->boolean('noibat')) {
            $query->whereNotNull('thoigian_batdau')
                  ->whereNotNull('thoigian_ketthuc')
                  ->where('thoigian_batdau', '<=', now())
                  ->where('thoigian_ketthuc', '>=', now())
                  ->where('dichvu_hot', 5)
                  ->orderBy('thoigian_ketthuc', 'asc');
        }

        // Lọc tin mới nhất còn hạn
        if ($request->boolean('moinhat')) {
            $query->whereNotNull('thoigian_batdau')
                  ->whereNotNull('thoigian_ketthuc')
                  ->where('thoigian_batdau', '<=', now())
                  ->where('thoigian_ketthuc', '>=', now())
                  ->orderBy('created_at');
        }

        // Lọc theo trạng thái
        if ($request->has('trangthai')) {
            $query->where('trangthai', $request->trangthai);
        }

        // Lọc theo từ khóa
        if ($request->has('keyword')) {
            $keyword = $request->keyword;
            $query->where(function ($q) use ($keyword) {
                $q->where('ten', 'LIKE', "%$keyword%")
                  ->orWhere('mota', 'LIKE', "%$keyword%");
            });
        }

        // Quận/Huyện
        if ($request->has('qhuyen_id')) {
            $qhuyenIds = $this->normalizeToArray($request->input('qhuyen_id'));
            if (!empty($qhuyenIds)) {
                $query->whereIn('qhuyen_id', $qhuyenIds);
            }
        }

        // Phường/Xã
        if ($request->has('phuongxa_id')) {
            $phuongxaIds = $this->normalizeToArray($request->input('phuongxa_id'));
            if (!empty($phuongxaIds)) {
                $query->whereIn('phuongxa_id', $phuongxaIds);
            }
        }

        // Khoảng giá
        if ($request->has('khoanggia')) {
            $giaRanges = $this->normalizeToArray($request->input('khoanggia'));
            if (!empty($giaRanges)) {
                $query->whereIn('khoanggia', $giaRanges);
            }
        }

        // Diện tích / khu vực
        if ($request->has('khoangkhuvuc')) {
            $areas = $this->normalizeToArray($request->input('khoangkhuvuc'));
            if (!empty($areas)) {
                $query->whereIn('khoangkhuvuc', $areas);
            }
        }

        // Danh mục
        if ($request->has('danhmuc_id')) {
            $dmIds = $this->normalizeToArray($request->input('danhmuc_id'));
            $filteredIds = array_filter($dmIds, function ($id) {
                return is_numeric($id) && !in_array((int)$id, [-1, -2]);
            });
            if (!empty($filteredIds)) {
                $query->whereIn('danhmuc_id', $filteredIds);
            }
        }

        // Phân trang
        $perPage = $request->get('per_page', 100);
        $posts = $query->paginate($perPage);

        return response()->json([
            'status' => true,
            'message' => 'Posts retrieved successfully',
            'total' => $posts->total(),
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

    /**
     * Lấy thông tin người dùng theo Id bài post
     */
    public function userByPostId(Request $request, int $postId)
    {
        $post = Phong::with('user')->find($postId);

        if (!$post) {
            return response()->json([
                'status' => false,
                'message' => 'Không tìm thấy bài đăng',
            ], 404);
        }

        return response()->json([
            'status' => true,
            'message' => 'Lấy thông tin người dùng thành công',
            'user' => $post->user,
        ], 200);
    }

    /**
     * Gợi ý các bài đăng tương tự
     */
    public function getSimilarPosts($postId)
    {
        $currentPost = Phong::find($postId);

        if (!$currentPost) {
            return response()->json([
                'status' => false,
                'message' => 'Bài đăng không tồn tại',
            ], 404);
        }

        $similarPosts = Phong::with(['category', 'district', 'wards', 'city'])
            ->where('id', '!=', $postId)
            ->where('danhmuc_id', $currentPost->danhmuc_id)
            ->where('qhuyen_id', $currentPost->qhuyen_id)
            ->where('phuongxa_id', $currentPost->phuongxa_id)
            ->limit(5)
            ->get();

        return response()->json([
            'status' => true,
            'data' => $similarPosts
        ]);
    }
    public function updateStatus(Request $request, $id)
    {
        $request->validate([
            'status' => 'required|integer',
        ]);

        $post = Phong::findOrFail($id);
        $post->trangthai = $request->input('status');
        $post->save();

        // Trả về bài viết kèm các quan hệ:
        $post = Phong::with(['category', 'district', 'wards', 'city'])
            ->find($post->id);

        return response()->json([
            'status' => true,
            'message' => 'Cập nhật trạng thái thành công',
            'data' => $post,
        ]);
    }

    //thanh toán
    public function apiPayRoom(Request $request, $id)
    {
        $userId = auth()->id();
        $room = Phong::find($id);

        if (!$room) {
            return response()->json([
                'status' => false,
                'message' => 'Phòng không tồn tại.'
            ], 404);
        }

        $roomType = $request->room_type;
        $day = $request->day;
        $startDate = $request->thoigian_batdau;

        $configPriceType = config('payment.type_price');
        if (!isset($configPriceType[$roomType])) {
            return response()->json([
                'status' => false,
                'message' => 'Loại dịch vụ không hợp lệ.'
            ], 400);
        }

        $gia = $configPriceType[$roomType];
        $totalMoney = $gia * $day;

        $user = NguoiDung::find($userId);

        if ($user->sodukhadung < $totalMoney) {
            return response()->json([
                'status' => false,
                'message' => 'Số dư không đủ để thanh toán. Vui lòng nạp thêm tiền để tiến hành thanh toán'
            ], 400);
        }

        try {
            DB::beginTransaction();

            LichSuThanhToan::create([
                'nguoidung_id' => $userId,
                'phong_id'     => $room->id,
                'tien'         => $totalMoney,
                'loai'         => $roomType,
                'dichvu_id'    => 0,
                'trangthai'    => LichSuThanhToan::STATUS_SUCCESS,
                'created_at'   => now()
            ]);

            // Trừ tiền người dùng
            $user->decrement('sodukhadung', $totalMoney);

            try {
                $timeStart = Carbon::createFromFormat('d/m/Y', $startDate);
            } catch (\Exception $e) {
                return response()->json([
                    'status' => false,
                    'message' => 'Định dạng ngày không hợp lệ. Định dạng đúng: dd/mm/yyyy',
                ], 422);
            }

            // Tính ngày kết thúc
            $timeEnd = $timeStart->copy()->addDays($day);

            // Cập nhật phòng
            $room->update([
                'trangthai'          => Phong::STATUS_PAID,
                'thoigian_batdau'    => $timeStart->format('Y-m-d'),
                'thoigian_ketthuc'   => $timeEnd->format('Y-m-d'),
                'dichvu_hot'         => $roomType,
                'updated_at'         => now()
            ]);

            DB::commit();

            return response()->json([
                'status' => true,
                'message' => 'Thanh toán thành công.',
                'data' => [
                    'room_id' => $room->id,
                    'total_money' => $totalMoney,
                    'start_date' => $timeStart->toDateString(),
                    'end_date' => $timeEnd->toDateString(),
                ]
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            Log::error("Lỗi thanh toán phòng: " . $e->getMessage());

            return response()->json([
                'status' => false,
                'message' => 'Đã xảy ra lỗi khi thanh toán. Vui lòng thử lại.'
            ], 500);
        }
    }


    //Lưu trữ
    public function store(Request $request)
    {
        $dodai = $request->hasFile('album') ? 'có album' : 'khong co album';
        $dodai = $request->hasFile('album') ? 'có album' : 'không có album';

        $albumInput = $request->file('album');
        $kieudulieu = is_array($albumInput) ? 'là mảng' : (is_null($albumInput) ? 'null' : gettype($albumInput));

        try {
            $data = $request->except(['anhdaidien', 'file']);
            $data['created_at'] = Carbon::now();
            $data['trangthai'] = Phong::STATUS_EXPIRED; // hoặc STATUS_PENDING nếu muốn duyệt thủ công
            $data['slug'] = Str::slug($request->ten);
            $data['xacthuc_id'] = Auth::id();

            $data = $this->switchPrice($data);
            $data = $this->switchArea($data);

            // Xử lý ảnh đại diện
            if ($request->hasFile('anhdaidien')) {
                $file = $request->file('anhdaidien');

                $now = now();
                $year = $now->format('Y');
                $month = $now->format('m');
                $day = $now->format('d');

                $folderPath = public_path("uploads/$year/$month/$day");
                if (!file_exists($folderPath)) {
                    mkdir($folderPath, 0775, true);
                }

                $originalName = $file->getClientOriginalName();
                $today = $now->format('Y-m-d');
                $fileName = $today . '__' . $originalName;

                $file->move($folderPath, $fileName);

                // Chỉ lưu tên file
                $data['anhdaidien'] = $fileName;
            }

            // Tạo phòng (bài đăng)
            $room = Phong::create($data);


            // Xử lý nhiều ảnh chi tiết
            if ($room && $request->hasFile('album')) {
        $files = $request->file('album');

        // Đảm bảo luôn là mảng (vì nếu chỉ có 1 ảnh, Laravel trả về 1 object UploadedFile)
        if (!is_array($files)) {
            $files = [$files];
        }

        foreach ($files as $index => $image) {
            if ($image && $image->isValid()) {
                $now = now();
                $year = $now->format('Y');
                $month = $now->format('m');
                $day = $now->format('d');

                $folderPath = public_path("uploads/$year/$month/$day");
                if (!file_exists($folderPath)) {
                    mkdir($folderPath, 0775, true);
                }

                $originalName = $image->getClientOriginalName();
                $today = $now->format('Y-m-d');
                $fileName = $today . '__' . $index . '__' . $originalName;

                $image->move($folderPath, $fileName);

                DB::table('hinhanh_ct')->insert([
                    'phong_id' => $room->id,
                    'duongdan' => "$fileName",
                    'ten' => $originalName,
                    'created_at' => now(),
                ]);
            }
        }
        }

            return response()->json([
                'status' => true,
                'message' => 'Tạo tin thành công',
                'data' => $room,
                'b' => $albumInput
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Lỗi tạo phòng: ' . $e->getMessage()
            ], 500);
        }
    }

    //Update
    public function update(Request $request, $id)
    {
        try {
            $room = Phong::findOrFail($id);

            $data = $request->except(['anhdaidien', 'album']);
            $data['updated_at'] = now();

            // Nếu tiêu đề thay đổi thì cập nhật slug
            if ($request->has('ten')) {
                $data['slug'] = Str::slug($request->ten);
            }

            $data = $this->switchPrice($data);
            $data = $this->switchArea($data);

            // Xử lý ảnh đại diện nếu có cập nhật
            if ($request->hasFile('anhdaidien')) {
                $file = $request->file('anhdaidien');

                $now = now();
                $year = $now->format('Y');
                $month = $now->format('m');
                $day = $now->format('d');

                $folderPath = public_path("uploads/$year/$month/$day");
                if (!file_exists($folderPath)) {
                    mkdir($folderPath, 0775, true);
                }

                $originalName = $file->getClientOriginalName();
                $today = $now->format('Y-m-d');
                $fileName = $today . '__' . $originalName;

                $file->move($folderPath, $fileName);

                // Cập nhật tên ảnh đại diện
                $data['anhdaidien'] = $fileName;
            }

            // Cập nhật dữ liệu bài đăng
            $room->update($data);

            // Nếu có album ảnh mới, thì xóa ảnh cũ và lưu mới
            if ($request->hasFile('album')) {
                $files = $request->file('album');

                if (!is_array($files)) {
                    $files = [$files];
                }

                // Xóa ảnh cũ trong bảng hinhanh_ct
                DB::table('hinhanh_ct')->where('phong_id', $room->id)->delete();

                foreach ($files as $index => $image) {
                    if ($image && $image->isValid()) {
                        $now = now();
                        $year = $now->format('Y');
                        $month = $now->format('m');
                        $day = $now->format('d');

                        $folderPath = public_path("uploads/$year/$month/$day");
                        if (!file_exists($folderPath)) {
                            mkdir($folderPath, 0775, true);
                        }

                        $originalName = $image->getClientOriginalName();
                        $today = $now->format('Y-m-d');
                        $fileName = $today . '__' . $index . '__' . $originalName;

                        $image->move($folderPath, $fileName);

                        DB::table('hinhanh_ct')->insert([
                            'phong_id' => $room->id,
                            'duongdan' => $fileName,
                            'ten' => $originalName,
                            'created_at' => now(),
                        ]);
                    }
                }
            }

            return response()->json([
                'status' => true,
                'message' => 'Cập nhật tin thành công',
                'data' => $room,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Lỗi cập nhật phòng: ' . $e->getMessage(),
            ], 500);
        }
    }




    protected function switchPrice($data)
    {
        $gia = (int) $data['gia'];
        if ($gia < 1000000) $data['khoanggia'] = 1;
        elseif ($gia < 2000000) $data['khoanggia'] = 2;
        elseif ($gia < 3000000) $data['khoanggia'] = 3;
        elseif ($gia < 5000000) $data['khoanggia'] = 4;
        elseif ($gia < 7000000) $data['khoanggia'] = 5;
        elseif ($gia < 10000000) $data['khoanggia'] = 6;
        elseif ($gia < 15000000) $data['khoanggia'] = 7;
        else $data['khoanggia'] = 8;
        return $data;
    }

    protected function switchArea($data)
    {
        $area = (float) $data['khuvuc'];
        if ($area < 20) $data['khoangkhuvuc'] = 1;
        elseif ($area < 30) $data['khoangkhuvuc'] = 2;
        elseif ($area < 50) $data['khoangkhuvuc'] = 3;
        elseif ($area < 60) $data['khoangkhuvuc'] = 4;
        elseif ($area < 70) $data['khoangkhuvuc'] = 5;
        elseif ($area < 80) $data['khoangkhuvuc'] = 6;
        elseif ($area < 100) $data['khoangkhuvuc'] = 7;
        elseif ($area < 120) $data['khoangkhuvuc'] = 8;
        elseif ($area < 150) $data['khoangkhuvuc'] = 9;
        else $data['khoangkhuvuc'] = 10;

        return $data;
    }

}
