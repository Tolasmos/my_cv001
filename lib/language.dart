// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  late AnimationController blobController;

  final List<Map<String, dynamic>> languages = [
    // {
    //   'label': 'ENGLISH',
    //   'value': 0.95,
    //   'color': Colors.cyanAccent,
    //   'gradient': [Colors.cyan, Colors.blueAccent],
    //   'desc':
    //       'Professional working proficiency with a focus on technical documentation.',
    //   'flag': '🇬🇧',
    // },
    {
      'label': 'KHMER',
      'value': 0.99,
      'color': const Color.fromARGB(255, 246, 244, 242),
      'gradient': [Colors.orangeAccent, Colors.redAccent],
      'desc':
          'Native fluency. High proficiency in both written and verbal communication.',
      'flag': '🇰🇭',
    },
    {
      'label': 'ENGLISH',
      'value': 0.70,
      'color': const Color.fromARGB(255, 245, 248, 248),
      'gradient': [Colors.cyan, Colors.blueAccent],
      'desc':
          'Professional working proficiency with a focus on technical documentation.',
      'flag': '🇬🇧',
    },
    {
      'label': 'FRENCH',
      'value': 0.60,
      'color': const Color.fromARGB(255, 243, 240, 244),
      'gradient': [Colors.purpleAccent, Colors.deepPurple],
      'desc':
          'Conversational level. Capable of handling daily tasks and basic reading.',
      'flag': '🇫🇷',
    },
  ];

  @override
  void initState() {
    super.initState();
    blobController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    blobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentLang = languages[selectedIndex];
    final activeColor = currentLang['color'] as Color;

    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      body: Stack(
        children: [
          // PARALLAX GLASS BLOBS
          AnimatedBuilder(
            animation: blobController,
            builder: (_, __) {
              return Stack(
                children: [
                  _GlassBlob(
                    x: 80 + blobController.value * 120,
                    y: 120,
                    size: 260,
                    color: activeColor,
                  ),
                  _GlassBlob(
                    x: 280,
                    y: 420 + blobController.value * 140,
                    size: 220,
                    color: activeColor.withOpacity(0.7),
                  ),
                ],
              );
            },
          ),

          // CONTENT
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 80),
                _buildHeader(activeColor),
                const SizedBox(height: 40),
                _buildSelectorRow(),
                const SizedBox(height: 50),
                _buildDetailsCard(currentLang),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Color color) {
    return Column(
      children: [
        const Text(
          "LANGUAGES",
          style: TextStyle(
            fontSize: 40,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Container(
          height: 4,
          width: 60,
          decoration: BoxDecoration(
            color: const Color(0xFF00D2FF),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildSelectorRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: languages.asMap().entries.map((entry) {
        int index = entry.key;
        var lang = entry.value;
        bool isSelected = selectedIndex == index;

        return _MagneticWrapper(
          onTap: () => setState(() => selectedIndex = index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.elasticOut,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.all(15),
            height: isSelected ? 130 : 110,
            width: isSelected ? 100 : 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: isSelected
                  ? LinearGradient(
                      colors: lang['gradient'],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isSelected
                  ? Colors.transparent
                  : Colors.white.withOpacity(0.04),
              border: Border.all(
                color: isSelected
                    ? Colors.white.withOpacity(0.5)
                    : lang['color'].withOpacity(0.2),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCircularProgress(
                  lang['value'],
                  isSelected,
                  lang['color'],
                ),
                const SizedBox(height: 10),
                Text(
                  lang['label'],
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.white38,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCircularProgress(double value, bool isSelected, Color color) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: const Duration(milliseconds: 1400),
      builder: (_, val, __) => Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 45,
            width: 45,
            child: CircularProgressIndicator(
              value: val,
              strokeWidth: 4,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation(
                isSelected ? Colors.white : color,
              ),
            ),
          ),
          Text(
            '${(val * 100).toInt()}%',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: isSelected ? Colors.white : color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(Map<String, dynamic> lang) {
    final color = lang['color'] as Color;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: Container(
        key: ValueKey(lang['label']),
        width: 340,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 35),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 15, 58, 76).withOpacity(0.85),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: color.withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: color.withOpacity(0.1),
              child: Text(lang['flag'], style: const TextStyle(fontSize: 32)),
            ),
            const SizedBox(height: 20),
            Text(
              lang['label'],
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              lang['desc'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------ GLASS BLOB ------------------
class _GlassBlob extends StatelessWidget {
  final double x, y, size;
  final Color color;

  const _GlassBlob({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
          child: Container(
            width: size,
            height: size,
            color: color.withOpacity(0.12),
          ),
        ),
      ),
    );
  }
}

// ------------------ MAGNETIC WRAPPER ------------------
class _MagneticWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _MagneticWrapper({required this.child, required this.onTap});

  @override
  State<_MagneticWrapper> createState() => _MagneticWrapperState();
}

class _MagneticWrapperState extends State<_MagneticWrapper> {
  double rx = 0;
  double ry = 0;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (e) {
        final s = context.size!;
        final dx = (e.localPosition.dx - s.width / 2) / s.width;
        final dy = (e.localPosition.dy - s.height / 2) / s.height;
        setState(() {
          rx = dy * 0.35;
          ry = dx * -0.35;
        });
      },
      onExit: (_) => setState(() {
        rx = 0;
        ry = 0;
      }),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(rx)
            ..rotateY(ry),
          child: widget.child,
        ),
      ),
    );
  }
}
