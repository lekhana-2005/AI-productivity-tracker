import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:math';

class SmartCalendarScreen extends StatefulWidget {
  const SmartCalendarScreen({super.key});

  @override
  State<SmartCalendarScreen> createState() => _SmartCalendarScreenState();
}

class _SmartCalendarScreenState extends State<SmartCalendarScreen> {
  final TextEditingController _taskController = TextEditingController();
  final Map<DateTime, List<String>> _tasks = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      final random = Random();
      final randomDay = DateTime(
        _focusedDay.year,
        _focusedDay.month,
        random.nextInt(28) + 1,
      );
      setState(() {
        if (_tasks[randomDay] == null) _tasks[randomDay] = [];
        _tasks[randomDay]!.add(_taskController.text);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task "${_taskController.text}" added on ${randomDay.day}/${randomDay.month}')),
      );
      _taskController.clear();
    }
  }

  List<String> _getTasksForDay(DateTime day) {
    return _tasks[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Calendar Demo"),
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
            },
            eventLoader: _getTasksForDay,
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                  color: Colors.pinkAccent, shape: BoxShape.circle),
              selectedDecoration: BoxDecoration(
                  color: Colors.deepPurple, shape: BoxShape.circle),
              markerDecoration: BoxDecoration(
                  color: Colors.teal, shape: BoxShape.circle),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(
                      labelText: "Enter task",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addTask,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      foregroundColor: Colors.white),
                  child: const Text("Add"),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                if (_selectedDay != null) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Tasks for ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}:",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  ..._getTasksForDay(_selectedDay!).map((task) => ListTile(
                        title: Text(task),
                        leading: const Icon(Icons.check_circle_outline,
                            color: Colors.pinkAccent),
                      )),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}
