// lib/models/reminder.dart
class Reminder {
  final String? id;
  final String title;
  final String description;
  final DateTime time;
  final String priority;

  Reminder({
    this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.priority,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'time': time.toIso8601String(),
      'priority': priority,
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      time: DateTime.parse(map['time']),
      priority: map['priority'],
    );
  }
}
