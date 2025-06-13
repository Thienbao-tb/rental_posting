<?php

namespace App\Http\Controllers\Auth;

use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;
use App\Models\NguoiDung;
use App\Http\Controllers\Controller;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Database\QueryException; // Import lớp QueryException

class RegisterController extends Controller
{
    public function index()
    {
        return view('auth.register');
    }

    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'ten' => 'required|regex:/^[\pL\s]+$/u|not_regex:/\s{2,}/|max:50',
            'email' => 'required|unique:nguoidung,email|email',
            'password' => 'required|min:8|regex:/^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/',
            'confirm_password' => 'required|same:password',
            'sodienthoai' => 'required|digits_between:10,11|unique:nguoidung,sodienthoai',
        ], [
            'ten.max' => 'Họ tên không được quá 50 ký tự',
            'ten.required' => 'Họ tên không được bỏ trống',
            'ten.regex' => 'Họ tên chỉ được chứa ký tự chữ cái và cách nhau bởi 1 khoảng trắng',
            'ten.not_regex' => 'Họ tên không được chứa nhiều hơn một khoảng trắng liên tiếp',
            'email.email' => 'Email chưa đúng định dạng',
            'email.required' => 'Vui lòng điền email',
            'email.unique' => 'Trùng email!',
            'password.required' => 'Vui lòng điền mật khẩu',
            'password.regex' => 'Mật khẩu phải chứa ít nhất một chữ cái, một số, và một ký tự đặc biệt',
            'password.min' => 'Mật khẩu phải có ít nhất 8 ký tự',
            'confirm_password.required' => 'Vui lòng xác nhận mật khẩu',
            'confirm_password.same' => 'Mật khẩu xác nhận không trùng khớp với mật khẩu',
            'sodienthoai.required' => 'Điền điện thoại',
            'sodienthoai.unique' => 'Trùng điện thoại!',
            'sodienthoai.digits_between' => 'Số điện thoại phải có độ dài từ 10 đến 11 số',
        ]);

        if ($validator->fails()) {
            return redirect()->route('get.register')->withErrors($validator)->withInput();
        }

        try {
            // Tạo người dùng mới
            $user = new NguoiDung();
            $user->ten = $request->input('ten');
            $user->email = $request->input('email');
	        $user->password = Hash::make($request->input('password'));
            $user->sodienthoai = $request->input('sodienthoai');
            $user->save();

            // Đăng nhập người dùng sau khi đăng ký thành công
            Auth::login($user);
            if (Auth::check()) {
                toastr()->success('Đăng nhập thành công!', 'Thông báo', ['timeOut' => 3000]);
                return redirect()->route('get.home');
            }
        } catch (QueryException $e) {
            $errorCode = $e->errorInfo[1];
            $errorMessage = 'Đăng ký thất bại! Lỗi cơ sở dữ liệu.';

            switch ($errorCode) {
                case 1062: // Lỗi trùng lặp trong MySQL
                    if (strpos($e->getMessage(), 'nguoidung_email_unique') !== false) {
                        $errorMessage = 'Email này đã tồn tại.';
                    } elseif (strpos($e->getMessage(), 'nguoidung_sodienthoai_unique') !== false) {
                        $errorMessage = 'Số điện thoại này đã tồn tại.';
                    }
                    break;
                case 1044: // Lỗi truy cập cơ sở dữ liệu bị từ chối
                    $errorMessage = 'Truy cập cơ sở dữ liệu bị từ chối.';
                    break;
                case 1045: // Lỗi truy cập cơ sở dữ liệu sai tên người dùng hoặc mật khẩu
                    $errorMessage = 'Sai tên người dùng hoặc mật khẩu cơ sở dữ liệu.';
                    break;
                case 1146: // Lỗi bảng không tồn tại
                    $errorMessage = 'Bảng không tồn tại trong cơ sở dữ liệu.';
                    break;
                case 1216: // Lỗi vi phạm ràng buộc ngoại
                    $errorMessage = 'Vi phạm ràng buộc ngoại khi thêm dữ liệu.';
                    break;
                case 1364: // Lỗi giá trị mặc định không được xác định
                    $errorMessage = 'Một hoặc nhiều trường không có giá trị mặc định.';
                    break;
                case 1406: // Lỗi giá trị quá dài trong MySQL
                    $errorMessage = 'Dữ liệu nhập vào quá dài.';
                    break;
                case 2002: // Lỗi kết nối cơ sở dữ liệu không thành công
                    $errorMessage = 'Không thể kết nối đến cơ sở dữ liệu.';
                    break;
                default:
                    $errorMessage = 'Đăng ký thất bại! Lỗi không xác định.';
                    break;
            }

            return redirect()->route('get.register')->withErrors(['database_error' => $errorMessage])->withInput();
        }
    }
}
