import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../theme/app_theme.dart';
import '../../models/report_model.dart';
import '../citizen/citizen_home.dart';

class AIResultScreen extends StatelessWidget {
  final ReportModel report;
  final Uint8List? imageBytes;

  const AIResultScreen({super.key, required this.report, this.imageBytes});

  Color get _severityColor => AppTheme.severityColor(report.severity);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: imageBytes != null ? 260 : 100,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text('AI Report', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              background: imageBytes != null
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.memory(imageBytes!, fit: BoxFit.cover),
                        Container(color: Colors.black.withValues(alpha: 0.5)),
                        // Scan line animation
                        Positioned(
                          left: 0, right: 0,
                          child: Container(height: 2, color: AppTheme.primary.withValues(alpha: 0.8))
                              .animate(onPlay: (c) => c.repeat())
                              .moveY(begin: 0, end: 260, duration: 2.seconds),
                        ),
                      ],
                    )
                  : Container(decoration: BoxDecoration(gradient: AppTheme.darkBgGradient)),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Detection badge
                  _DetectionBadge(report: report).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2),
                  SizedBox(height: 16),

                  // Scores row
                  Row(
                    children: [
                      Expanded(child: _ScoreCard(
                        label: 'AI Confidence',
                        value: report.confidence,
                        max: 100,
                        color: AppTheme.primary,
                        suffix: '%',
                      ).animate(delay: 100.ms).fadeIn()),
                      SizedBox(width: 12),
                      Expanded(child: _ScoreCard(
                        label: 'Severity Score',
                        value: report.severityScore,
                        max: 10,
                        color: _severityColor,
                        suffix: '/10',
                      ).animate(delay: 200.ms).fadeIn()),
                      SizedBox(width: 12),
                      Expanded(child: _ScoreCard(
                        label: 'Priority Score',
                        value: report.priorityScore,
                        max: 10,
                        color: AppTheme.warning,
                        suffix: '/10',
                      ).animate(delay: 300.ms).fadeIn()),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Cost & Timeline
                  _CostTimelineCard(report: report).animate(delay: 400.ms).fadeIn(),

                  SizedBox(height: 16),

                  // AI Analysis details
                  _AnalysisSection(report: report).animate(delay: 500.ms).fadeIn(),

                  SizedBox(height: 16),

                  // Recommendation
                  _RecommendationCard(report: report).animate(delay: 600.ms).fadeIn(),

                  SizedBox(height: 24),

                  // Status badge
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.success.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_rounded, color: AppTheme.success, size: 24),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Report Submitted', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                              Text(
                                'Your report has been submitted and ${report.assignedDepartment} has been notified.',
                                style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate(delay: 700.ms).fadeIn().scale(begin: const Offset(0.95, 0.95)),

                  SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const CitizenHome()),
                        (route) => false,
                      ),
                      icon: Icon(Icons.home_rounded),
                      label: Text('Back to Home'),
                    ),
                  ).animate(delay: 800.ms).fadeIn(),

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

class _DetectionBadge extends StatelessWidget {
  final ReportModel report;

  const _DetectionBadge({required this.report});

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.severityColor(report.severity);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.15), color.withValues(alpha: 0.05)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(_categoryIcon(report.category), color: color, size: 28),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(report.category, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        report.severity,
                        style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(report.assignedDepartment, style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 12)),
                SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.check_circle, color: AppTheme.primary, size: 13),
                    SizedBox(width: 4),
                    Text('${report.confidence.toStringAsFixed(1)}% confidence', style: TextStyle(color: AppTheme.primary, fontSize: 11, fontWeight: FontWeight.w600)),
                    SizedBox(width: 12),
                    Icon(Icons.timer_outlined, color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), size: 13),
                    SizedBox(width: 4),
                    Text(report.repairWindow.replaceAll('Repair within ', '').replaceAll('required', ''), style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Road Crack': return Icons.linear_scale_rounded;
      case 'Pothole': return Icons.radio_button_unchecked;
      case 'Bridge Damage': return Icons.account_balance_rounded;
      case 'Water Leakage': return Icons.water_drop_rounded;
      case 'Broken Streetlight': return Icons.highlight_off_rounded;
      case 'Garbage Overflow': return Icons.delete_rounded;
      case 'Drainage Block': return Icons.water_rounded;
      case 'Corrosion / Rust': return Icons.warning_rounded;
      default: return Icons.report_problem_rounded;
    }
  }
}

class _ScoreCard extends StatelessWidget {
  final String label;
  final double value;
  final double max;
  final Color color;
  final String suffix;

  const _ScoreCard({
    required this.label,
    required this.value,
    required this.max,
    required this.color,
    required this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color!,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: [
          CircularPercentIndicator(
            radius: 34,
            lineWidth: 6,
            percent: (value / max).clamp(0.0, 1.0),
            center: Text(
              '${value.toStringAsFixed(0)}$suffix',
              style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 11),
            ),
            progressColor: color,
            backgroundColor: color.withValues(alpha: 0.15),
            circularStrokeCap: CircularStrokeCap.round,
          ),
          SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey))),
        ],
      ),
    );
  }
}

class _CostTimelineCard extends StatelessWidget {
  final ReportModel report;
  const _CostTimelineCard({required this.report});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color!,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Cost & Timeline', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _InfoTile(icon: Icons.currency_rupee_rounded, label: 'Est. Cost', value: report.estimatedCost, color: AppTheme.warning)),
              SizedBox(width: 12),
              Expanded(child: _InfoTile(icon: Icons.schedule_rounded, label: 'Action Required', value: report.repairWindow, color: AppTheme.danger)),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoTile({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          SizedBox(height: 6),
          Text(label, style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 10)),
          SizedBox(height: 2),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12)),
        ],
      ),
    );
  }
}

class _AnalysisSection extends StatelessWidget {
  final ReportModel report;
  const _AnalysisSection({required this.report});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color!,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('AI Analysis', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          SizedBox(height: 12),
          _AnalysisRow(icon: Icons.warning_rounded, color: AppTheme.danger, label: 'Risk', value: report.risk),
          const Divider(height: 20),
          _AnalysisRow(icon: Icons.search_rounded, color: AppTheme.warning, label: 'Cause', value: report.cause),
        ],
      ),
    );
  }
}

class _AnalysisRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const _AnalysisRow({required this.icon, required this.color, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 18),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12)),
              SizedBox(height: 3),
              Text(value, style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 13, height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final ReportModel report;
  const _RecommendationCard({required this.report});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppTheme.primary.withValues(alpha: 0.12), AppTheme.secondary.withValues(alpha: 0.06)]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_rounded, color: AppTheme.primary, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Recommendation', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w700, fontSize: 13)),
                SizedBox(height: 5),
                Text(report.recommendation, style: TextStyle(fontSize: 13, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
