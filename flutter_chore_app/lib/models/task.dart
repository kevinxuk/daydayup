class Task {
  String id;
  String groupName;
  String name;
  double amount;
  String icon;
  bool isWeekendOnly;
  DateTime createdAt;
  bool isActive;

  Task({
    required this.id,
    required this.groupName,
    required this.name,
    required this.amount,
    required this.icon,
    this.isWeekendOnly = false,
    required this.createdAt,
    this.isActive = true,
  });
}

class UserProfile {
  String childName;
  String className;
  String parentPassword;
  double totalEarned;
  int streakDays;
  DateTime lastActiveDate;

  UserProfile({
    this.childName = '小朋友',
    this.className = '',
    this.parentPassword = '',
    this.totalEarned = 0.0,
    this.streakDays = 0,
    required this.lastActiveDate,
  });
}
