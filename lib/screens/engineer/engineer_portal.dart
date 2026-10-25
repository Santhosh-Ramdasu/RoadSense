import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../services/app_state.dart';
import '../../models/report_model.dart';
import '../../config/constants.dart';
import '../role_selection_screen.dart';

class EngineerPortal extends StatefulWidget {
  const EngineerPortal({super.key});

  @override
  State<EngineerPortal> createState() => _EngineerPortalState();
}

class _EngineerPortalState extends State<EngineerPortal> {
  String _filter = 'Active';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final engineerId = state.currentUser['id'] ?? 'eng001';
    var myTasks = state.engineerReports(engineerId);

    // If no specific tasks, show some assigned ones for demo
    if (myTasks.isEmpty) {
      myTasks = state.reports.where((r) => r.status == statusAssigned || r.status == statusInProgress).take(8).toList();
    }

    final filtered = _filter == 'All'
        ? myTasks
        : _filter == 'Active'
            ? myTasks.where((r) => r.status != statusResolved).toList()
            : myTasks.where((r) => r.status == statusResolved).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 150,
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
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF064E3B), Color(0xFF0A0E1A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 70, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)]),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.engineering_rounded, color: Colors.white, size: 24),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(state.currentUser['name'] ?? 'Engineer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                            Row(
                              children: [
                                Icon(Icons.circle, color: AppTheme.success, size: 8),
                                SizedBox(width: 4),
                                Text('On Duty', style: TextStyle(color: AppTheme.success, fontSize: 12, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ],
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
                  // Stats
                  Row(
                    children: [
                      Expanded(child: _EngineerStat(
                        label: 'Assigned',
                        value: '${myTasks.where((r) => r.status == statusAssigned).length}',
                        icon: Icons.assignment_rounded,
                        color: AppTheme.warning,
                      ).animate().fadeIn()),
                      SizedBox(width: 12),
                      Expanded(child: _EngineerStat(
                        label: 'In Progress',
                        value: '${myTasks.where((r) => r.status == statusInProgress).length}',
                        icon: Icons.build_rounded,
                        color: AppTheme.primary,
                      ).animate(delay: 100.ms).fadeIn()),
                      SizedBox(width: 12),
                      Expanded(child: _EngineerStat(
                        label: 'Completed',
                        value: '${myTasks.where((r) => r.status == statusResolved).length}',
                        icon: Icons.check_circle_rounded,
                        color: AppTheme.success,
                      ).animate(delay: 200.ms).fadeIn()),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Filter tabs
                  Row(
                    children: ['Active', 'Completed', 'All'].map((f) {
                      final isSelected = _filter == f;
                      return GestureDetector(
                        onTap: () => setState(() => _filter = f),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.success : Theme.of(context).cardTheme.color!,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected ? AppTheme.success : Theme.of(context).dividerColor,
                            ),
                          ),
                          child: Text(f, style: TextStyle(
                            color: isSelected ? Colors.white : (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey),
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                            fontSize: 13,
                          )),
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 16),

                  if (filtered.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          children: [
                            Icon(Icons.task_alt, size: 48, color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey).withValues(alpha: 0.4)),
                            SizedBox(height: 12),
                            Text('No tasks in this category', style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey))),
                          ],
                        ),
                      ),
                    )
                  else
                    ...filtered.asMap().entries.map((e) => _EngineerTaskCard(
                      report: e.value,
                    ).animate(delay: Duration(milliseconds: 300 + e.key * 70)).fadeIn().slideY(begin: 0.1)),

                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EngineerStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _EngineerStat({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          SizedBox(height: 6),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 22)),
          SizedBox(height: 2),
          Text(label, style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 10), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _EngineerTaskCard extends StatefulWidget {
  final ReportModel report;
  const _EngineerTaskCard({required this.report});

  @override
  State<_EngineerTaskCard> createState() => _EngineerTaskCardState();
}

class _EngineerTaskCardState extends State<_EngineerTaskCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();
    final color = AppTheme.severityColor(widget.report.severity);
    final statusColor = AppTheme.statusColor(widget.report.status);

    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color!,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _expanded ? AppTheme.success.withValues(alpha: 0.5) : Theme.of(context).dividerColor),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.construction_rounded, color: color, size: 22),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.report.category, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                        SizedBox(height: 2),
                        Text(widget.report.address, style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(widget.report.severity, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w700)),
                            ),
                            SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(widget.report.status, style: TextStyle(color: statusColor, fontSize: 9, fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(_expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded, color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey)),
                ],
              ),
            ),

            if (_expanded) ...[
              Divider(color: Theme.of(context).dividerColor, height: 1),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DetailRow(label: 'Est. Cost', value: widget.report.estimatedCost),
                    _DetailRow(label: 'Action Required', value: widget.report.repairWindow),
                    _DetailRow(label: 'AI Confidence', value: '${widget.report.confidence.toStringAsFixed(1)}%'),
                    SizedBox(height: 4),
                    Text('Recommendation:', style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 12, fontWeight: FontWeight.w600)),
                    SizedBox(height: 4),
                    Text(widget.report.recommendation, style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 12, height: 1.4)),
                    SizedBox(height: 12),

                    if (widget.report.status != statusResolved)
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                await state.updateReportStatus(
                                  widget.report.id,
                                  statusInProgress,
                                );
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text('Status updated to In Progress'),
                                    backgroundColor: AppTheme.primary,
                                  ));
                                }
                              },
                              icon: Icon(Icons.build_rounded, size: 16),
                              label: Text('Start Work'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primary,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                await state.updateReportStatus(
                                  widget.report.id,
                                  statusResolved,
                                  resolutionNote: 'Repair completed by ${state.currentUser['name']}',
                                  repairCost: 15000,
                                );
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text('✅ Issue marked as resolved!'),
                                    backgroundColor: AppTheme.success,
                                  ));
                                }
                              },
                              icon: Icon(Icons.check_circle_rounded, size: 16),
                              label: Text('Mark Done'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.success,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.success.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_rounded, color: AppTheme.success, size: 16),
                            SizedBox(width: 6),
                            Text('Repair Completed', style: TextStyle(color: AppTheme.success, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 12)),
          Text(value, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
        ],
      ),
    );
  }
}
