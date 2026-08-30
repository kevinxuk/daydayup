import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_data.dart';
import '../models/task.dart';

class ChoreProvider with ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper();
  List<Task> _tasks = [];
  Map<String, double> _todayChecks = {};
  UserProfile _profile = UserProfile(lastActiveDate: DateTime.now());

  List<Task> get tasks => _tasks;
  Map<String, double> get todayChecks => _todayChecks;
  UserProfile get profile => _profile;

  String get todayKey => _todayKey();
  String _todayKey() => DateTime.now().toIso8601String().split('T')[0];

  Future<void> init() async {
    await _db.init();
    _tasks = _db.getTasks();
    _profile = UserProfile(
      childName: _db.getProfileName(),
      className: _db.getProfileClass(),
      parentPassword: _db.getProfilePassword(),
      totalEarned: _db.getProfileTotalEarned(),
      streakDays: _db.getProfileStreakDays(),
      lastActiveDate: DateTime.now(),
    );
    _loadTodayChecks();
    notifyListeners();
  }

  void _loadTodayChecks() {
    _todayChecks = _db.getCheckedToday(todayKey);
  }

  double get todayTotal => _todayChecks.values.fold(0.0, (sum, v) => sum + v);

  double get monthTotal {
    final now = DateTime.now();
    final stats = _db.getMonthStats(now.year, now.month);
    return stats.values.fold(0.0, (sum, v) => sum + v);
  }

  double get bestDay {
    final now = DateTime.now();
    final stats = _db.getMonthStats(now.year, now.month);
    if (stats.isEmpty) return 0.0;
    return stats.values.fold(0.0, (max, v) => v > max ? v : max);
  }

  int get checkedDays {
    final now = DateTime.now();
    final stats = _db.getMonthStats(now.year, now.month);
    return stats.values.where((v) => v > 0).length;
  }

  Future<void> toggleTask(String taskId) async {
    await _db.toggleCheck(taskId, todayKey);
    _loadTodayChecks();
    notifyListeners();
  }

  void addTask(Task task) {
    _tasks.add(task);
    _db.addTask(task);
    notifyListeners();
  }

  void updateTask(Task task) {
    _db.updateTask(task);
    _tasks = _db.getTasks();
    notifyListeners();
  }

  void deleteTask(String id) {
    _db.deleteTask(id);
    _tasks = _db.getTasks();
    notifyListeners();
  }

  void toggleTaskActive(String id) {
    final task = _db.getTaskById(id);
    if (task != null) {
      task.isActive = !task.isActive;
      _db.updateTask(task);
      _tasks = _db.getTasks();
      notifyListeners();
    }
  }

  void updateProfile(String childName, String className, String password) {
    _profile = UserProfile(
      childName: childName,
      className: className,
      parentPassword: password,
      totalEarned: _profile.totalEarned,
      streakDays: _profile.streakDays,
      lastActiveDate: _profile.lastActiveDate,
    );
    _db.saveProfile(childName, className, password);
    notifyListeners();
  }

  Map<String, List<Task>> get groupedTasks {
    final grouped = <String, List<Task>>{};
    for (var task in _tasks) {
      grouped.putIfAbsent(task.groupName, () => []).add(task);
    }
    return grouped;
  }
}
