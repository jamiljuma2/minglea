import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  String? currentPlan;
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchSubscription() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(
        Uri.parse('https://minglea.onrender.com/api/subscription'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          currentPlan = data['plan'];
        });
      } else {
        setState(() {
          errorMessage = 'Failed to fetch subscription.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateSubscription(String plan) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      if (plan == 'premium' || plan == 'gold') {
        // Initiate payment before updating subscription
        final paymentResponse = await http.post(
          Uri.parse('https://minglea.onrender.com/api/payments/subscribe'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'plan': plan}),
        );
        if (paymentResponse.statusCode != 200) {
          setState(() {
            errorMessage = 'Payment failed.';
            isLoading = false;
          });
          return;
        }
      }
      final response = await http.post(
        Uri.parse('https://minglea.onrender.com/api/subscription'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'plan': plan}),
      );
      if (response.statusCode == 200) {
        setState(() {
          currentPlan = plan;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to update subscription.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSubscription();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subscription Plans')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading) const CircularProgressIndicator(),
            if (errorMessage != null)
              Text(errorMessage!, style: const TextStyle(color: Colors.red)),
            if (!isLoading)
              Column(
                children: [
                  Text('Current Plan: ${currentPlan ?? 'Free'}',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 24),
                  Card(
                    child: ListTile(
                      title: const Text('Free Plan'),
                      subtitle: const Text(
                          '• 20 swipes/day\n• Blurred likes\n• Basic features'),
                      trailing: ElevatedButton(
                        onPressed: () => updateSubscription('free'),
                        child: const Text('Select'),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: const Text('Premium Plan'),
                      subtitle: const Text(
                          '• 100 swipes/day\n• See who liked you\n• Boost profile'),
                      trailing: ElevatedButton(
                        onPressed: () => updateSubscription('premium'),
                        child: const Text('Upgrade'),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: const Text('Gold Plan'),
                      subtitle: const Text(
                          '• Unlimited swipes\n• Super likes\n• Priority support'),
                      trailing: ElevatedButton(
                        onPressed: () => updateSubscription('gold'),
                        child: const Text('Upgrade'),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
