class ClubMember {
  final String name;
  final String position;
  final String? imageUrl;
  final String? department;

  const ClubMember({
    required this.name,
    required this.position,
    this.imageUrl,
    this.department,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'position': position,
      'imageUrl': imageUrl,
      'department': department,
    };
  }

  factory ClubMember.fromMap(Map<String, dynamic> map) {
    return ClubMember(
      name: map['name'] as String,
      position: map['position'] as String,
      imageUrl: map['imageUrl'] as String?,
      department: map['department'] as String?,
    );
  }
} 