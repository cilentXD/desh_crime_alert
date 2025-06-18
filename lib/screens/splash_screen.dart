import 'package:flutter/material.dart';
import 'package:desh_crime_alert/utils/custom_painters.dart'; // Import custom painters

class DeshCrimeAlertScreen extends StatefulWidget {
  const DeshCrimeAlertScreen({super.key});

  @override
  State<DeshCrimeAlertScreen> createState() => _DeshCrimeAlertScreenState();
}

class _DeshCrimeAlertScreenState extends State<DeshCrimeAlertScreen>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _pulseController;
  late Animation<double> _glowAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    
    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _initializeApp(); // Navigate after animations
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 3)); // Wait for animations to play
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            colors: [
              Color(0xFF2a2a2a),
              Color(0xFF1a1a1a),
              Color(0xFF0f0f0f),
            ],
            stops: [0.0, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Corner brackets
            _buildCornerBrackets(),
            
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Glowing diamond logo with alert
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer glow rings
                      AnimatedBuilder(
                        animation: _glowAnimation,
                        builder: (context, child) {
                          return Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF00d4aa).withOpacity(_glowAnimation.value * 0.3),
                                  blurRadius: 50,
                                  spreadRadius: 20,
                                ),
                                BoxShadow(
                                  color: const Color(0xFF00d4aa).withOpacity(_glowAnimation.value * 0.1),
                                  blurRadius: 100,
                                  spreadRadius: 40,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      
                      // Diamond shape
                      CustomPaint(
                        size: const Size(120, 120),
                        painter: DiamondPainter(),
                      ),
                      
                      // Inner triangle with elements
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CustomPaint(
                          painter: InnerElementsPainter(),
                        ),
                      ),
                      
                      // Alert badge
                      Positioned(
                        top: 20,
                        right: 20,
                        child: AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _pulseAnimation.value,
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFff6b35),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFff6b35).withOpacity(0.6),
                                      blurRadius: 15,
                                      spreadRadius: 3,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.priority_high,
                                  color: Colors.white,
                                  size: 20,
                                  weight: 800,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 60),
                  
                  // DESH Title
                  Text(
                    'DESH',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 8,
                      shadows: [
                        Shadow(
                          color: const Color(0xFF00d4aa).withOpacity(0.5),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Crime Alert subtitle
                  Text(
                    'CRIME ALERT',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.8),
                      letterSpacing: 4,
                    ),
                  ),
                ],
              ),
            ),
            
            // Status indicator dots
            _buildStatusDots(),
          ],
        ),
      ),
    );
  }

  Widget _buildCornerBrackets() {
    return Stack(
      children: [
        // Top left
        Positioned(
          top: 40,
          left: 40,
          child: CustomPaint(
            size: const Size(30, 30),
            painter: CornerBracketPainter(isTopLeft: true),
          ),
        ),
        // Top right
        Positioned(
          top: 40,
          right: 40,
          child: CustomPaint(
            size: const Size(30, 30),
            painter: CornerBracketPainter(isTopRight: true),
          ),
        ),
        // Bottom left
        Positioned(
          bottom: 40,
          left: 40,
          child: CustomPaint(
            size: const Size(30, 30),
            painter: CornerBracketPainter(isBottomLeft: true),
          ),
        ),
        // Bottom right
        Positioned(
          bottom: 40,
          right: 40,
          child: CustomPaint(
            size: const Size(30, 30),
            painter: CornerBracketPainter(isBottomRight: true),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusDots() {
    return Stack(
      children: [
        Positioned(
          top: 120,
          left: 60,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          bottom: 120,
          right: 60,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}

