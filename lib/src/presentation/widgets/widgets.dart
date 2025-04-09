// lib/presentation/widgets/task_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tasker/core/theme/app_theme.dart';
import 'package:tasker/src/domain/entity.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final Function() onCompleted;
  final Function() onFailed;
  final Function() onSkipped;

  const TaskCard({
    super.key,
    required this.task,
    required this.onCompleted,
    required this.onFailed,
    required this.onSkipped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.6,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    task.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildScheduleChips(context),
              const SizedBox(height: 16),
              _buildSwipeInstructions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleChips(BuildContext context) {
    final List<Widget> chips = [];
    
    if (task.schedule.monday) chips.add(_buildDayChip(context, 'MON'));
    if (task.schedule.tuesday) chips.add(_buildDayChip(context, 'TUE'));
    if (task.schedule.wednesday) chips.add(_buildDayChip(context, 'WED'));
    if (task.schedule.thursday) chips.add(_buildDayChip(context, 'THU'));
    if (task.schedule.friday) chips.add(_buildDayChip(context, 'FRI'));
    if (task.schedule.saturday) chips.add(_buildDayChip(context, 'SAT'));
    if (task.schedule.sunday) chips.add(_buildDayChip(context, 'SUN'));
    
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: chips,
    );
  }

  Widget _buildDayChip(BuildContext context, String day) {
    return Chip(
      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
      label: Text(
        day,
        style: TextStyle(
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSwipeInstructions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSwipeInstruction(
          context, 
          Icons.arrow_back, 
          'Failed', 
          AppTheme.failedColor
        ),
        const SizedBox(width: 24),
        _buildSwipeInstruction(
          context, 
          Icons.arrow_downward, 
          'Skip', 
          AppTheme.skippedColor
        ),
        const SizedBox(width: 24),
        _buildSwipeInstruction(
          context, 
          Icons.arrow_forward, 
          'Done', 
          AppTheme.completedColor
        ),
      ],
    );
  }

  Widget _buildSwipeInstruction(
    BuildContext context, 
    IconData icon, 
    String label, 
    Color color
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
          size: 32,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// lib/presentation/widgets/calendar_task_view.dart

class CalendarTaskView extends StatelessWidget {
  final DateTime focusedDay;
  final Map<DateTime, List<TaskCompletionRecord>> recordsByDate;
  final List<Task> allTasks;
  final Function(DateTime) onDaySelected;
  final Function(DateTime) onPageChanged;

  const CalendarTaskView({
    super.key,
    required this.focusedDay,
    required this.recordsByDate,
    required this.allTasks,
    required this.onDaySelected,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCalendar(context),
        const SizedBox(height: 16),
        _buildDaySummary(context),
      ],
    );
  }

  Widget _buildCalendar(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: focusedDay,
      calendarFormat: CalendarFormat.month,
      selectedDayPredicate: (day) => isSameDay(day, focusedDay),
      onDaySelected: (selectedDay, _) => onDaySelected(selectedDay),
      onPageChanged: onPageChanged,
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        todayDecoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        selectedDecoration: const BoxDecoration(
          color: AppTheme.primaryColor,
          shape: BoxShape.circle,
        ),
      ),
      eventLoader: (day) {
        final normalizedDay = DateTime(day.year, day.month, day.day);
        return recordsByDate[normalizedDay] ?? [];
      },
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, events) {
          if (events.isEmpty) return null;

          final normalizedDay = DateTime(day.year, day.month, day.day);
          final records = recordsByDate[normalizedDay] ?? [];
          
          final completedCount = records.where((r) => r.status == TaskStatus.completed).length;
          final failedCount = records.where((r) => r.status == TaskStatus.failed).length;
          final skippedCount = records.where((r) => r.status == TaskStatus.skipped).length;
          
          // Determine the color based on completion ratio
          Color markerColor = AppTheme.pendingColor;
          
          if (completedCount > 0 && failedCount == 0 && skippedCount == 0) {
            markerColor = AppTheme.completedColor;
          } else if (failedCount > 0 && completedCount == 0) {
            markerColor = AppTheme.failedColor;
          } else if (completedCount > 0 && failedCount > 0) {
            markerColor = AppTheme.warningColor;
          } else if (skippedCount > 0 && completedCount == 0 && failedCount == 0) {
            markerColor = AppTheme.skippedColor;
          }
          
          return Container(
            margin: const EdgeInsets.only(top: 4),
            height: 8,
            width: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: markerColor,
            ),
          );
        },
      ),
    );
  }

  Widget _buildDaySummary(BuildContext context) {
    final normalizedDay = DateTime(focusedDay.year, focusedDay.month, focusedDay.day);
    final dayRecords = recordsByDate[normalizedDay] ?? [];
    
    if (dayRecords.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No tasks completed on this day'),
        ),
      );
    }
    
    return Expanded(
      child: ListView.builder(
        itemCount: dayRecords.length,
        itemBuilder: (context, index) {
          final record = dayRecords[index];
          final task = allTasks.firstWhere(
            (t) => t.id == record.taskId,
            orElse: () => Task(
              id: 'unknown',
              title: 'Unknown Task',
              description: 'This task no longer exists',
              schedule: const WeekdaySchedule(),
              createdAt: DateTime.now(),
            ),
          );
          
          return _buildTaskRecord(context, task, record);
        },
      ),
    );
  }

  Widget _buildTaskRecord(
    BuildContext context,
    Task task,
    TaskCompletionRecord record,
  ) {
    Color statusColor;
    IconData statusIcon;
    
    switch (record.status) {
      case TaskStatus.completed:
        statusColor = AppTheme.completedColor;
        statusIcon = Icons.check_circle;
        break;
      case TaskStatus.failed:
        statusColor = AppTheme.failedColor;
        statusIcon = Icons.cancel;
        break;
      case TaskStatus.skipped:
        statusColor = AppTheme.skippedColor;
        statusIcon = Icons.skip_next;
        break;
      default:
        statusColor = AppTheme.pendingColor;
        statusIcon = Icons.hourglass_empty;
    }
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(
          statusIcon,
          color: statusColor,
          size: 28,
        ),
        title: Text(
          task.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Text(
          DateFormat('hh:mm a').format(record.date),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}

// lib/presentation/widgets/task_form.dart

class TaskForm extends StatefulWidget {
  final Task? initialTask;
  final Function(String, String, WeekdaySchedule) onSubmit;

  const TaskForm({
    super.key,
    this.initialTask,
    required this.onSubmit,
  });

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  bool _monday = true;
  bool _tuesday = true;
  bool _wednesday = true;
  bool _thursday = true;
  bool _friday = true;
  bool _saturday = true;
  bool _sunday = true;

  @override
  void initState() {
    super.initState();
    if (widget.initialTask != null) {
      _titleController.text = widget.initialTask!.title;
      _descriptionController.text = widget.initialTask!.description;
      
      _monday = widget.initialTask!.schedule.monday;
      _tuesday = widget.initialTask!.schedule.tuesday;
      _wednesday = widget.initialTask!.schedule.wednesday;
      _thursday = widget.initialTask!.schedule.thursday;
      _friday = widget.initialTask!.schedule.friday;
      _saturday = widget.initialTask!.schedule.saturday;
      _sunday = widget.initialTask!.schedule.sunday;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.initialTask == null ? 'Create New Task' : 'Edit Task',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                hintText: 'Enter a title for your task',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter task details',
                prefixIcon: Icon(Icons.description),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Schedule',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            _buildScheduleSelector(),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  widget.initialTask == null ? 'Create Task' : 'Update Task',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildDayChip('MON', _monday, (val) => setState(() => _monday = val)),
        _buildDayChip('TUE', _tuesday, (val) => setState(() => _tuesday = val)),
        _buildDayChip('WED', _wednesday, (val) => setState(() => _wednesday = val)),
        _buildDayChip('THU', _thursday, (val) => setState(() => _thursday = val)),
        _buildDayChip('FRI', _friday, (val) => setState(() => _friday = val)),
        _buildDayChip('SAT', _saturday, (val) => setState(() => _saturday = val)),
        _buildDayChip('SUN', _sunday, (val) => setState(() => _sunday = val)),
      ],
    );
  }

  Widget _buildDayChip(String label, bool selected, Function(bool) onSelected) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      backgroundColor: Colors.white,
      selectedColor: AppTheme.primaryColor.withOpacity(0.1),
      checkmarkColor: AppTheme.primaryColor,
      labelStyle: TextStyle(
        color: selected ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final schedule = WeekdaySchedule(
        monday: _monday,
        tuesday: _tuesday,
        wednesday: _wednesday,
        thursday: _thursday,
        friday: _friday,
        saturday: _saturday,
        sunday: _sunday,
      );
      
      widget.onSubmit(
        _titleController.text,
        _descriptionController.text,
        schedule,
      );
    }
  }
}

// lib/presentation/widgets/swipeable_task_card.dart

class SwipeableTaskCard extends StatefulWidget {
  final Task task;
  final Function() onCompleted;
  final Function() onFailed;
  final Function() onSkipped;

  const SwipeableTaskCard({
    super.key,
    required this.task,
    required this.onCompleted,
    required this.onFailed,
    required this.onSkipped,
  });

  @override
  State<SwipeableTaskCard> createState() => _SwipeableTaskCardState();
}

class _SwipeableTaskCardState extends State<SwipeableTaskCard> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late Offset _dragStartPosition;
  late Offset _dragPosition;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    
    _dragStartPosition = Offset.zero;
    _dragPosition = Offset.zero;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final offset = _animation.value;
          return Transform.translate(
            offset: offset,
            child: TaskCard(
              task: widget.task,
              onCompleted: widget.onCompleted,
              onFailed: widget.onFailed,
              onSkipped: widget.onSkipped,
            ),
          );
        },
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    _dragStartPosition = details.globalPosition;
    _dragPosition = details.globalPosition;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragPosition = details.globalPosition;
      
      final dx = _dragPosition.dx - _dragStartPosition.dx;
      final dy = _dragPosition.dy - _dragStartPosition.dy;
      
      _animation = Tween<Offset>(
        begin: Offset(dx, dy),
        end: Offset(dx, dy),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ));
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final dx = _dragPosition.dx - _dragStartPosition.dx;
    final dy = _dragPosition.dy - _dragStartPosition.dy;
    
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Determine if swipe is horizontal or vertical
    final isHorizontalSwipe = dx.abs() > dy.abs();
    
    if (isHorizontalSwipe) {
      // Horizontal swipe
      if (dx > screenWidth * 0.3) {
        // Swipe right - Completed
        _animation = Tween<Offset>(
          begin: Offset(dx, dy),
          end: Offset(screenWidth, 0),
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOut,
        ));
        _controller.forward().then((_) => widget.onCompleted());
      } else if (dx < -screenWidth * 0.3) {
        // Swipe left - Failed
        _animation = Tween<Offset>(
          begin: Offset(dx, dy),
          end: Offset(-screenWidth, 0),
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOut,
        ));
        _controller.forward().then((_) => widget.onFailed());
      } else {
        // Not enough swipe - Return to center
        _resetPosition(dx, dy);
      }
    } else {
      // Vertical swipe
      if (dy > screenHeight * 0.15) {
        // Swipe down - Skip
        _animation = Tween<Offset>(
          begin: Offset(dx, dy),
          end: Offset(0, screenHeight),
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOut,
        ));
        _controller.forward().then((_) => widget.onSkipped());
      } else {
        // Not enough swipe - Return to center
        _resetPosition(dx, dy);
      }
    }
  }

  void _resetPosition(double dx, double dy) {
    _animation = Tween<Offset>(
      begin: Offset(dx, dy),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _controller.forward(from: 0);
  }
}