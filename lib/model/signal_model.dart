import 'package:equatable/equatable.dart';

class LocationModel extends Equatable {
  final double latitude;
  final double longitude;
  final String? address;

  const LocationModel({
    required this.latitude,
    required this.longitude,
    this.address,
  });

  @override
  List<Object?> get props => [latitude, longitude, address];
}

enum SignalStatus { inactive, pending, accepted, inProgress, resolved }

enum SignalStage { stage1, stage2, stage3 }

class EmergencySignalModel extends Equatable {
  final String id;
  final String victimId;
  final LocationModel location;
  final DateTime timestamp;
  final SignalStatus status;
  final SignalStage stage;
  final List<String> responderIds;
  final double radius;
  final String? chatGroupId;

  const EmergencySignalModel({
    required this.id,
    required this.victimId,
    required this.location,
    required this.timestamp,
    required this.status,
    required this.stage,
    required this.responderIds,
    this.radius = 50.0,
    this.chatGroupId,
  });

  @override
  List<Object?> get props => [id, victimId, location, timestamp, status, stage, responderIds, radius, chatGroupId];

  EmergencySignalModel copyWith({
    SignalStatus? status,
    SignalStage? stage,
    double? radius,
    List<String>? responderIds,
    String? chatGroupId,
  }) {
    return EmergencySignalModel(
      id: id,
      victimId: victimId,
      location: location,
      timestamp: timestamp,
      status: status ?? this.status,
      stage: stage ?? this.stage,
      responderIds: responderIds ?? this.responderIds,
      radius: radius ?? this.radius,
      chatGroupId: chatGroupId ?? this.chatGroupId,
    );
  }
}

