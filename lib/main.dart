import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management/provider/auth_provider.dart';
import 'package:task_management/screens/login_screen.dart';
import 'package:task_management/screens/register_screen.dart';
import 'package:task_management/screens/task_edit_screen.dart';
import 'package:task_management/screens/task_list_screen.dart';

import 'models/task.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/register', // Set register screen as the initial route.
      onGenerateRoute: _generateRoute, // Dynamic route handling for arguments.
    );
  }

  // Custom route generator to handle dynamic arguments for screens.
  Route<dynamic> _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const TaskListScreen());
      case '/task/create':
        return MaterialPageRoute(builder: (_) => const TaskEditScreen());
      case '/task/edit':
        final task = settings.arguments as Task?; // Cast to Task to avoid type mismatch.
        return MaterialPageRoute(
          builder: (_) => TaskEditScreen(task: task),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('404 - Page Not Found'),
            ),
          ),
        );
    }
  }
}
