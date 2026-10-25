import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../theme/app_theme.dart';
import '../../services/app_state.dart';
import '../../models/report_model.dart';
import '../../config/constants.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/issue_card.dart';
import '../map/map_dashboard.dart';
import '../role_selection_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _AdminHomePage(),
          MapDashboard(),
          _IssueListPage(),
        ],
      ),
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
            BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
            BottomNavigationBarItem(icon: Icon(Icons.map_rounded), label: 'Map'),
            BottomNavigationBarItem(icon: Icon(Icons.list_rounded), label: 'Issues'),
          ],
        ),
      ),
    );
  }
}

class _AdminHomePage extends StatelessWidget {
  const _AdminHomePage();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
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
                padding: const EdgeInsets.fromLTRB(20, 70, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        ShaderMask(
                          shaderCallback: (b) => AppTheme.primaryGradient.createShader(b),
                          child: Icon(Icons.psychology_rounded, color: Colors.white, size: 24),
                        ),
                        SizedBox(width: 8),
                        Text('Admin Dashboard', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.success.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Container(width: 6, height: 6, decoration: BoxDecoration(color: AppTheme.success, shape: BoxShape.circle)),
                              SizedBox(width: 5),
                              Text('Live', style: TextStyle(color: AppTheme.success, fontSize: 11, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
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
                  // KPI Cards
                  _buildKPIRow(context, state),
                  SizedBox(height: 20),
                  // Resolution rate ring
                  _ResolutionRing(state: state).animate(delay: 300.ms).fadeIn(),
                  SizedBox(height: 20),
                  // Trend chart
                  _TrendChart(state: state).animate(delay: 400.ms).fadeIn(),
                  SizedBox(height: 20),
                  // Category pie
                  _CategoryChart(state: state).animate(delay: 500.ms).fadeIn(),
                  SizedBox(height: 20),
                  // Live reports
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Critical Issues', style: Theme.of(context).textTheme.headlineMedium),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.danger.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('${state.criticalReports.length}', style: TextStyle(color: AppTheme.danger, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  ...state.criticalReports.take(5).toList().asMap().entries.map(
                    (e) => IssueCard(
                      report: e.value,
                      showStatus: true,
                      showAssign: true,
                      onTap: () => _showAssignSheet(context, e.value),
                    ).animate(delay: Duration(milliseconds: 600 + e.key * 80)).fadeIn().slideY(begin: 0.1),
                  ),
                  SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKPIRow(BuildContext context, AppState state) {
    final kpis = [
      {'label': "Today's Reports", 'value': '${state.todayReports}', 'icon': Icons.today_rounded, 'color': AppTheme.primary},
      {'label': 'Pending', 'value': '${state.pendingReports.length}', 'icon': Icons.pending_rounded, 'color': AppTheme.danger},
      {'label': 'Resolved', 'value': '${state.resolvedReports.length}', 'icon': Icons.check_circle_rounded, 'color': AppTheme.success},
      {'label': 'Avg Response', 'value': '${state.avgResponseTimeHours.toStringAsFixed(0)}h', 'icon': Icons.timer_rounded, 'color': AppTheme.warning},
    ];

    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.35,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: kpis.asMap().entries.map((e) => StatCard(
        label: e.value['label'] as String,
        value: e.value['value'] as String,
        icon: e.value['icon'] as IconData,
        color: e.value['color'] as Color,
      ).animate(delay: Duration(milliseconds: 100 + e.key * 80)).fadeIn().slideY(begin: 0.2)).toList(),
    );
  }

  void _showAssignSheet(BuildContext context, ReportModel report) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardTheme.color!,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _AssignEngineerSheet(report: report),
    );
  }
}

class _ResolutionRing extends StatelessWidget {
  final AppState state;
  const _ResolutionRing({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color!,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Performance Overview', style: Theme.of(context).textTheme.headlineMedium),
          SizedBox(height: 16),
          Row(
            children: [
              CircularPercentIndicator(
                radius: 60,
                lineWidth: 10,
                percent: (state.resolutionRate / 100).clamp(0.0, 1.0),
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${state.resolutionRate.toStringAsFixed(0)}%',
                      style: TextStyle(color: AppTheme.success, fontWeight: FontWeight.w800, fontSize: 18),
                    ),
                    Text('Resolved', style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 9)),
                  ],
                ),
                progressColor: AppTheme.success,
                backgroundColor: AppTheme.success.withValues(alpha: 0.1),
                circularStrokeCap: CircularStrokeCap.round,
              ),
              SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: [
                    _ProgressStat(label: 'Resolved', value: state.resolvedReports.length, total: state.reports.length, color: AppTheme.success),
                    SizedBox(height: 8),
                    _ProgressStat(label: 'In Progress', value: state.reports.where((r) => r.status == statusInProgress).length, total: state.reports.length, color: AppTheme.primary),
                    SizedBox(height: 8),
                    _ProgressStat(label: 'Pending', value: state.pendingReports.length, total: state.reports.length, color: AppTheme.danger),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressStat extends StatelessWidget {
  final String label;
  final int value;
  final int total;
  final Color color;

  const _ProgressStat({required this.label, required this.value, required this.total, required this.color});

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? value / total : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(fontSize: 12)),
            Text('$value', style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12)),
          ],
        ),
        SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: pct.clamp(0.0, 1.0),
            minHeight: 5,
            backgroundColor: color.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class _TrendChart extends StatelessWidget {
  final AppState state;
  const _TrendChart({required this.state});

  @override
  Widget build(BuildContext context) {
    final data = state.reportsLast30Days;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color!,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reports — Last 30 Days', style: Theme.of(context).textTheme.headlineMedium),
          SizedBox(height: 4),
          Text('${data.reduce((a, b) => a + b)} total reports', style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 12)),
          SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => FlLine(color: Theme.of(context).dividerColor, strokeWidth: 0.5),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 20,
                      interval: 7,
                      getTitlesWidget: (val, _) => Text(
                        '${val.toInt() + 1}d',
                        style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 9),
                      ),
                    ),
                  ),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.toDouble())).toList(),
                    isCurved: true,
                    color: AppTheme.primary,
                    barWidth: 2.5,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppTheme.primary.withValues(alpha: 0.3), AppTheme.primary.withValues(alpha: 0.0)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChart extends StatefulWidget {
  final AppState state;
  const _CategoryChart({required this.state});

  @override
  State<_CategoryChart> createState() => _CategoryChartState();
}

class _CategoryChartState extends State<_CategoryChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final byCategory = widget.state.reportsByCategory;
    final entries = byCategory.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final colors = [AppTheme.primary, AppTheme.danger, AppTheme.warning, AppTheme.success, AppTheme.secondary, AppTheme.accent, const Color(0xFFF97316), AppTheme.primaryLight];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color!,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Issues by Category', style: Theme.of(context).textTheme.headlineMedium),
          SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                height: 160,
                width: 160,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (event, response) {
                        if (!event.isInterestedForInteractions || response == null || response.touchedSection == null) {
                          setState(() => _touchedIndex = -1);
                          return;
                        }
                        setState(() => _touchedIndex = response.touchedSection!.touchedSectionIndex);
                      },
                    ),
                    sections: entries.asMap().entries.map((e) {
                      final isTouched = e.key == _touchedIndex;
                      final color = colors[e.key % colors.length];
                      return PieChartSectionData(
                        color: color,
                        value: e.value.value.toDouble(),
                        title: isTouched ? '${e.value.value}' : '',
                        radius: isTouched ? 60 : 50,
                        titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                        badgeWidget: isTouched ? Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
                          child: Text(e.value.key.split(' ').first, style: TextStyle(fontSize: 8, color: Colors.white)),
                        ) : null,
                        badgePositionPercentageOffset: 1.4,
                      );
                    }).toList(),
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: entries.asMap().entries.take(5).map((e) {
                    final color = colors[e.key % colors.length];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 7),
                      child: Row(
                        children: [
                          Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                          SizedBox(width: 6),
                          Expanded(child: Text(e.value.key, style: TextStyle(fontSize: 11), overflow: TextOverflow.ellipsis)),
                          Text('${e.value.value}', style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 11)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IssueListPage extends StatefulWidget {
  const _IssueListPage();

  @override
  State<_IssueListPage> createState() => _IssueListPageState();
}

class _IssueListPageState extends State<_IssueListPage> {
  String _sort = 'Priority';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    var reports = List.from(state.reports);
    if (_sort == 'Priority') {
      reports.sort((a, b) => b.priorityScore.compareTo(a.priorityScore));
    } else if (_sort == 'Date') {
      reports.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('All Issues'),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.sort_rounded),
            onSelected: (v) => setState(() => _sort = v),
            itemBuilder: (_) => ['Priority', 'Date', 'Severity'].map((s) =>
              PopupMenuItem(value: s, child: Text(s))
            ).toList(),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: reports.length,
        itemBuilder: (ctx, i) => IssueCard(
          report: reports[i],
          showStatus: true,
          showAssign: true,
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Theme.of(context).cardTheme.color!,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
              builder: (_) => _AssignEngineerSheet(report: reports[i]),
            );
          },
        ).animate(delay: Duration(milliseconds: i * 40)).fadeIn(),
      ),
    );
  }
}

class _AssignEngineerSheet extends StatefulWidget {
  final ReportModel report;
  const _AssignEngineerSheet({required this.report});

  @override
  State<_AssignEngineerSheet> createState() => _AssignEngineerSheetState();
}

class _AssignEngineerSheetState extends State<_AssignEngineerSheet> {
  String? _selectedEngineerId;

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();
    final color = AppTheme.severityColor(widget.report.severity);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Theme.of(context).dividerColor, borderRadius: BorderRadius.circular(2))),
            ),
            SizedBox(height: 16),
            Text(widget.report.category, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                  child: Text(widget.report.severity, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
                ),
                SizedBox(width: 8),
                Text(widget.report.address, style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 12)),
              ],
            ),
            SizedBox(height: 20),
            Text('Assign Engineer', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            SizedBox(height: 10),
            ...demoEngineers.map((eng) {
              final isSelected = _selectedEngineerId == eng['id'];
              return GestureDetector(
                onTap: () => setState(() => _selectedEngineerId = eng['id']),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primary.withValues(alpha: 0.15) : Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isSelected ? AppTheme.primary : Theme.of(context).dividerColor),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: AppTheme.primary.withValues(alpha: 0.2),
                        child: Text(eng['name']![0], style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w700)),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(eng['name']!, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                            Text('Zone: ${eng['zone']}  •  ${eng['phone']}', style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 11)),
                          ],
                        ),
                      ),
                      if (isSelected) Icon(Icons.check_circle_rounded, color: AppTheme.primary),
                    ],
                  ),
                ),
              );
            }),
            SizedBox(height: 12),
            if (widget.report.status != statusResolved) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedEngineerId == null ? null : () async {
                    final eng = demoEngineers.firstWhere((e) => e['id'] == _selectedEngineerId);
                    await state.assignEngineer(widget.report.id, _selectedEngineerId!, eng['name']!);
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Assigned to ${eng['name']}'),
                        backgroundColor: AppTheme.success,
                      ));
                    }
                  },
                  child: Text('Assign Engineer'),
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () async {
                    await state.updateReportStatus(widget.report.id, statusResolved,
                      resolutionNote: 'Marked resolved by admin.',
                    );
                    if (context.mounted) Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppTheme.success),
                    foregroundColor: AppTheme.success,
                  ),
                  child: Text('Mark as Resolved'),
                ),
              ),
            ],
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
