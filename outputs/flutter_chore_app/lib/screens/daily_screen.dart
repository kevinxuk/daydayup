import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chore_provider.dart';

class DailyScreen extends StatefulWidget {
  const DailyScreen({super.key});

  @override
  State<DailyScreen> createState() => _DailyScreenState();
}

class _DailyScreenState extends State<DailyScreen> {
  String _selectedDate = '';

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now().toIso8601String().split('T')[0];
  }

  String _getWeekday(DateTime d) {
    final days = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    return days[d.weekday - 1];
  }

  bool _isWeekend(String key) {
    final d = DateTime.parse(key);
    return d.weekday >= 6;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChoreProvider>();
    final grouped = provider.groupedTasks;
    final isToday = _selectedDate == provider.todayKey;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('每日打卡'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2024),
                lastDate: DateTime(2027),
              );
              if (picked != null) {
                setState(() => _selectedDate = picked.toIso8601String().split('T')[0]);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildDateHeader(provider),
            _buildStatsRow(provider),
            ...grouped.entries.map((e) => _buildGroup(e, provider, isToday)),
          ],
        ),
      ),
    );
  }

  Widget _buildDateHeader(ChoreProvider p) {
    final parts = _selectedDate.split('-');
    final date = DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
    final isWeekend = _isWeekend(_selectedDate);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isWeekend
              ? [const Color(0xFFFFF3E0), const Color(0xFFFFCCBC)]
              : [const Color(0xFFE3F2FD), const Color(0xFFBBDEFB)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_selectedDate, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 4),
              Text(
                '${parts[0]}年${parts[1]}月${parts[2]}日 ${_getWeekday(date)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Text(isToday ? '今天' : '历史', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(ChoreProvider p) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _statCard('今日收入', '+¥${p.todayTotal.toStringAsFixed(1)}', Colors.green)),
          const SizedBox(width: 8),
          Expanded(child: _statCard('本月累计', '+¥${p.monthTotal.toStringAsFixed(1)}', Colors.blue)),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildGroup(MapEntry<String, List<dynamic>> entry, ChoreProvider p, bool isToday) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            children: [
              Text(entry.key, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const Spacer(),
              Text('${entry.value.length}项', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Column(
            children: entry.value.map((task) => _buildTaskRow(task, p, isToday)).toList(),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildTaskRow(dynamic task, ChoreProvider p, bool isToday) {
    final isChecked = isToday && p.todayChecks[task.id] != null;
    final isWeekendTask = task.isWeekendOnly;
    final isWeekendDay = _isWeekend(_selectedDate);
    final isDisabled = isWeekendTask && !isWeekendDay;

    return InkWell(
      onTap: isDisabled || !isToday ? null : () => p.toggleTask(task.id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5))),
        child: Row(
          children: [
            Container(
              width: 24, height: 24,
              decoration: BoxDecoration(
                color: isChecked ? Colors.green : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: isChecked ? Colors.green : Colors.grey),
              ),
              child: isChecked ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
            ),
            const SizedBox(width: 12),
            Text(task.icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                task.name,
                style: TextStyle(
                  fontSize: 14,
                  color: isDisabled ? Colors.grey : Colors.black87,
                  decoration: isChecked ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Text('+¥${task.amount.toStringAsFixed(1)}', style: const TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold)),
            ),
            if (isWeekendTask) const Padding(padding: EdgeInsets.only(left: 8), child: Text('🌙')),
          ],
        ),
      ),
    );
  }
}
