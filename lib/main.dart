// lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'providers/reminder_provider.dart';

import 'screens/add_edit_reminder_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyACc_T63PUYIRDwbZXjR37kYU_5EDrYeO4",
            authDomain: "reminder-app-28b74.firebaseapp.com",
            projectId: "reminder-app-28b74",
            storageBucket: "reminder-app-28b74.appspot.com",
            messagingSenderId: "886240523391",
            appId: "1:886240523391:web:ad27985a21424836eabb4a",
            measurementId: "G-V5786E5LJG"));
  } else {
    await Firebase.initializeApp();
  }
  await NotificationService().init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reminder App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminders = ref.watch(reminderProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminders'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditReminderScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: reminders.length,
        itemBuilder: (context, index) {
          final reminder = reminders[index];
          return ListTile(
            title: Text(reminder.title),
            subtitle: Text(DateFormat.yMMMd().add_jm().format(reminder.time)),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                context.read().deleteReminder(reminder.id!);
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddEditReminderScreen(reminder: reminder),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
