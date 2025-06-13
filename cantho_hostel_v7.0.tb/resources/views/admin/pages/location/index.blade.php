@extends('admin.layouts.app_master_admin')
@section('content')
<h2 class="mt-3" style="display: flex;justify-content: space-between"><span>Danh sách địa điểm</span> <a href="{{ route('get_admin.location.create') }}" style="font-size: 16px; font-weight: 600;">Thêm mới</a></h2>
<div class="">
    <form style="margin-bottom:20px" action="" class="row">
        <div class="col-sm-3">
            <input type="text" placeholder="Tên địa điểm" value="{{ Request::get('n') }}" name="n" class="form-control">
        </div>
        <div class="col-sm-3">
            <button type="submit" style="background:#ffa80f;border:none;font-weight: 600;" class="btn btn-primary">Tìm kiếm</button>
        </div>
    </form>
</div>
<table class="table table-hover">
    <thead>
        <tr>
            <th>#</th>
            <th>Tên</th>
            <th>Phân loại</th>
            <th>Nổi bật</th>
            <th>Ngày tạo</th>
            <th>Tuỳ chọn</th>

        </tr>
    </thead>
    <tbody>
        @foreach($locations ?? [] as $item)
        <tr>
            <td scope="row">{{ $item->id }}</td>
            <td scope="row">{{ $item->ten }}</td>
            <td scope="row">{{ $item->getType($item->loai) }}</td>

            <td scope="row">
                @if ($item->hot == 1)
                <span class="text-danger">Hot</span>
                @else
                <span class="text-pink">Mặc định</span>
                @endif
            </td>
            <td scope="row">{{ $item->created_at }}</td>
            <td scope="row">
                <a href="{{ route('get_admin.location.update', $item->id) }}" class="text-blue"><i class="bi bi-pencil-square"></i></a>
                <a href="{{ route('get_admin.location.delete', $item->id) }}" class="text-danger" style="margin-left: 20px"><i class="bi bi-trash"></i></a>
            </td>
        </tr>
        @endforeach
    </tbody>
</table>
{!! $locations->appends($query ?? [])->links('vendor.pagination.simple-bootstrap-4') !!}
@stop