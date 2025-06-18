import 'package:flutter/material.dart';
import 'login_screen.dart'; // Import the corrected login page

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _textAnimationController;
  late AnimationController _buttonAnimationController;
  late AnimationController _backgroundAnimationController;
  late AnimationController _particleAnimationController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _buttonFadeAnimation;
  late Animation<Offset> _buttonSlideAnimation;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _particleAnimation;

  @override
  void initState() {
    super.initState();

    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _backgroundAnimationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _particleAnimationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);

    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _logoRotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _textSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _textAnimationController,
        curve: Curves.easeOutBack,
      ),
    );

    _buttonFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _buttonAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _buttonSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 1.0), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _buttonAnimationController,
        curve: Curves.easeOutBack,
      ),
    );

    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _backgroundAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _particleAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    _backgroundAnimationController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    _logoAnimationController.forward();
    await Future.delayed(const Duration(milliseconds: 800));
    _textAnimationController.forward();
    await Future.delayed(const Duration(milliseconds: 600));
    _buttonAnimationController.forward();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _textAnimationController.dispose();
    _buttonAnimationController.dispose();
    _backgroundAnimationController.dispose();
    _particleAnimationController.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(
                    const Color(0xFF1A1A2E),
                    const Color(0xFF16213E),
                    _backgroundAnimation.value,
                  )!,
                  Color.lerp(
                    const Color(0xFF16213E),
                    const Color(0xFF0F3460),
                    _backgroundAnimation.value,
                  )!,
                  Color.lerp(
                    const Color(0xFF0F3460),
                    const Color(0xFF533483),
                    _backgroundAnimation.value,
                  )!,
                ],
              ),
            ),
            child: Stack(
              children: [
                // Animated particles/stars background
                AnimatedBuilder(
                  animation: _particleAnimation,
                  builder: (context, child) {
                    return CustomPaint(
                      size: Size.infinite,
                      painter: ParticlePainter(_particleAnimation.value),
                    );
                  },
                ),
                // Glassmorphism overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.05),
                        Colors.transparent,
                        Colors.purple.withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Enhanced logo with glassmorphism effect
                                AnimatedBuilder(
                                  animation: _logoAnimationController,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: _logoScaleAnimation.value,
                                      child: Transform.rotate(
                                        angle: _logoRotationAnimation.value * 0.1,
                                        child: Container(
                                          width: 160,
                                          height: 160,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Colors.white.withOpacity(0.2),
                                                Colors.white.withOpacity(0.05),
                                                Colors.purple.withOpacity(0.1),
                                              ],
                                            ),
                                            border: Border.all(
                                              color: Colors.white.withOpacity(0.3),
                                              width: 1.5,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.purple.withOpacity(0.3),
                                                blurRadius: 30,
                                                spreadRadius: 0,
                                              ),
                                              BoxShadow(
                                                color: Colors.white.withOpacity(0.1),
                                                blurRadius: 10,
                                                spreadRadius: -5,
                                              ),
                                            ],
                                          ),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              // Pulsing ring effect
                                              AnimatedBuilder(
                                                animation: _particleAnimation,
                                                builder: (context, child) {
                                                  return Container(
                                                    width: 140 + (20 * _particleAnimation.value),
                                                    height: 140 + (20 * _particleAnimation.value),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: Colors.cyan.withOpacity(
                                                          0.3 * (1 - _particleAnimation.value),
                                                        ),
                                                        width: 2,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                              // Main icon
                                              ShaderMask(
                                                shaderCallback: (bounds) => LinearGradient(
                                                  colors: [
                                                    Colors.white,
                                                    Colors.cyan.shade200,
                                                    Colors.purple.shade200,
                                                  ],
                                                ).createShader(bounds),
                                                child: const Icon(
                                                  Icons.security,
                                                  size: 80,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 40),
                                // Enhanced text with gradient and backdrop blur
                                FadeTransition(
                                  opacity: _textFadeAnimation,
                                  child: SlideTransition(
                                    position: _textSlideAnimation,
                                    child: Column(
                                      children: [
                                        ShaderMask(
                                          shaderCallback: (bounds) => LinearGradient(
                                            colors: [
                                              Colors.white,
                                              Colors.cyan.shade100,
                                              Colors.purple.shade100,
                                            ],
                                          ).createShader(bounds),
                                          child: Text(
                                            'Desh Crime Alert',
                                            style: TextStyle(
                                              fontSize: 36,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                              letterSpacing: 2.0,
                                              shadows: [
                                                Shadow(
                                                  blurRadius: 20.0,
                                                  color: Colors.purple.withOpacity(0.5),
                                                  offset: const Offset(0, 4),
                                                ),
                                                Shadow(
                                                  blurRadius: 10.0,
                                                  color: Colors.cyan.withOpacity(0.3),
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(
                                              color: Colors.white.withOpacity(0.2),
                                            ),
                                          ),
                                          child: Text(
                                            'আপনাদের নিরাপত্তাই আমাদের লক্ষ্য',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white.withOpacity(0.9),
                                              fontFamily: 'HindSiliguri',
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Enhanced button with glassmorphism
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: FadeTransition(
                              opacity: _buttonFadeAnimation,
                              child: SlideTransition(
                                position: _buttonSlideAnimation,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(35),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.cyan.withOpacity(0.8),
                                        Colors.purple.withOpacity(0.8),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.cyan.withOpacity(0.3),
                                        blurRadius: 20,
                                        spreadRadius: 0,
                                        offset: const Offset(0, 8),
                                      ),
                                      BoxShadow(
                                        color: Colors.purple.withOpacity(0.3),
                                        blurRadius: 20,
                                        spreadRadius: 0,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      foregroundColor: Colors.white,
                                      shadowColor: Colors.transparent,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 60,
                                        vertical: 18,
                                      ),
                                      textStyle: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.0,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(35),
                                      ),
                                    ),
                                    onPressed: _navigateToLogin,
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('Get Started'),
                                        SizedBox(width: 8),
                                        Icon(
                                          Icons.arrow_forward_rounded,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Custom painter for animated particles/stars
class ParticlePainter extends CustomPainter {
  final double animationValue;

  ParticlePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    final glowPaint = Paint()
      ..color = Colors.cyan.withOpacity(0.3)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    // Create floating particles
    for (int i = 0; i < 50; i++) {
      final x = (i * 47.3) % size.width;
      final y = (i * 23.7 + animationValue * 100) % size.height;
      final radius = (i % 3) + 1.0;
      final opacity = (0.3 + (i % 4) * 0.2) * 
          (0.5 + 0.5 * (1 - (animationValue - 0.5).abs() * 2).clamp(0.0, 1.0));

      paint.color = Colors.white.withOpacity(opacity);
      glowPaint.color = Colors.cyan.withOpacity(opacity * 0.5);

      canvas.drawCircle(Offset(x, y), radius + 2, glowPaint);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}