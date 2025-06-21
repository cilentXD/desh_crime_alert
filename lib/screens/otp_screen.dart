import 'package:desh_crime_alert/main_scaffold_screen.dart';
import 'package:desh_crime_alert/services/auth_service.dart';
import 'package:flutter/material.dart';

class OTPScreen extends StatefulWidget {
  final String phone;
  final String? name;

  const OTPScreen({
    super.key,
    required this.phone,
    this.name,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _otpController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shield,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 30),
            const Text(
              'OTP ভেরিফিকেশন',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '+88${widget.phone} নাম্বারে OTP পাঠানো হয়েছে',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, letterSpacing: 8),
              decoration: InputDecoration(
                hintText: '000000',
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _isLoading ? null : _verifyOTP,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('ভেরিফাই করুন'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _verifyOTP() async {
    if (_otpController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('6 ডিজিটের OTP দিন')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final verified = await AuthService().verifyOTP(
        _otpController.text,
        name: widget.name,
      );
      if (verified && mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MainScaffoldScreen()),
          (route) => false,
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP verification failed.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
   