// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reminder.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addReminder(Reminder reminder) async {
    await _db.collection('reminders').add(reminder.toMap());
  }

  Future<void> updateReminder(Reminder reminder) async {
    await _db.collection('reminders').doc(reminder.id).update(reminder.toMap());
  }

  Future<void> deleteReminder(String id) async {
    await _db.collection('reminders').doc(id).delete();
  }

  Stream<List<Reminder>> getReminders() {
    return _db.collection('reminders').snapshots().map((snapshot) => snapshot
        .docs
        .map((doc) => Reminder.fromMap(doc.data() as Map<String, dynamic>))
        .toList());
  }
}
