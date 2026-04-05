import 'package:flutter/material.dart';
import '../data/clue_library.dart';
import '../theme/app_theme.dart';
import '../widgets/parchment_background.dart';

class ClueLibraryScreen extends StatefulWidget {
  const ClueLibraryScreen({super.key});

  @override
  State<ClueLibraryScreen> createState() => _ClueLibraryScreenState();
}

class _ClueLibraryScreenState extends State<ClueLibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ClueDifficulty? _difficultyFilter;
  final List<String> _selectedClues = [];
  String _searchQuery = '';
  final _searchController = TextEditingController();

  static const _categories = [
    ClueCategory.home,
    ClueCategory.garden,
    ClueCategory.park,
    ClueCategory.birthday,
    ClueCategory.any,
  ];

  static const _categoryLabels = ['Home', 'Garden', 'Park', 'Birthday', 'Any'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<LibraryClue> get _filteredClues {
    final category = _categories[_tabController.index];
    return ClueLibrary.clues.where((c) {
      if (c.category != category) return false;
      if (_difficultyFilter != null && c.difficulty != _difficultyFilter) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!c.riddle.toLowerCase().contains(query) &&
            !c.answer.toLowerCase().contains(query)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ParchmentBackground(child: Scaffold(
      appBar: AppBar(
        title: const Text('Clue Library'),
        bottom: TabBar(
          controller: _tabController,
          onTap: (_) => setState(() {}),
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: AppTheme.gold,
          tabs: _categoryLabels.map((l) => Tab(text: l)).toList(),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Search clues or answers...',
                prefixIcon: const Icon(Icons.search, color: AppTheme.darkGold),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ),
          // Difficulty filters
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Text('Difficulty: ', style: AppTheme.body(size: 14)),
                const SizedBox(width: 8),
                _buildDifficultyChip(null, 'All'),
                const SizedBox(width: 6),
                _buildDifficultyChip(ClueDifficulty.easy, 'Easy'),
                const SizedBox(width: 6),
                _buildDifficultyChip(ClueDifficulty.medium, 'Med'),
                const SizedBox(width: 6),
                _buildDifficultyChip(ClueDifficulty.hard, 'Hard'),
              ],
            ),
          ),
          Expanded(
            child: AnimatedBuilder2(
              animation: _tabController,
              builder: (context, _) {
                final clues = _filteredClues;
                if (clues.isEmpty) {
                  return Center(
                    child: Text(
                      _searchQuery.isNotEmpty
                          ? 'No clues match "$_searchQuery"'
                          : 'No clues match this filter',
                      style: AppTheme.body(size: 16, color: Colors.grey),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: clues.length,
                  itemBuilder: (context, index) {
                    final clue = clues[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(clue.difficultyEmoji),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    clue.riddle,
                                    style: AppTheme.body(size: 15),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '[${clue.answer}]',
                              style: AppTheme.body(
                                size: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: _selectedClues.contains(clue.riddle)
                                  ? Chip(
                                      label: Text('Added',
                                          style: AppTheme.body(
                                              size: 13, color: Colors.white)),
                                      backgroundColor: AppTheme.adventureGreen,
                                    )
                                  : OutlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          _selectedClues.add(clue.riddle);
                                        });
                                      },
                                      style: OutlinedButton.styleFrom(
                                        minimumSize: const Size(48, 36),
                                        side: const BorderSide(
                                            color: AppTheme.darkGold),
                                      ),
                                      child: Text(
                                        'Add to Hunt +',
                                        style: AppTheme.body(
                                          size: 13,
                                          color: AppTheme.darkGold,
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          if (_selectedClues.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, _selectedClues),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.adventureGreen,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  'Add ${_selectedClues.length} Clue${_selectedClues.length == 1 ? '' : 's'} to Hunt',
                  style: AppTheme.heading(size: 18, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    ));
  }

  Widget _buildDifficultyChip(ClueDifficulty? difficulty, String label) {
    final isSelected = _difficultyFilter == difficulty;
    return GestureDetector(
      onTap: () => setState(() => _difficultyFilter = difficulty),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.darkGold : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}

class AnimatedBuilder2 extends AnimatedWidget {
  final Widget Function(BuildContext, Widget?) builder;

  const AnimatedBuilder2({
    super.key,
    required Listenable animation,
    required this.builder,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return builder(context, null);
  }
}
