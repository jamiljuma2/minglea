import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
import 'subscription_screen.dart';
import 'match_screen.dart' as match;

class SwipeMatchScreen extends StatefulWidget {
  const SwipeMatchScreen({super.key});

  @override
  State<SwipeMatchScreen> createState() => _SwipeMatchScreenState();
}

class _SwipeMatchScreenState extends State<SwipeMatchScreen> {
  String sortOption = 'distance';
  bool onlineOnly = false;
  final List<String> sortOptions = ['distance', 'age', 'lastActive'];
  RangeValues ageRange = const RangeValues(18, 60);
  String? genderFilter;
  List<String> interestsFilter = [];
  final List<String> availableGenders = ['Male', 'Female', 'Other'];
  final List<String> availableInterests = [
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
  List<Map<String, dynamic>> candidates = [];
  int currentIndex = 0;
  bool isLoading = false;
  double searchRadius = 50; // km
  int swipeCount = 0;
  int swipeLimit = 20;

  Future<void> fetchCandidates() async {
    setState(() {
      isLoading = true;
    });
    // Replace with actual user location
    final lat = 0.0; // TODO: get from profile
    final lng = 0.0; // TODO: get from profile
    final apiUrl =
        'http://localhost:5000/api/nearby?lat=$lat&lng=$lng&radius=$searchRadius';
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final users = jsonDecode(response.body) as List;
      var filtered = users.map((u) => u as Map<String, dynamic>).toList();
      if (genderFilter != null) {
        filtered = filtered.where((u) => u['gender'] == genderFilter).toList();
      }
      if (interestsFilter.isNotEmpty) {
        filtered = filtered
            .where((u) =>
                u['interests'] != null &&
                interestsFilter
                    .any((i) => (u['interests'] as List).contains(i)))
            .toList();
      }
      filtered = filtered.where((u) {
        final age = u['age'] ?? 0;
        return age >= ageRange.start && age <= ageRange.end;
      }).toList();
      if (onlineOnly) {
        filtered = filtered.where((u) => u['online'] == true).toList();
      }
      if (sortOption == 'distance') {
        filtered
            .sort((a, b) => (a['distance'] ?? 0).compareTo(b['distance'] ?? 0));
      } else if (sortOption == 'age') {
        filtered.sort((a, b) => (a['age'] ?? 0).compareTo(b['age'] ?? 0));
      } else if (sortOption == 'lastActive') {
        filtered.sort((a, b) => DateTime.parse(b['lastActive'] ?? '')
            .compareTo(DateTime.parse(a['lastActive'] ?? '')));
      }
      setState(() {
        candidates = filtered;
        currentIndex = 0;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCandidates();
  }

  void swipe(bool liked) async {
    // Swipe limit logic (example: 20 for free, 100 for premium, 10000 for gold)
    if (swipeCount >= swipeLimit) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('🚫 Swipe Limit Reached'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('You have reached your daily swipe limit.'),
              const SizedBox(height: 8),
              const Text(
                  'Upgrade to Premium or Gold to get unlimited swipes, see who liked you, and unlock more features!'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  Icon(Icons.star, color: Colors.pink),
                  Icon(Icons.star, color: Colors.purple),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                showDialog(
                  context: context,
                  builder: (ctx2) => AlertDialog(
                    title: const Text('Premium Benefits'),
                    content: const Text(
                        'Premium and Gold plans offer unlimited swipes, priority matches, and exclusive features. Learn more in the subscription screen.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx2);
                        },
                        child: const Text('Back'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx2);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SubscriptionScreen()),
                          );
                        },
                        child: const Text('Upgrade'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Learn More'),
            ),
          ],
        ),
      );
      return;
    }
    setState(() {
      isLoading = true;
    });
    final candidate = candidates[currentIndex];
    final response = await http.post(
      Uri.parse('http://localhost:5000/api/swipe'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "candidateId": candidate['name'],
        "liked": liked,
      }),
    );
    setState(() {
      isLoading = false;
      swipeCount++;
      if (liked &&
          response.statusCode == 200 /* && response.body == 'match' */) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => match.MatchScreen(
              matchedUserId: candidate['name']!,
              matchedUserName: candidate['name']!,
            ),
          ),
        );
      } else if (currentIndex < candidates.length - 1) {
        currentIndex++;
      } else {
        // TODO: Fetch more candidates or show end of list
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget sortDropdown = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          const Text('Sort by:'),
          const SizedBox(width: 8),
          DropdownButton<String>(
            value: sortOption,
            items: sortOptions
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
            onChanged: (val) => setState(() {
              if (val != null) sortOption = val;
            }),
          ),
          const SizedBox(width: 16),
          Checkbox(
            value: onlineOnly,
            onChanged: (val) => setState(() {
              onlineOnly = val ?? false;
            }),
          ),
          const Text('Online only'),
        ],
      ),
    );
    // ...existing code...
    Widget ageFilterSlider = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          const Text('Age:'),
          Expanded(
            child: RangeSlider(
              values: ageRange,
              min: 18,
              max: 60,
              divisions: 42,
              labels: RangeLabels(
                '${ageRange.start.toInt()}',
                '${ageRange.end.toInt()}',
              ),
              onChanged: (val) {
                setState(() {
                  ageRange = val;
                });
              },
            ),
          ),
        ],
      ),
    );
    final candidate = candidates.isNotEmpty ? candidates[currentIndex] : null;
    return Scaffold(
      appBar: AppBar(title: const Text('Swipe & Match')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : candidates.isEmpty
              ? const Center(child: Text('No nearby users found.'))
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      sortDropdown,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            const Text('Distance:'),
                            Expanded(
                              child: Slider(
                                value: searchRadius,
                                min: 1,
                                max: 100,
                                divisions: 99,
                                label: '${searchRadius.toInt()} km',
                                onChanged: (val) {
                                  setState(() {
                                    searchRadius = val;
                                  });
                                },
                              ),
                            ),
                            ElevatedButton(
                              onPressed: fetchCandidates,
                              child: const Text('Refresh'),
                            ),
                          ],
                        ),
                      ),
                      ageFilterSlider,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            const Text('Gender:'),
                            const SizedBox(width: 8),
                            DropdownButton<String>(
                              value: genderFilter,
                              hint: const Text('Any'),
                              items: availableGenders
                                  .map((g) => DropdownMenuItem(
                                      value: g, child: Text(g)))
                                  .toList(),
                              onChanged: (val) =>
                                  setState(() => genderFilter = val),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Wrap(
                          spacing: 8,
                          children: availableInterests.map((interest) {
                            final selected = interestsFilter.contains(interest);
                            return FilterChip(
                              label: Text(interest),
                              selected: selected,
                              onSelected: (val) {
                                setState(() {
                                  if (val) {
                                    interestsFilter.add(interest);
                                  } else {
                                    interestsFilter.remove(interest);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      Card(
                        margin: const EdgeInsets.all(16),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              if (candidate?['photoUrl'] != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child: Image.network(
                                    candidate!['photoUrl'],
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              Text(candidate?['name'] ?? '',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text(candidate?['bio'] ?? ''),
                              const SizedBox(height: 8),
                              Text('Gender: ${candidate?['gender'] ?? ''}'),
                              if (candidate?['age'] != null)
                                Text('Age: ${candidate!['age']}'),
                              if (candidate?['distance'] != null)
                                Text(
                                    'Distance: ${candidate!['distance'].toStringAsFixed(1)} km'),
                              if (candidate?['online'] == true)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.circle,
                                        color: Colors.green, size: 16),
                                    const SizedBox(width: 4),
                                    const Text('Online'),
                                  ],
                                ),
                              if (candidate?['lastActive'] != null)
                                Text(
                                    'Last active: ${candidate!['lastActive']}'),
                              if (candidate?['interests'] != null)
                                Wrap(
                                  spacing: 6,
                                  children: (candidate!['interests'] as List)
                                      .map<Widget>((i) => Chip(label: Text(i)))
                                      .toList(),
                                ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () => swipe(false),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey),
                            child: const Text('Pass'),
                          ),
                          const SizedBox(width: 24),
                          ElevatedButton(
                            onPressed: () => swipe(true),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pink),
                            child: const Text('Like'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }
}
