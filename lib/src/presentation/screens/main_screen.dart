

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasker/injection_cotainer.dart' as di;
import 'package:tasker/src/presentation/cubits/taskcard/task_card_cubit.dart';
import 'package:tasker/src/presentation/cubits/taskhistory/task_history_cubit.dart';
import 'package:tasker/src/presentation/screens/history_screen.dart';
import 'package:tasker/src/presentation/screens/home_screen.dart';
import 'package:tasker/src/presentation/screens/task_list_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          BlocProvider(
            create: (_) => di.sl<TaskCardCubit>(),
            child: const HomeScreen(),
          ),
          BlocProvider(
            create: (_) => di.sl<TaskHistoryCubit>(),
            child: const HistoryScreen(),
          ),
          const TasksListScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Today',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Tasks',
          ),
        ],
      ),
    );
  }
}