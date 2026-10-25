import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../services/app_state.dart';
import '../../models/report_model.dart';
import '../../config/constants.dart';

class MapDashboard extends StatefulWidget {
  const MapDashboard({super.key});

  @override
  State<MapDashboard> createState() => _MapDashboardState();
}

class _MapDashboardState extends State<MapDashboard> {
  final _mapController = MapController();
  String _filterSeverity = 'All';
  String _filterStatus = 'All';
  ReportModel? _selectedReport;

  List<ReportModel> _filteredReports(List<ReportModel> all) {
    return all.where((r) {
      final sev = _filterSeverity == 'All' || r.severity == _filterSeverity;
      final status = _filterStatus == 'All' || r.status == _filterStatus;
      return sev && status;
    }).toList();
  }

  Color _markerColor(ReportModel r) {
    if (r.status == statusResolved) return AppTheme.success;
    switch (r.severity) {
      case 'Critical': return AppTheme.danger;
      case 'High': return const Color(0xFFF97316);
      case 'Medium': return AppTheme.warning;
      case 'Low': return AppTheme.success;
      default: return AppTheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final reports = _filteredReports(state.reports);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(defaultLat, defaultLng),
              initialZoom: defaultZoom,
              onTap: (_, __) => setState(() => _selectedReport = null),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.roadsense.roadsense',
              ),
              MarkerLayer(
                markers: reports.map((report) {
                  final color = _markerColor(report);
                  return Marker(
                    point: report.latLng,
                    width: 36,
                    height: 36,
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedReport = report),
                      child: Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.5),
                          boxShadow: [
                            BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 8, spreadRadius: 1),
                          ],
                        ),
                        child: Icon(_markerIcon(report.category), color: Colors.white, size: 16),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // Top bar
          Positioned(
            top: 0, left: 0, right: 0,
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Theme.of(context).dividerColor),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 12)],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.psychology_rounded, color: AppTheme.primary, size: 20),
                        SizedBox(width: 8),
                        const Expanded(
                          child: Text('RoadSense Map', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('${reports.length} Issues', style: TextStyle(color: AppTheme.primary, fontSize: 12, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Filter row
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _MapFilter(label: 'All', isSelected: _filterSeverity == 'All', color: AppTheme.primary, onTap: () => setState(() => _filterSeverity = 'All')),
                          _MapFilter(label: 'Critical', isSelected: _filterSeverity == 'Critical', color: AppTheme.danger, onTap: () => setState(() => _filterSeverity = 'Critical')),
                          _MapFilter(label: 'High', isSelected: _filterSeverity == 'High', color: const Color(0xFFF97316), onTap: () => setState(() => _filterSeverity = 'High')),
                          _MapFilter(label: 'Medium', isSelected: _filterSeverity == 'Medium', color: AppTheme.warning, onTap: () => setState(() => _filterSeverity = 'Medium')),
                          _MapFilter(label: 'Resolved', isSelected: _filterStatus == 'Resolved', color: AppTheme.success, onTap: () => setState(() {
                            _filterStatus = _filterStatus == 'Resolved' ? 'All' : 'Resolved';
                            _filterSeverity = 'All';
                          })),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Legend
          Positioned(
            right: 12, bottom: _selectedReport != null ? 240 : 100,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _LegendItem(color: AppTheme.danger, label: 'Critical'),
                  _LegendItem(color: const Color(0xFFF97316), label: 'High'),
                  _LegendItem(color: AppTheme.warning, label: 'Medium'),
                  _LegendItem(color: AppTheme.success, label: 'Low / Fixed'),
                ],
              ),
            ),
          ),

          // Map controls
          Positioned(
            right: 12,
            bottom: _selectedReport != null ? 380 : 180,
            child: Column(
              children: [
                _MapButton(icon: Icons.add, onTap: () => _mapController.move(_mapController.camera.center, _mapController.camera.zoom + 1)),
                SizedBox(height: 8),
                _MapButton(icon: Icons.remove, onTap: () => _mapController.move(_mapController.camera.center, _mapController.camera.zoom - 1)),
                SizedBox(height: 8),
                _MapButton(icon: Icons.my_location, onTap: () => _mapController.move(const LatLng(defaultLat, defaultLng), defaultZoom)),
              ],
            ),
          ),

          // Selected report card
          if (_selectedReport != null)
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: _ReportPopup(
                report: _selectedReport!,
                onClose: () => setState(() => _selectedReport = null),
              ).animate().slideY(begin: 1.0, duration: 300.ms, curve: Curves.easeOutCubic),
            ),
        ],
      ),
    );
  }

  IconData _markerIcon(String category) {
    switch (category) {
      case 'Road Crack': return Icons.linear_scale_rounded;
      case 'Pothole': return Icons.radio_button_unchecked;
      case 'Bridge Damage': return Icons.account_balance_rounded;
      case 'Water Leakage': return Icons.water_drop_rounded;
      case 'Broken Streetlight': return Icons.light_rounded;
      case 'Garbage Overflow': return Icons.delete_rounded;
      case 'Drainage Block': return Icons.water_rounded;
      default: return Icons.report_rounded;
    }
  }
}

class _MapFilter extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _MapFilter({required this.label, required this.isSelected, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _MapButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _MapButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }
}

class _ReportPopup extends StatelessWidget {
  final ReportModel report;
  final VoidCallback onClose;

  const _ReportPopup({required this.report, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.severityColor(report.severity);
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 20)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.report_rounded, color: color, size: 22),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(report.category, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                    Text(report.address, style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 12)),
                  ],
                ),
              ),
              IconButton(icon: Icon(Icons.close), onPressed: onClose, iconSize: 20),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              _PopupChip(label: report.severity, color: color),
              SizedBox(width: 8),
              _PopupChip(label: report.status, color: AppTheme.statusColor(report.status)),
              SizedBox(width: 8),
              _PopupChip(label: '${report.confidence.toInt()}% conf.', color: AppTheme.primary),
            ],
          ),
          SizedBox(height: 10),
          Text(report.risk, style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 12, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  '💰 ${report.estimatedCost}',
                  style: TextStyle(color: AppTheme.warning, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
              Text(report.repairWindow, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}

class _PopupChip extends StatelessWidget {
  final String label;
  final Color color;

  const _PopupChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
    );
  }
}
