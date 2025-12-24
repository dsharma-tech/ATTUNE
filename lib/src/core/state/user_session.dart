import 'package:flutter/foundation.dart';
import 'package:attune/src/core/theme/app_colors.dart';
import 'package:flutter/widgets.dart';

class UserSession extends ChangeNotifier {
  static final UserSession instance = UserSession._internal();

  UserSession._internal();

  // Daily Check-in Data
  double _energyLevel = 50;
  double _stressLevel = 20;
  String _currentMood = '';
  String _currentTone = '';
  bool _isCheckedIn = false;

  // Focus Settings
  double _defaultWorkDuration = 25;
  double _defaultBreakDuration = 5;

  // Getters
  double get energyLevel => _energyLevel;
  double get stressLevel => _stressLevel;
  String get currentMood => _currentMood;
  String get currentTone => _currentTone;
  bool get isCheckedIn => _isCheckedIn;
  double get defaultWorkDuration => _defaultWorkDuration;
  double get defaultBreakDuration => _defaultBreakDuration;

  // Dynamic Theme Color (From AppColors)
  Color get currentThemeColor => AppColors.getColorForTone(_currentTone);

  // Setters
  void updateCheckIn({
    required double energy,
    required double stress,
    required String mood,
    required String tone,
  }) {
    _energyLevel = energy;
    _stressLevel = stress;
    _currentMood = mood;
    _currentTone = tone;
    _isCheckedIn = true;
    notifyListeners();
  }

  void updateFocusSettings({double? workDuration, double? breakDuration}) {
    if (workDuration != null) _defaultWorkDuration = workDuration;
    if (breakDuration != null) _defaultBreakDuration = breakDuration;
    print(
      'UserSession Updated: Tone=$_currentTone, ThemeColor=$currentThemeColor',
    );
    notifyListeners();
  }

  // Time Format Settings
  bool _is24HourFormat = false;
  bool get is24HourFormat => _is24HourFormat;

  void toggleTimeFormat(bool value) {
    _is24HourFormat = value;
    notifyListeners();
  }

  // Smart Logic for Focus Duration
  double getSmartFocusDuration() {
    // If stress is high (>70), suggest shorter sessions
    if (_stressLevel > 70) return 20;

    // If energy is high (>70) and stress is low (<40), suggest longer sessions
    if (_energyLevel > 70 && _stressLevel < 40) return 45;

    // Default configuration
    return _defaultWorkDuration;
  }
}
