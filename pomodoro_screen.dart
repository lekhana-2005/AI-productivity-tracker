import 'dart:async';
import 'package:flutter/material.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  static const int _workDuration = 25 * 60; // 25 minutes in seconds
  int _remainingTime = _workDuration;
  Timer? _timer;
  bool _isRunning = false;
  bool _isCompleted = false;

  void _startTimer() {
    if (_timer != null) return;
    setState(() {
      _isRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer?.cancel();
          _timer = null;
          _isRunning = false;
          _isCompleted = true;
          // Navigate to Procrastination Control screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProcrastinationControlScreen()),
          );
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _remainingTime = _workDuration;
      _isRunning = false;
      _isCompleted = false;
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_workDuration - _remainingTime) / _workDuration;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodoro Timer'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Focus Session',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                  ),
                  Text(
                    _formatTime(_remainingTime),
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isRunning ? _pauseTimer : _startTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(_isRunning ? 'Pause' : 'Start'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _resetTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Reset'),
                ),
              ],
            ),
            if (_isCompleted) ...[
              const SizedBox(height: 20),
              const Text(
                'Session Complete! 🎉',
                style: TextStyle(fontSize: 20, color: Colors.green),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ProcrastinationControlScreen extends StatefulWidget {
  const ProcrastinationControlScreen({super.key});

  @override
  State<ProcrastinationControlScreen> createState() => _ProcrastinationControlScreenState();
}

class _ProcrastinationControlScreenState extends State<ProcrastinationControlScreen>
    with TickerProviderStateMixin {
  late AnimationController _plantController;
  late Animation<double> _plantAnimation;
  Timer? _wateringTimer;
  bool _isAlive = true;
  bool _needsWater = false;
  static const int _wateringTime = 30; // 30 seconds to water
  int _wateringRemaining = _wateringTime;

  @override
  void initState() {
    super.initState();
    _plantController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _plantAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _plantController, curve: Curves.easeInOut),
    );
    _startWateringTimer();
  }

  void _startWateringTimer() {
    _needsWater = true;
    _wateringTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_wateringRemaining > 0) {
          _wateringRemaining--;
        } else {
          _wateringTimer?.cancel();
          _isAlive = false;
        }
      });
    });
  }

  void _waterPlant() {
    if (_needsWater && _isAlive) {
      _wateringTimer?.cancel();
      setState(() {
        _needsWater = false;
        _wateringRemaining = _wateringTime;
      });
      _plantController.forward();
    }
  }

  @override
  void dispose() {
    _plantController.dispose();
    _wateringTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Procrastination Control'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _plantAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _plantAnimation.value,
                  child: Text(
                    _isAlive ? '🌱' : '🥀',
                    style: const TextStyle(fontSize: 100),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              _isAlive
                  ? (_needsWater ? 'Water your plant!' : 'Plant is growing!')
                  : 'Plant died! 😢',
              style: const TextStyle(fontSize: 24),
            ),
            if (_needsWater && _isAlive) ...[
              const SizedBox(height: 10),
              Text(
                'Time left: $_wateringRemaining seconds',
                style: const TextStyle(fontSize: 18, color: Colors.red),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _waterPlant,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text('Water Plant 💧'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
