import 'package:flutter/material.dart';

class LoginImageWidget extends StatelessWidget {
  const LoginImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'login-image-png.png',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'login-image.svg',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return _buildFallback();
            },
          );
        },
      ),
    );
  }

  Widget _buildFallback() {
    return const SizedBox(
      height: 400,
      child: Center(
        child: Text(
          'Login Image\nPlaceholder',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
        ),
      ),
    );
  }
}
