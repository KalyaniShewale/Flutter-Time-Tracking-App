import 'package:uuid/uuid.dart';

class TimeEntry {
  final String id;
  final String projectId;
  final String task;
  final DateTime date;
  final double hours;
  final String notes;

  TimeEntry({
    String? id,
    required this.projectId,
    required this.task,
    required this.date,
    required this.hours,
    this.notes = '',
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
    'id': id,
    'projectId': projectId,
    'task': task,
    'date': date.toIso8601String(),
    'hours': hours,
    'notes': notes,
  };

  factory TimeEntry.fromJson(Map<String, dynamic> json) => TimeEntry(
    id: json['id'],
    projectId: json['projectId'],
    task: json['task'],
    date: DateTime.parse(json['date']),
    hours: json['hours'].toDouble(),
    notes: json['notes'],
  );
}