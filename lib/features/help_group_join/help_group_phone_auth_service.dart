import 'package:desh_crime_alert/services/auth_service.dart';

/// Helper wrapper around the existing [`AuthService`] so that the rest of the
/// code can evolve independently from the generic login / register flow.
///
/// * Keeps business-logic wording focused on a “Help Group join” context.
class HelpGroupPhoneAuthService {
  static final HelpGroupPhoneAuthService _instance = HelpGroupPhoneAuthService._internal();
  factory HelpGroupPhoneAuthService() => _instance;
  HelpGroupPhoneAuthService._internal();

  final AuthService _auth = AuthService();

  /// Sends an OTP to the given Bangladeshi phone number (without +88).
  Future<void> sendOTP(String phone) async {
    await _auth.sendOTP(phone);
  }

  /// Verifies the entered OTP. Returns `true` on success.
  Future<bool> verifyOTP(String otp) async {
    return _auth.verifyOTP(otp);
  }
}
