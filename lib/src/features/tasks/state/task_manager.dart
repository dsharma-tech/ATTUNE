import 'package:flutter/foundation.dart';
import '../domain/task_model.dart';

class TaskManager extends ChangeNotifier {
  static final TaskManager instance = TaskManager._internal();

  TaskManager._internal() {
    // Add some sample tasks for demonstration
    final now = DateTime.now();
    _tasks.addAll([
      Task(
        id: '1',
        title: 'Review Project Requirements',
        date: now,
        isCompleted: true,
      ),
      Task(id: '2', title: 'Draft Initial Design', date: now),
      Task(id: '3', title: 'Team Sync', date: now.add(const Duration(days: 1))),
    ]);
  }

  final List<Task> _tasks = [];
  bool _isPlanLocked = false;

  // Getters
  List<Task> get tasks => List.unmodifiable(_tasks);
  bool get isPlanLocked => _isPlanLocked;

  List<Task> getTasksForDate(DateTime date) {
    return _tasks.where((task) {
      return task.date.year == date.year &&
          task.date.month == date.month &&
          task.date.day == date.day;
    }).toList();
  }

  // Actions
  void addTask({
    required String title,
    String? description,
    required DateTime date,
  }) {
    // Prevent adding to today if locked
    if (_isPlanLocked && _isSameDay(date, DateTime.now())) {
      throw Exception('Daily plan is locked.');
    }

    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      date: date,
    );
    _tasks.add(newTask);
    notifyListeners();
  }

  void toggleTaskCompletion(String taskId) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      final task = _tasks[index];
      _tasks[index] = task.copyWith(isCompleted: !task.isCompleted);
      notifyListeners();
    }
  }

  void deleteTask(String taskId) {
    // Prevent deleting from today if locked, unless it's just cleanup?
    // Requirement says: "Once locked: Prevent editing of today’s tasks"
    // Deleting is arguably editing the list.
    final task = _tasks.firstWhere((t) => t.id == taskId);
    if (_isPlanLocked && _isSameDay(task.date, DateTime.now())) {
      // Ideally we show error, but void return. UI should hide delete option.
      return;
    }

    _tasks.removeWhere((t) => t.id == taskId);
    notifyListeners();
  }

  // Time Capsule
  void lockDailyPlan() {
    _isPlanLocked = true;
    notifyListeners();
  }

  void unlockDailyPlan() {
    _isPlanLocked = false;
    notifyListeners();
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
