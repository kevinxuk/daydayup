import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chore_provider.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int _selectedYear = 2026;
  int _selectedMonth = 8;
  final List<int> _years = [2025, 2026, 2027];
  final List<int> _months = List.generate(12, (i) => i + 1);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChoreProvider>();
    final monthTotal = provider.monthTotal;
    final bestDay = provider.bestDay;
    final checkedDays = provider.checkedDays;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(title: const Text('数据统计'), backgroundColor: Colors.blueAccent),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildDateSelector(),
            const SizedBox(height: 16),
            _buildSummaryCards(monthTotal, bestDay, checkedDays),
            const SizedBox(height: 16),
            _buildGroupChart(provider),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _selector('年', _years, _selectedYear, (v) => setState(() => _selectedYear = v)),
          _selector('月', _months, _selectedMonth, (v) => setState(() => _selectedMonth = v)),
        ],
      ),
    );
  }

  Widget _selector(String label, List<int> items, int selected, Function(int) onChange) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        DropdownButton<int>(
          value: selected,
          items: items.map((i) => DropdownMenuItem(value: i, child: Text('$i'))).toList(),
          onChanged: (v) => onChange(v!),
        ),
      ],
    );
  }

  Widget _buildSummaryCards(double monthTotal, double bestDay, int checkedDays) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _card('本月收入', '+¥${monthTotal.toStringAsFixed(1)}', Colors.green)),
          const SizedBox(width: 8),
          Expanded(child: _card('最高单日', '+¥${bestDay.toStringAsFixed(1)}', Colors.blue)),
          const SizedBox(width: 8),
          Expanded(child: _card('打卡天数', '$checkedDays天', Colors.orange)),
        ],
      ),
    );
  }

  Widget _card(String label, String value, Color color) {
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

  Widget _buildGroupChart(ChoreProvider provider) {
    final grouped = provider.groupedTasks;
    final colors = [Colors.blueAccent, Colors.green, Colors.orange, Colors.teal];

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('任务分布', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...grouped.entries.toList().asMap().entries.map((entry) {
            final idx = entry.key;
            final group = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(width: 12, height: 12, decoration: BoxDecoration(color: colors[idx % colors.length], borderRadius: BorderRadius.circular(3))),
                  const SizedBox(width: 8),
                  Expanded(child: Text(group.key, style: const TextStyle(fontSize: 14))),
                  Text('${group.value.length}项', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
