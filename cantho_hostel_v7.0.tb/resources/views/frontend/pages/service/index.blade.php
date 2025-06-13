@extends('frontend.layouts.app_master')
@section('title', 'Trang chủ')
@push('css')
<link href="/css/home.css" rel="stylesheet">
@endpush

@section('content')


<style>
/* @media (min-width: 576px)   {} */
@media (max-width: 768px)   {
    .responsive-table-price {
        display: block;
        width: 100%;
        overflow-x: auto;
        scrollbar-width: none; 
    }
}
.table-pricing {
    text-align: justify;
}
.table.table-pricing thead>tr>th {
    text-align:center;
}
/* @media (min-width: 992px)   {}
@media (min-width: 1200px)  {}
@media (max-width: 1200px)  {}
@media (max-width: 991px)   {} */

</style>


<section class="grid post-category">

    <header class="page-header category clearfix">
        <h1 class="page-h1" style="float: none;  margin-bottom: 20px; text-align: center; font-size:30px">Bảng giá
        </h1>
    </header>
    <div class="responsive-table-price">
    <table class="table table-pricing">
    <thead>
        <tr>
            <th style="background: #fff; border: 0;"></th>
            <th class="package_vip1" style="background-color:#E13427; color: #fff; vertical-align: middle;">TIN NỔI BẬT<span class="star star-5"></span>
            </th>
            <th class="package_vip2" style="background-color:#ea2e9d; color: #fff; vertical-align: middle;">TIN VIP 1<span class="star star-4"></span>
            </th>

            <th class="package_vip2" style="background-color:#FF6600; color: #fff; vertical-align: middle;">TIN VIP 2<span class="star star-4"></span>
            
            <th class="package_vip4" style="background-color:#007BFF; color: #fff; vertical-align: middle;">TIN VIP 3<span class="star star-2"></span>
            </th>
            <th class="package_tinthuong" style="background-color:#055699; color: #fff; vertical-align: middle;">TIN THƯỜNG</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td class="nowrap" style="vertical-align: top;"><strong>Ưu điểm</strong>
            </td>
            <td style="vertical-align: top;">
                <p>- Lượt xem nhiều gấp <strong>30 lần</strong> so với tin thường</p>
                <p>- Ưu việt, tiếp cận <strong>tối đa</strong> khách hàng.</p>
                <p>- Xuất hiện vị trí <strong>đầu tiên ở trang chủ</strong>
                </p>
                <p>- Đứng <strong>trên tất cả</strong> các loại tin VIP khác</p>
                <p>- Xuất hiện <strong>đầu tiên</strong> ở mục tin nổi bật xuyên suốt khu vực chuyên mục đó.

                </p>
            </td>
            <td style="vertical-align: top;">
                <p>- Lượt xem nhiều gấp <strong>15 lần</strong> so với tin thường</p>
                <p>- Tiếp cận <strong>rất nhiều</strong> khách hàng. </p>
                <p>- Xuất hiện <strong>sau VIP NỔI BẬT</strong> và <strong>trước Vip 2, Vip 3, tin thường</strong>.</p>
                <p>- Xuất hiện thêm ở mục tin nổi bật xuyên suốt khu vực chuyên mục đó.
                    
                </p>
            </td>
            <td style="vertical-align: top;">
                <p>- Lượt xem nhiều gấp <strong>10 lần</strong> so với tin thường</p>
                <p>- Tiếp cận khách hàng <strong>rất tốt</strong>.</p>
                <p>- Xuất hiện <strong>sau VIP 1</strong> và <strong>trước VIP 3, tin thường</strong>.</p>
                <p>- Xuất hiện thêm ở mục tin nổi bật xuyên suốt khu vực chuyên mục đó.
                    
                </p>
            </td>
            <td style="vertical-align: top;">
                <p>- Lượt xem nhiều gấp <strong>5 lần</strong> so với tin thường</p>
                <p>- Tiếp cận khách hàng <strong>tốt</strong>.</p>
                <p>- Xuất hiện <strong>sau VIP 2</strong> và <strong>trước tin thường</strong>.</p>
            </td>
            <td style="vertical-align: top;">
                <p>- Tiếp cận khách hàng <strong>khá tốt</strong>.</p>
                <p>- Xuất hiện <strong>sau các loại tin VIP</strong>.</p>
            </td>
        </tr>
        <tr>
            <td class="nowrap" style="vertical-align: top;"><strong>Phù hợp</strong>
            </td>
            <td style="vertical-align: top;">
                <p>- Phù hợp khách hàng là công ty/cá nhân sở hữu hệ thống lớn có từ 15-20 căn phòng/nhà trở lên hoặc phòng trống quá lâu, thường xuyên đang cần <strong>cho thuê gấp</strong>.</p>
            </td>
            <td style="vertical-align: top;">
                <p>- Phù hợp khách hàng cá nhân/môi giới có 10-15 căn phòng/nhà đang trống thường xuyên, cần <strong>cho thuê nhanh nhất</strong>.</p>
            </td>
            <td style="vertical-align: top;">
                <p>- Phù hợp khách hàng cá nhân/môi giới có lượng căn trống thường xuyên, cần <strong>cho thuê nhanh hơn</strong>.</p>
            </td>
            <td style="vertical-align: top;">
                <p>- Phù hợp loại hình phòng trọ chung chủ, KTX ở ghép hay khách hàng có 1-5 căn phòng/nhà cần cho thuê nhanh, <strong>tiếp cận khách hàng tốt hơn</strong>.</p>
            </td>
            <td style="vertical-align: top;">
                <p>- Phù hợp tất cả các loại hình tuy nhiên lượng tiếp cận <strong>khách hàng thấp hơn</strong> và <strong>cho thuê chậm hơn so</strong> với tin VIP.</p>
            </td>
        </tr>
        <tr>
            <td class="nowrap"><strong>Giá ngày</strong>
            </td>
            <td><span class="price-day">80.000đ</span><span style="display: block; font-size: 0.8rem;">(Tối thiểu 5 ngày)</span>
            </td>
            <td><span class="price-day">50.000đ</span><span style="display: block; font-size: 0.8rem;">(Tối thiểu 5 ngày)</span>
            </td>
            <td><span class="price-day">30.000đ</span><span style="display: block; font-size: 0.8rem;">(Tối thiểu 5 ngày)</span>
            </td>
            <td><span class="price-day">20.000đ</span><span style="display: block; font-size: 0.8rem;">(Tối thiểu 5 ngày)</span>
            </td>
            <td><span class="price-day">2.000đ</span><span style="display: block; font-size: 0.8rem;">(Tối thiểu 5 ngày)</span>
            </td>
        </tr>
        <tr>
            <td class="nowrap"><strong>Giá tuần (7 ngày)</strong>
            </td>
            <td><span class="price-week">560.000đ</span>
            </td>
            <td><span class="price-week">350.000đ</span>
            </td>
            <td><span class="price-week">210.000đ</span>
            </td>
            <td><span class="price-week">140.000đ</span>
            </td>
            <td><span class="price-week">14.000đ</span>
            </td>
        </tr>
        <tr>
            <td class="nowrap" style="vertical-align: middle;"><strong>Màu sắc tiêu đề</strong>
            </td>
            <td>
                <p><span style="color:#E13427; font-weight: bold;">TIÊU ĐỀ MÀU ĐỎ, IN HOA</span>
                </p>
            </td>
            <td>
                <p><span style="color:#E13427; font-weight: bold;">TIÊU ĐỀ MÀU ĐỎ, IN HOA</span>
                </p>
            </td>
            <td>
                <p><span style="color:#E13427; font-weight: bold;">TIÊU ĐỀ MÀU ĐỎ, IN HOA</span>
                </p>
            </td>
            <td>
                <p><span style="color:#E13427; font-weight: bold;">TIÊU ĐỀ MÀU ĐỎ, IN HOA</span>
                </p>
            </td>
            <td>
                <p><span style="color:#E13427; font-weight: bold;">TIÊU ĐỀ MÀU ĐỎ, IN HOA</span>
                </p>
            </td>
        </tr>
        <tr>
            <td class="nowrap" style="vertical-align: middle;"><strong>Admin duyệt bài</strong>
            </td>
            <td>
                <p><img style="margin: 0 auto;" src="/images/icon-tick-green.svg">
                </p>
            </td>
            <td>
                <p><img style="margin: 0 auto;" src="/images/icon-tick-green.svg">
                </p>
            </td>
            <td>
                <p><img style="margin: 0 auto;" src="/images/icon-tick-green.svg">
                </p>
            </td>
            <td>
                <p><img style="margin: 0 auto;" src="/images/icon-tick-green.svg">
                </p>
            </td>
            <td>
            <p><img style="margin: 0 auto;" src="/images/icon-tick-green.svg">
                </p>
            </td>
        </tr>
        
        <tr>
            <td class="nowrap" style="vertical-align: middle;"><strong>Huy hiệu nổi bật</strong>
            </td>
            <td>
                <p><img style="margin: 0 auto;" src="/images/icon-tick-green.svg">
                </p>
            </td>
            <td>
                <p><i style="color:red" class="fa-solid fa-x"></i>
                </p>
            </td>
            <td>
                <p><i style="color:red" class="fa-solid fa-x"></i>
                </p>
            </td>
            <td>
                <p><i style="color:red" class="fa-solid fa-x"></i>
                </p>
            </td>
            <td>
                <p><i style="color:red" class="fa-solid fa-x"></i>
                </p>
            </td>
        </tr>
        
    </tbody>
</table>
    </div>

</section>
@include('components.link_footer')
@include('components.whyus')
@stop

@push('script')
<script src="/js/home.js"></script>
@endpush