import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_posting_app/providers/blog_provider.dart';
import 'package:rental_posting_app/providers/care_about_provider.dart';
import 'package:rental_posting_app/providers/category_provider.dart';
import 'package:rental_posting_app/providers/detail_image_provider.dart';
import 'package:rental_posting_app/providers/get_post_byCategory_provider.dart';
import 'package:rental_posting_app/providers/get_post_byUser_provider.dart';
import 'package:rental_posting_app/providers/highlight_post_provider.dart';
import 'package:rental_posting_app/providers/location_provider.dart';
import 'package:rental_posting_app/providers/new_post_provider.dart';
import 'package:rental_posting_app/providers/payment_provider.dart';
import 'package:rental_posting_app/providers/post_payment_provider.dart';
import 'package:rental_posting_app/providers/post_provider.dart';
import 'package:rental_posting_app/providers/recharge_provider.dart';
import 'package:rental_posting_app/providers/user_info_provider.dart';
import 'package:rental_posting_app/providers/vn_pay_provider.dart';
import 'package:rental_posting_app/screens/auth/splash_screen.dart';

import 'providers/auth_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
            create: (_) => HighlightPostProvider()..fetchInitialPosts()),
        ChangeNotifierProvider(
            create: (_) => NewPostProvider()..fetchInitialPosts()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(
            create: (_) => DetailImageProvider()..fetchDetailImage()),
        ChangeNotifierProvider(
            create: (_) => UserInfoProvider()..fetchUserInfo()),
        ChangeNotifierProvider(
            create: (_) => SimilarProvider()..fetchSimilar()),
        ChangeNotifierProvider(
            create: (_) => CategoryProvider()..fetchCategory()),
        ChangeNotifierProvider(
            create: (_) => GetPostByCategoryProvider()..fetchPostByCategory()),
        ChangeNotifierProvider(create: (_) => BlogProvider()..fetchBlog()),
        ChangeNotifierProvider(
            create: (_) => RechargeProvider()..fetchRechargeHistory()),
        ChangeNotifierProvider(
            create: (_) => PaymentProvider()..fetchPaymentHistory()),
        ChangeNotifierProvider(
          create: (_) => GetPostByUserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PostPaymentProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PostProvider(),
        ),
        ChangeNotifierProvider(create: (_) => VnPayProvider()),
      ],
      child: MaterialApp(
        title: "Stay Connect",
        theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xffF5F9FF),
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0xff0A8066)),
            useMaterial3: true,
            fontFamily: "Montserrat",
            appBarTheme: const AppBarTheme(),
            textTheme: const TextTheme(
                bodyMedium: TextStyle(
                    fontSize: 16.0,
                    color: Color(0xff202244),
                    fontWeight: FontWeight.w500),
                bodySmall: TextStyle(
                    fontSize: 14.0,
                    color: Color(0xff202244),
                    fontWeight: FontWeight.w500),
                labelSmall: TextStyle(
                    fontSize: 12.0,
                    color: Color(0xff202244),
                    fontWeight: FontWeight.w500),
                headlineSmall: TextStyle(
                    fontSize: 24.0,
                    color: Color(0xff202244),
                    fontWeight: FontWeight.w500),
                titleLarge: TextStyle(
                    fontSize: 18,
                    color: Color(0xff202244),
                    fontWeight: FontWeight.w500)),
            iconTheme: const IconThemeData(color: Color(0xff202244))),

        // home: const PostListScreen(),
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
