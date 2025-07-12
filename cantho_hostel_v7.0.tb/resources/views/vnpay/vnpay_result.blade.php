<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết quả thanh toán</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 15px;
        }

        .card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 400px;
            padding: 30px 20px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2);
        }

        .status-icon {
            width: 80px;
            height: 80px;
            margin: 0 auto 20px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 40px;
            font-weight: bold;
            color: white;
            animation: pulse 2s ease-in-out infinite;
        }

        .success-icon {
            background: linear-gradient(135deg, #4CAF50, #45a049);
        }

        .error-icon {
            background: linear-gradient(135deg, #f44336, #d32f2f);
        }

        .success-icon::before { content: '✓'; }
        .error-icon::before { content: '✗'; }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }

        h2 {
            font-size: 22px;
            margin-bottom: 20px;
            font-weight: 600;
            line-height: 1.4;
        }

        .success { color: #4CAF50; }
        .error { color: #f44336; }

        .payment-details {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 20px;
            margin: 20px 0;
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
            padding: 8px 0;
            border-bottom: 1px solid #e9ecef;
        }

        .detail-row:last-child {
            border-bottom: none;
            margin-bottom: 0;
        }

        .detail-label {
            font-size: 14px;
            color: #6c757d;
            font-weight: 500;
        }

        .detail-value {
            font-size: 16px;
            font-weight: 600;
            color: #343a40;
        }

        .amount {
            color: #28a745;
        }

        .balance {
            color: #007bff;
        }

        .redirect {
            margin-top: 25px;
            padding: 15px;
            background: #e3f2fd;
            border-radius: 10px;
            border-left: 4px solid #2196f3;
        }

        .redirect-text {
            font-size: 14px;
            color: #1976d2;
            font-weight: 500;
            margin-bottom: 8px;
        }

        .countdown {
            font-size: 18px;
            font-weight: 700;
            color: #1976d2;
            animation: countdown 1s ease-in-out infinite;
        }

        @keyframes countdown {
            0% { opacity: 1; }
            50% { opacity: 0.6; }
            100% { opacity: 1; }
        }

        .progress-bar {
            width: 100%;
            height: 4px;
            background: #e0e0e0;
            border-radius: 2px;
            overflow: hidden;
            margin-top: 15px;
        }

        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #2196f3, #1976d2);
            width: 100%;
            animation: progress 5s linear;
        }

        @keyframes progress {
            from { width: 100%; }
            to { width: 0%; }
        }

        /* Mobile optimizations */
        @media (max-width: 480px) {
            .card {
                padding: 25px 15px;
                margin: 10px;
                border-radius: 15px;
            }

            h2 {
                font-size: 20px;
            }

            .status-icon {
                width: 70px;
                height: 70px;
                font-size: 35px;
            }

            .detail-value {
                font-size: 15px;
            }

            .payment-details {
                padding: 15px;
            }
        }

        /* Very small screens */
        @media (max-width: 320px) {
            .card {
                padding: 20px 12px;
            }

            h2 {
                font-size: 18px;
            }

            .status-icon {
                width: 60px;
                height: 60px;
                font-size: 30px;
            }
        }

        /* Landscape mobile */
        @media (max-height: 500px) and (orientation: landscape) {
            body {
                padding: 10px;
            }

            .card {
                padding: 20px 15px;
            }

            .status-icon {
                width: 60px;
                height: 60px;
                font-size: 30px;
                margin-bottom: 15px;
            }

            h2 {
                font-size: 18px;
                margin-bottom: 15px;
            }

            .payment-details {
                padding: 15px;
                margin: 15px 0;
            }
        }
    </style>
    <script>
        let countdown = 5; // số giây đếm ngược
        document.addEventListener("DOMContentLoaded", function () {
            const textElement = document.getElementById("redirect-text");
            const countdownElement = document.getElementById("countdown-number");

            const interval = setInterval(function () {
                countdown--;
                if (textElement && countdownElement) {
                    countdownElement.textContent = countdown;
                }

                if (countdown <= 0) {
                    clearInterval(interval);
                    if (textElement) {
                        textElement.innerHTML = 'Đang chuyển hướng...';
                    }
                }
            }, 1000);

            // Chuyển hướng sau 5 giây
            setTimeout(function () {
    window.location.href = "flutter://payment-result?status={{ $status ? 'success' : 'fail' }}";
}, 5000);
        });
    </script>
</head>
<body>
    <div class="card">
        <!-- Demo với success status -->
        <div class="status-icon {{ $status ? 'success-icon' : 'error-icon' }}"></div>

        <h2 class="{{ $status ? 'success' : 'error' }}">
            {{ $message }}
        </h2>

        @if ($status)
            <div class="payment-details">
                <div class="detail-row">
                    <span class="detail-label">Số tiền:</span>
                    <span class="detail-value amount">{{ number_format($amount ?? 0) }} VND</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Số dư mới:</span>
                    <span class="detail-value balance">{{ number_format($balance ?? 0) }} VND</span>
                </div>
            </div>
        @endif

        <div class="redirect">
            <div class="redirect-text" id="redirect-text">
                Bạn sẽ được chuyển về ứng dụng sau <span class="countdown" id="countdown-number">5</span> giây...
            </div>
            <div class="progress-bar">
                <div class="progress-fill"></div>
            </div>
        </div>
    </div>
</body>
</html>
