import 'dart:math';
import 'package:uuid/uuid.dart';
import 'package:latlong2/latlong.dart';
import '../config/constants.dart';

class ReportModel {
  final String id;
  final String userId;
  final String userName;
  final String category;
  final String severity;
  final String status;
  final String description;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final String address;
  final double confidence;
  final double severityScore;
  final double priorityScore;
  final String estimatedCost;
  final String repairWindow;
  final String risk;
  final String cause;
  final String recommendation;
  final String assignedDepartment;
  final String? assignedEngineerId;
  final String? assignedEngineerName;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final String? resolutionNote;
  final double? repairCost;

  ReportModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.category,
    required this.severity,
    required this.status,
    required this.description,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.confidence,
    required this.severityScore,
    required this.priorityScore,
    required this.estimatedCost,
    required this.repairWindow,
    required this.risk,
    required this.cause,
    required this.recommendation,
    required this.assignedDepartment,
    this.assignedEngineerId,
    this.assignedEngineerName,
    required this.createdAt,
    this.resolvedAt,
    this.resolutionNote,
    this.repairCost,
  });

  LatLng get latLng => LatLng(latitude, longitude);

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'userName': userName,
    'category': category,
    'severity': severity,
    'status': status,
    'description': description,
    'imageUrl': imageUrl,
    'latitude': latitude,
    'longitude': longitude,
    'address': address,
    'confidence': confidence,
    'severityScore': severityScore,
    'priorityScore': priorityScore,
    'estimatedCost': estimatedCost,
    'repairWindow': repairWindow,
    'risk': risk,
    'cause': cause,
    'recommendation': recommendation,
    'assignedDepartment': assignedDepartment,
    'assignedEngineerId': assignedEngineerId,
    'assignedEngineerName': assignedEngineerName,
    'createdAt': createdAt.toIso8601String(),
    'resolvedAt': resolvedAt?.toIso8601String(),
    'resolutionNote': resolutionNote,
    'repairCost': repairCost,
  };

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
    id: json['id'],
    userId: json['userId'],
    userName: json['userName'],
    category: json['category'],
    severity: json['severity'],
    status: json['status'],
    description: json['description'],
    imageUrl: json['imageUrl'] ?? '',
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
    address: json['address'],
    confidence: (json['confidence'] as num).toDouble(),
    severityScore: (json['severityScore'] as num).toDouble(),
    priorityScore: (json['priorityScore'] as num).toDouble(),
    estimatedCost: json['estimatedCost'],
    repairWindow: json['repairWindow'],
    risk: json['risk'],
    cause: json['cause'],
    recommendation: json['recommendation'],
    assignedDepartment: json['assignedDepartment'],
    assignedEngineerId: json['assignedEngineerId'],
    assignedEngineerName: json['assignedEngineerName'],
    createdAt: DateTime.parse(json['createdAt']),
    resolvedAt: json['resolvedAt'] != null ? DateTime.parse(json['resolvedAt']) : null,
    resolutionNote: json['resolutionNote'],
    repairCost: json['repairCost'] != null ? (json['repairCost'] as num).toDouble() : null,
  );

  ReportModel copyWith({
    String? status,
    String? assignedEngineerId,
    String? assignedEngineerName,
    DateTime? resolvedAt,
    String? resolutionNote,
    double? repairCost,
  }) {
    return ReportModel(
      id: id, userId: userId, userName: userName,
      category: category, severity: severity,
      status: status ?? this.status,
      description: description, imageUrl: imageUrl,
      latitude: latitude, longitude: longitude, address: address,
      confidence: confidence, severityScore: severityScore,
      priorityScore: priorityScore, estimatedCost: estimatedCost,
      repairWindow: repairWindow, risk: risk, cause: cause,
      recommendation: recommendation, assignedDepartment: assignedDepartment,
      assignedEngineerId: assignedEngineerId ?? this.assignedEngineerId,
      assignedEngineerName: assignedEngineerName ?? this.assignedEngineerName,
      createdAt: createdAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      resolutionNote: resolutionNote ?? this.resolutionNote,
      repairCost: repairCost ?? this.repairCost,
    );
  }
}

// Predictive maintenance asset
class AssetPrediction {
  final String assetId;
  final String assetName;
  final String assetType;
  final String location;
  final double riskScore;
  final String riskLevel;
  final String predictedFailureIn;
  final String recommendation;
  final int reportCount30Days;
  final DateTime lastInspection;
  final double maintenanceCostEstimate;

  AssetPrediction({
    required this.assetId,
    required this.assetName,
    required this.assetType,
    required this.location,
    required this.riskScore,
    required this.riskLevel,
    required this.predictedFailureIn,
    required this.recommendation,
    required this.reportCount30Days,
    required this.lastInspection,
    required this.maintenanceCostEstimate,
  });
}

// Seed data generator
class SeedData {
  static final _uuid = Uuid();
  static final _random = Random();

  static final List<Map<String, dynamic>> _bengaluruLocations = [
    {'address': 'MG Road, Bengaluru', 'lat': 12.9757, 'lng': 77.6011},
    {'address': 'Koramangala, Bengaluru', 'lat': 12.9352, 'lng': 77.6245},
    {'address': 'Indiranagar, Bengaluru', 'lat': 12.9784, 'lng': 77.6408},
    {'address': 'Whitefield, Bengaluru', 'lat': 12.9698, 'lng': 77.7499},
    {'address': 'Marathahalli, Bengaluru', 'lat': 12.9591, 'lng': 77.6974},
    {'address': 'Electronic City, Bengaluru', 'lat': 12.8456, 'lng': 77.6603},
    {'address': 'HSR Layout, Bengaluru', 'lat': 12.9116, 'lng': 77.6474},
    {'address': 'BTM Layout, Bengaluru', 'lat': 12.9166, 'lng': 77.6101},
    {'address': 'Jayanagar, Bengaluru', 'lat': 12.9308, 'lng': 77.5838},
    {'address': 'Basavanagudi, Bengaluru', 'lat': 12.9422, 'lng': 77.5747},
    {'address': 'Malleswaram, Bengaluru', 'lat': 13.0035, 'lng': 77.5651},
    {'address': 'Rajajinagar, Bengaluru', 'lat': 12.9899, 'lng': 77.5514},
    {'address': 'Vijayanagar, Bengaluru', 'lat': 12.9716, 'lng': 77.5352},
    {'address': 'Yeshwantpur, Bengaluru', 'lat': 13.0214, 'lng': 77.5520},
    {'address': 'Hebbal, Bengaluru', 'lat': 13.0358, 'lng': 77.5970},
    {'address': 'Yelahanka, Bengaluru', 'lat': 13.1005, 'lng': 77.5963},
    {'address': 'Bannerghatta Road, Bengaluru', 'lat': 12.8930, 'lng': 77.5977},
    {'address': 'Sarjapur Road, Bengaluru', 'lat': 12.9102, 'lng': 77.6887},
    {'address': 'Outer Ring Road, Bengaluru', 'lat': 12.9553, 'lng': 77.7024},
    {'address': 'Old Airport Road, Bengaluru', 'lat': 12.9609, 'lng': 77.6387},
  ];

  static final List<Map<String, dynamic>> _aiResults = [
    {
      'category': 'Road Crack',
      'confidence': 96.4, 'severityScore': 7.8, 'priorityScore': 8.4,
      'estimatedCost': '₹18,000 – ₹24,000',
      'repairWindow': 'Repair within 72 hours',
      'risk': 'Road surface failure during monsoon. Risk of vehicle damage and accidents.',
      'cause': 'Heavy vehicle load combined with poor drainage causing subsurface erosion.',
      'recommendation': 'Immediate cold-patch repair followed by hot-mix resurfacing.',
      'department': 'Municipal Road Dept.',
    },
    {
      'category': 'Pothole',
      'confidence': 98.1, 'severityScore': 8.5, 'priorityScore': 9.1,
      'estimatedCost': '₹8,000 – ₹12,000',
      'repairWindow': 'Repair within 24 hours',
      'risk': 'Risk of vehicle axle damage and two-wheeler accidents. High traffic zone.',
      'cause': 'Water infiltration under pavement causing base layer collapse.',
      'recommendation': 'Emergency cold patch followed by permanent hot-mix filling.',
      'department': 'Municipal Road Dept.',
    },
    {
      'category': 'Bridge Damage',
      'confidence': 91.2, 'severityScore': 9.2, 'priorityScore': 9.7,
      'estimatedCost': '₹2,40,000 – ₹3,80,000',
      'repairWindow': 'Immediate inspection required',
      'risk': 'Structural integrity compromised. Risk of partial bridge collapse under heavy load.',
      'cause': 'Long-term corrosion of steel reinforcement bars combined with inadequate maintenance.',
      'recommendation': 'Immediate load restriction. Structural assessment by civil engineer. Emergency repair.',
      'department': 'BBMP Bridge Division',
    },
    {
      'category': 'Water Leakage',
      'confidence': 94.7, 'severityScore': 5.5, 'priorityScore': 6.2,
      'estimatedCost': '₹5,000 – ₹9,000',
      'repairWindow': 'Repair within 7 days',
      'risk': 'Soil erosion under road, potential sinkhole formation, mosquito breeding.',
      'cause': 'Aging water pipeline with corroded joints.',
      'recommendation': 'Pipe section replacement and surface repaving.',
      'department': 'BWSSB Water Supply',
    },
    {
      'category': 'Broken Streetlight',
      'confidence': 99.3, 'severityScore': 4.2, 'priorityScore': 5.8,
      'estimatedCost': '₹3,500 – ₹6,000',
      'repairWindow': 'Repair within 48 hours',
      'risk': 'Reduced visibility increases accident risk and enables criminal activity.',
      'cause': 'Damaged luminaire and faulty wiring due to weathering.',
      'recommendation': 'Replace LED luminaire and inspect wiring. Test adjacent lights.',
      'department': 'BESCOM Street Lighting',
    },
    {
      'category': 'Garbage Overflow',
      'confidence': 97.8, 'severityScore': 3.8, 'priorityScore': 4.5,
      'estimatedCost': '₹1,200 – ₹2,500',
      'repairWindow': 'Clear within 12 hours',
      'risk': 'Disease vector breeding, foul odour, drainage blockage during rain.',
      'cause': 'Inadequate waste collection frequency in high-density area.',
      'recommendation': 'Immediate clearance. Increase collection frequency. Install larger bin.',
      'department': 'BBMP Solid Waste Mgmt.',
    },
    {
      'category': 'Drainage Block',
      'confidence': 95.6, 'severityScore': 6.3, 'priorityScore': 7.0,
      'estimatedCost': '₹4,000 – ₹7,000',
      'repairWindow': 'Repair within 48 hours',
      'risk': 'Severe flooding during rain. Road erosion and property damage.',
      'cause': 'Solid waste accumulation blocking drain inlet.',
      'recommendation': 'Drain desilting. Install mesh guard. Inspect upstream drains.',
      'department': 'BBMP Storm Water Drain',
    },
    {
      'category': 'Corrosion / Rust',
      'confidence': 88.9, 'severityScore': 6.0, 'priorityScore': 6.8,
      'estimatedCost': '₹12,000 – ₹20,000',
      'repairWindow': 'Repair within 14 days',
      'risk': 'Structural weakening over time. Risk of failure under dynamic load.',
      'cause': 'Prolonged exposure to moisture without protective coating.',
      'recommendation': 'Wire brush cleaning, anti-corrosion primer, epoxy coating.',
      'department': 'BBMP Structures Division',
    },
  ];

  static final List<String> _citizenNames = [
    'Ravi Shankar', 'Anita Desai', 'Mohammed Ali', 'Priya Nair', 'Suresh Babu',
    'Kavitha Reddy', 'Arun Kumar', 'Deepa Menon', 'Rajesh Gowda', 'Suma Rao',
    'Vijay Malhotra', 'Lakshmi Iyer', 'Kiran Patel', 'Meera Krishnan', 'Ganesh Murthy',
  ];

  static final List<String> _severities = ['Low', 'Low', 'Medium', 'Medium', 'Medium', 'High', 'High', 'Critical'];

  static List<ReportModel> generateSeedReports() {
    final reports = <ReportModel>[];
    final now = DateTime.now();

    for (int i = 0; i < 50; i++) {
      final location = _bengaluruLocations[_random.nextInt(_bengaluruLocations.length)];
      final aiResult = _aiResults[_random.nextInt(_aiResults.length)];
      final severity = _severities[_random.nextInt(_severities.length)];
      final daysAgo = _random.nextInt(30);
      final isResolved = _random.nextDouble() < 0.35;
      final isAssigned = !isResolved && _random.nextDouble() < 0.5;
      final citizen = _citizenNames[_random.nextInt(_citizenNames.length)];
      final engineer = isAssigned || isResolved
          ? demoEngineers[_random.nextInt(demoEngineers.length)]
          : null;

      String status;
      if (isResolved) {
        status = statusResolved;
      } else if (isAssigned) {
        status = _random.nextBool() ? statusAssigned : statusInProgress;
      } else {
        status = statusPending;
      }

      // Add slight random offset to lat/lng
      final latOffset = (_random.nextDouble() - 0.5) * 0.02;
      final lngOffset = (_random.nextDouble() - 0.5) * 0.02;

      reports.add(ReportModel(
        id: _uuid.v4(),
        userId: 'user_${_random.nextInt(50)}',
        userName: citizen,
        category: aiResult['category'],
        severity: severity,
        status: status,
        description: 'Reported by citizen. AI-analyzed issue at this location.',
        imageUrl: '',
        latitude: (location['lat'] as double) + latOffset,
        longitude: (location['lng'] as double) + lngOffset,
        address: location['address'],
        confidence: (aiResult['confidence'] as double),
        severityScore: (aiResult['severityScore'] as double),
        priorityScore: (aiResult['priorityScore'] as double),
        estimatedCost: aiResult['estimatedCost'],
        repairWindow: aiResult['repairWindow'],
        risk: aiResult['risk'],
        cause: aiResult['cause'],
        recommendation: aiResult['recommendation'],
        assignedDepartment: aiResult['department'],
        assignedEngineerId: engineer?['id'],
        assignedEngineerName: engineer?['name'],
        createdAt: now.subtract(Duration(days: daysAgo, hours: _random.nextInt(24))),
        resolvedAt: isResolved ? now.subtract(Duration(days: _random.nextInt(daysAgo + 1))) : null,
        resolutionNote: isResolved ? 'Repair completed. Area cleared and restored.' : null,
        repairCost: isResolved ? (_random.nextInt(30) + 5) * 1000.0 : null,
      ));
    }

    // Sort by date desc
    reports.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return reports;
  }

  static List<AssetPrediction> generatePredictions() {
    return [
      AssetPrediction(
        assetId: 'asset_001',
        assetName: 'Road Stretch — MG Road',
        assetType: 'Road',
        location: 'MG Road, Bengaluru',
        riskScore: 8.7,
        riskLevel: 'Critical',
        predictedFailureIn: '3 months',
        recommendation: 'Schedule resurfacing before monsoon. Monitor drainage.',
        reportCount30Days: 12,
        lastInspection: DateTime.now().subtract(const Duration(days: 45)),
        maintenanceCostEstimate: 480000,
      ),
      AssetPrediction(
        assetId: 'asset_002',
        assetName: 'Bridge — Hebbal Flyover',
        assetType: 'Bridge',
        location: 'Hebbal, Bengaluru',
        riskScore: 7.2,
        riskLevel: 'High',
        predictedFailureIn: '6 months',
        recommendation: 'Structural inspection required. Anti-corrosion treatment.',
        reportCount30Days: 7,
        lastInspection: DateTime.now().subtract(const Duration(days: 90)),
        maintenanceCostEstimate: 1200000,
      ),
      AssetPrediction(
        assetId: 'asset_003',
        assetName: 'Streetlight Grid — Koramangala',
        assetType: 'Streetlight',
        location: 'Koramangala, Bengaluru',
        riskScore: 5.4,
        riskLevel: 'Medium',
        predictedFailureIn: '2 months',
        recommendation: 'Replace aging sodium lamps with LED. Check wiring.',
        reportCount30Days: 4,
        lastInspection: DateTime.now().subtract(const Duration(days: 30)),
        maintenanceCostEstimate: 85000,
      ),
      AssetPrediction(
        assetId: 'asset_004',
        assetName: 'Drainage — Marathahalli Sector',
        assetType: 'Drainage',
        location: 'Marathahalli, Bengaluru',
        riskScore: 6.9,
        riskLevel: 'High',
        predictedFailureIn: '1 month',
        recommendation: 'Urgently desilting before monsoon. Inlet mesh installation.',
        reportCount30Days: 9,
        lastInspection: DateTime.now().subtract(const Duration(days: 60)),
        maintenanceCostEstimate: 65000,
      ),
      AssetPrediction(
        assetId: 'asset_005',
        assetName: 'Water Main — Whitefield',
        assetType: 'Water Pipeline',
        location: 'Whitefield, Bengaluru',
        riskScore: 4.2,
        riskLevel: 'Medium',
        predictedFailureIn: '5 months',
        recommendation: 'Pressure testing required. Replace aging joints.',
        reportCount30Days: 3,
        lastInspection: DateTime.now().subtract(const Duration(days: 20)),
        maintenanceCostEstimate: 120000,
      ),
      AssetPrediction(
        assetId: 'asset_006',
        assetName: 'Road — Electronic City Phase 2',
        assetType: 'Road',
        location: 'Electronic City, Bengaluru',
        riskScore: 3.1,
        riskLevel: 'Low',
        predictedFailureIn: '8 months',
        recommendation: 'Minor patch work. Monitor pothole formation.',
        reportCount30Days: 2,
        lastInspection: DateTime.now().subtract(const Duration(days: 15)),
        maintenanceCostEstimate: 45000,
      ),
    ];
  }
}
