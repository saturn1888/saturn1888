import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../data/illustrations.dart';
import '../models/hunt.dart';
import '../services/hunt_sharing_service.dart';
import '../theme/app_theme.dart';
import '../widgets/parchment_background.dart';
import '../widgets/mute_button.dart';
import '../widgets/adventure_widgets.dart';

class JoinHuntScreen extends StatefulWidget {
  const JoinHuntScreen({super.key});

  @override
  State<JoinHuntScreen> createState() => _JoinHuntScreenState();
}

class _JoinHuntScreenState extends State<JoinHuntScreen> {
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  bool _loading = false;
  String? _error;
  bool _showScanner = false;
  bool _codeEntered = false;
  String? _validCode;
  String? _huntName;

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _lookupCode(String code) async {
    final clean = code.toUpperCase().trim();
    if (clean.length < 6) {
      setState(() => _error = 'Code must be 6 characters');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final exists = await HuntSharingService.codeExists(clean);
      if (!mounted) return;

      if (exists) {
        setState(() {
          _validCode = clean;
          _codeEntered = true;
          _loading = false;
        });
      } else {
        setState(() {
          _error = 'Hunt not found. Check the code and try again.';
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Could not connect. Check your internet.';
          _loading = false;
        });
      }
    }
  }

  Future<void> _joinHunt() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Please enter your name or team name');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final hunt = await HuntSharingService.joinHunt(_validCode!);
      if (!mounted) return;

      if (hunt == null) {
        setState(() {
          _error = 'Could not download hunt. Try again.';
          _loading = false;
        });
        return;
      }

      // Save hunt locally
      final box = Hive.box<Hunt>('hunts');
      await box.put(hunt.id, hunt);

      if (mounted) {
        // Navigate to play the hunt
        Navigator.pushReplacementNamed(
          context,
          '/play',
          arguments: hunt,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Download failed. Check your connection.';
          _loading = false;
        });
      }
    }
  }

  void _onQRScanned(String data) {
    // Expect format: OZHUNT:ABCDEF
    String code = data;
    if (data.startsWith('OZHUNT:')) {
      code = data.substring(7);
    }
    setState(() => _showScanner = false);
    _codeController.text = code;
    _lookupCode(code);
  }

  @override
  Widget build(BuildContext context) {
    if (_showScanner) return _buildScanner();

    return ParchmentBackground(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Join a Hunt'),
          actions: const [MuteButton()],
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: _codeEntered ? _buildNameEntry() : _buildCodeEntry(),
          ),
        ),
      ),
    );
  }

  Widget _buildCodeEntry() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(Illustrations.joinIllustration,
            width: 120,
            height: 120,
            errorBuilder: (_, __, ___) =>
                const Text('🗺️', style: TextStyle(fontSize: 64))),
        const SizedBox(height: 16),
        Text('Join a Hunt', style: AppTheme.heading(size: 28)),
        const SizedBox(height: 8),
        Text(
          'Enter the hunt code or scan the QR code\nto join an adventure!',
          style: AppTheme.body(size: 15, color: AppTheme.leather),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),

        // Code input
        TextField(
          controller: _codeController,
          textCapitalization: TextCapitalization.characters,
          textAlign: TextAlign.center,
          style: AppTheme.heading(size: 28),
          maxLength: 6,
          decoration: InputDecoration(
            hintText: 'ABCDEF',
            hintStyle: AppTheme.heading(
                size: 28, color: Colors.grey.withOpacity(0.3)),
            counterText: '',
          ),
        ),
        const SizedBox(height: 16),

        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(_error!,
                style: AppTheme.body(size: 14, color: Colors.red),
                textAlign: TextAlign.center),
          ),

        // Enter code button
        _loading
            ? const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : WoodButton(
                label: 'Find Hunt',
                icon: Icons.search,
                onPressed: () => _lookupCode(_codeController.text),
              ),
        const SizedBox(height: 16),

        // Divider
        Row(
          children: [
            Expanded(
                child: Divider(color: AppTheme.leather.withOpacity(0.3))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('OR',
                  style: AppTheme.body(size: 14, color: Colors.grey)),
            ),
            Expanded(
                child: Divider(color: AppTheme.leather.withOpacity(0.3))),
          ],
        ),
        const SizedBox(height: 16),

        // Scan QR button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => setState(() => _showScanner = true),
            icon: const Icon(Icons.qr_code_scanner),
            label: Text('Scan QR Code',
                style: AppTheme.body(size: 16, color: AppTheme.warmBrown)),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              side: BorderSide(color: AppTheme.leather.withOpacity(0.4)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNameEntry() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(Illustrations.joinIllustration,
            width: 120,
            height: 120,
            errorBuilder: (_, __, ___) =>
                const Text('🎯', style: TextStyle(fontSize: 64))),
        const SizedBox(height: 16),
        Text('Hunt Found!', style: AppTheme.heading(size: 28)),
        const SizedBox(height: 8),
        Text(
          'Enter your name or team name to join.',
          style: AppTheme.body(size: 15, color: AppTheme.leather),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.darkGold.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Code: $_validCode',
            style: AppTheme.heading(size: 18, color: AppTheme.darkGold),
          ),
        ),
        const SizedBox(height: 24),

        TextField(
          controller: _nameController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            hintText: 'Your name or team name',
            prefixIcon: Icon(Icons.person),
          ),
          autofocus: true,
        ),
        const SizedBox(height: 16),

        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(_error!,
                style: AppTheme.body(size: 14, color: Colors.red),
                textAlign: TextAlign.center),
          ),

        _loading
            ? const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                ),
              )
            : WoodButton(
                label: 'Join Hunt!',
                icon: Icons.play_arrow,
                onPressed: _joinHunt,
                color: AppTheme.adventureGreen,
              ),
      ],
    );
  }

  Widget _buildScanner() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        leading: IconButton(
          onPressed: () => setState(() => _showScanner = false),
          icon: const Icon(Icons.close),
        ),
      ),
      body: MobileScanner(
        onDetect: (capture) {
          final barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            if (barcode.rawValue != null) {
              _onQRScanned(barcode.rawValue!);
              return;
            }
          }
        },
      ),
    );
  }
}
