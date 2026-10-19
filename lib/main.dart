import 'package:flutter/material.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My To-Do',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const TodoListPage(),
    );
  }
}

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  // Our data: each task has a title and whether it's done.
  final List<Map<String, dynamic>> _tasks = [];
  final TextEditingController _inputController = TextEditingController();

  void _addTask() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return; // ignore empty input
    setState(() {
      _tasks.add({'title': text, 'done': false});
    });
    _inputController.clear(); // clear the text box for the next task
  }

  void _toggleTask(int index) {
    setState(() {
      _tasks[index]['done'] = !_tasks[index]['done'];
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final doneCount = _tasks.where((t) => t['done'] == true).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My To-Do'),
        centerTitle: true,
      ),
      body: _tasks.isEmpty
          ? const Center(
              child: Text(
                'Nothing to do yet.\nAdd your first task below!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    '$doneCount of ${_tasks.length} done',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      return ListTile(
                        leading: Checkbox(
                          value: task['done'],
                          onChanged: (_) => _toggleTask(index),
                        ),
                        title: Text(
                          task['title'],
                          style: TextStyle(
                            decoration: task['done']
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: task['done'] ? Colors.grey : Colors.black,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _deleteTask(index),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _inputController,
                decoration: const InputDecoration(
                  hintText: 'What needs doing?',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onSubmitted: (_) => _addTask(), // Enter key also adds
              ),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: _addTask,
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
