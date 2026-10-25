import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/report_model.dart';

class IssueCard extends StatelessWidget {
  final ReportModel report;
  final bool showStatus;
  final bool showAssign;
  final VoidCallback? onTap;

  const IssueCard({
    super.key,
    required this.report,
    this.showStatus = false,
    this.showAssign = false,
    this.onTap,
  });

  Color get _sevColor => AppTheme.severityColor(report.severity);
  Color get _statusColor => AppTheme.statusColor(report.status);

  IconData get _categoryIcon {
    switch (report.category) {
      case 'Road Crack': return Icons.linear_scale_rounded;
      case 'Pothole': return Icons.radio_button_unchecked;
      case 'Bridge Damage': return Icons.account_balance_rounded;
      case 'Water Leakage': return Icons.water_drop_rounded;
      case 'Broken Streetlight': return Icons.light_rounded;
      case 'Garbage Overflow': return Icons.delete_rounded;
      case 'Drainage Block': return Icons.water_rounded;
      case 'Corrosion / Rust': return Icons.warning_rounded;
      default: return Icons.report_problem_rounded;
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return '${diff.inMinutes}m ago';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color!,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: _sevColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_categoryIcon, color: _sevColor, size: 22),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    report.category,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2),
                  Text(
                    report.address,
                    style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _sevColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          report.severity,
                          style: TextStyle(color: _sevColor, fontSize: 9, fontWeight: FontWeight.w700),
                        ),
                      ),
                      if (showStatus) ...[
                        SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _statusColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            report.status,
                            style: TextStyle(color: _statusColor, fontSize: 9, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                      const Spacer(),
                      Text(
                        _timeAgo(report.createdAt),
                        style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${report.confidence.toInt()}%',
                  style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w800, fontSize: 14),
                ),
                Text('AI conf.', style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 9)),
                if (showAssign) ...[
                  SizedBox(height: 4),
                  Icon(Icons.chevron_right_rounded, color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), size: 18),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
