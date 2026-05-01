import 'dart:math';
import 'package:flutter/material.dart';
import '../data/illustrations.dart';
import '../models/hunt_theme.dart';
import '../theme/app_theme.dart';
import '../widgets/parchment_background.dart';
import '../widgets/mute_button.dart';
import '../widgets/adventure_widgets.dart';

class HuntSetupScreen extends StatefulWidget {
  const HuntSetupScreen({super.key});

  @override
  State<HuntSetupScreen> createState() => _HuntSetupScreenState();
}

class _HuntSetupScreenState extends State<HuntSetupScreen> {
  final _nameController = TextEditingController();
  HuntThemeType _selectedTheme = HuntThemeType.custom;
  int? _timerMinutes;
  bool _customTimer = false;
  final _customTimerController = TextEditingController();

  static const List<int?> _timerOptions = [null, 5, 10, 15, 20, 30];

  @override
  void dispose() {
    _nameController.dispose();
    _customTimerController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return ParchmentBackground(child: Scaffold(
      appBar: AppBar(
        title: Text('HUNT SETUP', style: AppTheme.heading(size: 20)),
        actions: const [MuteButton()],
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdventureHeader(title: 'Hunt Name', emoji: '🏷️'),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              maxLength: 40,
              style: AppTheme.body(size: 16),
              decoration: const InputDecoration(
                hintText: 'e.g. Backyard Adventure',
                counterText: '',
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 28),
            AdventureHeader(title: 'Choose a Theme', emoji: '🎨'),
            Text(
              'Each theme changes the look and feel',
              style: AppTheme.caption(size: 13),
            ),
            const SizedBox(height: 12),
            _buildThemePreview(),
            const SizedBox(height: 12),
            // Theme selector chips
            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: HuntThemeData.all.length,
                itemBuilder: (context, index) {
                  final theme = HuntThemeData.all[index];
                  final isSelected = _selectedTheme == theme.type;
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 0 : 4,
                      right: 4,
                    ),
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => _selectedTheme = theme.type),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.tertiary
                              : AppTheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.asset(
                                Illustrations.themeImage(theme.name),
                                width: 20,
                                height: 20,
                                filterQuality: FilterQuality.high,
                                errorBuilder: (_, __, ___) => Text(
                                    theme.emoji,
                                    style: const TextStyle(fontSize: 14)),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              theme.name.split(' ').first,
                              style: AppTheme.body(
                                size: 13,
                                color: isSelected
                                    ? const Color(0xFF1A0A00)
                                    : AppTheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),


            const SizedBox(height: 24),
            AdventureHeader(title: 'Timer', emoji: '⏱️'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ..._timerOptions.map((minutes) {
                  final isSelected = !_customTimer && _timerMinutes == minutes;
                  return GestureDetector(
                    onTap: () => setState(() {
                      _timerMinutes = minutes;
                      _customTimer = false;
                    }),
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? const LinearGradient(
                                colors: [Color(0xFF7C3AED), Color(0xFF9B59D4)])
                            : null,
                        color: isSelected ? null : AppTheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: isSelected
                            ? [BoxShadow(
                                color: const Color(0xFF7C3AED).withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 3))]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        minutes == null ? 'Off' : '${minutes}min',
                        style: AppTheme.body(
                          size: 13,
                          color: isSelected
                              ? Colors.white
                              : AppTheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  );
                }),
                GestureDetector(
                  onTap: () => setState(() => _customTimer = true),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: _customTimer
                          ? AppTheme.primary
                          : AppTheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Icon(Icons.edit,
                        size: 18,
                        color: _customTimer
                            ? AppTheme.background
                            : AppTheme.onSurfaceVariant),
                  ),
                ),
              ],
            ),
            if (_customTimer) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: TextField(
                      controller: _customTimerController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Minutes',
                        isDense: true,
                      ),
                      onChanged: (v) {
                        final mins = int.tryParse(v);
                        if (mins != null && mins > 0) {
                          setState(() => _timerMinutes = mins);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('minutes', style: AppTheme.body(size: 14)),
                ],
              ),
            ],
            const SizedBox(height: 32),
            GradientButton(
              label: 'Next →',
              icon: Icons.arrow_forward,
              onPressed: () {
                final name = _nameController.text.trim();
                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please enter a hunt name')),
                  );
                  return;
                }
                Navigator.pushNamed(
                  context,
                  '/treasure-items',
                  arguments: {
                    'name': name,
                    'theme': _selectedTheme,
                    'timer': _timerMinutes,
                    'treasureItems': <dynamic>[],
                    'clues': <dynamic>[],
                  },
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    ));
  }

  Widget _buildThemePreview() {
    final theme = HuntThemeData.fromType(_selectedTheme);
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceHigh,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          // Theme header row
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  Illustrations.themeImage(theme.name),
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (_, __, ___) =>
                      Text(theme.emoji, style: const TextStyle(fontSize: 44)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(theme.name,
                        style: AppTheme.heading(
                            size: 20, color: AppTheme.gold)),
                    const SizedBox(height: 4),
                    Text(theme.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.body(
                            size: 13,
                            color: Colors.white.withOpacity(0.7))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Preview label
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Preview:',
                style: AppTheme.caption(
                    size: 10,
                    color: Colors.white.withOpacity(0.45))),
          ),
          const SizedBox(height: 4),
          // Found it button preview
          Container(
            width: double.infinity,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primary, AppTheme.primaryDim],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: const Color(0xFF00412F),
                  blurRadius: 0,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              theme.foundItText,
              textAlign: TextAlign.center,
              style: AppTheme.heading(size: 15, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

