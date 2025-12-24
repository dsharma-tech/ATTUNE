import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:attune/src/core/state/user_session.dart';
import '../../check_in/presentation/widgets/daily_check_in_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _getMoodEmoji(String mood) {
    switch (mood) {
      case 'Great':
        return '🤩';
      case 'Good':
        return '😃';
      case 'Okay':
        return '🙂';
      case 'Meh':
        return '😐';
      case 'Rough':
        return '🌧️';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: UserSession.instance,
        builder: (context, child) {
          final now = DateTime.now();
          final dayString = DateFormat('EEEE').format(now);
          final dateString = DateFormat('MMMM d, y').format(now);
          final moodEmoji = _getMoodEmoji(UserSession.instance.currentMood);
          final timeFormat = UserSession.instance.is24HourFormat
              ? DateFormat('HH:mm')
              : DateFormat('h:mm a');
          final timeString = timeFormat.format(now);

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Row(
                  children: [
                    Text(
                      'Attune',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 28,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                centerTitle: false,
                backgroundColor: Theme.of(context).colorScheme.surface,
                floating: true,
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => context.push('/profile'),
                      icon: Icon(
                        Icons.person_outline,
                        color: Theme.of(context).primaryColor,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Time, Date, Day, AND EMOJI
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  timeString,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                        fontSize: 36,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$dayString, $dateString',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ],
                            ),
                            if (moodEmoji.isNotEmpty)
                              TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0.0, end: 1.0),
                                duration: const Duration(milliseconds: 800),
                                curve: Curves.elasticOut,
                                builder: (context, value, child) {
                                  return Transform.scale(
                                    scale: value,
                                    child: Text(
                                      moodEmoji,
                                      style: const TextStyle(fontSize: 64),
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Daily Check-in (Wider)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: DailyCheckInCard(),
                      ),
                      const SizedBox(height: 32),

                      // To-Do / Task Summary
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your To-Do',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            _buildTaskSummaryCard(context),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Quick Actions
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quick Actions',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildQuickAction(
                                  context,
                                  icon: Icons.timer_outlined,
                                  label: 'Focus',
                                  color: Colors.purple.shade50,
                                  iconColor: Colors.purple,
                                  onTap: () => context.go('/focus'),
                                ),
                                _buildQuickAction(
                                  context,
                                  icon: Icons.check_circle_outline,
                                  label: 'Tasks',
                                  color: Colors.blue.shade50,
                                  iconColor: Colors.blue,
                                  onTap: () => context.go('/tasks'),
                                ),
                                _buildQuickAction(
                                  context,
                                  icon: Icons.nightlight_outlined,
                                  label: 'Rest',
                                  color: Colors.indigo.shade50,
                                  iconColor: Colors.indigo,
                                  onTap: () {}, // Placeholder for Rest Mode
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Bottom padding for scrollability
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ); // CustomScrollView
        },
      ),
    ); // Scaffold
  }

  Widget _buildTaskSummaryCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '3 Tasks Remaining',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'High Priority',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () => context.go('/tasks'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(
                    context,
                  ).primaryColor.withOpacity(0.1),
                  foregroundColor: Theme.of(context).primaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Sample Tasks List
          _buildTaskItem('Finish Project Report', true),
          const SizedBox(height: 12),
          _buildTaskItem('Email Team meeting', false),
        ],
      ),
    );
  }

  Widget _buildTaskItem(String title, bool isCompleted) {
    return Row(
      children: [
        Icon(
          isCompleted ? Icons.check_circle : Icons.circle_outlined,
          color: isCompleted ? Colors.green : Colors.grey[400],
          size: 20,
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
            color: isCompleted ? Colors.grey : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 100,
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 32),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
