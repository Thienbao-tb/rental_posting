<!doctype html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="csrf-token" content="{{ csrf_token() }}" />
    <meta name="viewport"
        content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <title>@yield('title', 'Phòng trọ Cần Thơ')</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/2.0.1/css/toastr.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet" />
    

    
    <style>
        .star.star-3 {
            width: 42px;
            height: 17px;
        }

        .star {
            background: url(../images/mobile/star2.png) left center repeat-x;
            background-size: 14px 14px;
            display: inline-block;
            margin-right: 3px;
            float: left;
        }

        .pagination {
            display: flex;
            justify-content: center;
        }

        .pagination li {
            width: 40px;
            height: 40px;
            background: white;
            border: 1px solid #3861fb;
            text-align: center;
            line-height: 40px;
            font-size: 20px;
            border-radius: 50%;
            margin: 0 10px;
            color: #212121;
        }

        .pagination li.active {
            background-color: #3861fb;
            color: white;
        }
        .backtotop_icon {
            position: fixed;
            bottom: 86px;
            right: 24px;
            border-radius: 10px;
            width: 50px;
            height: 50px;
            text-align: center;
            line-height: 50px;
            color: #fff;
            font-size: 20px;
            background-color: rgb(0, 149, 139);
            text-decoration: none;
            opacity: 0;
            box-shadow: -4px 4px 24px -10px rgba(0, 149, 139,.3)
        }
        .cd-top--is-visible {
            visibility: visible;
            opacity: 1;
        }
        .scroll_up{
            color:#fff;
        }
    </style>
    @stack('css')
</head>

<body>
    @include('components.header.header', [
        'container' => 'container',
    ])
    @yield('not_container')
    <div>
        @yield('hero')
    </div>
    <div class="container">
        @yield('content')
    </div>
    @yield('not_container_bottom')
    @include('components.footer.footer', [
        'container' => 'container',
    ])
    @include('components.footer.mb_footer')
    @include('components.footer.mb_sidebar')
    @stack('script')
    <a href="#" class="backtotop_icon cd-top text-replace js-cd-top">
        <i class="fa-solid fa-arrow-up scroll_up"></i>
    </a>
    <script src="https://code.jquery.com/jquery-1.12.4.min.js"
        integrity="sha256-ZosEbRLbNQzLpnKIkEdrPv7lOy9C27hHQ+Xp8a4MxAQ=" crossorigin="anonymous"></script>
    <script src="/scroll/back-to-top-master/assets/js/main.js"></script>
    <script src="/scroll/back-to-top-master/assets/js/util.js"></script>
    <script>
        var offset = 300,
            offsetOpacity = 1200,
            scrollDuration = 700;
    </script>
    <script>
        toastr.options.positionClass = 'toastr-bottom-right';
    </script>
    
</body>

</html>
