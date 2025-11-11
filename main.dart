import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pomodoro_screen.dart';
import 'ai_insights_screen.dart';
import 'smart_task_board_screen.dart';
import 'smart_calendar_screen.dart';
import 'mind_sync_assistant_screen.dart';
import 'achievement_garden_screen.dart';

void main() {
  runApp(const FocusFlowApp());
}

class FocusFlowApp extends StatelessWidget {
  const FocusFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FocusFlow',
      theme: ThemeData(
        primaryColor: const Color(0xFFE11584), // Rani Pink
        scaffoldBackgroundColor: const Color(0xFFFFF8F0), // Cream
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE11584),
          primary: const Color(0xFFE11584), // Rani Pink
          secondary: const Color(0xFF98D8C8), // Mint
          tertiary: const Color(0xFFFFB347), // Peach
          surface: const Color(0xFFFFF8F0), // Cream
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 8,
          shadowColor: Colors.black.withValues(alpha: 26),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        textTheme: GoogleFonts.poppinsTextTheme().copyWith(
          headlineSmall: GoogleFonts.poppins(
            color: const Color(0xFFE11584),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          bodyLarge: GoogleFonts.poppins(
            color: const Color(0xFF333333),
            fontSize: 16,
          ),
          bodyMedium: GoogleFonts.poppins(
            color: const Color(0xFF666666),
            fontSize: 14,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE11584),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 6,
            shadowColor: Colors.black.withValues(alpha: 51),
          ),
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).colorScheme.secondary.withValues(alpha: 26),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isWide = constraints.maxWidth > 600;
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(24),
  gradient: const LinearGradient(
    colors: [Colors.pinkAccent, Colors.pink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
),


                          child: Column(
                            children: [
                              Icon(
                                Icons.self_improvement,
                                size: isWide ? 120 : 100,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Welcome to FocusFlow',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontSize: isWide ? 48 : 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Your AI-powered productivity companion',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.grey[600],
                                      fontSize: isWide ? 20 : 16,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 48),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const DashboardScreen()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 8,
                                  shadowColor: Theme.of(context).primaryColor.withValues(alpha: 77),
                                ),
                                child: const Text('Get Started'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Timer? _inactivityTimer;
  static const int _inactivityDuration = 5 * 60; // 5 minutes in seconds
  int _inactivityCounter = 0;
  String _currentMood = '😊 Focused';
  String _currentSuggestion = '';

  @override
  void initState() {
    super.initState();
    _startInactivityTimer();
  }

  void _startInactivityTimer() {
    _inactivityTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _inactivityCounter++;
        if (_inactivityCounter >= _inactivityDuration) {
          _showFocusDropAlert();
          _inactivityCounter = 0; // Reset for next alert
        }
      });
    });
  }

  void _resetInactivityTimer() {
    setState(() {
      _inactivityCounter = 0;
    });
  }

  void _showFocusDropAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Focus Drop Detected'),
        content: const Text('No activity detected for 5 minutes. Take a break or refocus!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showMoodDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How are you feeling?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('😊 Focused'),
              onTap: () {
                setState(() {
                  _currentMood = '😊 Focused';
                  _currentSuggestion = 'Great! Keep up the momentum. Try a quick stretch in 10 minutes.';
                });
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('😟 Distracted'),
              onTap: () {
                setState(() {
                  _currentMood = '😟 Distracted';
                  _currentSuggestion = 'Take a 5-minute walk or listen to calming music to refocus.';
                });
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('😰 Stressed'),
              onTap: () {
                setState(() {
                  _currentMood = '😰 Stressed';
                  _currentSuggestion = 'Practice deep breathing: Inhale for 4 seconds, hold for 4, exhale for 4.';
                });
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('😴 Tired'),
              onTap: () {
                setState(() {
                  _currentMood = '😴 Tired';
                  _currentSuggestion = 'Hydrate and take a power nap. Schedule a break now.';
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }



  @override
  void dispose() {
    _inactivityTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _resetInactivityTimer,
      onPanUpdate: (details) => _resetInactivityTimer(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Personalized Greeting
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Text('🌸', style: TextStyle(fontSize: 32)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good morning, User!',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const Text('"Every small step counts towards your goals."'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Focus Analytics Panel
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('📊 Focus Analytics'),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStat('Score', '85%'),
                          _buildStat('Streak', '7 🔥'),
                          _buildStat('Trend', '↗️'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // AI Insights Widget
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('🧠 AI Insights'),
                      const SizedBox(height: 8),
                      const Text('Predicted focus dip at 2 PM. Suggested break now.'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Smart Task Board
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('✅ Smart Task Board'),
                      const SizedBox(height: 8),
                      const Text('Tasks from integrated tools will appear here.'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Pomodoro Tracker
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('⏱️ Pomodoro Tracker'),
                      const SizedBox(height: 8),
                      const Text('25:00 - Focus Session'),
                      LinearProgressIndicator(
                        value: 0.6,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PomodoroScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Start Pomodoro'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Smart Calendar
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('🗓️ Smart Calendar'),
                      const SizedBox(height: 8),
                      const Text('AI-optimized schedule preview.'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // MindSync Assistant
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('💬 MindSync Assistant'),
                      const SizedBox(height: 8),
                      const Text('How can I help you stay focused today?'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Mood Meter
              Card(
                child: InkWell(
                  onTap: _showMoodDialog,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('🎨 Mood Meter'),
                        const SizedBox(height: 8),
                        Text('Current mood: $_currentMood'),
                        if (_currentSuggestion.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            'AI Suggestion: $_currentSuggestion',
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ],
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _showMoodDialog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Log Mood'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Achievement Garden
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('🌿 Achievement Garden'),
                      const SizedBox(height: 8),
                      const Text('Your productivity garden is growing! 🌱'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Adaptive Alerts
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('🔔 Adaptive Alerts'),
                      const SizedBox(height: 8),
                      const Text('Next reminder: Break time in 5 minutes.'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Explore Features Section
              Text(
                'Explore Features',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  FeatureCard(
                    title: 'Pomodoro',
                    icon: Icons.timer,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PomodoroScreen())),
                  ),
                  FeatureCard(
                    title: 'AI Insights',
                    icon: Icons.lightbulb,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AIInsightsScreen())),
                  ),
                  FeatureCard(
                    title: 'Smart Task Board',
                    icon: Icons.task,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SmartTaskBoardScreen())),
                  ),
                  FeatureCard(
                    title: 'Smart Calendar',
                    icon: Icons.calendar_today,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SmartCalendarScreen())),
                  ),
                  FeatureCard(
                    title: 'MindSync Assistant',
                    icon: Icons.chat,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MindSyncAssistantScreen())),
                  ),
                  FeatureCard(
                    title: 'Achievement Garden',
                    icon: Icons.grass,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  FocusPlantApp())),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Integrations Section
              Text(
                'Integrations',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: const [
                  IntegrationCard(name: 'ClickUp', url: 'https://clickup.com'),
                  IntegrationCard(name: 'Trello', url: 'https://trello.com'),
                  IntegrationCard(name: 'Asana', url: 'https://asana.com'),
                  IntegrationCard(name: 'Notion', url: 'https://notion.so'),
                  IntegrationCard(name: 'Wrike', url: 'https://wrike.com'),
                  IntegrationCard(name: 'Monday', url: 'https://monday.com'),
                  IntegrationCard(name: 'Clockwise', url: 'https://clockwise.com'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class FeatureCard extends StatelessWidget {
  const FeatureCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IntegrationCard extends StatefulWidget {
  const IntegrationCard({super.key, required this.name, required this.url});

  final String name;
  final String url;

  @override
  State<IntegrationCard> createState() => _IntegrationCardState();
}

class _IntegrationCardState extends State<IntegrationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  IconData _getIconForService(String name) {
    switch (name.toLowerCase()) {
      case 'clickup':
        return Icons.check_circle;
      case 'trello':
        return Icons.view_list;
      case 'asana':
        return Icons.assignment;
      case 'notion':
        return Icons.note;
      case 'wrike':
        return Icons.work;
      case 'monday':
        return Icons.calendar_today;
      case 'clockwise':
        return Icons.schedule;
      default:
        return Icons.link;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor.withValues(alpha: 204),
                  Theme.of(context).colorScheme.secondary.withValues(alpha: 204),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 26),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                onTap: () {
                  final currentContext = context;
                  () async {
                    final uri = Uri.parse(widget.url);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    } else {
                      if (currentContext.mounted) {
                        ScaffoldMessenger.of(currentContext).showSnackBar(
                          SnackBar(content: Text('Could not launch ${widget.url}')),
                        );
                      }
                    }
                  }();
                },
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                onTapCancel: _onTapCancel,
                splashColor: Colors.white.withValues(alpha: 76),
                highlightColor: Colors.white.withValues(alpha: 25),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _getIconForService(widget.name),
                        size: 32,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.name,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
