import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..forward();

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    Future.delayed(const Duration(seconds: 3), () {
      Get.off(() => const MainScreen());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Updated prominent text styling
              Text(
                "💭 Dream Journal 🌙",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36, // Increased font size for better visibility
                  fontWeight: FontWeight.bold, // Bold for prominence
                  color: Colors.white, // Light color for contrast
                  letterSpacing: 1.5, // Spacing for aesthetic appeal
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Capture your dreams 💤",
                style: TextStyle(
                  fontSize: 18, // Slightly larger text for clarity
                  color: Colors.white70, // Softer white for secondary text
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
