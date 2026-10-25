import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/report_model.dart';
import '../config/constants.dart';

/// Simulates a Firebase Firestore database using SharedPreferences.
/// Stores all data locally — perfect for hackathon prototype.
class AppState extends ChangeNotifier {
  static const _reportsKey = 'infra_reports';
  static const _userKey = 'current_user';

  final _uuid = const Uuid();

  List<ReportModel> _reports = [];
  Map<String, dynamic> _currentUser = {};
  bool _isLoading = false;
  String _selectedRole = roleCitizen;

  List<ReportModel> get reports => List.unmodifiable(_reports);
  Map<String, dynamic> get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String get selectedRole => _selectedRole;

  // Filtered views
  List<ReportModel> get pendingReports =>
      _reports.where((r) => r.status == statusPending).toList();

  List<ReportModel> get criticalReports =>
      _reports.where((r) => r.severity == 'Critical' || r.severity == 'High').toList();

  List<ReportModel> get resolvedReports =>
      _reports.where((r) => r.status == statusResolved).toList();

  List<ReportModel> get myReports =>
      _reports.where((r) => r.userId == _currentUser['id']).toList();

  List<ReportModel> engineerReports(String engineerId) =>
      _reports.where((r) => r.assignedEngineerId == engineerId).toList();

  // Dashboard stats
  int get todayReports {
    final today = DateTime.now();
    return _reports.where((r) =>
      r.createdAt.year == today.year &&
      r.createdAt.month == today.month &&
      r.createdAt.day == today.day).length;
  }

  double get resolutionRate {
    if (_reports.isEmpty) return 0;
    return (resolvedReports.length / _reports.length) * 100;
  }

  double get avgResponseTimeHours {
    final resolved = _reports.where((r) =>
      r.status == statusResolved && r.resolvedAt != null).toList();
    if (resolved.isEmpty) return 0;
    final totalHours = resolved.fold<double>(0, (sum, r) =>
      sum + r.resolvedAt!.difference(r.createdAt).inHours);
    return totalHours / resolved.length;
  }

  Map<String, int> get reportsByCategory {
    final map = <String, int>{};
    for (final r in _reports) {
      map[r.category] = (map[r.category] ?? 0) + 1;
    }
    return map;
  }

  Map<String, int> get reportsByStatus {
    return {
      'Pending': pendingReports.length,
      'Assigned': _reports.where((r) => r.status == statusAssigned).length,
      'In Progress': _reports.where((r) => r.status == statusInProgress).length,
      'Resolved': resolvedReports.length,
    };
  }

  // Reports per day for last 30 days
  List<int> get reportsLast30Days {
    final now = DateTime.now();
    return List.generate(30, (i) {
      final day = now.subtract(Duration(days: 29 - i));
      return _reports.where((r) =>
        r.createdAt.year == day.year &&
        r.createdAt.month == day.month &&
        r.createdAt.day == day.day).length;
    });
  }

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    // Load or seed reports
    final savedReports = prefs.getString(_reportsKey);
    if (savedReports != null) {
      final list = jsonDecode(savedReports) as List;
      _reports = list.map((e) => ReportModel.fromJson(e)).toList();
    } else {
      // First run — seed with demo data
      _reports = SeedData.generateSeedReports();
      await _saveReports(prefs);
    }

    // Load or create demo user
    final savedUser = prefs.getString(_userKey);
    if (savedUser != null) {
      _currentUser = jsonDecode(savedUser);
    } else {
      _currentUser = {
        'id': _uuid.v4(),
        'name': 'Demo User',
        'email': 'demo@roadsense.ai',
        'phone': '+91 98765 43210',
        'role': roleCitizen,
        'avatar': null,
      };
      await prefs.setString(_userKey, jsonEncode(_currentUser));
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> setRole(String role) async {
    _selectedRole = role;
    _currentUser['role'] = role;

    if (role == roleAdmin || role == roleDecisionMaker) {
      _currentUser['name'] = 'Admin Officer';
      _currentUser['id'] = 'admin_001';
    } else if (role == roleEngineer) {
      _currentUser['name'] = demoEngineers[0]['name'];
      _currentUser['id'] = demoEngineers[0]['id'];
    } else {
      _currentUser['name'] = 'Ravi Shankar';
      _currentUser['id'] = 'citizen_001';
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(_currentUser));
    notifyListeners();
  }

  Future<void> addReport(ReportModel report) async {
    _reports.insert(0, report);
    final prefs = await SharedPreferences.getInstance();
    await _saveReports(prefs);
    notifyListeners();
  }

  Future<void> updateReportStatus(String reportId, String newStatus, {
    String? engineerId,
    String? engineerName,
    String? resolutionNote,
    double? repairCost,
  }) async {
    final index = _reports.indexWhere((r) => r.id == reportId);
    if (index == -1) return;

    _reports[index] = _reports[index].copyWith(
      status: newStatus,
      assignedEngineerId: engineerId,
      assignedEngineerName: engineerName,
      resolvedAt: newStatus == statusResolved ? DateTime.now() : null,
      resolutionNote: resolutionNote,
      repairCost: repairCost,
    );

    final prefs = await SharedPreferences.getInstance();
    await _saveReports(prefs);
    notifyListeners();
  }

  Future<void> assignEngineer(String reportId, String engineerId, String engineerName) async {
    await updateReportStatus(reportId, statusAssigned,
      engineerId: engineerId,
      engineerName: engineerName,
    );
  }

  Future<void> resetToSeedData() async {
    final prefs = await SharedPreferences.getInstance();
    _reports = SeedData.generateSeedReports();
    await _saveReports(prefs);
    notifyListeners();
  }

  Future<void> _saveReports(SharedPreferences prefs) async {
    final encoded = jsonEncode(_reports.map((r) => r.toJson()).toList());
    await prefs.setString(_reportsKey, encoded);
  }
}
