// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cv_01/skill.dart';
import 'package:cv_01/project.dart';
import 'package:cv_01/language.dart';
import 'package:cv_01/experience.dart';

void main() => runApp(const ProfessionalCV());

class ProfessionalCV extends StatelessWidget {
  const ProfessionalCV({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: const Color(0xFF00D2FF),
      ),
      home: const MainSlider(),
    );
  }
}

class MainSlider extends StatefulWidget {
  const MainSlider({super.key});

  @override
  State<MainSlider> createState() => _MainSliderState();
}

class _MainSliderState extends State<MainSlider> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      body: PageView(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        children: [
          HeroPage(controller: _pageController),
          const SkillPage(),
          const ProjectPage(),
          const LanguagePage(),
          const ExperiencePage(),
        ],
      ),
    );
  }
}

class HeroPage extends StatefulWidget {
  final PageController controller;
  const HeroPage({super.key, required this.controller});

  @override
  State<HeroPage> createState() => _HeroPageState();
}

class _HeroPageState extends State<HeroPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint("Could not launch $urlString");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 120),

                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, 20 * _animationController.value),
                        child: child,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00D2FF).withOpacity(0.4),
                            blurRadius: 30,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 75,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 72,
                          backgroundImage: AssetImage('assets/1.jpg'),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                  const Text(
                    "CHHIT CHANTOLA",
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "NETWORK ENGINEER",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 244, 248, 249),
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _contactIcon(
                        Icons.email,
                        "chittola9@gmail.com",
                        const Color.fromARGB(255, 248, 247, 247),
                      ),

                      _contactIcon(
                        Icons.map,
                        "https://maps.app.goo.gl/6kHhEa5m4UhTD3Tc6",
                        Colors.greenAccent,
                      ),
                      _contactIcon(
                        Icons.code,
                        "https://github.com/Tolasmos",
                        Colors.white,
                      ),

                      _contactIcon(
                        Icons.facebook,
                        "https://web.facebook.com/chhit.chantola",
                        const Color(0xFF1877F2),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                  _buildAboutMeBox(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Wrap(
              alignment: WrapAlignment.end,
              spacing: 10,
              runSpacing: 10,
              children: [
                _navBtn("SKILLS", 1),
                _navBtn("PROJECTS", 2),
                _navBtn("LANGUAGES", 3),
                _navBtn("EXPERIENCE", 4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutMeBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: const Column(
          children: [
            Text(
              "ABOUT ME",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 241, 241, 241),
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 15),
            Text(
              "I’m 21 years old and currently in my fourth year at the Institute of Technology of Cambodia (ITC). I am kind, helpful, and punctual. I enjoy working with others but am also capable of handling tasks independently. I like setting goals and putting in my best effort to achieve them. I stay organized, plan ahead, and manage my time effectively to accomplish my tasks efficiently.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white70,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navBtn(String label, int index) {
    return OutlinedButton(
      onPressed: () => widget.controller.animateToPage(
        index,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Color(0xFF00D2FF)),
      ),
      child: Text(label),
    );
  }

  Widget _contactIcon(IconData icon, String url, Color iconColor) {
    return IconButton(
      onPressed: () => _launchURL(url),
      icon: Icon(icon, color: iconColor, size: 28),
    );
  }
}
