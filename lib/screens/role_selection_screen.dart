import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../config/constants.dart';
import '../services/app_state.dart';
import 'citizen/citizen_home.dart';
import 'admin/admin_dashboard.dart';
import 'engineer/engineer_portal.dart';
import 'analytics/predictive_analytics.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  final _roles = [
    {
      'id': roleCitizen,
      'title': 'Citizen',
      'subtitle': 'Report infrastructure damage\nwith AI assistance',
      'icon': Icons.person_pin_circle_rounded,
      'gradient': [const Color(0xFF3B82F6), const Color(0xFF1D4ED8)],
      'features': ['📷 Photo Upload', '🤖 AI Analysis', '📍 GPS Tracking', '📊 Track Status'],
    },
    {
      'id': roleEngineer,
      'title': 'Field Engineer',
      'subtitle': 'View assigned tasks and\nupdate repair status',
      'icon': Icons.engineering_rounded,
      'gradient': [const Color(0xFF10B981), const Color(0xFF059669)],
      'features': ['📋 Task List', '✅ Status Updates', '📸 Upload Proof', '💰 Cost Entry'],
    },
    {
      'id': roleAdmin,
      'title': 'Government Admin',
      'subtitle': 'Monitor dashboard, assign\nengineers & track repairs',
      'icon': Icons.admin_panel_settings_rounded,
      'gradient': [const Color(0xFF8B5CF6), const Color(0xFF6D28D9)],
      'features': ['📊 Live Dashboard', '🗺️ Map View', '👷 Assign Work', '📈 Analytics'],
    },
    {
      'id': roleDecisionMaker,
      'title': 'Decision Maker',
      'subtitle': 'AI-driven predictive analytics\nfor infrastructure planning',
      'icon': Icons.insights_rounded,
      'gradient': [const Color(0xFFF59E0B), const Color(0xFFD97706)],
      'features': ['🔮 Predictions', '📉 Risk Scores', '💡 AI Insights', '💼 Budget Plan'],
    },
  ];

  bool _isNavigating = false;

  Future<void> _selectRole(BuildContext context, String roleId) async {
    if (_isNavigating) return;
    setState(() => _isNavigating = true);

    // Capture context-dependent objects before any await
    final state = context.read<AppState>();
    final navigator = Navigator.of(context);

    await state.setRole(roleId);

    Widget destination;
    switch (roleId) {
      case roleEngineer:
        destination = const EngineerPortal();
        break;
      case roleAdmin:
        destination = const AdminDashboard();
        break;
      case roleDecisionMaker:
        destination = const PredictiveAnalytics();
        break;
      default:
        destination = const CitizenHome();
    }

    if (!mounted) return;
    await navigator.push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => destination,
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        ),
      ),
    );

    setState(() => _isNavigating = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.darkBgGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.psychology_rounded, color: Colors.white, size: 26),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('RoadSense', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                        Text('Select your role to continue', style: TextStyle(fontSize: 12, color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey))),
                      ],
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms),

                SizedBox(height: 32),

                Text(
                  'Who are\nyou today?',
                  style: Theme.of(context).textTheme.displayLarge,
                ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.2),

                SizedBox(height: 8),

                Text(
                  'Choose your role to access the right portal',
                  style: Theme.of(context).textTheme.bodyMedium,
                ).animate(delay: 200.ms).fadeIn(),

                SizedBox(height: 28),

                // Role cards
                ...List.generate(_roles.length, (i) {
                  final role = _roles[i];
                  return _RoleCard(
                    role: role,
                    delay: Duration(milliseconds: 300 + i * 100),
                    onTap: () => _selectRole(context, role['id'] as String),
                  );
                }),

                SizedBox(height: 20),

                // Footer
                Center(
                  child: Column(
                    children: [
                      Text(
                        'RoadSense v1.0 • Hackathon Prototype',
                        style: TextStyle(fontSize: 11, color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey).withValues(alpha: 0.5)),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'SDG 9 — Sustainable Infrastructure',
                        style: TextStyle(fontSize: 11, color: AppTheme.success.withValues(alpha: 0.7)),
                      ),
                    ],
                  ),
                ).animate(delay: 800.ms).fadeIn(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatefulWidget {
  final Map<String, dynamic> role;
  final Duration delay;
  final VoidCallback onTap;

  const _RoleCard({required this.role, required this.delay, required this.onTap});

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final gradColors = widget.role['gradient'] as List<Color>;
    final features = widget.role['features'] as List<String>;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _hovered = true),
      onTapUp: (_) => setState(() => _hovered = false),
      onTapCancel: () => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 16),
        transform: Matrix4.identity()..scaleByDouble(_hovered ? 0.97 : 1.0, _hovered ? 0.97 : 1.0, 1.0, 1.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              gradColors[0].withValues(alpha: 0.15),
              gradColors[1].withValues(alpha: 0.05),
            ],
          ),
          border: Border.all(
            color: gradColors[0].withValues(alpha: _hovered ? 0.6 : 0.3),
            width: 1.5,
          ),
          boxShadow: _hovered ? [
            BoxShadow(
              color: gradColors[0].withValues(alpha: 0.2),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ] : [],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Icon
              Container(
                width: 60, height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradColors),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: gradColors[0].withValues(alpha: 0.35),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(widget.role['icon'] as IconData, color: Colors.white, size: 30),
              ),
              SizedBox(width: 16),
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.role['title'] as String,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.role['subtitle'] as String,
                      style: TextStyle(fontSize: 12, color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), height: 1.4),
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 6, runSpacing: 4,
                      children: features.take(2).map((f) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: gradColors[0].withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(f, style: TextStyle(fontSize: 10, color: gradColors[0])),
                      )).toList(),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: gradColors[0], size: 16),
            ],
          ),
        ),
      ),
    ).animate(delay: widget.delay).fadeIn(duration: 400.ms).slideX(begin: 0.1);
  }
}
