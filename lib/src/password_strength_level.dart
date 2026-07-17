import 'package:flutter/material.dart';

enum PasswordStrengthLevel {
  veryWeak,
  weak,
  soSo,
  good,
  strong,
}

extension PasswordStrengthExtension on PasswordStrengthLevel {
  String get label {
    switch (this) {
      case PasswordStrengthLevel.veryWeak:
        return 'Very Weak';
      case PasswordStrengthLevel.weak:
        return 'Weak';
      case PasswordStrengthLevel.soSo:
        return 'So-so';
      case PasswordStrengthLevel.good:
        return 'Good';
      case PasswordStrengthLevel.strong:
        return 'Strong';
    }
  }

  Color get color {
    switch (this) {
      case PasswordStrengthLevel.veryWeak:
        return const Color(0xFF94A3B8); // Slate 400
      case PasswordStrengthLevel.weak:
        return const Color(0xFFEF4444); // Red 500
      case PasswordStrengthLevel.soSo:
        return const Color(0xFFF97316); // Orange 500
      case PasswordStrengthLevel.good:
        return const Color(0xFFEAB308); // Amber 500
      case PasswordStrengthLevel.strong:
        return const Color(0xFF10B981); // Emerald 500
    }
  }

  double get progress {
    switch (this) {
      case PasswordStrengthLevel.veryWeak:
        return 0.0;
      case PasswordStrengthLevel.weak:
        return 0.25;
      case PasswordStrengthLevel.soSo:
        return 0.50;
      case PasswordStrengthLevel.good:
        return 0.75;
      case PasswordStrengthLevel.strong:
        return 1.0;
    }
  }

  int get filledSegments {
    switch (this) {
      case PasswordStrengthLevel.veryWeak:
        return 0;
      case PasswordStrengthLevel.weak:
        return 1;
      case PasswordStrengthLevel.soSo:
        return 2;
      case PasswordStrengthLevel.good:
        return 3;
      case PasswordStrengthLevel.strong:
        return 4;
    }
  }
}
