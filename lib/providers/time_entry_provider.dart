import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart';
import '../models/time_entry.dart';
import '../models/project.dart';

class TimeEntryProvider with ChangeNotifier {
  final LocalStorage _storage = LocalStorage('time_tracker');
  List<TimeEntry> _entries = [];
  List<Project> _projects = [];
  List<String> _tasks = [];

  List<TimeEntry> get entries => _entries;
  List<Project> get projects => _projects;
  List<String> get tasks => _tasks;

  TimeEntryProvider() {
    _init();
  }

  Future<void> _init() async {
    await _storage.ready;
    _loadData();
  }

  void _loadData() {
    _entries = (_storage.getItem('entries') ?? []).map<TimeEntry>((e) => TimeEntry.fromJson(e)).toList();
    _projects = (_storage.getItem('projects') ?? []).map<Project>((e) => Project.fromJson(e)).toList();
    _tasks = List<String>.from(_storage.getItem('tasks') ?? []);
    notifyListeners();
  }

  void _persistData() {
    _storage.setItem('entries', _entries.map((e) => e.toJson()).toList());
    _storage.setItem('projects', _projects.map((e) => e.toJson()).toList());
    _storage.setItem('tasks', _tasks);
  }

  void addEntry(TimeEntry entry) {
    _entries.add(entry);
    _persistData();
    notifyListeners();
  }

  void deleteEntry(String id) {
    _entries.removeWhere((entry) => entry.id == id);
    _persistData();
    notifyListeners();
  }

  void addProject(Project project) {
    _projects.add(project);
    _persistData();
    notifyListeners();
  }

  void deleteProject(String id) {
    _projects.removeWhere((project) => project.id == id);
    _persistData();
    notifyListeners();
  }

  void addTask(String task) {
    _tasks.add(task);
    _persistData();
    notifyListeners();
  }

  void deleteTask(String task) {
    _tasks.remove(task);
    _persistData();
    notifyListeners();
  }
}