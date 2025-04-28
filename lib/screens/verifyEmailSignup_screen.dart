import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VerifyEmailSignupScreen extends StatefulWidget {
  final String email; // Email từ màn hình đăng ký

  const VerifyEmailSignupScreen({super.key, required this.email});

  @override
  _VerifyEmailSignupScreenState createState() =>
      _VerifyEmailSignupScreenState();
}

class _VerifyEmailSignupScreenState extends State<VerifyEmailSignupScreen> {
  final _otpController = TextEditingController();
  bool _isLoading = false;

  Future<void> _verifyEmail() async {
    final otp = _otpController.text.trim();
    final email = widget.email;

    final url = Uri.parse('http://192.168.47.176:8080/api/v1/pharmacy/user/verify-email-signup');

    try {
      setState(() {
        _isLoading = true;
      });

      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Kiểm tra mã trả về từ server
        if (data['code'] == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Email xác thực thành công!')),
          );

          // Điều hướng đến màn hình tiếp theo, ví dụ màn hình trang chủ hoặc màn hình đăng nhập
          // Navigator.pushReplacementNamed(context, '/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Xác thực thất bại: ${data['message']}')),
          );
        }
      } else {
        final errorData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Xác thực thất bại: ${errorData['message']}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lỗi kết nối đến server')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Xác thực Email - Đăng ký'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _otpController,
              decoration: const InputDecoration(
                labelText: 'Nhập mã OTP',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập mã OTP';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      if (_otpController.text.isNotEmpty) {
                        _verifyEmail();
                      }
                    },
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Xác thực'),
            ),
          ],
        ),
      ),
    );
  }
}
