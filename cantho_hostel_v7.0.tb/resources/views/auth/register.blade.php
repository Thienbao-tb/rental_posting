@extends('frontend.layouts.app_master')
@section('title', 'Register')
@push('css')
<link href="/css/auth.css" rel="stylesheet">
@endpush

@section('content')
<div style="" class="b-auth box_shadow">
    <div class="auth-header">
        <h1 class="title" style="text-align: center;">Tạo tài khoản mới</h1>
    </div>
    <div class="auth-content">
        <form action="" method="POST" autocomplete="off">
            @csrf
            <div class="form-group">
                <label for="ten">Họ tên</label>
                <input type="text" class="form-control" required placeholder="" name="ten" value ="{{old('ten')}}" id="ten">
                    @error('ten')
                    <div class="alert alert-danger">{{ $message }}</div>
                    @enderror
            </div>
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" class="form-control"  placeholder="" name="email" value ="{{old('email')}}" id="email">
                    @error('email')
                    <div class="alert alert-danger">{{ $message }}</div>
                    @enderror

            </div>
            <div class="form-group">
                <label for="sodienthoai">Số điện thoại</label>
                <input type="text" class="form-control" required placeholder="" name="sodienthoai" value ="{{old('sodienthoai')}}" id="sodienthoai">
                    @error('sodienthoai')
                    <div class="alert alert-danger">{{ $message }}</div>
                    @enderror
            </div>
            <div class="form-group">
                <label for="password">Nhập mật khẩu</label>
                <input type="password" class="form-control" required placeholder="" name="password" id="password">
                    @error('password')
                    <div class="alert alert-danger">{{ $message }}</div>
                    @enderror
            </div>
            <div class="form-group">
                <label for="password">Nhập lại mật khẩu</label>
                <input type="password" class="form-control" required placeholder="" name="confirm_password" id="confirm_password">
                    @error('confirm_password')
                    <div class="alert alert-danger">{{ $message }}</div>
                    @enderror
            </div>
            <div class="form-group">
                <button type="submit" class="btn btn-blue btn-submit" style="background-color: var(--primary-color);">Tạo tài
                    khoản</button>
            </div>

            <div class="form-group form-group-register">

                <p class="text-center">Bạn đã có tài khoản? <a class="link" href="{{ route('get.login') }}">Đăng nhập
                        ngay</a></p>
            </div>
        </form>
    </div>
</div>

@include('components.whyus')

@stop

@push('script')
<script src="/js/auth.js"></script>
@endpush