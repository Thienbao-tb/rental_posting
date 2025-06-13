import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_posting_app/providers/post_provider.dart';
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
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => PostProvider()),
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
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
