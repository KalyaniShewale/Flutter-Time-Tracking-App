import 'package:uuid/uuid.dart';

class Project {
  final String id;
  final String name;
  final DateTime createdAt;

  Project({
    String? id,
    required this.name,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Project.fromJson(Map<String, dynamic> json) => Project(
    id: json['id'],
    name: json['name'],
    createdAt: DateTime.parse(json['createdAt']),
  );
}