import 'package:equatable/equatable.dart';

enum MessageType { text, voice, location }

class EmergencyMessage extends Equatable {
  final String id;
  final String senderId;
  final String senderName;
  final String? senderRole;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final bool isAnonymous;

  const EmergencyMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    this.senderRole,
    required this.content,
    required this.type,
    required this.timestamp,
    this.isAnonymous = false,
  });

  @override
  List<Object?> get props => [id, senderId, senderName, senderRole, content, type, timestamp, isAnonymous];

  Map<String, dynamic> toJson() => {
    'id': id,
    'sender_id': senderId,
    'sender_name': senderName,
    'sender_role': senderRole,
    'content': content,
    'type': type.name,
    'timestamp': timestamp.toIso8601String(),
    'is_anonymous': isAnonymous,
  };

  factory EmergencyMessage.fromJson(Map<String, dynamic> json) => EmergencyMessage(
    id: json['id'] as String,
    senderId: json['sender_id'] as String,
    senderName: json['sender_name'] as String,
    senderRole: json['sender_role'] as String?,
    content: json['content'] as String,
    type: MessageType.values.firstWhere((e) => e.name == json['type']),
    timestamp: DateTime.parse(json['timestamp'] as String),
    isAnonymous: json['is_anonymous'] as bool? ?? false,
  );
}
