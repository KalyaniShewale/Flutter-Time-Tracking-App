import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/time_entry.dart';
import '../providers/time_entry_provider.dart';
import '../utils/strings.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  _AddEntryScreenState createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _hoursController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String? _selectedProjectId;
  String? _selectedTask;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimeEntryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title:  Text(AppStrings. addEntry ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedProjectId,
                decoration: const InputDecoration(labelText: AppStrings.projects),
                items: provider.projects
                    .map((project) => DropdownMenuItem(
                  value: project.id,
                  child: Text(project.name),
                ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedProjectId = value),
                validator: (value) => value == null ? AppStrings.required : null,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedTask,
                decoration: const InputDecoration(labelText: AppStrings.tasks),
                items: provider.tasks
                    .map((task) => DropdownMenuItem(
                  value: task,
                  child: Text(task),
                ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedTask = value),
                validator: (value) => value == null ? AppStrings.required  : null,
              ),
              const SizedBox(height: 20),
              ListTile(
                title: const Text(AppStrings.date),
                subtitle: Text(DateFormat.yMd().format(_selectedDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _hoursController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: AppStrings.hours,
                  hintText: AppStrings.hoursHint,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return AppStrings.required ;
                  if (double.tryParse(value) == null) return AppStrings.invalid;
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: AppStrings.notes,
                  hintText: AppStrings.addingnotes,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                child: const Text(AppStrings.saveEntry),
                onPressed: () => _saveEntry(provider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  void _saveEntry(TimeEntryProvider provider) {
    if (_formKey.currentState!.validate()) {
      final newEntry = TimeEntry(
        projectId: _selectedProjectId!,
        task: _selectedTask!,
        date: _selectedDate,
        hours: double.parse(_hoursController.text),
        notes: _notesController.text,
      );

      provider.addEntry(newEntry);
      Navigator.pop(context);
    }
  }
}