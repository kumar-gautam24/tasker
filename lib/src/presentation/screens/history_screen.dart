// lib/presentation/screens/history_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasker/src/presentation/cubits/taskhistory/task_history_cubit.dart';
import 'package:tasker/src/presentation/widgets/widgets.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _loadMonthData();
  }

  void _loadMonthData() {
    context.read<TaskHistoryCubit>().loadHistoryForMonth(_focusedDay);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TaskHistoryCubit, TaskHistoryState>(
        builder: (context, state) {
          if (state is TaskHistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskHistoryLoaded) {
            return _buildHistoryView(state);
          } else if (state is TaskHistoryError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('Select a month to view history'));
          }
        },
      ),
    );
  }

  Widget _buildHistoryView(TaskHistoryLoaded state) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Task History',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        Expanded(
          child: CalendarTaskView(
            focusedDay: _focusedDay,
            recordsByDate: state.historyByDate,
            allTasks: state.tasks,
            onDaySelected: (selectedDay) {
              setState(() {
                _focusedDay = selectedDay;
              });
            },
            onPageChanged: (newMonth) {
              setState(() {
                _focusedDay = newMonth;
                _loadMonthData();
              });
            },
          ),
        ),
      ],
    );
  }
}
