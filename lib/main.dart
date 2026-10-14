import 'package:flutter/material.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E6FFB)),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const TodoHomeScreen(),
    );
  }
}

// Model sederhana untuk To-Do Item
class TodoItem {
  String title;
  bool isDone;

  TodoItem({required this.title, this.isDone = false});
}

class TodoHomeScreen extends StatefulWidget {
  const TodoHomeScreen({super.key});

  @override
  State<TodoHomeScreen> createState() => _TodoHomeScreenState();
}

class _TodoHomeScreenState extends State<TodoHomeScreen> {
  // Data list to-do lokal (in-memory)
  final List<TodoItem> _todos = [
    TodoItem(title: 'Meeting with Team - Discuss project'),
    TodoItem(title: 'Grocery Shopping - Buy milk and eggs'),
    TodoItem(title: 'Workout - 30-minute run'),
    TodoItem(title: 'Pay Electricity Bill', isDone: true),
    TodoItem(title: "Book Doctor's Appointment", isDone: true),
  ];

  final TextEditingController _taskController = TextEditingController();

  // Fungsi menambah task via dialog sederhana
  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tambah Tugas Baru'),
        content: TextField(
          controller: _taskController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Masukkan nama tugas...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _taskController.clear();
              Navigator.pop(ctx);
            },
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final text = _taskController.text.trim();
              if (text.isNotEmpty) {
                setState(() {
                  _todos.add(TodoItem(title: text));
                });
                _taskController.clear();
              }
              Navigator.pop(ctx);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingTasks = _todos.where((t) => !t.isDone).toList();
    final completedTasks = _todos.where((t) => t.isDone).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Color(0xFF1E6FFB)),
            SizedBox(width: 8),
            Text(
              'To Do List',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E6FFB),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _todos.isEmpty
          ? const Center(
              child: Text(
                'Tidak ada tugas. Tekan + untuk menambah!',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                if (pendingTasks.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Tugas Belum Selesai',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  ...pendingTasks.map((item) => _buildTodoTile(item)),
                ],
                if (completedTasks.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Tugas Selesai',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  ...completedTasks.map((item) => _buildTodoTile(item)),
                ],
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: const Color(0xFF1E6FFB),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Widget baris item to-do
  Widget _buildTodoTile(TodoItem item) {
    return Card(
      elevation: 0,
      color: item.isDone ? const Color(0xFFF8FAFC) : const Color(0xFFEFF6FF),
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: item.isDone ? const Color(0xFFE2E8F0) : const Color(0xFFDBEAFE),
        ),
      ),
      child: ListTile(
        leading: Checkbox(
          value: item.isDone,
          activeColor: const Color(0xFF1E6FFB),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          onChanged: (val) {
            setState(() {
              item.isDone = val ?? false;
            });
          },
        ),
        title: Text(
          item.title,
          style: TextStyle(
            fontSize: 15,
            decoration: item.isDone ? TextDecoration.lineThrough : null,
            color: item.isDone ? const Color(0xFF94A3B8) : const Color(0xFF1E293B),
            fontWeight: item.isDone ? FontWeight.normal : FontWeight.w500,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          onPressed: () {
            setState(() {
              _todos.remove(item);
            });
          },
        ),
      ),
    );
  }
}
