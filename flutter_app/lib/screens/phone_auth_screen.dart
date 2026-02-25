import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;
  String? verificationId;

  Future<void> sendOTP() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneController.text.trim(),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        // TODO: Navigate to main app screen
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          errorMessage = e.message;
          isLoading = false;
        });
      },
      codeSent: (String vId, int? resendToken) {
        setState(() {
          verificationId = vId;
          isLoading = false;
        });
      },
      codeAutoRetrievalTimeout: (String vId) {
        setState(() {
          verificationId = vId;
          isLoading = false;
        });
      },
    );
  }

  Future<void> verifyOTP() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: otpController.text.trim(),
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      // TODO: Navigate to main app screen
      // Example: Call backend API to sync user
      await http.post(
        Uri.parse('https://minglea.onrender.com/api/auth/phone'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "phone": phoneController.text.trim(),
        }),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phone OTP Authentication')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: sendOTP,
              child: const Text('Send OTP'),
            ),
            if (verificationId != null) ...[
              TextField(
                controller: otpController,
                decoration: const InputDecoration(labelText: 'Enter OTP'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: verifyOTP,
                child: const Text('Verify OTP'),
              ),
            ],
            if (errorMessage != null)
              Text(errorMessage!, style: const TextStyle(color: Colors.red)),
            if (isLoading) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
