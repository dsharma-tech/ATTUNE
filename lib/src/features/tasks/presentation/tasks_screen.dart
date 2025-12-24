import 'package:flutter/material.dart';
import 'package:attune/src/features/tasks/presentation/widgets/daily_tasks_view.dart';
import 'package:attune/src/features/tasks/presentation/widgets/weekly_tasks_view.dart';
import 'package:attune/src/features/tasks/state/task_manager.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tasks'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Daily'),
              Tab(text: 'Weekly'),
            ],
          ),
          actions: [
            AnimatedBuilder(
              animation: TaskManager.instance,
              builder: (context, child) {
                final isLocked = TaskManager.instance.isPlanLocked;
                return IconButton(
                  icon: Icon(
                    isLocked ? Icons.lock : Icons.lock_open,
                    color: isLocked ? Theme.of(context).primaryColor : null,
                  ),
                  tooltip: isLocked ? 'Plan Locked' : 'Lock Plan',
                  onPressed: () => _showTimeCapsuleDialog(context, isLocked),
                );
              },
            ),
          ],
        ),
        body: const TabBarView(children: [DailyTasksView(), WeeklyTasksView()]),
      ),
    );
  }

  void _showTimeCapsuleDialog(BuildContext context, bool isLocked) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: Text(isLocked ? 'Time Capsule 🔒' : 'Lock Daily Plan?'),
        content: Text(
          isLocked
              ? 'Your plan is currently locked to help you focus. Do you need to unlock it for an emergency change?'
              : 'Lock your daily plan to prevent distractions and commit to your tasks. You can unlock it if really needed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (isLocked) {
                TaskManager.instance.unlockDailyPlan();
              } else {
                TaskManager.instance.lockDailyPlan();
              }
              Navigator.pop(context);
            },
            child: Text(
              isLocked ? 'Emergency Unlock' : 'Lock Plan',
              style: TextStyle(
                color: isLocked ? Colors.red : Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
