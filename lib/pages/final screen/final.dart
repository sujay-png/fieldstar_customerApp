import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ThankYouPage extends StatefulWidget {
  const ThankYouPage({super.key});

  @override
  State<ThankYouPage> createState() => _ThankYouPageState();
}

class _ThankYouPageState extends State<ThankYouPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
      context.go('/Home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: Color(0xFFD1FAE5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Color(0xFF10B981),
                size: 36,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "Thank You!",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Your feedback helps us improve our service quality",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Redirecting to dashboard...",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 16),

            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}