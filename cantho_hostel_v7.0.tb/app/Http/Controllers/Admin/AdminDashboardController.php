<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\LichSuNapTien;
use App\Models\LichSuThanhToan;
use App\Models\NguoiDung;
use App\Models\Phong;
use App\Models\User;
use Illuminate\Http\Request;

class AdminDashboardController extends Controller
{
    public function index()
    {
        $totalUser            = NguoiDung::select('id')->count();
        $totalRoom            = Phong::select('id')->count();
        $totalPay             = LichSuThanhToan::select('id')->count();
        $totalRechargeHistory = LichSuNapTien::select('id')->count();
        
        
        $users = NguoiDung::orderByDesc('id')->paginate(5); 
        $paymentHistory = LichSuThanhToan::with('user:id,ten')->orderByDesc('id')->paginate(7, ['*'], 'paymentHistory_page');  // Use paginate instead of limit
        $rechargeHistory = LichSuNapTien::with('user:id,ten')->orderByDesc('id')->paginate(20); 

        $viewData = [
            'totalUser'            => $totalUser,
            'totalRoom'            => $totalRoom,
            'totalPay'             => $totalPay,
            'totalRechargeHistory' => $totalRechargeHistory,
            'paymentHistory'       => $paymentHistory,
            'users'                => $users,
            'rechargeHistory'      => $rechargeHistory
        ];

        return view('admin.pages.index', $viewData);
    }
}