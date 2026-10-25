import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../services/app_state.dart';
import '../../config/constants.dart';
import '../role_selection_screen.dart';
import 'report_screen.dart';
import 'complaint_history.dart';
import '../map/map_dashboard.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/issue_card.dart';

class CitizenHome extends StatefulWidget {
  const CitizenHome({super.key});

  @override
  State<CitizenHome> createState() => _CitizenHomeState();
}

class _CitizenHomeState extends State<CitizenHome> {
  int _currentIndex = 0;

  final _pages = const [
    _CitizenHomePage(),
    MapDashboard(),
    ComplaintHistory(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(top: BorderSide(color: Theme.of(context).dividerColor, width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          backgroundColor: Colors.transparent,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.map_rounded), label: 'Map'),
            BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: 'History'),
          ],
        ),
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ReportScreen()),
              ),
              backgroundColor: AppTheme.primary,
              icon: Icon(Icons.camera_alt_rounded, color: Colors.white),
              label: Text('Report Issue', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            )
          : null,
    );
  }
}

class _CitizenHomePage extends StatelessWidget {
  const _CitizenHomePage();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.currentUser;
    final myReports = state.myReports;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            actions: [
              IconButton(
                icon: Icon(Icons.switch_account_rounded),
                onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(gradient: AppTheme.darkBgGradient),
                child: Stack(
                  children: [
                    Positioned(
                      top: -60, right: -60,
                      child: Container(
                        width: 200, height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(colors: [
                            AppTheme.primary.withValues(alpha: 0.2),
                            Colors.transparent,
                          ]),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Hello, ${user['name']?.split(' ').first ?? 'Citizen'} 👋',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Report infrastructure issues in your area',
                            style: TextStyle(fontSize: 13, color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Stats
                  Row(
                    children: [
                      Expanded(child: StatCard(
                        label: 'My Reports',
                        value: '${myReports.length}',
                        icon: Icons.report_rounded,
                        color: AppTheme.primary,
                      ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2)),
                      SizedBox(width: 12),
                      Expanded(child: StatCard(
                        label: 'Resolved',
                        value: '${myReports.where((r) => r.status == statusResolved).length}',
                        icon: Icons.check_circle_rounded,
                        color: AppTheme.success,
                      ).animate(delay: 100.ms).fadeIn(duration: 400.ms).slideY(begin: 0.2)),
                      SizedBox(width: 12),
                      Expanded(child: StatCard(
                        label: 'Pending',
                        value: '${myReports.where((r) => r.status == statusPending).length}',
                        icon: Icons.pending_rounded,
                        color: AppTheme.warning,
                      ).animate(delay: 200.ms).fadeIn(duration: 400.ms).slideY(begin: 0.2)),
                    ],
                  ),

                  SizedBox(height: 24),

                  // Quick Actions
                  Text('Quick Actions', style: Theme.of(context).textTheme.headlineMedium),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      _QuickAction(
                        icon: Icons.camera_alt_rounded,
                        label: 'Report\nIssue',
                        gradient: AppTheme.primaryGradient,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ReportScreen()),
                        ),
                      ),
                      SizedBox(width: 12),
                      _QuickAction(
                        icon: Icons.map_rounded,
                        label: 'View\nMap',
                        gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)]),
                        onTap: () {},
                      ),
                      SizedBox(width: 12),
                      _QuickAction(
                        icon: Icons.history_rounded,
                        label: 'My\nHistory',
                        gradient: const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)]),
                        onTap: () {},
                      ),
                      SizedBox(width: 12),
                      _QuickAction(
                        icon: Icons.notifications_rounded,
                        label: 'Alerts',
                        gradient: const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFD97706)]),
                        onTap: () {},
                      ),
                    ],
                  ),

                  SizedBox(height: 24),

                  // City-wide stats banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.primary.withValues(alpha: 0.15), AppTheme.secondary.withValues(alpha: 0.1)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.location_city_rounded, color: AppTheme.primary, size: 32),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Bengaluru City Status', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                              SizedBox(height: 4),
                              Text(
                                '${state.reports.length} total reports • ${state.resolvedReports.length} resolved • ${state.pendingReports.length} pending',
                                style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.success.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${state.resolutionRate.toStringAsFixed(0)}%',
                            style: TextStyle(color: AppTheme.success, fontWeight: FontWeight.w700, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ).animate(delay: 300.ms).fadeIn(),

                  SizedBox(height: 24),

                  // Recent reports from city
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Recent City Reports', style: Theme.of(context).textTheme.headlineMedium),
                      TextButton(
                        onPressed: () {},
                        child: Text('See All'),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),

                  ...state.reports.take(5).toList().asMap().entries.map((entry) =>
                    IssueCard(
                      report: entry.value,
                      onTap: () {},
                    ).animate(delay: Duration(milliseconds: 400 + entry.key * 80)).fadeIn().slideY(begin: 0.1)
                  ),

                  SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradient.colors.map((c) => c.withValues(alpha: 0.15)).toList(),
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: (gradient.colors.first).withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              ShaderMask(
                shaderCallback: (b) => gradient.createShader(b),
                child: Icon(icon, color: Colors.white, size: 26),
              ),
              SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
