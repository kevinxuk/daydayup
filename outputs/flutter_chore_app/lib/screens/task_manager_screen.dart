import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chore_provider.dart';
import '../models/task.dart';

class TaskManagerScreen extends StatefulWidget {
  const TaskManagerScreen({super.key});

  @override
  State<TaskManagerScreen> createState() => _TaskManagerScreenState();
}

class _TaskManagerScreenState extends State<TaskManagerScreen> {
  final _nameCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _iconCtrl = TextEditingController();
  String _selectedGroup = '🌅 晨间';
  bool _isWeekendOnly = false;

  final List<String> _groups = ['🌅 晨间', '🏠 家务', '📚 学习', '🏃 运动'];
  final List<String> _icons = [
    '⏰', '🛏️', '🍳', '🎒', '🍽️', '🧹', '🗑️', '🧽', '🧸', '🧺',
    '📝', '📖', '📚', '✍️', '📐', '📁', '🔤',
    '⏭️', '🏃', '💪', '🤸', '🦘', '🔥', '⚽'
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _amountCtrl.dispose();
    _iconCtrl.dispose();
    super.dispose();
  }

  void _showAddDialog() {
    _nameCtrl.clear();
    _amountCtrl.clear();
    _iconCtrl.text = '✅';
    _selectedGroup = '🌅 晨间';
    _isWeekendOnly = false;
    showDialog(
      context: context,
      builder: (_) => _TaskDialog(
        name: _nameCtrl, amount: _amountCtrl, icon: _iconCtrl,
        group: _selectedGroup, isWeekend: _isWeekendOnly,
        groups: _groups, icons: _icons,
        onSave: (name, amount, icon, group, isWeekend) {
          final task = Task(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            groupName: group, name: name, amount: amount,
            icon: icon, isWeekendOnly: isWeekend, createdAt: DateTime.now(),
          );
          context.read<ChoreProvider>().addTask(task);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showEditDialog(Task task) {
    _nameCtrl.text = task.name;
    _amountCtrl.text = task.amount.toString();
    _iconCtrl.text = task.icon;
    _selectedGroup = task.groupName;
    _isWeekendOnly = task.isWeekendOnly;
    showDialog(
      context: context,
      builder: (_) => _TaskDialog(
        name: _nameCtrl, amount: _amountCtrl, icon: _iconCtrl,
        group: _selectedGroup, isWeekend: _isWeekendOnly,
        groups: _groups, icons: _icons,
        onSave: (name, amount, icon, group, isWeekend) {
          task.name = name; task.amount = amount; task.icon = icon;
          task.groupName = group; task.isWeekendOnly = isWeekend;
          context.read<ChoreProvider>().updateTask(task);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _confirmDelete(Task task) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('删除任务'),
        content: Text('确定删除"${task.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
          TextButton(onPressed: () { context.read<ChoreProvider>().deleteTask(task.id); Navigator.pop(context); },
              child: const Text('删除', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<ChoreProvider>().tasks;
    final grouped = <String, List<Task>>{};
    for (var t in tasks) grouped.putIfAbsent(t.groupName, () => []).add(t);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(title: const Text('任务管理'), backgroundColor: Colors.blueAccent, actions: [
        IconButton(icon: const Icon(Icons.add), onPressed: _showAddDialog),
      ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(padding: const EdgeInsets.all(16), child: Row(children: [
              _chip('🌅 晨间', grouped['🌅 晨间']?.length ?? 0, Colors.orange),
              const SizedBox(width: 8),
              _chip('🏠 家务', grouped['🏠 家务']?.length ?? 0, Colors.blue),
              const SizedBox(width: 8),
              _chip('📚 学习', grouped['📚 学习']?.length ?? 0, Colors.green),
              const SizedBox(width: 8),
              _chip('🏃 运动', grouped['🏃 运动']?.length ?? 0, Colors.teal),
            ])),
            ...grouped.entries.map((e) => _buildGroup(e)).toList(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, int count, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
    child: Text('$label $count项', style: TextStyle(fontSize: 12, color: color)),
  );

  Widget _buildGroup(MapEntry<String, List<Task>> entry) {
    return Column(
      children: [
        Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 4), child: Text(entry.key, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey))),
        Container(margin: const EdgeInsets.symmetric(horizontal: 16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)), child: Column(
          children: entry.value.map((t) => ListTile(
            leading: Text(t.icon, style: const TextStyle(fontSize: 24)),
            title: Text(t.name),
            subtitle: Row(children: [
              Text('¥${t.amount.toStringAsFixed(1)}', style: const TextStyle(color: Colors.green)),
              if (t.isWeekendOnly) ...[const SizedBox(width: 8), const Text('🌙 仅周末', style: TextStyle(fontSize: 11, color: Colors.grey))],
            ]),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(icon: Icon(t.isActive ? Icons.check_circle : Icons.cancel, color: t.isActive ? Colors.green : Colors.grey), onPressed: () => context.read<ChoreProvider>().toggleTaskActive(t.id)),
              IconButton(icon: const Icon(Icons.edit), onPressed: () => _showEditDialog(t)),
              IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _confirmDelete(t)),
            ]),
          )).toList(),
        )),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _TaskDialog extends StatelessWidget {
  final TextEditingController name;
  final TextEditingController amount;
  final TextEditingController icon;
  final String group;
  final bool isWeekend;
  final List<String> groups;
  final List<String> icons;
  final Function(String, double, String, String, bool) onSave;

  const _TaskDialog({required this.name, required this.amount, required this.icon, required this.group, required this.isWeekend, required this.groups, required this.icons, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('添加任务'),
      content: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          DropdownButton<String>(value: group, items: groups.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(), onChanged: (v) {}, isExpanded: true),
          const SizedBox(height: 8),
          TextField(controller: icon, decoration: const InputDecoration(labelText: '图标 (Emoji)', border: OutlineInputBorder())),
          const SizedBox(height: 8),
          TextField(controller: name, decoration: const InputDecoration(labelText: '任务名称', border: OutlineInputBorder())),
          const SizedBox(height: 8),
          TextField(controller: amount, decoration: const InputDecoration(labelText: '金额 (元)', border: OutlineInputBorder()), keyboardType: const TextInputType.numberWithOptions(decimal: true)),
          const SizedBox(height: 8),
          SwitchListTile(title: const Text('仅周末可完成'), value: isWeekend, onChanged: (v) {}),
        ]),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
        ElevatedButton(onPresse
