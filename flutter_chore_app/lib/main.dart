import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'providers/chore_provider.dart';
import 'screens/daily_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/task_manager_screen.dart';
import 'screens/parent_panel_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const ChoreRewardApp());
}

class ChoreRewardApp extends StatelessWidget {
  const ChoreRewardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChoreProvider()..init(),
      child: MaterialApp(
        title: '家务零花钱打卡',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.blueAccent,
          ),
          useMaterial3: true,
        ),
        home: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = const [
    DailyScreen(),
    StatisticsScreen(),
    TaskManagerScreen(),
    ParentPanelScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.today), label: '打卡'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: '统计'),
          BottomNavigationBarItem(icon: Icon(Icons.task_alt), label: '任务'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '管理'),
        ],
      ),
    );
  }
}
