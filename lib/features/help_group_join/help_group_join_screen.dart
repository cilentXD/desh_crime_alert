import 'package:desh_crime_alert/features/help_group_join/help_group_phone_auth_service.dart';
import 'package:flutter/material.dart';

/// Screen that lets a user join a Help Group using phone-OTP verification.
class HelpGroupJoinScreen extends StatefulWidget {
  const HelpGroupJoinScreen({super.key});

  @override
  State<HelpGroupJoinScreen> createState() => _HelpGroupJoinScreenState();
}

class _HelpGroupJoinScreenState extends State<HelpGroupJoinScreen> {
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _otpCtrl = TextEditingController();
  bool _otpSent = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join Help Group')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            !_otpSent ? _buildPhoneForm() : _buildOtpForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Enter your phone number to join the group'),
        const SizedBox(height: 16),
        TextField(
          controller: _phoneCtrl,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            prefixIcon: Icon(Icons.phone),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _isLoading ? null : _sendOtp,
          child: _isLoading
              ? const CircularProgressIndicator()
              : const Text('Send OTP'),
        ),
      ],
    );
  }

  Widget _buildOtpForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Enter OTP sent to your phone'),
        const SizedBox(height: 16),
        TextField(
          controller: _otpCtrl,
          keyboardType: TextInputType.number,
          maxLength: 6,
          decoration: const InputDecoration(
            labelText: 'OTP',
            prefixIcon: Icon(Icons.lock),
            counterText: '',
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _isLoading ? null : _verifyOtp,
          child: _isLoading
              ? const CircularProgressIndicator()
              : const Text('Verify & Join'),
        ),
      ],
    );
  }

  Future<void> _sendOtp() async {
    final phone = _phoneCtrl.text.trim();
    if (phone.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      await HelpGroupPhoneAuthService().sendOTP(phone);
      setState(() => _otpSent = true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyOtp() async {
    final otp = _otpCtrl.text.trim();
    if (otp.length != 6) return;
    setState(() => _isLoading = true);
    try {
      final ok = await HelpGroupPhoneAuthService().verifyOTP(otp);
      if (ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully joined help group!')),
        );
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid OTP')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
