// lib/providers/reminder_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/reminder.dart';
import '../services/firestore_service.dart';

final reminderProvider =
    StateNotifierProvider<ReminderNotifier, List<Reminder>>((ref) {
  return ReminderNotifier();
});

class ReminderNotifier extends StateNotifier<List<Reminder>> {
  final FirestoreService _firestoreService = FirestoreService();

  ReminderNotifier() : super([]) {
    loadReminders();
  }

  void loadReminders() {
    _firestoreService.getReminders().listen((reminders) {
      state = reminders;
    });
  }

  Future<void> addReminder(Reminder reminder) async {
    await _firestoreService.addReminder(reminder);
  }

  Future<void> updateReminder(Reminder reminder) async {
    await _firestoreService.updateReminder(reminder);
  }

  Future<void> deleteReminder(String id) async {
    await _firestoreService.deleteReminder(id);
  }
}
