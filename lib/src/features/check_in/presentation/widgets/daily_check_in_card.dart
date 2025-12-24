import 'package:flutter/material.dart';
import 'package:attune/src/core/state/user_session.dart';
import 'package:attune/src/core/theme/app_colors.dart';

class DailyCheckInCard extends StatefulWidget {
  const DailyCheckInCard({super.key});

  @override
  State<DailyCheckInCard> createState() => _DailyCheckInCardState();
}

class _DailyCheckInCardState extends State<DailyCheckInCard> {
  bool _isCheckedIn = false;
  double _energyLevel = 50;
  double _stressLevel = 20;
  String? _selectedMood;
  String _selectedTone = '';

  final List<String> _tones = [
    'Focused',
    'Calm',
    'Productive',
    'Creative',
    'Relaxed',
  ];

  Color _getCardColor(BuildContext context) {
    if (_selectedTone.isEmpty) return Theme.of(context).primaryColor;
    return AppColors.getColorForTone(_selectedTone);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _getCardColor(context),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: _getCardColor(context).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: _isCheckedIn ? _buildCompactView() : _buildFullForm(),
    );
  }

  Widget _buildCompactView() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'You\'re all set!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Mood: $_selectedMood • Tone: $_selectedTone',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.bolt, color: Colors.white70, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${_energyLevel.toInt()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.spa, color: Colors.white70, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${_stressLevel.toInt()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => setState(() => _isCheckedIn = false),
          icon: const Icon(Icons.edit, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildFullForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Daily Check-in',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 32),
        _buildMoodSelector(),
        const SizedBox(height: 32),
        _buildSliderSection(
          'Energy Level',
          _energyLevel,
          (val) => setState(() => _energyLevel = val),
          Icons.bolt,
        ),
        const SizedBox(height: 24),
        _buildSliderSection(
          'Stress Level',
          _stressLevel,
          (val) => setState(() => _stressLevel = val),
          Icons.spa,
        ),
        const SizedBox(height: 32),
        _buildToneSelector(),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: (_selectedMood != null && _selectedTone.isNotEmpty)
                ? () {
                    setState(() => _isCheckedIn = true);

                    // Update Shared Session
                    UserSession.instance.updateCheckIn(
                      energy: _energyLevel,
                      stress: _stressLevel,
                      mood: _selectedMood!,
                      tone: _selectedTone,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Check-in completed! Have a great day.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: _getCardColor(context),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              disabledBackgroundColor: Colors.white.withOpacity(0.3),
              disabledForegroundColor: Colors.white.withOpacity(0.5),
            ),
            child: const Text(
              'Complete Check-in',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMoodSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildMoodIcon(Icons.sentiment_very_dissatisfied, 'Rough'),
        _buildMoodIcon(Icons.sentiment_dissatisfied, 'Meh'),
        _buildMoodIcon(Icons.sentiment_neutral, 'Okay'),
        _buildMoodIcon(Icons.sentiment_satisfied, 'Good'),
        _buildMoodIcon(Icons.sentiment_very_satisfied, 'Great'),
      ],
    );
  }

  Widget _buildMoodIcon(IconData icon, String label) {
    final isSelected = _selectedMood == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedMood = label),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Icon(
              icon,
              color: isSelected ? _getCardColor(context) : Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(isSelected ? 1.0 : 0.6),
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderSection(
    String label,
    double value,
    ValueChanged<double> onChanged,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white70, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              '${value.toInt()}%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.white.withOpacity(0.2),
            thumbColor: Colors.white,
            overlayColor: Colors.white.withOpacity(0.1),
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
          ),
          child: Slider(value: value, min: 0, max: 100, onChanged: onChanged),
        ),
      ],
    );
  }

  Widget _buildToneSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Set Tone for the Day',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _tones.map((tone) {
            final isSelected = _selectedTone == tone;
            return GestureDetector(
              onTap: () =>
                  setState(() => _selectedTone = isSelected ? '' : tone),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white
                      : Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withOpacity(isSelected ? 1 : 0.5),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  tone,
                  style: TextStyle(
                    color: isSelected ? _getCardColor(context) : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
