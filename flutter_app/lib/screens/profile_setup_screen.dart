import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'subscription_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  Position? _position;
  bool _locating = false;
  String? _locationError;

  Future<void> _getLocation() async {
    setState(() {
      _locating = true;
      _locationError = null;
    });
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationError = 'Location services are disabled.';
          _locating = false;
        });
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationError = 'Location permission denied.';
            _locating = false;
          });
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationError = 'Location permission permanently denied.';
          _locating = false;
        });
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _position = pos;
        _locating = false;
      });
    } catch (e) {
      setState(() {
        _locationError = e.toString();
        _locating = false;
      });
    }
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  String? gender;
  bool isLoading = false;
  String? errorMessage;

  Future<void> saveProfile() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final apiUrl = 'https://minglea.onrender.com/api/profile';
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      final body = {
        'name': nameController.text,
        'bio': bioController.text,
        'gender': gender,
        if (_position != null) ...{
          'latitude': _position!.latitude,
          'longitude': _position!.longitude,
        }
      };
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SubscriptionScreen()),
        );
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to save profile: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Setup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: bioController,
              decoration: const InputDecoration(labelText: 'Bio'),
            ),
            DropdownButton<String>(
              value: gender,
              hint: const Text('Select Gender'),
              items: ['Male', 'Female', 'Other']
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              onChanged: (val) => setState(() => gender = val),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.location_on),
                  label: const Text('Set Location'),
                  onPressed: _locating ? null : _getLocation,
                ),
                if (_position != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                        'Lat: ${_position!.latitude}, Lng: ${_position!.longitude}'),
                  ),
              ],
            ),
            if (_locationError != null)
              Text(_locationError!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            if (errorMessage != null)
              Text(errorMessage!, style: const TextStyle(color: Colors.red)),
            if (isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: saveProfile,
                child: const Text('Save Profile'),
              ),
          ],
        ),
      ),
    );
  }
}
