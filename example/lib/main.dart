import 'package:flutter/material.dart';
import 'package:flutter_password_strength_meter_library/password_strength_field.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Strength Meter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      ),
      home: const DemoScreen(),
    );
  }
}

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  final _passwordController1 = TextEditingController();
  final _passwordController2 = TextEditingController();
  final _passwordController3 = TextEditingController();

  @override
  void dispose() {
    _passwordController1.dispose();
    _passwordController2.dispose();
    _passwordController3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFEEF2F6),
              Color(0xFFE2E8F0),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: const BoxDecoration(
                          color: Color(0x1A6366F1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.security_rounded,
                          size: 48.0,
                          color: Color(0xFF6366F1),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Password Strength Meter',
                        style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32.0),
                Card(
                  elevation: 4.0,
                  shadowColor: const Color(0x1A000000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        PasswordStrengthField(
                          controller: _passwordController1,
                          labelText: 'Basic Password Field',
                          hintText: 'Enter password',
                          borderRadius: 16.0,
                          fillColor: const Color(0xFFF8FAFC),
                        ),
                        const SizedBox(height: 28.0),
                        PasswordStrengthField(
                          controller: _passwordController2,
                          labelText: 'Password with Requirements Checklist',
                          hintText: 'Enter password (shows list below)',
                          borderRadius: 16.0,
                          showChecklist: true,
                          fillColor: const Color(0xFFF8FAFC),
                        ),
                        const SizedBox(height: 28.0),
                        PasswordStrengthField(
                          controller: _passwordController3,
                          labelText: 'Custom Requirements (Min 6, No Special Char/Uppercase)',
                          hintText: 'Enter password',
                          borderRadius: 16.0,
                          minPasswordLength: 6,
                          requireUppercase: false,
                          requireSpecialChar: false,
                          showChecklist: true,
                          fillColor: const Color(0xFFF8FAFC),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
