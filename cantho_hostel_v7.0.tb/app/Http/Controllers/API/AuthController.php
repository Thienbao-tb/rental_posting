<?php
namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\NguoiDung;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Mail;
use App\Mail\SendMailResetPassword;
use Illuminate\Support\Str;

class AuthController extends Controller
{
    /**
     * Đăng ký người dùng mới
     */
    public function register(Request $request) {
        $validator = Validator::make($request->all(), [
            'ten' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:nguoidung',
            'password' => 'required|string|min:8|confirmed',
            'sodienthoai' => 'string|max:255',
            'facebook' => 'nullable|string|max:255',
            'anhdaidien' => 'nullable|string|max:255',
        ]);

        if($validator->fails()){
            return response()->json([
                'status' => false,
                'message' => 'Validation error',
                'error' => $validator->errors(),
            ], 422);
        }

        $user = NguoiDung::create([
            'ten' => $request->ten,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'sodienthoai' => $request->sodienthoai,
            'facebook' => $request->facebook,
            'anhdaidien' => $request->anhdaidien,
            'sodukhudung' => 0,
            'email_verified_at' => null,
            'remember_token' => null,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'status' => true,
            'message' => 'Đăng ký thành công',
            'user' => $user,
            'token' => $token
        ], 201);
    }

    /**
     * Đăng nhập người dùng
     */
    public function login(Request $request) {
        $validator = Validator::make($request->all(), [
            'email' => 'required|string|email',
            'password' => 'required|string'
        ]);

        if($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => 'Validation error',
                'error' => $validator->errors()
            ], 422);
        }

        // Xác thực với guard mặc định (cần đảm bảo config đúng)
        if(!Auth::attempt($request->only('email', 'password'))) {
            return response()->json([
                'status' => false,
                'message' => 'Thông tin đăng nhập không hợp lệ'
            ], 401);
        }

        $user = NguoiDung::where('email', $request->email)->firstOrFail();
        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'status' => true,
            'message' => 'Đăng nhập thành công',
            'user' => $user,
            'token' => $token
        ], 200);
    }

    /**
     * Lấy thông tin người dùng
     */
    public function user(Request $request) {
        return response()->json([
            'status' => true,
            'message' => 'Lấy thông tin người dùng thành công',
            'user' => $request->user()
        ], 200);
    }

    /**
     * Đăng xuất người dùng
     */
    public function logout(Request $request) {
        $request->user()->currentAccessToken()->delete();
        return response()->json([
            'status' => true,
            'message' => 'Đăng xuất thành công',
        ], 200);
    }

    public function forgotPassword(Request $request) {
        $request -> validate([
            'email' => 'required|email|exists:users,email',
        ]);
        $user = NguoiDung::where('email', $request->email)->first();
        $newPassword = Str::random(8);
        $user-> password = Hash::make($newPassword);
        $user->save();

        Mail::to($user->email)->send(new SendMailResetPassword($newPassword));

        return response()->json([
            'message' => 'Mật khẩu mới đã được gửi về email của bạn.',
             'success' => true
        ]);
    }
}
