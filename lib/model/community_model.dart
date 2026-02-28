class CommunityModel {
  final String id;
  final String name;
  final int memberCount;
  final List<String> memberNames;

  CommunityModel({
    required this.id,
    required this.name,
    required this.memberCount,
    this.memberNames = const [],
  });

  factory CommunityModel.fromJson(Map<String, dynamic> json) {
    // Handle old format where "members" was a string like "1 Member"
    int count = 0;
    final rawMembers = json['members_count'] ?? json['members'];
    if (rawMembers is int) {
      count = rawMembers;
    } else if (rawMembers is String) {
      // Extract number from "X Members" or similar
      final match = RegExp(r'(\d+)').firstMatch(rawMembers);
      count = match != null ? int.parse(match.group(1)!) : 0;
    }

    return CommunityModel(
      id: json['id']?.toString() ?? '',
      name:
          json['community_name']?.toString() ?? json['name']?.toString() ?? '',
      memberCount: count,
      memberNames:
          (json['member_names'] as List?)?.map((e) => e.toString()).toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'community_name': name,
    'members_count': memberCount,
    'member_names': memberNames,
  };

  // Helper for UI display
  String get membersDisplay =>
      memberCount == 1 ? "1 Member" : "$memberCount Members";

  CommunityModel copyWith({
    String? id,
    String? name,
    int? memberCount,
    List<String>? memberNames,
  }) {
    return CommunityModel(
      id: id ?? this.id,
      name: name ?? this.name,
      memberCount: memberCount ?? this.memberCount,
      memberNames: memberNames ?? this.memberNames,
    );
  }
}
