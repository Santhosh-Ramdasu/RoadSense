import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../config/constants.dart';
import 'auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 3200), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (_, __, ___) => const AuthScreen(),
            transitionsBuilder: (_, anim, __, child) => FadeTransition(
              opacity: anim,
              child: child,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.darkBgGradient),
        child: Stack(
          children: [
            // Background grid pattern
            CustomPaint(
              painter: _GridPainter(),
              size: MediaQuery.of(context).size,
            ),
            // Glow orbs
            Positioned(
              top: -100, left: -100,
              child: Container(
                width: 400, height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    AppTheme.primary.withValues(alpha: 0.15),
                    Colors.transparent,
                  ]),
                ),
              ),
            ),
            Positioned(
              bottom: -100, right: -100,
              child: Container(
                width: 350, height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    AppTheme.secondary.withValues(alpha: 0.12),
                    Colors.transparent,
                  ]),
                ),
              ),
            ),
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: 100, height: 100,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withValues(alpha: 0.4),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.psychology_rounded,
                      color: Colors.white,
                      size: 56,
                    ),
                  )
                  .animate()
                  .scale(begin: const Offset(0.4, 0.4), duration: 600.ms, curve: Curves.elasticOut)
                  .fadeIn(duration: 400.ms),

                  SizedBox(height: 28),

                  // App name
                  ShaderMask(
                    shaderCallback: (bounds) => AppTheme.primaryGradient.createShader(bounds),
                    child: Text(
                      'RoadSense',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -1,
                      ),
                    ),
                  )
                  .animate(delay: 400.ms)
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 0.3),

                  SizedBox(height: 10),

                  Text(
                    appTagline,
                    style: TextStyle(
                      fontSize: 15,
                      color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey),
                      letterSpacing: 0.5,
                    ),
                  )
                  .animate(delay: 700.ms)
                  .fadeIn(duration: 500.ms),

                  SizedBox(height: 60),

                  // Animated dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8, height: 8,
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        shape: BoxShape.circle,
                      ),
                    )
                    .animate(delay: Duration(milliseconds: 900 + i * 150))
                    .fadeIn()
                    .then()
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scale(end: const Offset(1.5, 1.5), duration: 600.ms)),
                  ),

                  SizedBox(height: 20),

                  Text(
                    'Powered by Gemini AI',
                    style: TextStyle(
                      fontSize: 12,
                      color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey).withValues(alpha: 0.6),
                      letterSpacing: 1,
                    ),
                  )
                  .animate(delay: 1200.ms)
                  .fadeIn(duration: 400.ms),
                ],
              ),
            ),

            // SDG badge bottom
            Positioned(
              bottom: 40, left: 0, right: 0,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.success.withValues(alpha: 0.4)),
                      color: AppTheme.success.withValues(alpha: 0.1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.eco, color: AppTheme.success, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'SDG 9 — Industry, Innovation & Infrastructure',
                          style: TextStyle(
                            color: AppTheme.success,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                  .animate(delay: 1500.ms)
                  .fadeIn(duration: 400.ms),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 1;
    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
