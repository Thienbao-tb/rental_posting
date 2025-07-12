<?php

namespace App\Http\Controllers\API;

use App\Models\LichSuNapTien;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Models\NguoiDung;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Auth;

class NapTienController extends Controller
{
    public function createTransaction(Request $request)
    {
        $vnp_TmnCode = env('VNPAY_TMN_CODE');
        $vnp_HashSecret = env('VNPAY_HASH_SECRET');
        $vnp_Url = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
        $vnp_ReturnUrl = env('VNPAY_RETURN_URL');

        $amount = $request->input('amount', 100000);
        $vnp_Amount = $amount * 100;
        $vnp_TxnRef = time();

        $userId = Auth::id();

        LichSuNapTien::create([
            'ma' => $vnp_TxnRef,
            'nguoidung_id' => $userId,
            'tien' => $amount,
            'tongtien' => $amount,
            'loai' => 3,
        ]);

        $inputData = [
            "vnp_Version" => "2.1.0",
            "vnp_TmnCode" => $vnp_TmnCode,
            "vnp_Amount" => $vnp_Amount,
            "vnp_Command" => "pay",
            "vnp_CreateDate" => now()->format('YmdHis'),
            "vnp_CurrCode" => "VND",
            "vnp_IpAddr" => $request->ip(),
            "vnp_Locale" => "vn",
            "vnp_OrderInfo" => "Nạp tiền tài khoản",
            "vnp_OrderType" => "other",
            "vnp_ReturnUrl" => $vnp_ReturnUrl,
            "vnp_TxnRef" => $vnp_TxnRef,
        ];

        ksort($inputData);

        $hashdata = '';
        $query = '';
        $i = 0;
        foreach ($inputData as $key => $value) {
            if ($i == 1) {
                $hashdata .= '&' . urlencode($key) . "=" . urlencode($value);
            } else {
                $hashdata .= urlencode($key) . "=" . urlencode($value);
                $i = 1;
            }
            $query .= urlencode($key) . "=" . urlencode($value) . '&';
        }

        $vnp_SecureHash = hash_hmac('sha512', $hashdata, $vnp_HashSecret);
        $vnp_Url .= "?" . $query . "vnp_SecureHash=" . $vnp_SecureHash;

        return response()->json([
            'status' => true,
            'payment_url' => $vnp_Url,
            'txn_ref' => $vnp_TxnRef,
        ]);
    }

    public function handleReturn(Request $request)
{
    $data = $request->except(['vnp_SecureHash', 'vnp_SecureHashType']);
    DB::beginTransaction();
    try {
        $vnp_HashSecret = env('VNPAY_HASH_SECRET');
        $vnp_SecureHash = $request->input('vnp_SecureHash');

        ksort($data);
        $hashdata = '';
        $i = 0;
        foreach ($data as $key => $value) {
            if ($i == 1) {
                $hashdata .= '&' . urlencode($key) . "=" . urlencode($value);
            } else {
                $hashdata .= urlencode($key) . "=" . urlencode($value);
                $i = 1;
            }
        }
        $secureHash = hash_hmac('sha512', $hashdata, $vnp_HashSecret);

        if ($secureHash === $vnp_SecureHash) {
            $txnRef = $request->input('vnp_TxnRef');
            $statusCode = $request->input('vnp_ResponseCode');

            $recharge = LichSuNapTien::where('ma', $txnRef)->first();

            if (!$recharge) {
                return view('vnpay.vnpay_result', [
                    'status' => false,
                    'message' => 'Không tìm thấy mã giao dịch',
                ]);
            }

            if ($statusCode === '00') {
                $recharge->trangthai = LichSuNapTien::STATUS_SUCCESS;
                $recharge->save();

                $user = NguoiDung::find($recharge->nguoidung_id);
                if ($user) {
                    $user->sodukhadung += $recharge->tongtien;
                    $user->save();
                }

                DB::commit();

                return view('vnpay.vnpay_result', [
                    'status' => true,
                    'message' => 'Thanh toán thành công',
                    'amount' => $recharge->tongtien,
                    'balance' => $user->sodukhadung ?? null
                ]);
            } else {
                $recharge->trangthai = LichSuNapTien::STATUS_ERROR;
                $recharge->save();

                DB::commit();

                return view('vnpay.vnpay_result', [
                    'status' => false,
                    'message' => 'Giao dịch thất bại',
                ]);
            }
        }

        return view('vnpay.vnpay_result', [
            'status' => false,
            'message' => 'Chữ ký không hợp lệ',
        ]);

    } catch (\Exception $e) {
        DB::rollBack();
        Log::error('[VNPay handleReturn] ' . $e->getMessage());

        return view('vnpay.vnpay_result', [
            'status' => false,
            'message' => 'Lỗi xử lý giao dịch: ' . $e->getMessage(),
        ]);
    }
}

}
