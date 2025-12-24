import 'package:flutter/material.dart';
import 'package:attune/src/features/tasks/state/task_manager.dart';

class DailyTasksView extends StatelessWidget {
  const DailyTasksView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: TaskManager.instance,
      builder: (context, child) {
        final tasks = TaskManager.instance.getTasksForDate(DateTime.now());
        final isLocked = TaskManager.instance.isPlanLocked;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: tasks.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: Theme.of(
                            context,
                          ).primaryColor.withOpacity(0.1),
                        ),
                      ),
                      child: ListTile(
                        leading: Checkbox.adaptive(
                          value: task.isCompleted,
                          activeColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          onChanged: (value) {
                            TaskManager.instance.toggleTaskCompletion(task.id);
                          },
                        ),
                        title: Text(
                          task.title,
                          style: TextStyle(
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: task.isCompleted
                                ? Colors.grey
                                : Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: task.description != null
                            ? Text(task.description!)
                            : null,
                        trailing: !isLocked
                            ? IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  size: 20,
                                ),
                                onPressed: () =>
                                    TaskManager.instance.deleteTask(task.id),
                              )
                            : const SizedBox(),
                      ),
                    );
                  },
                ),
          floatingActionButton: isLocked
              ? null
              : FloatingActionButton.extended(
                  onPressed: () => _showAddTaskSheet(context),
                  label: const Text('Add Task'),
                  icon: const Icon(Icons.add),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 4,
                ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.checklist_rtl_rounded,
            size: 64,
            color: Theme.of(context).primaryColor.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No tasks for today',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add a task to get started!',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  void _showAddTaskSheet(BuildContext context) {
    final titleController = TextEditingController();
    final noteController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'New Task',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: titleController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'What needs to be done?',
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                hintText: 'Add a note (optional)',
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (titleController.text.trim().isNotEmpty) {
                    TaskManager.instance.addTask(
                      title: titleController.text.trim(),
                      description: noteController.text.trim().isEmpty
                          ? null
                          : noteController.text.trim(),
                      date: DateTime.now(),
                    );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text('Add Task', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
