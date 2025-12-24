import 'dart:async';
import 'package:flutter/material.dart';
import 'package:attune/src/core/state/user_session.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  // Timer State
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isRunning = false;
  bool _isBreak = false;
  double _totalDuration = 0;

  // Selected Task
  String _selectedTask = 'Deep Work';
  final List<String> _tasks = [
    'Deep Work',
    'Finish Project Report',
    'Email Team',
    'Brainstorming',
    'Reading',
  ];

  @override
  void initState() {
    super.initState();
    _resetTimer();
  }

  void _resetTimer() {
    _timer?.cancel();
    // Smart Logic: Get duration based on user state
    final minutes = _isBreak
        ? UserSession.instance.defaultBreakDuration
        : UserSession.instance.getSmartFocusDuration();

    setState(() {
      _remainingSeconds = (minutes * 60).toInt();
      _totalDuration = _remainingSeconds.toDouble();
      _isRunning = false;
    });
  }

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
    } else {
      setState(() => _isRunning = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingSeconds > 0) {
          setState(() => _remainingSeconds--);
        } else {
          _handleSessionComplete();
        }
      });
    }
  }

  void _handleSessionComplete() {
    _timer?.cancel();
    setState(() => _isRunning = false);

    // Show Completion Dialog
    showAdaptiveDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog.adaptive(
        title: Text(_isBreak ? 'Break Over!' : 'Focus Session Complete!'),
        content: Text(
          _isBreak
              ? 'Ready to get back to work?'
              : 'Great job! Take a moment to breathe.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isBreak = !_isBreak; // Toggle Mode
                _resetTimer();
              });
            },
            child: Text(_isBreak ? 'Start Focus' : 'Take a Break'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = 1 - (_remainingSeconds / _totalDuration);
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Focus'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _resetTimer),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Smart Suggestion Badge
            if (!_isBreak &&
                UserSession.instance.getSmartFocusDuration() !=
                    UserSession.instance.defaultWorkDuration)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome, size: 16, color: primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      UserSession.instance.stressLevel > 70
                          ? 'Shortened for stress relief'
                          : 'Extended for high energy',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

            // Task Selector
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(16),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedTask,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: _tasks.map((String task) {
                    return DropdownMenuItem<String>(
                      value: task,
                      child: Text(
                        task,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedTask = val!),
                ),
              ),
            ),

            const Spacer(),

            // Timer
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 280,
                  height: 280,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey.shade100,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _isBreak ? Colors.green : primaryColor,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTime(_remainingSeconds),
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                    Text(
                      _isBreak ? 'Break' : 'Focus',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const Spacer(),

            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.large(
                  onPressed: _toggleTimer,
                  backgroundColor: _isBreak ? Colors.green : primaryColor,
                  elevation: 4,
                  shape: const CircleBorder(),
                  child: Icon(
                    _isRunning ? Icons.pause : Icons.play_arrow_rounded,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
