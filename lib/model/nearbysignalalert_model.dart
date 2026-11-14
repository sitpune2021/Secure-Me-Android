import 'dart:convert';

NearbySignalAlertModel nearbySignalAlertModelFromJson(String str) =>
    NearbySignalAlertModel.fromJson(json.decode(str));

String nearbySignalAlertModelToJson(NearbySignalAlertModel data) =>
    json.encode(data.toJson());

class NearbySignalAlertModel {
  final bool status;
  final String message;
  final Data data;

  NearbySignalAlertModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory NearbySignalAlertModel.fromJson(Map<String, dynamic> json) =>
      NearbySignalAlertModel(
        status: json['status'] ?? false,
        message: json['message'] ?? '',
        data: Data.fromJson(json['data'] ?? {}),
      );

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data.toJson(),
  };
}

class Data {
  final int totalAlerts;
  final List<Alert> alerts;

  Data({required this.totalAlerts, required this.alerts});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    totalAlerts: json['total_alerts'] ?? 0,
    alerts: (json['alerts'] as List<dynamic>? ?? [])
        .map((x) => Alert.fromJson(x as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'total_alerts': totalAlerts,
    'alerts': alerts.map((x) => x.toJson()).toList(),
  };
}

class Alert {
  final String signalId;
  final int signalRecordId;
  final int groupId;
  final String signalStatus;
  final DateTime createdAt;
  final int distanceKm;
  final EmergencyLocation emergencyLocation;
  final User user;
  final String myResponseStatus;

  Alert({
    required this.signalId,
    required this.signalRecordId,
    required this.groupId,
    required this.signalStatus,
    required this.createdAt,
    required this.distanceKm,
    required this.emergencyLocation,
    required this.user,
    required this.myResponseStatus,
  });

  factory Alert.fromJson(Map<String, dynamic> json) => Alert(
    signalId: json['signal_id'] ?? '',
    signalRecordId: json['signal_record_id'] ?? 0,
    groupId: json['group_id'] ?? 0,
    signalStatus: json['signal_status'] ?? '',
    createdAt:
        DateTime.tryParse(json['created_at'] ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0),
    distanceKm: json['distance_km'] ?? 0,
    emergencyLocation: EmergencyLocation.fromJson(
      json['emergency_location'] ?? {},
    ),
    user: User.fromJson(json['user'] ?? {}),
    myResponseStatus: json['my_response_status'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'signal_id': signalId,
    'signal_record_id': signalRecordId,
    'group_id': groupId,
    'signal_status': signalStatus,
    'created_at': createdAt.toIso8601String(),
    'distance_km': distanceKm,
    'emergency_location': emergencyLocation.toJson(),
    'user': user.toJson(),
    'my_response_status': myResponseStatus,
  };
}

class EmergencyLocation {
  final double latitude;
  final double longitude;

  EmergencyLocation({required this.latitude, required this.longitude});

  factory EmergencyLocation.fromJson(Map<String, dynamic> json) =>
      EmergencyLocation(
        latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
        longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
  };
}

class User {
  final int userId;
  final String name;
  final String phoneNo;

  User({required this.userId, required this.name, required this.phoneNo});

  factory User.fromJson(Map<String, dynamic> json) => User(
    userId: json['user_id'] ?? 0,
    name: json['name'] ?? '',
    phoneNo: json['phone_no'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'name': name,
    'phone_no': phoneNo,
  };
}
