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

enum SignalStatus { pending, sent, active, resolved }
enum SignalStage { stage1, stage2 }

class EmergencySignalModel extends Equatable {
  final String id;
  final String victimId;
  final LocationModel location;
  final DateTime timestamp;
  final SignalStatus status;
  final SignalStage stage;
  final List<String> responderIds;

  const EmergencySignalModel({
    required this.id,
    required this.victimId,
    required this.location,
    required this.timestamp,
    required this.status,
    required this.stage,
    required this.responderIds,
  });

  @override
  List<Object?> get props => [id, victimId, location, timestamp, status, stage, responderIds];
}
