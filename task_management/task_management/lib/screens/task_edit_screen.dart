import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';
import '../models/user.dart';
import '../service/api_service.dart';


class TaskEditScreen extends StatefulWidget {
  final Task? task;

  const TaskEditScreen({super.key, this.task});

  @override
  _TaskEditScreenState createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends State<TaskEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));
  String _priority = 'MEDIUM';
  User? _assignedUser;
  bool _isLoading = false;
  List<User> _availableUsers = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
    if (widget.task != null) {
      _populateTaskDetails(widget.task!);
    }
  }

  void _populateTaskDetails(Task task) {
    _titleController.text = task.title;
    _descriptionController.text = task.description;
    _dueDate = task.dueDate;
    _priority = task.priority;
    _assignedUser = task.assignedTo;
  }

  Future<void> _loadUsers() async {
    try {
      final users = await ApiService().getUsers();
      setState(() => _availableUsers = users);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load users: $e')),
      );
    }
  }

  Future<void> _submitTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final newTask = Task(
        id: widget.task?.id ?? 0,
        title: _titleController.text,
        description: _descriptionController.text,
        dueDate: _dueDate,
        priority: _priority,
        isCompleted: false,
        assignedTo: _assignedUser,
      );

      final apiService = ApiService();
      if (widget.task == null) {
        await apiService.createTask(newTask.toJson());
      } else {
        await apiService.updateTask(newTask.id, newTask.toJson());
      }

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save task: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _selectDueDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null) {
      setState(() => _dueDate = pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'Create Task'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Task Details',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                ),
                const SizedBox(height: 16),
                // Title Field
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: const TextStyle(color: Colors.deepPurple),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Please enter a title'
                      : null,
                ),
                const SizedBox(height: 16),
                // Description Field
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: const TextStyle(color: Colors.deepPurple),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                // Priority Dropdown
                DropdownButtonFormField<String>(
                  value: _priority,
                  decoration: InputDecoration(
                    labelText: 'Priority',
                    labelStyle: const TextStyle(color: Colors.deepPurple),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                  items: ['HIGH', 'MEDIUM', 'LOW']
                      .map(
                        (priority) => DropdownMenuItem(
                      value: priority,
                      child: Text(priority),
                    ),
                  )
                      .toList(),
                  onChanged: (value) => setState(() => _priority = value!),
                ),
                const SizedBox(height: 16),
                // Due Date
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Due Date', style: TextStyle(color: Colors.deepPurple)),
                  subtitle: Text(DateFormat.yMMMd().format(_dueDate)),
                  trailing: const Icon(Icons.calendar_today, color: Colors.deepPurple),
                  onTap: _selectDueDate,
                ),
                const SizedBox(height: 16),
                // Assign User
                DropdownButtonFormField<User>(
                  value: _assignedUser,
                  decoration: InputDecoration(
                    labelText: 'Assign To (Optional)',
                    labelStyle: const TextStyle(color: Colors.deepPurple),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                  items: _availableUsers.map((user) {
                    return DropdownMenuItem(
                      value: user,
                      child: Text(user.username),
                    );
                  }).toList(),
                  onChanged: (user) => setState(() => _assignedUser = user),
                  hint: const Text('Select User (Optional)'),
                ),
                const SizedBox(height: 24),
                // Submit Button
                Center(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple, // Set the button color
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(isEditing ? 'Save Changes' : 'Create Task', style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
