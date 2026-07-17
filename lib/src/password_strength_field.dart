import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'password_strength_level.dart';

class PasswordStrengthField extends StatefulWidget {
  /// Controller for text input field.
  final TextEditingController? controller;

  /// Optional label text shown above the field.
  final String? labelText;

  /// Optional hint text shown inside the field.
  final String? hintText;

  /// Custom validation function. If provided, runs along with or overrides default validations.
  final String? Function(String?)? validator;

  /// Whether to obscure text initially.
  final bool obscureText;

  /// Whether to show the visibility toggle icon for password inputs.
  final bool showPasswordToggle;

  /// Optional widget to display before the text input.
  final Widget? prefixIcon;

  /// Optional widget to display after the text input.
  final Widget? suffixIcon;

  /// Formatters for restricting or formatting user input.
  final List<TextInputFormatter>? inputFormatters;

  /// Keyboard type configuration.
  final TextInputType? keyboardType;

  /// Keyboard action button behavior.
  final TextInputAction? textInputAction;

  /// Triggered on every text change.
  final ValueChanged<String>? onChanged;

  /// Triggered when the user submits input (e.g. press enter on keyboard).
  final ValueChanged<String>? onFieldSubmitted;

  /// Focus node configuration for controlling keyboard focus.
  final FocusNode? focusNode;

  /// Whether the input field should gain focus automatically on build.
  final bool autofocus;

  /// Text style of input content.
  final TextStyle? style;

  /// Maximum lines of input. Default is 1.
  final int maxLines;

  /// Enable or disable the text input field.
  final bool enabled;

  /// Read-only mode configuration.
  final bool readOnly;

  /// Border corner radius.
  final double borderRadius;

  /// Border color when the text field has focus. If null, dynamically matches the current password strength level's color.
  final Color? focusedBorderColor;

  /// Border color when the text field is enabled but not focused.
  final Color enabledBorderColor;

  /// Border color when validation fails.
  final Color errorBorderColor;

  /// Width of border lines.
  final double borderWidth;

  /// Background color of the text field.
  final Color? fillColor;

  /// Whether to show the password strength indicator.
  final bool showStrengthMeter;

  /// Whether to show the detailed requirements checklist below the strength meter.
  final bool showChecklist;

  /// Minimum password length requirement. Default is 8.
  final int minPasswordLength;

  /// Require at least one uppercase character in password.
  final bool requireUppercase;

  /// Require at least one lowercase character in password.
  final bool requireLowercase;

  /// Require at least one numeric digit in password.
  final bool requireNumber;

  /// Require at least one special character in password.
  final bool requireSpecialChar;

  /// Whether to enable default validation against the password strength requirements.
  /// If true, the field will automatically validate that the password meets all
  /// specified requirements. If false, validation will only run if a custom [validator] is provided.
  final bool enableDefaultValidation;

  const PasswordStrengthField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.validator,
    this.obscureText = true,
    this.showPasswordToggle = true,
    this.prefixIcon,
    this.suffixIcon,
    this.inputFormatters,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onFieldSubmitted,
    this.focusNode,
    this.autofocus = false,
    this.style,
    this.maxLines = 1,
    this.enabled = true,
    this.readOnly = false,
    this.borderRadius = 12.0,
    this.focusedBorderColor,
    this.enabledBorderColor = const Color(0xFFE2E8F0), // Slate grey
    this.errorBorderColor = const Color(0xFFEF4444), // Crimson red
    this.borderWidth = 1.5,
    this.fillColor,
    this.showStrengthMeter = true,
    this.showChecklist = false,
    this.minPasswordLength = 8,
    this.requireUppercase = true,
    this.requireLowercase = true,
    this.requireNumber = true,
    this.requireSpecialChar = true,
    this.enableDefaultValidation = false,
  });

  @override
  State<PasswordStrengthField> createState() => _PasswordStrengthFieldState();
}

class _PasswordStrengthFieldState extends State<PasswordStrengthField> {
  late bool _obscureText;
  late TextEditingController _controller;
  PasswordStrengthLevel _strengthLevel = PasswordStrengthLevel.veryWeak;

  // Track requirement matches
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
    _onTextChanged();
  }

  @override
  void didUpdateWidget(covariant PasswordStrengthField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_onTextChanged);
      if (oldWidget.controller == null) {
        _controller.dispose();
      }
      _controller = widget.controller ?? TextEditingController();
      _controller.addListener(_onTextChanged);
      _onTextChanged();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    final text = _controller.text;
    setState(() {
      _hasMinLength = text.length >= widget.minPasswordLength;
      _hasUppercase = RegExp(r'[A-Z]').hasMatch(text);
      _hasLowercase = RegExp(r'[a-z]').hasMatch(text);
      _hasNumber = RegExp(r'[0-9]').hasMatch(text);
      _hasSpecialChar = RegExp(r'[!@#\$&*~._-]').hasMatch(text);

      if (text.isEmpty) {
        _strengthLevel = PasswordStrengthLevel.veryWeak;
        return;
      }

      int score = 0;
      int maxPossible = 0;

      score += _hasMinLength ? 1 : 0;
      maxPossible += 1;

      if (widget.requireUppercase) {
        score += _hasUppercase ? 1 : 0;
        maxPossible += 1;
      }
      if (widget.requireLowercase) {
        score += _hasLowercase ? 1 : 0;
        maxPossible += 1;
      }
      if (widget.requireNumber) {
        score += _hasNumber ? 1 : 0;
        maxPossible += 1;
      }
      if (widget.requireSpecialChar) {
        score += _hasSpecialChar ? 1 : 0;
        maxPossible += 1;
      }

      final ratio = maxPossible > 0 ? score / maxPossible : 0.0;
      if (ratio == 0.0) {
        _strengthLevel = PasswordStrengthLevel.veryWeak;
      } else if (ratio <= 0.3) {
        _strengthLevel = PasswordStrengthLevel.weak;
      } else if (ratio <= 0.6) {
        _strengthLevel = PasswordStrengthLevel.soSo;
      } else if (ratio <= 0.8) {
        _strengthLevel = PasswordStrengthLevel.good;
      } else {
        _strengthLevel = PasswordStrengthLevel.strong;
      }
    });
  }

  Widget? _buildSuffixIcon() {
    if (widget.showPasswordToggle) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: Colors.grey.shade600,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }
    return widget.suffixIcon;
  }

  InputDecoration _buildDecoration(Color activeColor) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(
        color: widget.enabledBorderColor,
        width: widget.borderWidth,
      ),
    );
    final focusBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(
        color: widget.focusedBorderColor ?? activeColor,
        width: widget.borderWidth * 1.2,
      ),
    );
    final errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(
        color: widget.errorBorderColor,
        width: widget.borderWidth,
      ),
    );
    return InputDecoration(
      hintText: widget.hintText,
      prefixIcon: widget.prefixIcon ?? const Icon(Icons.lock_outline_rounded, color: Color(0xFF64748B)),
      suffixIcon: _buildSuffixIcon(),
      filled: widget.fillColor != null,
      fillColor: widget.fillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      border: border,
      enabledBorder: border,
      focusedBorder: focusBorder,
      errorBorder: errorBorder,
      focusedErrorBorder: focusBorder.copyWith(
        borderSide: BorderSide(
          color: widget.errorBorderColor,
          width: widget.borderWidth * 1.2,
        ),
      ),
    );
  }

  String? _defaultValidator(String? value) {
    if (widget.validator != null) {
      return widget.validator!(value);
    }
    if (!widget.enableDefaultValidation) {
      return null;
    }
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    List<String> missing = [];
    if (value.length < widget.minPasswordLength) {
      missing.add('${widget.minPasswordLength}+ chars');
    }
    if (widget.requireUppercase && !RegExp(r'[A-Z]').hasMatch(value)) {
      missing.add('uppercase');
    }
    if (widget.requireLowercase && !RegExp(r'[a-z]').hasMatch(value)) {
      missing.add('lowercase');
    }
    if (widget.requireNumber && !RegExp(r'[0-9]').hasMatch(value)) {
      missing.add('number');
    }
    if (widget.requireSpecialChar && !RegExp(r'[!@#\$&*~._-]').hasMatch(value)) {
      missing.add('special char');
    }
    if (missing.isNotEmpty) {
      return 'Requires: ${missing.join(", ")}';
    }
    return null;
  }

  Widget _buildStrengthIndicator() {
    if (!widget.showStrengthMeter || _controller.text.isEmpty) {
      return const SizedBox.shrink();
    }

    final level = _strengthLevel;
    final levelColor = level.color;
    final levelText = level.label;
    final filledCount = level.filledSegments;

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
          if (widget.showChecklist) ...[
            const SizedBox(height: 12.0),
            _buildChecklist(),
          ],
        ],
      ),
    );
  }

  Widget _buildChecklist() {
    final list = <Widget>[];

    list.add(_buildChecklistItem(
      'At least ${widget.minPasswordLength} characters',
      _hasMinLength,
    ));
    if (widget.requireUppercase) {
      list.add(_buildChecklistItem(
        'At least one uppercase letter',
        _hasUppercase,
      ));
    }
    if (widget.requireLowercase) {
      list.add(_buildChecklistItem(
        'At least one lowercase letter',
        _hasLowercase,
      ));
    }
    if (widget.requireNumber) {
      list.add(_buildChecklistItem(
        'At least one number',
        _hasNumber,
      ));
    }
    if (widget.requireSpecialChar) {
      list.add(_buildChecklistItem(
        'At least one special character (!@#\$&*~._-)',
        _hasSpecialChar,
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: list,
    );
  }

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
    final activeColor = _strengthLevel.color;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 8.0),
        ],
        TextFormField(
          controller: _controller,
          obscureText: _obscureText,
          keyboardType: widget.keyboardType ?? TextInputType.visiblePassword,
          textInputAction: widget.textInputAction,
          inputFormatters: widget.inputFormatters,
          onChanged: (val) {
            if (widget.onChanged != null) {
              widget.onChanged!(val);
            }
          },
          onFieldSubmitted: widget.onFieldSubmitted,
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          style: widget.style,
          maxLines: widget.maxLines,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          decoration: _buildDecoration(activeColor),
          validator: _defaultValidator,
        ),
        _buildStrengthIndicator(),
      ],
    );
  }
}
