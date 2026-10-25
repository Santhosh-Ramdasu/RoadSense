import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../services/app_state.dart';
import '../../models/report_model.dart';
import '../../config/constants.dart';
import '../../widgets/issue_card.dart';

class ComplaintHistory extends StatefulWidget {
  const ComplaintHistory({super.key});

  @override
  State<ComplaintHistory> createState() => _ComplaintHistoryState();
}

class _ComplaintHistoryState extends State<ComplaintHistory> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final myReports = state.myReports;

    final filtered = _filter == 'All'
        ? myReports
        : myReports.where((r) => r.status == _filter).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('My Reports'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', statusPending, statusAssigned, statusInProgress, statusResolved]
                    .map((f) => _FilterChip(
                          label: f,
                          isSelected: _filter == f,
                          count: f == 'All' ? myReports.length : myReports.where((r) => r.status == f).length,
                          onTap: () => setState(() => _filter = f),
                        ))
                    .toList(),
              ),
            ),
          ),

          // Reports list
          Expanded(
            child: filtered.isEmpty
                ? _EmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    itemBuilder: (ctx, i) => IssueCard(
                      report: filtered[i],
                      showStatus: true,
                      onTap: () => _showDetail(context, filtered[i]),
                    ).animate(delay: Duration(milliseconds: i * 60)).fadeIn().slideY(begin: 0.1),
                  ),
          ),
        ],
      ),
    );
  }

  void _showDetail(BuildContext context, ReportModel report) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardTheme.color!,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _ReportDetailSheet(report: report),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final int count;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.isSelected, required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : Theme.of(context).cardTheme.color!,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primary : Theme.of(context).dividerColor,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey),
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
            SizedBox(width: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withValues(alpha: 0.25) : Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_late_outlined, size: 64, color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey).withValues(alpha: 0.4)),
          SizedBox(height: 16),
          Text('No reports yet', style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 16)),
          SizedBox(height: 8),
          Text('Take a photo and report an issue to get started', style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey).withValues(alpha: 0.6), fontSize: 13)),
        ],
      ),
    );
  }
}

class _ReportDetailSheet extends StatelessWidget {
  final ReportModel report;
  const _ReportDetailSheet({required this.report});

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.severityColor(report.severity);
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      expand: false,
      builder: (_, controller) => SingleChildScrollView(
        controller: controller,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.report_rounded, color: color, size: 24),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(report.category, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                      Text(report.address, style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppTheme.statusColor(report.status).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    report.status,
                    style: TextStyle(color: AppTheme.statusColor(report.status), fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            _DetailRow(label: 'Severity', value: report.severity, valueColor: color),
            _DetailRow(label: 'Confidence', value: '${report.confidence.toStringAsFixed(1)}%'),
            _DetailRow(label: 'Est. Cost', value: report.estimatedCost),
            _DetailRow(label: 'Action', value: report.repairWindow),
            if (report.assignedEngineerName != null)
              _DetailRow(label: 'Assigned To', value: report.assignedEngineerName!),
            _DetailRow(label: 'Department', value: report.assignedDepartment),
            _DetailRow(label: 'Submitted', value: _formatDate(report.createdAt)),
            if (report.resolvedAt != null)
              _DetailRow(label: 'Resolved', value: _formatDate(report.resolvedAt!)),
            SizedBox(height: 16),
            Text('AI Analysis', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            SizedBox(height: 8),
            Text(report.risk, style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 13, height: 1.4)),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 13)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: valueColor ?? Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
