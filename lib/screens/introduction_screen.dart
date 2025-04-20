import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class IntroductionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Chuyển sang LoginScreen sau 10 giây
    Future.delayed(const Duration(seconds: 10), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen(role: 'manager')),
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Giới Thiệu Thành Viên"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Chào mừng bạn đến với ứng dụng!\n\nNhóm phát triển:",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              "1. Nguyễn Kim Hồng\n2. Nguyễn Nhất Huy",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}