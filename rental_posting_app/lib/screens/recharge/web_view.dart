import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../home/home_page.dart';

class VnPayWebViewPage extends StatefulWidget {
  final String paymentUrl;
  const VnPayWebViewPage({super.key, required this.paymentUrl});

  @override
  State<VnPayWebViewPage> createState() => _VnPayWebViewPageState();
}

class _VnPayWebViewPageState extends State<VnPayWebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final url = request.url;
            if (url.startsWith("flutter://payment-result")) {
              final uri = Uri.parse(url);
              final status = uri.queryParameters["status"];

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const BottomNavScreen()),
                (route) => false,
              );

              return NavigationDecision.prevent; // ✅ Không load URL đó
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("VNPay Payment")),
      body: WebViewWidget(controller: _controller),
    );
  }
}
