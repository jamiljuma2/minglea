import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'dart:math' as math;

class MatchScreen extends StatelessWidget {
  final String matchedUserId;
  final String matchedUserName;
  const MatchScreen(
      {Key? key, required this.matchedUserId, required this.matchedUserName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('It’s a Match!')),
      body: Stack(
        children: [
          // Confetti animation (simple burst)
          Positioned.fill(
            child: AnimatedMatchConfetti(),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedAvatar(),
                const SizedBox(height: 24),
                Text('You matched with $matchedUserName!',
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink)),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          peerId: matchedUserId,
                          peerName: matchedUserName,
                        ),
                      ),
                    );
                  },
                  child: const Text('Start Chat',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedMatchConfetti extends StatefulWidget {
  @override
  State<AnimatedMatchConfetti> createState() => _AnimatedMatchConfettiState();
}

class _AnimatedMatchConfettiState extends State<AnimatedMatchConfetti>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ConfettiPainter(_controller.value),
          child: Container(),
        );
      },
    );
  }
}

class ConfettiPainter extends CustomPainter {
  final double progress;
  ConfettiPainter(this.progress);
  @override
  void paint(Canvas canvas, Size size) {
    final colors = [
      Colors.pink,
      Colors.purple,
      Colors.amber,
      Colors.blue,
      Colors.green
    ];
    final center = Offset(size.width / 2, size.height / 2);
    for (int i = 0; i < 30; i++) {
      final angle = i * 2 * 3.14159 / 30;
      final radius = progress * 200;
      final offset = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      final paint = Paint()..color = colors[i % colors.length];
      canvas.drawCircle(offset, 8 * (1 - progress), paint);
    }
  }

  @override
  bool shouldRepaint(covariant ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
// Remove extra closing brace
}

class AnimatedAvatar extends StatefulWidget {
  const AnimatedAvatar({Key? key}) : super(key: key);

  @override
  State<AnimatedAvatar> createState() => _AnimatedAvatarState();
}

class _AnimatedAvatarState extends State<AnimatedAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.8, end: 1.2)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: CircleAvatar(
        radius: 48,
        backgroundImage: AssetImage('assets/images/placeholder1.jpg'),
      ),
    );
  }
}
