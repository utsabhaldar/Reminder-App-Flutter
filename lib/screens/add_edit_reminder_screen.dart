// lib/screens/add_edit_reminder_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/providers/reminder_provider.dart';
import 'package:reminder_app/services/notification_service.dart';
import '../models/reminder.dart';
import 'package:provider/provider.dart';

// import '../providers/reminder_provider.dart';

class AddEditReminderScreen extends StatefulWidget {
  final Reminder? reminder;

  AddEditReminderScreen({this.reminder});

  @override
  _AddEditReminderScreenState createState() => _AddEditReminderScreenState();
}

class _AddEditReminderScreenState extends State<AddEditReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late DateTime _time;
  late String _priority;

  @override
  void initState() {
    super.initState();
    _title = widget.reminder?.title ?? '';
    _description = widget.reminder?.description ?? '';
    _time = widget.reminder?.time ?? DateTime.now();
    _priority = widget.reminder?.priority ?? 'Low';
  }

  void _saveReminder() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newReminder = Reminder(
        id: widget.reminder?.id,
        title: _title,
        description: _description,
        time: _time,
        priority: _priority,
      );
      if (widget.reminder == null) {
        context.read().addReminder(newReminder);
      } else {
        context.read().updateReminder(newReminder);
      }
      NotificationService().scheduleNotification(newReminder);
      Navigator.pop(context);
    }
  }

  void _pickDateTime() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: _time,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_time),
    );

    if (time == null) return;

    setState(() {
      _time = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reminder == null ? 'Add Reminder' : 'Edit Reminder'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveReminder,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) => _title = value!,
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) => _description = value!,
              ),
              ListTile(
                title:
                    Text('Time: ${DateFormat.yMMMd().add_jm().format(_time)}'),
                trailing: Icon(Icons.calendar_today),
                onTap: _pickDateTime,
              ),
              DropdownButtonFormField<String>(
                value: _priority,
                decoration: InputDecoration(labelText: 'Priority'),
                items: ['High', 'Medium', 'Low']
                    .map((priority) => DropdownMenuItem(
                          value: priority,
                          child: Text(priority),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _priority = value!),
                onSaved: (value) => _priority = value!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
