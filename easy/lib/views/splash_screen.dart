import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';
import 'app_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    startLoading();
  }

  void startLoading() {
    Timer.periodic(const Duration(milliseconds: 300), (timer) {
      setState(() {
        progress += 0.05;
      });

      if (progress >= 1) {
        timer.cancel();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => AppView()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFFCC80), Color(0xFFFFE0B2)],
              ),
            ),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: Lottie.asset(
                'assets/animations/bubbles.json',
                fit: BoxFit.cover,
                repeat: true,
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Easy Peasy',
                  style: TextStyle(
                    fontSize: 42,
                    fontFamily: 'Fredoka',
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF5D4037),
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                const Text(
                  'Learn English the fun way!',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Fredoka',
                    color: Colors.brown,
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 20,
                        spreadRadius: -5,
                      ),
                    ],
                  ),
                  child: Lottie.asset(
                    'assets/animations/tiger.json',
                    width: 350,
                    height: 350,
                  ),
                ),
                const SizedBox(height: 10),
                Opacity(
                  opacity: 0.4,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationX(3.14159),
                    child: ClipRRect(
                      child: Align(
                        alignment: Alignment.topCenter,
                        heightFactor: 0.4,
                        child: Lottie.asset(
                          'assets/animations/tiger.json',
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      colors: [Colors.orange, Colors.pink, Colors.purple],
                    ).createShader(bounds);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: progress,
                      color: Colors.blue,
                      backgroundColor: Colors.grey[300],
                      minHeight: 8,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Lottie.asset(
                        'assets/animations/star.json',
                        width: 24,
                        height: 24,
                        repeat: true,
                      ),
                      const Text(
                        'Loading your learning adventure... 🤓',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
