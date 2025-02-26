import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onToggleTheme;

  const SettingsScreen({super.key, required this.isDarkMode, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Dark Mode is ${isDarkMode ? "ON" : "OFF"}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Switch(
            value: isDarkMode,
            onChanged: onToggleTheme,
            activeColor: Colors.blue,
            inactiveThumbColor: Colors.grey,
          ),
        ],
      ),
    );
  }
}