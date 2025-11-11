import 'package:flutter/material.dart';

class AIInsightsScreen extends StatefulWidget {
  const AIInsightsScreen({super.key});

  @override
  State<AIInsightsScreen> createState() => _AIInsightsScreenState();
}

class _AIInsightsScreenState extends State<AIInsightsScreen> {
  final List<String> _insights = [
    "Based on your recent activity, you focus best between 10 AM and 12 PM. Schedule important tasks during this window.",
    "You've completed 4 Pomodoro sessions this week. Consider increasing to 6 for better productivity.",
    "Your focus drops after 2 hours of continuous work. Take a 5-minute break to recharge.",
    "AI predicts a potential distraction spike at 3 PM. Set a reminder to stay on track.",
    "Your task completion rate is 85%. Great job! Try breaking complex tasks into smaller steps.",
  ];

  int _currentInsightIndex = 0;

  void _nextInsight() {
    setState(() {
      _currentInsightIndex = (_currentInsightIndex + 1) % _insights.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Insights'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lightbulb,
                size: 100,
                color: Colors.amber,
              ),
              const SizedBox(height: 24),
              Text(
                'AI-Powered Insight',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _insights[_currentInsightIndex],
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _nextInsight,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text('Get Next Insight'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
