import 'package:flutter/material.dart';

class SmartTaskBoardScreen extends StatelessWidget {
  const SmartTaskBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Task Board'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📊 Task Analytics',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('Project Completion Rate'),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: 0.75,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                    ),
                    const Text('75% Complete'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('Focused Peak Hours'),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildHourBar('9AM', 0.8),
                        _buildHourBar('10AM', 0.9),
                        _buildHourBar('11AM', 0.7),
                        _buildHourBar('2PM', 0.6),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('Focus Drop Alerts'),
                    const SizedBox(height: 8),
                    const Text('3 focus drops detected this week'),
                    const SizedBox(height: 8),
                    const Text('AI Suggestion: Schedule breaks every 90 minutes to maintain focus.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHourBar(String hour, double value) {
    return Column(
      children: [
        Text(hour),
        const SizedBox(height: 4),
        Container(
          width: 20,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.bottomCenter,
            heightFactor: value,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
