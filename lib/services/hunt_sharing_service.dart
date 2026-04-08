import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import '../models/hunt.dart';
import '../models/clue.dart';
import '../models/hunt_theme.dart';
import '../models/treasure_item.dart';

class HuntSharingService {
  static final _firestore = FirebaseFirestore.instance;
  static final _storage = FirebaseStorage.instance;

  /// Generate a short 6-character alphanumeric code
  static String _generateCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // No I/O/0/1 to avoid confusion
    final rng = Random();
    return List.generate(6, (_) => chars[rng.nextInt(chars.length)]).join();
  }

  /// Upload a hunt to Firebase and return the share code
  static Future<String> shareHunt(Hunt hunt) async {
    final code = _generateCode();
    final huntRef = _firestore.collection('shared_hunts').doc(code);

    // Upload clue photos
    final clueData = <Map<String, dynamic>>[];
    for (int i = 0; i < hunt.clues.length; i++) {
      final clue = hunt.clues[i];
      String? photoUrl;
      if (clue.photoPath != null && File(clue.photoPath!).existsSync()) {
        photoUrl = await _uploadPhoto(
          File(clue.photoPath!),
          'hunts/$code/clues/clue_$i.jpg',
        );
      }
      clueData.add({
        'text': clue.text,
        'photoUrl': photoUrl,
        'wrongAnswerHint': clue.wrongAnswerHint,
        'order': clue.order,
      });
    }

    // Upload treasure item photos
    final itemData = <Map<String, dynamic>>[];
    if (hunt.treasureItems != null) {
      for (int i = 0; i < hunt.treasureItems!.length; i++) {
        final item = hunt.treasureItems![i];
        String? photoUrl;
        if (item.photoPath != null && File(item.photoPath!).existsSync()) {
          photoUrl = await _uploadPhoto(
            File(item.photoPath!),
            'hunts/$code/items/item_$i.jpg',
          );
        }
        itemData.add({
          'name': item.name,
          'photoUrl': photoUrl,
          'assignedClueIndex': item.assignedClueIndex,
        });
      }
    }

    // Upload prize photo
    String? prizePhotoUrl;
    if (hunt.prizePhotoPath != null &&
        File(hunt.prizePhotoPath!).existsSync()) {
      prizePhotoUrl = await _uploadPhoto(
        File(hunt.prizePhotoPath!),
        'hunts/$code/prize.jpg',
      );
    }

    // Save hunt data to Firestore
    await huntRef.set({
      'name': hunt.name,
      'themeType': hunt.themeType.index,
      'clues': clueData,
      'treasureItems': itemData,
      'timerMinutes': hunt.timerMinutes,
      'victoryMessage': hunt.victoryMessage,
      'prizeDescription': hunt.prizeDescription,
      'prizePhotoUrl': prizePhotoUrl,
      'createdAt': FieldValue.serverTimestamp(),
      'code': code,
    });

    return code;
  }

  /// Download a shared hunt by code
  static Future<Hunt?> joinHunt(String code) async {
    final upperCode = code.toUpperCase().trim();
    final doc =
        await _firestore.collection('shared_hunts').doc(upperCode).get();

    if (!doc.exists) return null;

    final data = doc.data()!;
    final appDir = await getApplicationDocumentsDirectory();

    // Download clue photos and build clues
    final cluesData = data['clues'] as List<dynamic>;
    final clues = <Clue>[];
    for (int i = 0; i < cluesData.length; i++) {
      final c = cluesData[i] as Map<String, dynamic>;
      String? localPhotoPath;
      if (c['photoUrl'] != null) {
        localPhotoPath = await _downloadPhoto(
          c['photoUrl'] as String,
          '${appDir.path}/shared_hunts/$upperCode/clue_$i.jpg',
        );
      }
      clues.add(Clue(
        text: c['text'] as String,
        photoPath: localPhotoPath,
        wrongAnswerHint: c['wrongAnswerHint'] as String?,
        order: c['order'] as int? ?? i,
      ));
    }

    // Download treasure item photos
    final itemsData = data['treasureItems'] as List<dynamic>? ?? [];
    final items = <TreasureItem>[];
    for (int i = 0; i < itemsData.length; i++) {
      final item = itemsData[i] as Map<String, dynamic>;
      String? localPhotoPath;
      if (item['photoUrl'] != null) {
        localPhotoPath = await _downloadPhoto(
          item['photoUrl'] as String,
          '${appDir.path}/shared_hunts/$upperCode/item_$i.jpg',
        );
      }
      items.add(TreasureItem(
        name: item['name'] as String,
        photoPath: localPhotoPath,
        assignedClueIndex: item['assignedClueIndex'] as int?,
      ));
    }

    // Download prize photo
    String? localPrizePhoto;
    if (data['prizePhotoUrl'] != null) {
      localPrizePhoto = await _downloadPhoto(
        data['prizePhotoUrl'] as String,
        '${appDir.path}/shared_hunts/$upperCode/prize.jpg',
      );
    }

    return Hunt(
      id: 'shared_$upperCode',
      name: data['name'] as String,
      themeType: HuntThemeType.values[data['themeType'] as int],
      clues: clues,
      timerMinutes: data['timerMinutes'] as int?,
      victoryMessage:
          data['victoryMessage'] as String? ?? 'You did it! 🎉',
      prizeDescription: data['prizeDescription'] as String?,
      prizePhotoPath: localPrizePhoto,
      treasureItems: items.isEmpty ? null : items,
    );
  }

  /// Check if a share code exists
  static Future<bool> codeExists(String code) async {
    final doc = await _firestore
        .collection('shared_hunts')
        .doc(code.toUpperCase().trim())
        .get();
    return doc.exists;
  }

  /// Submit a time to the hunt leaderboard
  static Future<void> submitTime({
    required String huntId,
    required String teamName,
    required int timeTakenSeconds,
    required int clueCount,
  }) async {
    // Only submit for shared hunts (id starts with "shared_")
    final code = huntId.replaceFirst('shared_', '');
    if (code == huntId) return; // not a shared hunt

    try {
      await _firestore
          .collection('shared_hunts')
          .doc(code)
          .collection('leaderboard')
          .add({
        'teamName': teamName,
        'timeTakenSeconds': timeTakenSeconds,
        'clueCount': clueCount,
        'completedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Silently fail — leaderboard is optional
    }
  }

  /// Get top times for a shared hunt
  static Future<List<Map<String, dynamic>>> getLeaderboard(
      String huntId) async {
    final code = huntId.replaceFirst('shared_', '');
    if (code == huntId) return [];

    try {
      final snapshot = await _firestore
          .collection('shared_hunts')
          .doc(code)
          .collection('leaderboard')
          .orderBy('timeTakenSeconds')
          .limit(10)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<String?> _uploadPhoto(File file, String path) async {
    try {
      final ref = _storage.ref().child(path);
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  static Future<String?> _downloadPhoto(
      String url, String localPath) async {
    try {
      final file = File(localPath);
      await file.parent.create(recursive: true);
      final ref = _storage.refFromURL(url);
      await ref.writeToFile(file);
      return file.path;
    } catch (e) {
      return null;
    }
  }
}
