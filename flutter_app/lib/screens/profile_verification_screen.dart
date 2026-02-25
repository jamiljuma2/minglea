import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileVerificationScreen extends StatelessWidget {
  const ProfileVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _ProfileVerificationScreenBody();
  }
}

class _ProfileVerificationScreenBody extends StatefulWidget {
  @override
  State<_ProfileVerificationScreenBody> createState() =>
      _ProfileVerificationScreenBodyState();
}

class _ProfileVerificationScreenBodyState
    extends State<_ProfileVerificationScreenBody> {
  bool _instagramVerified = false;
  bool _facebookVerified = false;

  Future<void> _fetchVerificationStatus() async {
    final apiUrl = 'https://minglea.onrender.com/api/profile';
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final profile = jsonDecode(response.body);
      setState(() {
        _instagramVerified = profile['instagramVerified'] == true;
        _facebookVerified = profile['facebookVerified'] == true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchVerificationStatus();
  }

  Future<void> _sendSelfieUrlToBackend(String url) async {
    // Replace with your backend API endpoint
    final apiUrl = 'https://minglea.onrender.com/api/profile';
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'selfieUrl': url}),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selfie URL saved to profile!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to save selfie URL: ${response.body}')));
    }
  }

  bool _uploading = false;
  String? _uploadedUrl;
  XFile? _selfie;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickSelfie() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        _selfie = picked;
      });
    }
  }

  Future<void> _uploadSelfie() async {
    if (_selfie == null) return;
    setState(() {
      _uploading = true;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      final ref = FirebaseStorage.instance.ref().child(
          'selfies/${user?.uid ?? 'anonymous'}_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(File(_selfie!.path));
      final url = await ref.getDownloadURL();
      setState(() {
        _uploadedUrl = url;
        _uploading = false;
      });
      await _sendSelfieUrlToBackend(url);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selfie uploaded to Firebase!')));
    } catch (e) {
      setState(() {
        _uploading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Upload failed: $e')));
    }
  }

  void _showOAuthDialog(String platform) {
    // Placeholder for real OAuth
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Connect $platform'),
        content: Text('Redirecting to $platform OAuth...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    // TODO: Implement real OAuth using flutter_web_auth or social auth packages
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Verification')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Verify Your Profile',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                if (_instagramVerified || _facebookVerified)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Icon(Icons.verified, color: Colors.blue, size: 28),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
                'To increase trust and get more matches, verify your profile by uploading a selfie or connecting your social accounts.'),
            const SizedBox(height: 24),
            if (_selfie != null)
              Column(
                children: [
                  Image.file(
                    File(_selfie!.path),
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 12),
                  if (_uploadedUrl != null) Text('Selfie uploaded!'),
                  if (_uploading) const CircularProgressIndicator(),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.cloud_upload),
                    label: const Text('Upload to Firebase'),
                    onPressed: _uploading ? null : _uploadSelfie,
                  ),
                ],
              ),
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text('Take Selfie'),
              onPressed: _pickSelfie,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.link),
              label: const Text('Connect Instagram'),
              onPressed: () => _showOAuthDialog('Instagram'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.link),
              label: const Text('Connect Facebook'),
              onPressed: () => _showOAuthDialog('Facebook'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Skip for Now'),
            ),
          ],
        ),
      ),
    );
  }
// ...existing code...
}
