import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/time_entry_provider.dart';
import '../utils/strings.dart';

class TaskManagementScreen extends StatelessWidget {
  const TaskManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimeEntryProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.manageTasks)),
      body: ListView.builder(
        itemCount: provider.tasks.length,
        itemBuilder: (ctx, index) => ListTile(
          title: Text(provider.tasks[index]),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => provider.deleteTask(provider.tasks[index]),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddTaskDialog(context),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.addTask),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: AppStrings.taskName),
        ),
        actions: [
          TextButton(
            child: const Text(AppStrings.cancel),
            onPressed: () => Navigator.pop(ctx),
          ),
          TextButton(
            child:  Text(AppStrings.add),
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Provider.of<TimeEntryProvider>(ctx, listen: false)
                    .addTask(controller.text);
                Navigator.pop(ctx);
              }
            },
          ),
        ],
      ),
    );
  }
}