import 'package:flutter/material.dart';

import '../models/task.dart';
import '../service/api_service.dart';
import '../widgets/task_list_item.dart';


class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final ApiService _apiService = ApiService();
  List<Task> _tasks = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _filterPriority = '';
  bool _filterCompleted = false;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      final tasks = await _apiService.getTasks();
      setState(() {
        _tasks = tasks;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load tasks: ${e.toString()}')),
      );
    }
  }

  List<Task> get filteredTasks {
    return _tasks.where((task) {
      final matchesSearch = task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          task.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesPriority = _filterPriority.isEmpty || task.priority == _filterPriority;
      final matchesComplete = !_filterCompleted || task.isCompleted == _filterCompleted;
      return matchesSearch && matchesPriority && matchesComplete;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
        backgroundColor: Colors.deepPurple, // Custom color for AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/task/create'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Increased padding for better spacing
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search tasks',
                  labelStyle: const TextStyle(color: Colors.deepPurple),
                  prefixIcon: const Icon(Icons.search, color: Colors.deepPurple),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(color: Colors.deepPurple),
                  ),
                  filled: true,
                  fillColor: Colors.deepPurple.shade50,
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),

            // Filters
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  // Priority Filter
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _filterPriority.isEmpty ? null : _filterPriority,
                      decoration: InputDecoration(
                        labelText: 'Priority',
                        labelStyle: const TextStyle(color: Colors.deepPurple),
                        filled: true,
                        fillColor: Colors.deepPurple.shade50,
                      ),
                      items: ['', 'HIGH', 'MEDIUM', 'LOW']
                          .map((priority) => DropdownMenuItem(
                        value: priority,
                        child: Text(priority.isEmpty ? 'All' : priority),
                      ))
                          .toList(),
                      onChanged: (value) => setState(() => _filterPriority = value ?? ''),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Completed Filter
                  Expanded(
                    child: Row(
                      children: [
                        const Text('Completed'),
                        Switch(
                          activeColor: Colors.deepPurple,
                          value: _filterCompleted,
                          onChanged: (value) => setState(() => _filterCompleted = value),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Task List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredTasks.isEmpty
                  ? const Center(child: Text('No tasks found.'))
                  : ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = filteredTasks[index];
                  return TaskListItem(
                    task: task,
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/task/detail',
                      arguments: task,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
