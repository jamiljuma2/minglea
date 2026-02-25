import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'profile_verification_screen.dart';
import 'dart:io';

class OnboardingInterestsScreen extends StatelessWidget {
  final List<String> interests = [
    'Music',
    'Sports',
    'Travel',
    'Food',
    'Movies',
    'Art',
    'Fitness',
    'Gaming',
    'Reading',
    'Pets',
    'Nature',
    'Tech',
    'Fashion',
    'Dancing',
    'Photography'
  ];

  OnboardingInterestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> selected = [];
    return Scaffold(
      appBar: AppBar(title: const Text('Select Interests')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Choose your interests',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: interests.map((interest) {
                  return ChoiceChip(
                    label: Text(interest),
                    selected: selected.contains(interest),
                    onSelected: (bool value) {
                      if (value) {
                        selected.add(interest);
                      } else {
                        selected.remove(interest);
                      }
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OnboardingPhotosScreen(),
                  ),
                );
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPhotosScreen extends StatefulWidget {
  const OnboardingPhotosScreen({super.key});

  @override
  State<OnboardingPhotosScreen> createState() => _OnboardingPhotosScreenState();
}

class _OnboardingPhotosScreenState extends State<OnboardingPhotosScreen> {
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _images = [];

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null && _images.length < 3) {
      setState(() {
        _images.add(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Photos')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Upload your best photos',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ..._images.map((img) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: File(img.path).existsSync()
                          ? Image.file(
                              File(img.path),
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/placeholder1.jpg',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                    )),
                if (_images.length < 3)
                  IconButton(
                    icon: const Icon(Icons.add_a_photo,
                        size: 32, color: Colors.pink),
                    onPressed: _pickImage,
                  ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _images.isNotEmpty
                  ? () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileVerificationScreen(),
                        ),
                      );
                    }
                  : null,
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
