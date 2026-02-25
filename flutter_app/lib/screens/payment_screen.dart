import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isLoading = false;
  String? errorMessage;

  Future<void> initiateMpesaPayment() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    // Example: Call backend M-Pesa endpoint
    final response = await http.post(
      Uri.parse('http://localhost:5000/api/payments/mpesa'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"amount": 100}),
    );
    setState(() {
      isLoading = false;
    });
    if (response.statusCode != 200) {
      setState(() {
        errorMessage = 'M-Pesa payment failed.';
      });
    }
  }

  Future<void> initiatePaypalPayment() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    // Example: Call backend PayPal endpoint
    final response = await http.post(
      Uri.parse('http://localhost:5000/api/payments/paypal'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"amount": 100}),
    );
    setState(() {
      isLoading = false;
    });
    if (response.statusCode != 200) {
      setState(() {
        errorMessage = 'PayPal payment failed.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payments')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: initiateMpesaPayment,
              child: const Text('Pay with M-Pesa'),
            ),
            ElevatedButton(
              onPressed: initiatePaypalPayment,
              child: const Text('Pay with PayPal'),
            ),
            if (isLoading) const CircularProgressIndicator(),
            if (errorMessage != null)
              Text(errorMessage!, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
