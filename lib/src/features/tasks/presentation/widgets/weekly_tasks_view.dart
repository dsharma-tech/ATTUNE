import 'package:flutter/material.dart';
import 'package:attune/src/features/tasks/state/task_manager.dart';
import 'package:intl/intl.dart';

class WeeklyTasksView extends StatelessWidget {
  const WeeklyTasksView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: TaskManager.instance,
      builder: (context, child) {
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 7,
          itemBuilder: (context, index) {
            final date = DateTime.now().add(Duration(days: index));
            final tasks = TaskManager.instance.getTasksForDate(date);
            final dayName = index == 0
                ? 'Today'
                : index == 1
                ? 'Tomorrow'
                : DateFormat('EEEE').format(date);
            final dateString = DateFormat('MMM d').format(date);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        dayName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: index == 0
                              ? Theme.of(context).primaryColor
                              : Colors.black87,
                        ),
                      ),
                      Text(
                        dateString,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                if (tasks.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Text(
                      'No tasks planned',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                else
                  ...tasks.map(
                    (task) => Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey[200]!),
                      ),
                      child: ListTile(
                        visualDensity: VisualDensity.compact,
                        leading: Icon(
                          task.isCompleted
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: task.isCompleted
                              ? Theme.of(context).primaryColor
                              : Colors.grey[400],
                          size: 20,
                        ),
                        title: Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 14,
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: task.isCompleted
                                ? Colors.grey
                                : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
              ],
            );
          },
        );
      },
    );
  }
}
