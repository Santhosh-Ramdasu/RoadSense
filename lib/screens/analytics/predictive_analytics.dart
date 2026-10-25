import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_theme.dart';
import '../../models/report_model.dart';
import '../role_selection_screen.dart';

class PredictiveAnalytics extends StatelessWidget {
  const PredictiveAnalytics({super.key});

  @override
  Widget build(BuildContext context) {
    final predictions = SeedData.generatePredictions();

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
                    colors: [const Color(0xFF1A0A2E), Theme.of(context).scaffoldBackgroundColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -50, right: -50,
                      child: Container(
                        width: 200, height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(colors: [AppTheme.secondary.withValues(alpha: 0.2), Colors.transparent]),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 70, 20, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              ShaderMask(
                                shaderCallback: (b) => const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFF8B5CF6)]).createShader(b),
                                child: Icon(Icons.insights_rounded, color: Colors.white, size: 26),
                              ),
                              SizedBox(width: 10),
                              Text('Predictive Analytics', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text('AI-driven infrastructure risk forecasting', style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 12)),
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
                  // Summary banner
                  _SummaryBanner(predictions: predictions).animate().fadeIn(duration: 400.ms),

                  SizedBox(height: 20),

                  // Risk chart
                  _RiskBarChart(predictions: predictions).animate(delay: 200.ms).fadeIn(),

                  SizedBox(height: 20),

                  Text('Asset Risk Forecast', style: Theme.of(context).textTheme.headlineMedium),
                  SizedBox(height: 4),
                  Text('AI predictions based on report frequency, repair history & seasonal patterns',
                    style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 12)),
                  SizedBox(height: 12),

                  ...predictions.asMap().entries.map((e) => _AssetRiskCard(
                    prediction: e.value,
                  ).animate(delay: Duration(milliseconds: 300 + e.key * 100)).fadeIn().slideY(begin: 0.1)),

                  SizedBox(height: 20),

                  // Seasonal heatmap
                  _SeasonalHeatmap().animate(delay: 500.ms).fadeIn(),

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

class _SummaryBanner extends StatelessWidget {
  final List<AssetPrediction> predictions;
  const _SummaryBanner({required this.predictions});

  @override
  Widget build(BuildContext context) {
    final critical = predictions.where((p) => p.riskLevel == 'Critical').length;
    final high = predictions.where((p) => p.riskLevel == 'High').length;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.secondary.withValues(alpha: 0.15), AppTheme.warning.withValues(alpha: 0.1)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.secondary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_graph_rounded, color: AppTheme.secondary, size: 20),
              SizedBox(width: 8),
              Text('AI Prediction Summary', style: TextStyle(color: AppTheme.secondary, fontWeight: FontWeight.w700, fontSize: 14)),
            ],
          ),
          SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _SummaryChip(label: 'Assets Monitored', value: '${predictions.length}', color: AppTheme.primary)),
              SizedBox(width: 10),
              Expanded(child: _SummaryChip(label: 'Critical Risk', value: '$critical', color: AppTheme.danger)),
              SizedBox(width: 10),
              Expanded(child: _SummaryChip(label: 'High Risk', value: '$high', color: AppTheme.warning)),
            ],
          ),
          SizedBox(height: 12),
          Text(
            '⚠️ $critical asset(s) require immediate attention before the monsoon season.',
            style: TextStyle(color: AppTheme.warning, fontSize: 12, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 22)),
          SizedBox(height: 2),
          Text(label, style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 9), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _RiskBarChart extends StatelessWidget {
  final List<AssetPrediction> predictions;
  const _RiskBarChart({required this.predictions});

  @override
  Widget build(BuildContext context) {
    final colors = [AppTheme.danger, AppTheme.warning, AppTheme.warning, AppTheme.success, AppTheme.success, AppTheme.primary];

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
          Text('Risk Score by Asset', style: Theme.of(context).textTheme.headlineMedium),
          SizedBox(height: 4),
          Text('Score 1–10 based on AI analysis', style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 12)),
          SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                maxY: 10,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => Theme.of(context).colorScheme.surface,
                    getTooltipItem: (group, gi, rod, ri) => BarTooltipItem(
                      predictions[group.x].riskScore.toStringAsFixed(1),
                      TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (val, _) {
                        final labels = ['MG\nRoad', 'Hebbal\nBridge', 'Kora-\nmangala', 'Maratha-\nhalli', 'White-\nfield', 'Elec\nCity'];
                        if (val.toInt() < labels.length) {
                          return Text(labels[val.toInt()], style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 8), textAlign: TextAlign.center);
                        }
                        return SizedBox();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      getTitlesWidget: (val, _) => Text('${val.toInt()}', style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 9)),
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => FlLine(color: Theme.of(context).dividerColor, strokeWidth: 0.5),
                ),
                borderData: FlBorderData(show: false),
                barGroups: predictions.asMap().entries.map((e) => BarChartGroupData(
                  x: e.key,
                  barRods: [
                    BarChartRodData(
                      toY: e.value.riskScore,
                      color: colors[e.key % colors.length],
                      width: 20,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: 10,
                        color: colors[e.key % colors.length].withValues(alpha: 0.08),
                      ),
                    ),
                  ],
                )).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AssetRiskCard extends StatelessWidget {
  final AssetPrediction prediction;

  const _AssetRiskCard({required this.prediction});

  Color get _riskColor {
    switch (prediction.riskLevel) {
      case 'Critical': return AppTheme.danger;
      case 'High': return const Color(0xFFF97316);
      case 'Medium': return AppTheme.warning;
      default: return AppTheme.success;
    }
  }

  IconData get _assetIcon {
    switch (prediction.assetType) {
      case 'Road': return Icons.add_road;
      case 'Bridge': return Icons.account_balance_rounded;
      case 'Streetlight': return Icons.light_rounded;
      case 'Drainage': return Icons.water_rounded;
      case 'Water Pipeline': return Icons.water_damage_rounded;
      default: return Icons.business_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color!,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _riskColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: _riskColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(_assetIcon, color: _riskColor, size: 24),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(prediction.assetName, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    Text(prediction.location, style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 11)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _riskColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(prediction.riskLevel, style: TextStyle(color: _riskColor, fontWeight: FontWeight.w700, fontSize: 11)),
              ),
            ],
          ),

          SizedBox(height: 14),

          // Risk score bar
          Row(
            children: [
              Text('Risk Score', style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 11)),
              const Spacer(),
              Text('${prediction.riskScore.toStringAsFixed(1)}/10',
                style: TextStyle(color: _riskColor, fontWeight: FontWeight.w700, fontSize: 12)),
            ],
          ),
          SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: prediction.riskScore / 10,
              minHeight: 8,
              backgroundColor: _riskColor.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(_riskColor),
            ),
          ),

          SizedBox(height: 12),

          Row(
            children: [
              Expanded(child: _PredictionBadge(icon: Icons.schedule_rounded, label: 'Predicted Failure', value: prediction.predictedFailureIn, color: _riskColor)),
              SizedBox(width: 10),
              Expanded(child: _PredictionBadge(icon: Icons.report_problem_rounded, label: 'Reports (30d)', value: '${prediction.reportCount30Days}', color: AppTheme.primary)),
            ],
          ),

          SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb_rounded, color: AppTheme.warning, size: 15),
                SizedBox(width: 8),
                Expanded(
                  child: Text(prediction.recommendation,
                    style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 11, height: 1.4)),
                ),
              ],
            ),
          ),

          SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Est. Maintenance', style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 11)),
              Text(
                '₹${(prediction.maintenanceCostEstimate / 1000).toStringAsFixed(0)}K',
                style: TextStyle(color: AppTheme.warning, fontWeight: FontWeight.w700, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PredictionBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _PredictionBadge({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 14),
          SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 9)),
                Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SeasonalHeatmap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    // Simulated risk data: monsoon months higher risk
    final risks = [2, 2, 3, 4, 5, 7, 9, 9, 8, 6, 3, 2];

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
          Text('Seasonal Risk Heatmap', style: Theme.of(context).textTheme.headlineMedium),
          SizedBox(height: 4),
          Text('Infrastructure failure risk by month', style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 12)),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(12, (i) {
              final risk = risks[i];
              final color = risk >= 8 ? AppTheme.danger
                  : risk >= 6 ? const Color(0xFFF97316)
                  : risk >= 4 ? AppTheme.warning
                  : AppTheme.success;
              return Column(
                children: [
                  Container(
                    width: 22,
                    height: risk * 12.0,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(months[i].substring(0, 1), style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 9)),
                ],
              );
            }),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              _HeatLegend(color: AppTheme.success, label: 'Low'),
              SizedBox(width: 12),
              _HeatLegend(color: AppTheme.warning, label: 'Medium'),
              SizedBox(width: 12),
              _HeatLegend(color: const Color(0xFFF97316), label: 'High'),
              SizedBox(width: 12),
              _HeatLegend(color: AppTheme.danger, label: 'Critical'),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeatLegend extends StatelessWidget {
  final Color color;
  final String label;

  const _HeatLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        SizedBox(width: 4),
        Text(label, style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 10)),
      ],
    );
  }
}
