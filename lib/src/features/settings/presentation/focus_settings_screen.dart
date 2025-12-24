import 'package:flutter/material.dart';
import 'package:attune/src/core/state/user_session.dart';

class FocusSettingsScreen extends StatefulWidget {
  const FocusSettingsScreen({super.key});

  @override
  State<FocusSettingsScreen> createState() => _FocusSettingsScreenState();
}

class _FocusSettingsScreenState extends State<FocusSettingsScreen> {
  // Initialize with values from UserSession
  double _workDuration = UserSession.instance.defaultWorkDuration;
  double _breakDuration = UserSession.instance.defaultBreakDuration;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Focus Settings'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSliderTile(
            'Work Interval',
            '${_workDuration.toInt()} minutes',
            _workDuration,
            15,
            60,
            (val) {
              setState(() => _workDuration = val);
              UserSession.instance.updateFocusSettings(workDuration: val);
            },
            Icons.work_outline,
          ),
          const SizedBox(height: 24),
          _buildSliderTile(
            'Break Interval',
            '${_breakDuration.toInt()} minutes',
            _breakDuration,
            5,
            30,
            (val) {
              setState(() => _breakDuration = val);
              UserSession.instance.updateFocusSettings(breakDuration: val);
            },
            Icons.coffee_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildSliderTile(
    String title,
    String valueText,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    valueText,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Using SliderTheme for color customization of adaptive slider
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Theme.of(context).primaryColor,
              inactiveTrackColor: Theme.of(
                context,
              ).primaryColor.withOpacity(0.2),
              thumbColor: Theme.of(context).primaryColor,
            ),
            child: Slider.adaptive(
              value: value,
              min: min,
              max: max,
              divisions: (max - min) ~/ 5,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
