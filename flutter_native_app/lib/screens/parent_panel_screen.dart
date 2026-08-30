import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chore_provider.dart';
import '../models/task.dart';

class ParentPanelScreen extends StatefulWidget {
  const ParentPanelScreen({super.key});

  @override
  State<ParentPanelScreen> createState() => _ParentPanelScreenState();
}

class _ParentPanelScreenState extends State<ParentPanelScreen> {
  bool _authenticated = false;
  final _pwdCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _classCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final p = context.read<ChoreProvider>().profile;
    _nameCtrl.text = p.childName;
    _classCtrl.text = p.className;
  }

  @override
  void dispose() {
    _pwdCtrl.dispose();
    _nameCtrl.dispose();
    _classCtrl.dispose();
    super.dispose();
  }

  Future<void> _authenticate() async {
    final pwd = _pwdCtrl.text;
    final profile = context.read<ChoreProvider>().profile;
    if (pwd.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请输入密码')));
      return;
    }
    if (profile.parentPassword.isEmpty) {
      context.read<ChoreProvider>().updateProfile(
        _nameCtrl.text.isEmpty ? '小朋友' : _nameCtrl.text,
        _classCtrl.text,
        pwd,
      );
      setState(() => _authenticated = true);
      Navigator.pop(context);
    } else if (pwd == profile.parentPassword) {
      setState(() => _authenticated = true);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('密码错误')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_authenticated) return _buildLogin();
    return _buildSettings();
  }

  Widget _buildLogin() {
    final profile = context.read<ChoreProvider>().profile;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(title: const Text('家长管理'), backgroundColor: Colors.blueAccent),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.lock, size: 48, color: Colors.blueAccent),
            const SizedBox(height: 16),
            Text(profile.parentPassword.isEmpty ? '设置家长密码' : '输入家长密码',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(controller: _nameCtrl,
                decoration: const InputDecoration(labelText: '孩子姓名', border: OutlineInputBorder())),
            const SizedBox(height: 8),
            TextField(controller: _classCtrl,
                decoration: const InputDecoration(labelText: '班级', border: OutlineInputBorder())),
            const SizedBox(height: 8),
            TextField(controller: _pwdCtrl, obscureText: true,
                decoration: const InputDecoration(labelText: '密码', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _authenticate,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              child: const Text('确认'),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildSettings() {
    final profile = context.watch<ChoreProvider>().profile;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(title: const Text('家长管理'), backgroundColor: Colors.blueAccent),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Colors.blueAccent, Colors.lightBlue]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40, backgroundColor: Colors.white,
                    child: Icon(Icons.child_care, size: 48, color: Colors.blueAccent),
                  ),
                  const SizedBox(height: 12),
                  Text(profile.childName,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  if (profile.className.isNotEmpty)
                    Text(profile.className, style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 12),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                    _stat('累计收入', '+¥${profile.totalEarned.toStringAsFixed(1)}'),
                    _stat('连续打卡', '${profile.streakDays}天'),
                  ]),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _item('修改孩子姓名', _editName),
                  _item('修改班级', _editClass),
                  _item('修改家长密码', _editPassword),
                  _item('重置所有数据', _resetData, isDanger: true),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _stat(String label, String value) => Column(children: [
    Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
    Text(label, style: const TextStyle(color: Colors.white70)),
  ]);

  Widget _item(String title, VoidCallback onTap, {bool isDanger = false}) => ListTile(
    title: Text(title, style: TextStyle(color: isDanger ? Colors.red : Colors.black)),
    trailing: const Icon(Icons.chevron_right),
    onTap: onTap,
  );

  Future<void> _editName() async {
    final ctrl = TextEditingController(text: context.read<ChoreProvider>().profile.childName);
    await showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('修改姓名'),
      content: TextField(controller: ctrl, decoration: const InputDecoration(hintText: '输入姓名')),
      actions: [
        TextButton(onPressed: () => Navigator.pop(_), child: const Text('取消')),
        TextButton(onPressed: () {
          final p = context.read<ChoreProvider>().profile;
          context.read<ChoreProvider>().updateProfile(ctrl.text, p.className, p.parentPassword);
          Navigator.pop(_);
        }, child: const Text('保存')),
      ],
    ));
  }

  Future<void> _editClass() async {
    final ctrl = TextEditingController(text: context.read<ChoreProvider>().profile.className);
    await showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('修改班级'),
      content: TextField(controller: ctrl, decoration: const InputDecoration(hintText: '输入班级')),
      actions: [
        TextButton(onPressed: () => Navigator.pop(_), child: const Text('取消')),
        TextButton(onPressed: () {
          final p = context.read<ChoreProvider>().profile;
          context.read<ChoreProvider>().updateProfile(p.childName, ctrl.text, p.parentPassword);
          Navigator.pop(_);
        }, child: const Text('保存')),
      ],
    ));
  }

  Future<void> _editPassword() async {
    final ctrl = TextEditingController();
    await showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('修改密码'),
      content: TextField(controller: ctrl, obscureText: true,
          decoration: const InputDecoration(hintText: '输入新密码')),
      actions: [
        TextButton(onPressed: () => Navigator.pop(_), child: const Text('取消')),
        TextButton(onPressed: () {
          final p = context.read<ChoreProvider>().profile;
          context.read<ChoreProvider>().updateProfile(p.childName, p.className, ctrl.text);
          Navigator.pop(_);
        }, child: const Text('保存')),
      ],
    ));
  }

  Future<void> _resetData() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('重置数据'),
        content: const Text('确定要重置所有打卡数据吗？此操作不可恢复！'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(_, false), child: const Text('取消')),
          TextButton(
              onPressed: () => Navigator.pop(_, true),
              child: const Text('确认重置', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (ok == true) {
      await context.read<ChoreProvider>().init();
      setState(() => _authenticated = false);
    }
  }
}
