import 'package:flutter/material.dart';

class MindSyncAssistantScreen extends StatefulWidget {
  const MindSyncAssistantScreen({super.key});

  @override
  State<MindSyncAssistantScreen> createState() => _MindSyncAssistantScreenState();
}

class _MindSyncAssistantScreenState extends State<MindSyncAssistantScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [
    {'sender': 'AI', 'message': 'Hello! I\'m your MindSync Assistant. How can I help you stay focused today?'},
  ];

  final List<String> _responses = [
    "Great question! Try the Pomodoro technique: 25 minutes of focused work followed by a 5-minute break.",
    "I sense some distraction. Let's try a quick mindfulness exercise: Close your eyes and take 3 deep breaths.",
    "Remember your goals! Visualize completing your task successfully.",
    "You're doing amazing! Take a moment to celebrate your progress.",
    "Need motivation? Think about why this task matters to you.",
  ];

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add({'sender': 'You', 'message': _messageController.text});
        _messages.add({'sender': 'AI', 'message': _responses[_messages.length % _responses.length]});
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MindSync Assistant'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['sender'] == 'You';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: isUser ? Theme.of(context).primaryColor : Colors.grey[200],
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Text(
                      message['message']!,
                      style: TextStyle(color: isUser ? Colors.white : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Ask me anything...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _sendMessage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
