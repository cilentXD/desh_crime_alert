import 'package:desh_crime_alert/welcome_screen.dart';
import 'package:flutter/material.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _iconController;
  late AnimationController _fadeController;

  final List<IntroItem> _introItems = [
    IntroItem(
      title: 'Emergency Help | জরুরি সাহায্য',
      description:
          'Get instant help in any emergency situation.\nযেকোনো বিপদে দ্রুত সহায়তা পান!',
      icon: Icons.emergency,
    ),
    IntroItem(
      title: 'Live Location | লাইভ লোকেশন',
      description:
          'Stay safe by sharing your live location.\nআপনার অবস্থান শেয়ার করুন নিরাপদে থাকতে!',
      icon: Icons.location_on,
    ),
    IntroItem(
      title: 'Nearby Alerts | আশেপাশের সতর্কতা',
      description:
          'Receive real-time alerts around you.\nআপনার আশেপাশের সতর্কতা পান সাথে সাথে!',
      icon: Icons.notifications_active,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _iconController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
    _fadeController.reset();
    _fadeController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFA5858), Color(0xFFFAD961)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Main PageView
              PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _introItems.length,
                itemBuilder: (context, index) {
                  return _buildIntroPage(_introItems[index]);
                },
              ),

              // Top Skip Button
              Positioned(
                top: 16,
                right: 24,
                child: TextButton(
                  onPressed: () => _goToAuth(),
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ),

              // Bottom Navigation
              Positioned(
                bottom: 40,
                left: 24,
                right: 24,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDotIndicator(),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 8,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.redAccent.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          if (_currentPage == _introItems.length - 1) {
                            _goToAuth();
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 450),
                              curve: Curves.easeOutCubic,
                            );
                          }
                        },
                        child: Text(
                          _currentPage == _introItems.length - 1
                              ? 'Start Now | শুরু করুন'
                              : 'Next | পরবর্তী',
                          style: const TextStyle(
                            fontSize: 18,
                            letterSpacing: 1.2,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Main intro page design with animation
  Widget _buildIntroPage(IntroItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 60),
      child: FadeTransition(
        opacity: _fadeController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated spinning icon
            AnimatedBuilder(
              animation: _iconController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _iconController.value * 2 * 3.1416,
                  child: child,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.14),
                      blurRadius: 40,
                      spreadRadius: 8,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 62,
                  backgroundColor: Colors.white,
                  child: Icon(
                    item.icon,
                    size: 75,
                    color: Colors.red.shade700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Text(
              item.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.1,
                shadows: [
                  Shadow(
                    color: Color.fromARGB(40, 0, 0, 0),
                    blurRadius: 6,
                    offset: Offset(1, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Text(
              item.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white.withOpacity(0.93),
                height: 1.5,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Animated dot indicator
  Widget _buildDotIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _introItems.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 7),
          width: _currentPage == index ? 28 : 10,
          height: 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: _currentPage == index
                ? Colors.white
                : Colors.white.withOpacity(0.5),
            boxShadow: _currentPage == index
                ? [
                    BoxShadow(
                      color: Colors.red.shade200,
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
        ),
      ),
    );
  }

  void _goToAuth() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const WelcomeScreen(),
      ),
    );
  }
}

class IntroItem {
  final String title;
  final String description;
  final IconData icon;

  IntroItem({
    required this.title,
    required this.description,
    required this.icon,
  });
}
