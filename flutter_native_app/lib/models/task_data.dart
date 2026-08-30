import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'task.dart';

class TaskConfig {
  static const String taskDataJson = '''
[
  {"group": "🌅 晨间", "name": "按时起床、叠好被子", "amount": 1.0, "icon": "⏰", "weekendOnly": false},
  {"group": "🌅 晨间", "name": "整理床铺", "amount": 0.5, "icon": "🛏️", "weekendOnly": false},
  {"group": "🌅 晨间", "name": "吃早餐（不催促）", "amount": 0.5, "icon": "🍳", "weekendOnly": false},
  {"group": "🌅 晨间", "name": "准备当天上学用品", "amount": 0.5, "icon": "🎒", "weekendOnly": false},
  {"group": "🏠 家务", "name": "摆碗筷、收拾餐桌", "amount": 1.0, "icon": "🍽️", "weekendOnly": false},
  {"group": "🏠 家务", "name": "扫地/拖地（自己房间）", "amount": 1.0, "icon": "🧹", "weekendOnly": false},
  {"group": "🏠 家务", "name": "倒垃圾（分类）", "amount": 0.5, "icon": "🗑️", "weekendOnly": false},
  {"group": "🏠 家务", "name": "擦桌子", "amount": 0.5, "icon": "🧽", "weekendOnly": false},
  {"group": "🏠 家务", "name": "整理玩具/书籍", "amount": 0.5, "icon": "🧸", "weekendOnly": false},
  {"group": "🏠 家务", "name": "周末：洗菜/择菜/洗袜子等", "amount": 2.0, "icon": "🧺", "weekendOnly": true},
  {"group": "📚 学习", "name": "按时完成作业（无催促）", "amount": 2.0, "icon": "📝", "weekendOnly": false},
  {"group": "📚 学习", "name": "主动复习/预习", "amount": 1.0, "icon": "📖", "weekendOnly": false},
  {"group": "📚 学习", "name": "课外阅读30分钟", "amount": 1.0, "icon": "📚", "weekendOnly": false},
  {"group": "📚 学习", "name": "练字/书法练习", "amount": 1.0, "icon": "✍️", "weekendOnly": false},
  {"group": "📚 学习", "name": "完成额外练习题", "amount": 1.0, "icon": "📐", "weekendOnly": false},
  {"group": "📚 学习", "name": "整理书包/学习资料", "amount": 0.5, "icon": "📁", "weekendOnly": false},
  {"group": "📚 学习", "name": "背单词/古诗词（10个）", "amount": 0.5, "icon": "🔤", "weekendOnly": false},
  {"group": "🏃 运动", "name": "跳绳100下", "amount": 1.0, "icon": "⏭️", "weekendOnly": false},
  {"group": "🏃 运动", "name": "跑步/慢跑800米", "amount": 1.5, "icon": "🏃", "weekendOnly": false},
  {"group": "🏃 运动", "name": "仰卧起坐30个", "amount": 1.0, "icon": "💪", "weekendOnly": false},
  {"group": "🏃 运动", "name": "坐位体前屈练习", "amount": 0.5, "icon": "🤸", "weekendOnly": false},
  {"group": "🏃 运动", "name": "立定跳远练习", "amount": 0.5, "icon": "🦘", "weekendOnly": false},
  {"group": "🏃 运动", "name": "开合跳/高抬腿（5分钟）", "amount": 1.0, "icon": "🔥", "weekendOnly": false},
  {"group": "🏃 运动", "name": "球类运动（篮球/足球/乒乓球等）", "amount": 1.5, "icon": "⚽", "weekendOnly": false}
]
''';

  static final List<Map<String, dynamic>> defaultTasks =
      jsonDecode(taskDataJson) as List<Map<String, dynamic>>;
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _initDefaults();
  }

  Future<void> _initDefaults() async {
    if (_prefs.getStringList('task_ids') == null) {
      final List<String> ids = [];
      for (var t in TaskConfig.defaultTasks) {
        final id = '${t['name']}_${DateTime.now().millisecondsSinceEpoch}';
        await _prefs.setString(id, jsonEncode({
          'id': id,
          'groupName': t['group'],
          'name': t['name'],
          'amount': t['amount'],
          'icon': t['icon'],
          'isWeekendOnly': t['weekendOnly'],
          'createdAt': DateTime.now().toIso8601String(),
          'isActive': true,
        }));
        ids.add(id);
      }
      await _prefs.setStringList('task_ids', ids);
    }
  }

  List<Task> getTasks() {
    final ids = _prefs.getStringList('task_ids') ?? [];
    final tasks = <Task>[];
    for (final id in ids) {
      final json = _prefs.getString(id);
      if (json != null) {
        final map = jsonDecode(json) as Map<String, dynamic>;
        tasks.add(Task(
          id: map['id'] as String,
          groupName: map['groupName'] as String,
          name: map['name'] as String,
          amount: (map['amount'] as num).toDouble(),
          icon: map['icon'] as String,
          isWeekendOnly: map['isWeekendOnly'] as bool,
          createdAt: DateTime.parse(map['createdAt'] as String),
          isActive: map['isActive'] as bool? ?? true,
        ));
      }
    }
    return tasks.where((t) => t.isActive).toList();
  }

  Task? getTaskById(String id) {
    final json = _prefs.getString(id);
    if (json == null) return null;
    final map = jsonDecode(json) as Map<String, dynamic>;
    return Task(
      id: map['id'] as String,
      groupName: map['groupName'] as String,
      name: map['name'] as String,
      amount: (map['amount'] as num).toDouble(),
      icon: map['icon'] as String,
      isWeekendOnly: map['isWeekendOnly'] as bool,
      createdAt: DateTime.parse(map['createdAt'] as String),
      isActive: map['isActive'] as bool? ?? true,
    );
  }

  Future<void> addTask(Task task) async {
    await _prefs.setString(task.id, jsonEncode({
      'id': task.id, 'groupName': task.groupName, 'name': task.name,
      'amount': task.amount, 'icon': task.icon, 'isWeekendOnly': task.isWeekendOnly,
      'createdAt': task.createdAt.toIso8601String(), 'isActive': task.isActive,
    }));
    final ids = _prefs.getStringList('task_ids') ?? [];
    ids.add(task.id);
    await _prefs.setStringList('task_ids', ids);
  }

  Future<void> updateTask(Task task) async {
    await _prefs.setString(task.id, jsonEncode({
      'id': task.id, 'groupName': task.groupName, 'name': task.name,
      'amount': task.amount, 'icon': task.icon, 'isWeekendOnly': task.isWeekendOnly,
      'createdAt': task.createdAt.toIso8601String(), 'isActive': task.isActive,
    }));
  }

  Future<void> deleteTask(String id) async {
    await _prefs.remove(id);
    final ids = _prefs.getStringList('task_ids') ?? [];
    ids.remove(id);
    await _prefs.setStringList('task_ids', ids);
  }

  Future<void> toggleCheck(String taskId, String dateKey) async {
    final key = 'check_${taskId}_$dateKey';
    final isChecked = _prefs.getBool(key) ?? false;
    await _prefs.setBool(key, !isChecked);
  }

  bool isTaskChecked(String taskId, String dateKey) {
    return _prefs.getBool('check_${taskId}_$dateKey') ?? false;
  }

  Map<String, double> getCheckedToday(String dateKey) {
    final ids = _prefs.getStringList('task_ids') ?? [];
    final result = <String, double>{};
    for (final id in ids) {
      if (_prefs.getBool('check_${id}_$dateKey') == true) {
        final task = getTaskById(id);
        if (task != null) result[id] = task.amount;
      }
    }
    return result;
  }

  Future<void> saveProfile(String childName, String className, String password) async {
    await _prefs.setString('profile_name', childName);
    await _prefs.setString('profile_class', className);
    await _prefs.setString('profile_password', password);
  }

  String getProfileName() => _prefs.getString('profile_name') ?? '小朋友';
  String getProfileClass() => _prefs.getString('profile_class') ?? '';
  String getProfilePassword() => _prefs.getString('profile_password') ?? '';
  double getProfileTotalEarned() => _prefs.getDouble('profile_total') ?? 0.0;
  int getProfileStreakDays() => _prefs.getInt('profile_streak') ?? 0;

  Future<void> saveProfileTotal(double total) async {
    await _prefs.setDouble('profile_total', total);
  }

  Future<void> saveProfileStreak(int streak) async {
    await _prefs.setInt('profile_streak', streak);
  }

  Map<String, double> getMonthStats(int year, int month) {
    final ids = _prefs.getStringList('task_ids') ?? [];
    final result = <String, double>{};
    for (final id in ids) {
      final task = getTaskById(id);
      if (task == null) continue;
      final firstDay = DateTime(year, month, 1);
      final lastDay = DateTime(year, month + 1, 0);
      int daysInMonth = lastDay.day;
      for (int day = 1; day <= daysInMonth; day++) {
        final dateKey = '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
        if (_prefs.getBool('check_${id}_$dateKey') == true) {
          result[dateKey] = (result[dateKey] ?? 0.0) + task.amount;
        }
      }
    }
    return result;
  }

  Future<void> resetAll() async {
    await _prefs.clear();
    await _initDefaults();
  }
}
