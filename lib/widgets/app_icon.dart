import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Method 1: Load SVG from assets folder
class AppIconFromAssets extends StatelessWidget {
  const AppIconFromAssets({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'From Assets',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 120,
          height: 120,
          child: SvgPicture.asset(
            'assets/icons/desh_crime_alert_icon.svg',
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}

// Method 2: Use inline SVG string
class AppIconFromString extends StatelessWidget {
  final String svgString = '''
<svg viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="appBg" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#1f2937;stop-opacity:1" />
      <stop offset="50%" style="stop-color:#374151;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#111827;stop-opacity:1" />
    </linearGradient>
    <linearGradient id="neonGrad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#06b6d4;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#0891b2;stop-opacity:1" />
    </linearGradient>
    <linearGradient id="alertGlow" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#f59e0b;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#d97706;stop-opacity:1" />
    </linearGradient>
    <filter id="glow" x="-50%" y="-50%" width="200%" height="200%">
      <feGaussianBlur stdDeviation="3" result="coloredBlur"/>
      <feMerge> 
        <feMergeNode in="coloredBlur"/>
        <feMergeNode in="SourceGraphic"/>
      </feMerge>
    </filter>
    <filter id="dropShadow" x="-50%" y="-50%" width="200%" height="200%">
      <feDropShadow dx="0" dy="6" stdDeviation="8" flood-color="#000000" flood-opacity="0.4"/>
    </filter>
  </defs>
  
  <rect x="10" y="10" width="180" height="180" rx="40" ry="40" fill="url(#appBg)" filter="url(#dropShadow)"/>
  <path d="M100 45 L75 60 L75 90 L100 135 L125 90 L125 60 Z" fill="url(#neonGrad)" stroke="#06b6d4" stroke-width="2" filter="url(#glow)"/>
  <path d="M100 55 L85 65 L85 85 L100 120 L115 85 L115 65 Z" fill="none" stroke="#ffffff" stroke-width="1.5" opacity="0.6"/>
  <path d="M100 70 L90 95 L110 95 Z" fill="#ffffff"/>
  <circle cx="100" cy="85" r="2" fill="#1f2937"/>
  <rect x="98" y="90" width="4" height="4" fill="#1f2937"/>
  <circle cx="100" cy="90" r="20" fill="none" stroke="#06b6d4" stroke-width="1" opacity="0.3"/>
  <circle cx="100" cy="90" r="30" fill="none" stroke="#06b6d4" stroke-width="1" opacity="0.2"/>
  <circle cx="100" cy="90" r="40" fill="none" stroke="#06b6d4" stroke-width="1" opacity="0.1"/>
  <circle cx="135" cy="55" r="12" fill="url(#alertGlow)" stroke="#ffffff" stroke-width="2" filter="url(#glow)"/>
  <text x="135" y="61" text-anchor="middle" font-family="Arial, sans-serif" font-size="10" font-weight="bold" fill="#ffffff">!</text>
  <rect x="25" y="25" width="8" height="2" fill="#06b6d4" opacity="0.8"/>
  <rect x="25" y="25" width="2" height="8" fill="#06b6d4" opacity="0.8"/>
  <rect x="167" y="25" width="8" height="2" fill="#06b6d4" opacity="0.8"/>
  <rect x="173" y="25" width="2" height="8" fill="#06b6d4" opacity="0.8"/>
  <rect x="25" y="167" width="8" height="2" fill="#06b6d4" opacity="0.8"/>
  <rect x="25" y="173" width="2" height="8" fill="#06b6d4" opacity="0.8"/>
  <rect x="167" y="173" width="8" height="2" fill="#06b6d4" opacity="0.8"/>
  <rect x="173" y="167" width="2" height="8" fill="#06b6d4" opacity="0.8"/>
  <text x="100" y="170" text-anchor="middle" font-family="Arial, sans-serif" font-size="12" font-weight="bold" fill="#ffffff" opacity="0.95">DESH</text>
  <text x="100" y="185" text-anchor="middle" font-family="Arial, sans-serif" font-size="8" font-weight="500" fill="#ffffff" opacity="0.8">CRIME ALERT</text>
  <circle cx="40" cy="40" r="3" fill="#ffffff" opacity="0.3"/>
  <circle cx="160" cy="160" r="3" fill="#ffffff" opacity="0.3"/>
</svg>
  ''';

  const AppIconFromString({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'From String',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 120,
          height: 120,
          child: SvgPicture.string(
            svgString,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}

// Method 3: Animated version with tap interaction
class AnimatedAppIcon extends StatefulWidget {
  const AnimatedAppIcon({super.key});

  @override
  AnimatedAppIconState createState() => AnimatedAppIconState();
}

class AnimatedAppIconState extends State<AnimatedAppIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Interactive (Tap me!)',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          onTap: () {
            // Handle app icon tap
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('DESH Crime Alert activated!'),
                backgroundColor: Color(0xFF06b6d4),
              ),
            );
          },
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: SizedBox(
                    width: 120,
                    height: 120,
                    child: SvgPicture.asset(
                      'assets/icons/desh_crime_alert_icon.svg',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Utility class for creating app icons in different sizes
class AppIconSizes {
  static Widget small() => _buildIcon(48);
  static Widget medium() => _buildIcon(72);
  static Widget large() => _buildIcon(120);
  static Widget extraLarge() => _buildIcon(180);

  static Widget _buildIcon(double size) {
    return SizedBox(
      width: size,
      height: size,
      child: SvgPicture.asset(
        'assets/icons/desh_crime_alert_icon.svg',
        fit: BoxFit.contain,
      ),
    );
  }
}

// Usage in app bar or navigation
class AppBarWithIcon extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWithIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AppIconSizes.small(),
      ),
      title: const Text('DESH Crime Alert'),
      backgroundColor: const Color(0xFF374151),
      foregroundColor: Colors.white,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
