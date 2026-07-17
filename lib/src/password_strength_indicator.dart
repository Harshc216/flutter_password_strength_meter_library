import 'package:flutter/material.dart';
import 'password_strength_level.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final PasswordStrengthLevel strengthLevel;
  final bool showStrengthMeter;
  final bool isPasswordEmpty;
  final Widget? checklist;

  const PasswordStrengthIndicator({
    super.key,
    required this.strengthLevel,
    required this.isPasswordEmpty,
    this.showStrengthMeter = true,
    this.checklist,
  });

  @override
  Widget build(BuildContext context) {
    if (!showStrengthMeter || isPasswordEmpty) {
      return const SizedBox.shrink();
    }

    final levelColor = strengthLevel.color;
    final levelText = strengthLevel.label;
    final filledCount = strengthLevel.filledSegments;

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 2.0, right: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(4, (index) {
              final isFilled = index < filledCount;
              final color = isFilled ? levelColor : const Color(0xFFE2E8F0);
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 0.0 : 4.0,
                    right: index == 3 ? 0.0 : 4.0,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 5.0,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                levelText,
                style: TextStyle(
                  color: levelColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.0,
                ),
              ),
              const Icon(
                Icons.info_outline_rounded,
                size: 16.0,
                color: Color(0xFF94A3B8),
              ),
            ],
          ),
          if (checklist != null) ...[
            const SizedBox(height: 12.0),
            checklist!,
          ],
        ],
      ),
    );
  }
}
