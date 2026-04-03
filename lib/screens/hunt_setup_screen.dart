import 'package:flutter/material.dart';
import '../models/hunt_theme.dart';
import '../theme/app_theme.dart';

class HuntSetupScreen extends StatefulWidget {
  const HuntSetupScreen({super.key});

  @override
  State<HuntSetupScreen> createState() => _HuntSetupScreenState();
}

class _HuntSetupScreenState extends State<HuntSetupScreen> {
  final _nameController = TextEditingController();
  HuntThemeType _selectedTheme = HuntThemeType.pirate;
  int? _timerMinutes;

  static const List<int?> _timerOptions = [null, 5, 10, 15, 20, 30];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hunt Setup')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hunt Name', style: AppTheme.heading(size: 20)),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'e.g. Backyard Adventure',
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 24),
            Text('Choose a Theme', style: AppTheme.heading(size: 20)),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.6,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: HuntThemeData.all.length,
              itemBuilder: (context, index) {
                final theme = HuntThemeData.all[index];
                final isSelected = _selectedTheme == theme.type;
                return GestureDetector(
                  onTap: () => setState(() => _selectedTheme = theme.type),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: theme.backgroundColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? theme.accentColor : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: theme.accentColor.withOpacity(0.4),
                                blurRadius: 8,
                                spreadRadius: 1,
                              )
                            ]
                          : [],
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                theme.emoji,
                                style: const TextStyle(fontSize: 32),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                theme.name,
                                style: AppTheme.heading(
                                  size: 14,
                                  color: theme.accentColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Icon(
                              Icons.check_circle,
                              color: theme.accentColor,
                              size: 24,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Text('Timer', style: AppTheme.heading(size: 20)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _timerOptions.map((minutes) {
                final isSelected = _timerMinutes == minutes;
                return ChoiceChip(
                  label: Text(
                    minutes == null ? 'Off' : '$minutes min',
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.warmBrown,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: AppTheme.darkGold,
                  backgroundColor: Colors.white,
                  onSelected: (_) => setState(() => _timerMinutes = minutes),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final name = _nameController.text.trim();
                  if (name.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a hunt name')),
                    );
                    return;
                  }
                  Navigator.pushNamed(
                    context,
                    '/clue-builder',
                    arguments: {
                      'name': name,
                      'theme': _selectedTheme,
                      'timer': _timerMinutes,
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.gold,
                  foregroundColor: AppTheme.warmBrown,
                ),
                child: Text('Next →', style: AppTheme.heading(size: 20, color: AppTheme.warmBrown)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
