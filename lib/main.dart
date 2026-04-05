import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/hunt_theme.dart';
import 'models/clue.dart';
import 'models/hunt.dart';
import 'models/trophy.dart';
import 'models/treasure_item.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/hunt_setup_screen.dart';
import 'screens/clue_builder_screen.dart';
import 'screens/clue_editor_screen.dart';
import 'screens/clue_library_screen.dart';
import 'screens/review_screen.dart';
import 'screens/play_select_screen.dart';
import 'screens/clue_screen.dart';
import 'screens/victory_screen.dart';
import 'screens/trophy_cabinet_screen.dart';
import 'screens/manage_hunts_screen.dart';
import 'screens/treasure_items_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(HuntThemeTypeAdapter());
  Hive.registerAdapter(ClueAdapter());
  Hive.registerAdapter(HuntAdapter());
  Hive.registerAdapter(TrophyAdapter());
  Hive.registerAdapter(TreasureItemAdapter());

  await Hive.openBox<Hunt>('hunts');
  await Hive.openBox<Trophy>('trophies');

  runApp(const OzHuntApp());
}

class OzHuntApp extends StatelessWidget {
  const OzHuntApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OzHunt',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/setup': (context) => const HuntSetupScreen(),
        '/clue-builder': (context) => const ClueBuilderScreen(),
        '/clue-editor': (context) => const ClueEditorScreen(),
        '/clue-library': (context) => const ClueLibraryScreen(),
        '/review': (context) => const ReviewScreen(),
        '/play-select': (context) => const PlaySelectScreen(),
        '/play': (context) => const ClueScreen(),
        '/victory': (context) => const VictoryScreen(),
        '/trophies': (context) => const TrophyCabinetScreen(),
        '/manage': (context) => const ManageHuntsScreen(),
        '/treasure-items': (context) => const TreasureItemsScreen(),
      },
    );
  }
}
