// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ExperiencePage(),
    );
  }
}

class Experience {
  final String title;
  final String company;
  final String duration;
  final IconData icon;
  final List<String> skills;
  final String description;

  Experience({
    required this.title,
    required this.company,
    required this.duration,
    required this.icon,
    required this.skills,
    required this.description,
  });
}

class ExperiencePage extends StatefulWidget {
  const ExperiencePage({super.key});

  @override
  State<ExperiencePage> createState() => _ExperiencePageState();
}

class _ExperiencePageState extends State<ExperiencePage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  double _scrollPercent = 0.0;

  static const Color bgDark = Color(0xFF0F2027);
  static const Color accentCyan = Color.fromARGB(255, 27, 184, 219);
  static const Color glassWhite = Color(0x0DFFFFFF);
  static const Color glassBorder = Color(0x1AFFFFFF);
  static const Color textSecondary = Color(0x99FFFFFF);

  late final List<Experience> experiences;

  @override
  void initState() {
    super.initState();

    // ===== YOUR EXPERIENCE DATA =====
    experiences = [
      Experience(
        title: "Cashier",
        company: "Restaurant JE MAV BAY CHA (BTB)",
        duration: "—",
        icon: Icons.store,
        skills: ["Customer Service", "Cash Handling", "Communication"],
        description:
            "Worked as a cashier, responsible for handling customer orders, "
            "managing payments, and ensuring smooth daily transactions.",
      ),
      Experience(
        title: "Delivery",
        company: "NTSPORT ONLINE / GIGI",
        duration: "2023 - 2024",
        icon: Icons.delivery_dining,
        skills: ["Delivery", "Time Management", "Navigation"],
        description:
            "Delivered online orders accurately and on time while maintaining "
            "good customer communication and service quality.",
      ),
      Experience(
        title: "Student / Volunteer",
        company: "Institute of Technology of Cambodia (ITC)",
        duration: "2025",
        icon: Icons.school,
        skills: ["Media", "Teamwork", "System Analysis", "Flutter", "Database"],
        description:
            "Volunteer Media for GTR Charity 2nd Event and participated in "
            "department field trips. Developed academic projects including "
            "Library System Management and Clothes Information Management System.",
      ),
    ];

    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        setState(() {
          _scrollPercent =
              (_scrollController.offset /
                      _scrollController.position.maxScrollExtent)
                  .clamp(0.0, 1.0);
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      body: Stack(
        children: [
          Positioned(
            top: 120 - _scrollPercent * 40,
            left: -80,
            child: _glowOrb(0.12),
          ),
          Positioned(
            bottom: 120 + _scrollPercent * 40,
            right: -80,
            child: _glowOrb(0.08),
          ),
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _header()),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => TimelineItem(
                    experience: experiences[index],
                    index: index,
                    scrollPercent: _scrollPercent,
                  ),
                  childCount: experiences.length,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _glowOrb(double baseOpacity) {
    return Container(
      width: 320,
      height: 320,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: accentCyan.withOpacity(baseOpacity + _scrollPercent * 0.05),
        boxShadow: [
          BoxShadow(
            color: accentCyan.withOpacity(0.15),
            blurRadius: 120,
            spreadRadius: 60,
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Column(
      children: [
        const SizedBox(height: 90),
        const Text(
          "EXPERIENCE",
          style: TextStyle(
            fontSize: 32,
            letterSpacing: 8,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 14),
        Container(
          height: 3,
          width: 60,
          decoration: BoxDecoration(
            color: accentCyan,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 60),
      ],
    );
  }
}

class TimelineItem extends StatefulWidget {
  final Experience experience;
  final int index;
  final double scrollPercent;

  const TimelineItem({
    super.key,
    required this.experience,
    required this.index,
    required this.scrollPercent,
  });

  @override
  State<TimelineItem> createState() => _TimelineItemState();
}

class _TimelineItemState extends State<TimelineItem>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      lowerBound: 0.9,
      upperBound: 1.1,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visible = widget.scrollPercent >= widget.index / 3 * 0.8;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 600 + widget.index * 120),
        opacity: visible ? 1 : 0,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 600 + widget.index * 120),
          transform: Matrix4.translationValues(0, visible ? 0 : 40, 0),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    ScaleTransition(
                      scale: _pulseController,
                      child: _icon(widget.experience.icon),
                    ),
                    Expanded(child: _line()),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(child: _glassCard(widget.experience)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _icon(IconData icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: _ExperiencePageState.accentCyan, width: 2),
      ),
      child: Icon(icon, color: _ExperiencePageState.accentCyan, size: 20),
    );
  }

  Widget _line() {
    return Container(
      width: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _ExperiencePageState.accentCyan,
            _ExperiencePageState.accentCyan.withOpacity(0),
          ],
        ),
      ),
    );
  }

  Widget _glassCard(Experience exp) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _ExperiencePageState.glassWhite,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: _ExperiencePageState.glassBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exp.duration,
                  style: const TextStyle(
                    color: _ExperiencePageState.accentCyan,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  exp.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  exp.company,
                  style: const TextStyle(
                    color: _ExperiencePageState.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: exp.skills.map((s) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _ExperiencePageState.accentCyan.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        s,
                        style: const TextStyle(
                          color: _ExperiencePageState.accentCyan,
                          fontSize: 10,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                Text(
                  exp.description,
                  style: TextStyle(
                    color: _ExperiencePageState.textSecondary.withOpacity(0.8),
                    height: 1.5,
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => _expanded = !_expanded),
                  child: Text(
                    _expanded ? "View Less" : "View More",
                    style: const TextStyle(
                      color: _ExperiencePageState.accentCyan,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
