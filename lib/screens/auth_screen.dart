
import 'package:desh_crime_alert/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:desh_crime_alert/screens/otp_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool isLoading = false;
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 50),

                // Logo
                const Icon(
                  Icons.shield,
                  size: 100,
                  color: Colors.red,
                ),
                const SizedBox(height: 30),

                // Title
                Text(
                  isLogin ? 'লগইন করুন' : 'নিবন্ধন করুন',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),

                // Form Fields
                if (!isLogin) ...[
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'আপনার নাম',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'মোবাইল নাম্বার',
                    prefixText: '+88',
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Submit Button
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
                    onPressed: isLoading ? null : _handleSubmit,
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            isLogin ? 'লগইন' : 'নিবন্ধন',
                            style: const TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                // Toggle Button
                TextButton(
                  onPressed: () => setState(() => isLogin = !isLogin),
                  child: Text(
                    isLogin ? 'নতুন অ্যাকাউন্ট খুলুন' : 'লগইন করুন',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('মোবাইল নাম্বার দিন')),
      );
      return;
    }

    if (!isLogin && _nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('আপনার নাম দিন')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await AuthService().sendOTP(_phoneController.text);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OTPScreen(
              phone: _phoneController.text,
              name: isLogin ? null : _nameController.text,
            ),
          ),
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
        setState(() => isLoading = false);
      }
    }
  }
}
