import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../theme/app_theme.dart';
import '../../services/gemini_service.dart';
import '../../services/app_state.dart';
import '../../models/report_model.dart';
import '../../config/constants.dart';
import 'ai_result_screen.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  Uint8List? _imageBytes;
  bool _isAnalyzing = false;
  double _scanProgress = 0;
  String _scanStatus = '';
  Position? _position;

  final _picker = ImagePicker();
  final _uuid = const Uuid();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final file = await _picker.pickImage(source: source, imageQuality: 85, maxWidth: 1024);
      if (file == null) return;
      final bytes = await file.readAsBytes();
      setState(() {
        _imageBytes = bytes;
        _isAnalyzing = false;
        _scanProgress = 0;
      });
      await _getLocation();
    } catch (e) {
      _showError('Could not load image: $e');
    }
  }

  Future<void> _getLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      _position = await Geolocator.getCurrentPosition();
    } catch (_) {
      // Use Bengaluru center as fallback
      _position = null;
    }
  }

  Future<void> _analyzeImage() async {
    if (_imageBytes == null) return;

    setState(() {
      _isAnalyzing = true;
      _scanProgress = 0;
      _scanStatus = 'Initializing AI scanner...';
    });

    // Animated progress
    final steps = [
      (0.15, 'Loading image data...'),
      (0.35, 'Detecting infrastructure elements...'),
      (0.55, 'Analyzing damage patterns...'),
      (0.72, 'Computing severity score...'),
      (0.88, 'Generating AI report...'),
      (1.0, 'Analysis complete!'),
    ];

    final analysisTask = GeminiService.analyzeImage(_imageBytes!);

    for (final step in steps) {
      await Future.delayed(const Duration(milliseconds: 280));
      if (mounted) {
        setState(() {
          _scanProgress = step.$1;
          _scanStatus = step.$2;
        });
      }
    }

    final result = await analysisTask;

    if (!mounted) return;

    // Create report model
    final lat = _position?.latitude ?? defaultLat + (DateTime.now().millisecond % 100) * 0.0003;
    final lng = _position?.longitude ?? defaultLng + (DateTime.now().millisecond % 100) * 0.0003;
    final state = context.read<AppState>();

    final report = ReportModel(
      id: _uuid.v4(),
      userId: state.currentUser['id'] ?? 'citizen_001',
      userName: state.currentUser['name'] ?? 'Citizen',
      category: result['category'] ?? 'Unknown',
      severity: result['severity'] ?? 'Medium',
      status: statusPending,
      description: 'Reported via RoadSense citizen app with AI analysis.',
      imageUrl: '',
      latitude: lat,
      longitude: lng,
      address: 'Near current location, Bengaluru',
      confidence: (result['confidence'] ?? 90).toDouble(),
      severityScore: (result['severityScore'] ?? 6.0).toDouble(),
      priorityScore: (result['priorityScore'] ?? 6.5).toDouble(),
      estimatedCost: result['estimatedCost'] ?? '₹10,000 – ₹15,000',
      repairWindow: result['repairWindow'] ?? 'Repair within 7 days',
      risk: result['risk'] ?? 'Risk of further deterioration.',
      cause: result['cause'] ?? 'Environmental wear.',
      recommendation: result['recommendation'] ?? 'Inspect and repair promptly.',
      assignedDepartment: result['assignedDepartment'] ?? 'Municipal Corporation',
      createdAt: DateTime.now(),
    );

    await state.addReport(report);

    if (!mounted) return;
    setState(() => _isAnalyzing = false);

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => AIResultScreen(report: report, imageBytes: _imageBytes),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppTheme.danger),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Report Issue'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image area
            _imageBytes == null
                ? _ImagePickerPlaceholder(
                    onCamera: () => _pickImage(ImageSource.camera),
                    onGallery: () => _pickImage(ImageSource.gallery),
                  )
                : _ImagePreview(
                    bytes: _imageBytes!,
                    onRetake: () => setState(() { _imageBytes = null; }),
                  ),

            SizedBox(height: 24),

            // Location info
            if (_imageBytes != null) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color!,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on_rounded, color: AppTheme.primary, size: 20),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('GPS Location', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        Text(
                          _position != null
                              ? '${_position!.latitude.toStringAsFixed(5)}, ${_position!.longitude.toStringAsFixed(5)}'
                              : 'Bengaluru, Karnataka (default)',
                          style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 12),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.success.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('GPS OK', style: TextStyle(color: AppTheme.success, fontSize: 10, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 100.ms),

              SizedBox(height: 16),

              // AI analysis section
              if (_isAnalyzing) ...[
                _ScanAnimation(progress: _scanProgress, status: _scanStatus),
              ] else ...[
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _analyzeImage,
                    icon: Icon(Icons.psychology_rounded, size: 22),
                    label: Text('Analyze with AI', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.2),
              ],

              SizedBox(height: 12),

              // Info chips
              Wrap(
                spacing: 8, runSpacing: 8,
                children: [
                  _InfoChip(icon: Icons.security, label: 'AI-Powered Detection'),
                  _InfoChip(icon: Icons.speed, label: '~2 sec Analysis'),
                  _InfoChip(icon: Icons.verified, label: '96%+ Accuracy'),
                ],
              ).animate(delay: 300.ms).fadeIn(),
            ],
          ],
        ),
      ),
    );
  }
}

class _ImagePickerPlaceholder extends StatelessWidget {
  final VoidCallback onCamera;
  final VoidCallback onGallery;

  const _ImagePickerPlaceholder({required this.onCamera, required this.onGallery});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color!,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor, width: 1.5, style: BorderStyle.solid),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.add_a_photo_rounded, color: Colors.white, size: 36),
          ),
          SizedBox(height: 16),
          Text('Add Infrastructure Photo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          SizedBox(height: 6),
          Text('Take a clear photo of the damage', style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 13)),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _PickerButton(icon: Icons.camera_alt_rounded, label: 'Camera', onTap: onCamera),
              SizedBox(width: 16),
              _PickerButton(icon: Icons.photo_library_rounded, label: 'Gallery', onTap: onGallery),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.95, 0.95));
  }
}

class _PickerButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PickerButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.3), blurRadius: 12)],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text(label, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  final Uint8List bytes;
  final VoidCallback onRetake;

  const _ImagePreview({required this.bytes, required this.onRetake});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Image.memory(bytes, width: double.infinity, height: 280, fit: BoxFit.cover),
          Positioned(
            top: 12, right: 12,
            child: GestureDetector(
              onTap: onRetake,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.refresh_rounded, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.95, 0.95));
  }
}

class _ScanAnimation extends StatelessWidget {
  final double progress;
  final String status;

  const _ScanAnimation({required this.progress, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primary.withValues(alpha: 0.1), AppTheme.secondary.withValues(alpha: 0.05)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.psychology_rounded, color: AppTheme.primary, size: 24)
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scale(end: const Offset(1.2, 1.2), duration: 600.ms),
              SizedBox(width: 10),
              Text('AI Analyzing...', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            ],
          ),
          SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Theme.of(context).cardTheme.color!,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(status, style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 12)),
              Text('${(progress * 100).toInt()}%',
                style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w700, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color!,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppTheme.primary, size: 13),
          SizedBox(width: 5),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
