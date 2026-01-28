// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:math';
import 'dart:ui';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: SkillPage()),
    ),
  );
}

class SkillPage extends StatefulWidget {
  const SkillPage({super.key});

  @override
  State<SkillPage> createState() => _SkillPageState();
}

class _SkillPageState extends State<SkillPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _mainController;
  final Random _rand = Random();

  static const Color accentCyan = Color(0xFF00D2FF);
  static const List<Color> bgGradient = [
    Color(0xFF0F2027),
    Color(0xFF203A43),
    Color(0xFF2C5364),
  ];

  final List<Map<String, dynamic>> skills = const [
    {
      "name": "Networking",
      "image": "assets/Network.png",
      "level": 0.60,
      "desc": "Design and manage robust network infrastructures.",
    },
    {
      "name": "Flutter",
      "image": "assets/Flutter.png",
      "level": 0.65,
      "desc": "Building dynamic and interactive web experiences.",
    },
    {
      "name": "Teamwork",
      "image": "assets/Teamwork.jpg",
      "level": 0.95,
      "desc": "Collaborating efficiently in agile environments.",
    },
  ];

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _mainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    int crossAxisCount = size.width > 1000 ? 3 : (size.width > 600 ? 2 : 1);

    return Scaffold(
      body: Stack(
        children: [
          // 1. Animated Gradient Layer
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: bgGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // 2. Floating Ambient Particles
          ...List.generate(20, (index) => _buildAmbientParticle(index, size)),

          // 3. Content Layer
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverHeader(),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 24,
                    crossAxisSpacing: 24,
                    childAspectRatio: 0.85,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _SkillCard(
                      skill: skills[index],
                      index: index,
                      animation: _mainController,
                    ),
                    childCount: skills.length,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSliverHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 80, 30, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "MY SKILLS",
              style: TextStyle(
                fontSize: 40,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),

            // DECORATIVE UNDERLINE
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
        ),
      ),
    );
  }

  Widget _buildAmbientParticle(int index, Size screen) {
    double pSize = _rand.nextDouble() * 50 + 10;
    double xPos = _rand.nextDouble() * screen.width;
    double yPos = _rand.nextDouble() * screen.height;

    return AnimatedBuilder(
      animation: _mainController,
      builder: (context, child) {
        double t = _mainController.value * 2 * pi;
        return Positioned(
          left: xPos + sin(t + index) * 40,
          top: yPos + cos(t + index) * 40,
          child: Container(
            width: pSize,
            height: pSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accentCyan.withOpacity(0.05),
            ),
          ),
        );
      },
    );
  }
}

class _SkillCard extends StatelessWidget {
  final Map<String, dynamic> skill;
  final int index;
  final Animation<double> animation;

  const _SkillCard({
    required this.skill,
    required this.index,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        double offset = sin(animation.value * 2 * pi + index) * 8;
        return Transform.translate(offset: Offset(0, offset), child: child);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1.5,
              ),
            ),
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SkillDetailPage(skill: skill),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: skill['name'],
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF00D2FF).withOpacity(0.2),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        skill['image'],
                        fit: BoxFit.contain,
                        errorBuilder: (c, e, s) => const Icon(
                          Icons.bolt,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    skill['name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  CircularPercentIndicator(
                    radius: 30.0,
                    lineWidth: 5.0,
                    percent: skill['level'],
                    center: Text(
                      "${(skill['level'] * 100).toInt()}%",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    progressColor: const Color(0xFF00D2FF),
                    backgroundColor: Colors.white10,
                    circularStrokeCap: CircularStrokeCap.round,
                    animation: true,
                    animationDuration: 1500,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SkillDetailPage extends StatelessWidget {
  final Map<String, dynamic> skill;
  const SkillDetailPage({super.key, required this.skill});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      body: Stack(
        children: [
          Positioned(
            top: 60,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Hero(
                    tag: skill['name'],
                    child: Image.asset(
                      skill['image'],
                      height: 180,
                      errorBuilder: (c, e, s) =>
                          const Icon(Icons.bolt, size: 100, color: Colors.cyan),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    skill['name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    skill['desc'] ?? "Advanced level proficiency.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 40),
                  CircularPercentIndicator(
                    radius: 80.0,
                    lineWidth: 10.0,
                    percent: skill['level'],
                    center: Text(
                      "${(skill['level'] * 100).toInt()}%",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    progressColor: const Color(0xFF00D2FF),
                    backgroundColor: Colors.white10,
                    animation: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
