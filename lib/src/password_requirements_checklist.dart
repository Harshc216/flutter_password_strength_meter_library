import 'package:flutter/material.dart';

class PasswordRequirementsChecklist extends StatelessWidget {
  final int minPasswordLength;
  final bool requireUppercase;
  final bool requireLowercase;
  final bool requireNumber;
  final bool requireSpecialChar;

  final bool hasMinLength;
  final bool hasUppercase;
  final bool hasLowercase;
  final bool hasNumber;
  final bool hasSpecialChar;

  const PasswordRequirementsChecklist({
    super.key,
    required this.minPasswordLength,
    required this.requireUppercase,
    required this.requireLowercase,
    required this.requireNumber,
    required this.requireSpecialChar,
    required this.hasMinLength,
    required this.hasUppercase,
    required this.hasLowercase,
    required this.hasNumber,
    required this.hasSpecialChar,
  });

  Widget _buildChecklistItem(String text, bool isMet) {
    final color = isMet ? Colors.green : Colors.grey.shade400;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              color: isMet ? const Color(0x1A4CAF50) : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isMet ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
              color: color,
              size: 16.0,
            ),
          ),
          const SizedBox(width: 8.0),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              color: isMet ? Colors.green.shade700 : Colors.grey.shade600,
              fontSize: 12.0,
              fontWeight: isMet ? FontWeight.w500 : FontWeight.normal,
            ),
            child: Text(text),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = <Widget>[];

    list.add(_buildChecklistItem(
      'At least $minPasswordLength characters',
      hasMinLength,
    ));
    if (requireUppercase) {
      list.add(_buildChecklistItem(
        'At least one uppercase letter',
        hasUppercase,
      ));
    }
    if (requireLowercase) {
      list.add(_buildChecklistItem(
        'At least one lowercase letter',
        hasLowercase,
      ));
    }
    if (requireNumber) {
      list.add(_buildChecklistItem(
        'At least one number',
        hasNumber,
      ));
    }
    if (requireSpecialChar) {
      list.add(_buildChecklistItem(
        'At least one special character (!@#\$&*~._-)',
        hasSpecialChar,
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: list,
    );
  }
}
