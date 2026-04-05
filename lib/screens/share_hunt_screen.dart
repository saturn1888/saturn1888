import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/hunt.dart';
import '../services/hunt_sharing_service.dart';
import '../theme/app_theme.dart';
import '../widgets/parchment_background.dart';
import '../widgets/mute_button.dart';

class ShareHuntScreen extends StatefulWidget {
  const ShareHuntScreen({super.key});

  @override
  State<ShareHuntScreen> createState() => _ShareHuntScreenState();
}

class _ShareHuntScreenState extends State<ShareHuntScreen> {
  String? _code;
  bool _uploading = true;
  String? _error;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final hunt = ModalRoute.of(context)!.settings.arguments as Hunt;
      _uploadHunt(hunt);
    }
  }

  Future<void> _uploadHunt(Hunt hunt) async {
    try {
      final code = await HuntSharingService.shareHunt(hunt);
      if (mounted) {
        setState(() {
          _code = code;
          _uploading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Could not share hunt. Check your internet connection.';
          _uploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ParchmentBackground(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Share Hunt'),
          actions: const [MuteButton()],
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: _uploading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                          color: AppTheme.darkGold),
                      const SizedBox(height: 24),
                      Text('Uploading hunt...',
                          style: AppTheme.heading(size: 20)),
                      const SizedBox(height: 8),
                      Text('This may take a moment if there are photos.',
                          style: AppTheme.body(
                              size: 14, color: Colors.grey)),
                    ],
                  )
                : _error != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('😕',
                              style: TextStyle(fontSize: 64)),
                          const SizedBox(height: 16),
                          Text(_error!,
                              style: AppTheme.body(
                                  size: 16, color: Colors.red),
                              textAlign: TextAlign.center),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Go Back'),
                          ),
                        ],
                      )
                    : _buildShareContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildShareContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Hunt Ready to Share!',
            style: AppTheme.heading(size: 24)),
        const SizedBox(height: 8),
        Text(
          'Friends can join using the code or QR below.',
          style: AppTheme.body(size: 14, color: AppTheme.leather),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),

        // QR Code
        Card(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: QrImageView(
              data: 'OZHUNT:$_code',
              version: QrVersions.auto,
              size: 200,
              backgroundColor: Colors.white,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.roundedOuter,
                color: Color(0xFF3E2723),
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.roundedOuter,
                color: Color(0xFF3E2723),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Text code
        Text('Or share this code:',
            style: AppTheme.body(size: 14, color: Colors.grey)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: _code!));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Code copied to clipboard!'),
                backgroundColor: Colors.green,
              ),
            );
          },
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            decoration: BoxDecoration(
              color: AppTheme.warmBrown,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.brown.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _code!,
                  style: AppTheme.heading(
                    size: 32,
                    color: const Color(0xFFFFD480),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.copy,
                    color: const Color(0xFFFFD480).withOpacity(0.7),
                    size: 20),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text('Tap to copy',
            style: AppTheme.body(size: 12, color: Colors.grey)),

        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () =>
                Navigator.popUntil(context, (route) => route.isFirst),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.gold,
              foregroundColor: AppTheme.warmBrown,
            ),
            child: Text('Done',
                style:
                    AppTheme.heading(size: 20, color: AppTheme.warmBrown)),
          ),
        ),
      ],
    );
  }
}
