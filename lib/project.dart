// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectPage extends StatelessWidget {
  const ProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The main background container with the 3-color gradient
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F2027), // Darkest Teal
              Color(0xFF203A43), // Mid Blue
              Color(0xFF2C5364), // Lighter Grey-Blue
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // PAGE TITLE
                const Text(
                  "MY PROJECTS",
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

                // PROJECT LIST
                _ProjectCard(
                  title: "Product-Shop-App",
                  desc: "Full-stack shop app with Stripe payment integration.",
                  tags: const ["Flutter", "Firebase", "Stripe"],
                  url: "https://tolasmos.github.io/grt_aa/",
                ),

                _ProjectCard(
                  title: "CV-PORTFOLIO-WEBSITE",
                  desc: "A sleek, responsive portfolio built with Flutter Web.",
                  tags: const ["Flutter Web", "UI/UX", "Animations"],
                  url: "https://your-portfolio-link.com",
                ),

                _ProjectCard(
                  title: "TOLA-ChatAPP",
                  desc:
                      "Messaging app with OpenAI integration and voice-to-text.",
                  tags: const ["OpenAI", "Dart", "WebSockets"],
                  url: "https://github.com/your-username/tola-chat",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// REUSABLE PROJECT CARD COMPONENT
class _ProjectCard extends StatefulWidget {
  final String title;
  final String desc;
  final List<String> tags;
  final String url;

  const _ProjectCard({
    required this.title,
    required this.desc,
    required this.tags,
    required this.url,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool isHovered = false; // Tracks if mouse is over the card

  Future<void> _launchURL() async {
    final Uri uri = Uri.parse(widget.url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint("Could not launch $uri");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _launchURL,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          // MOVE EFFECT: Translates the card -8px on the Y-axis when hovered
          transform: isHovered
              ? (Matrix4.identity()..translate(0, -8, 0))
              : Matrix4.identity(),
          width: 600,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(isHovered ? 0.12 : 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isHovered ? const Color(0xFF00D2FF) : Colors.white12,
              width: 1.5,
            ),
            boxShadow: [
              if (isHovered)
                BoxShadow(
                  color: const Color(0xFF00D2FF).withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                // ICON BOX
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00D2FF).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.rocket_launch,
                    color: Color(0xFF00D2FF),
                    size: 30,
                  ),
                ),
                const SizedBox(width: 20),

                // TEXT SECTION
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.desc,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 15),
                      // TAGS
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.tags
                            .map((tag) => _buildChip(tag))
                            .toList(),
                      ),
                    ],
                  ),
                ),

                // EXTERNAL LINK ICON
                Icon(
                  Icons.open_in_new,
                  color: isHovered ? const Color(0xFF00D2FF) : Colors.white24,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // HELPER WIDGET FOR TAGS
  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF00D2FF).withOpacity(0.05),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: const Color(0xFF00D2FF).withOpacity(0.2)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF00D2FF),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
