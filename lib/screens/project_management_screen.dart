import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/time_entry_provider.dart';
import '../models/project.dart';
import '../utils/strings.dart';

class ProjectManagementScreen extends StatelessWidget {
  const ProjectManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimeEntryProvider>(context);

    return Scaffold(
      appBar: AppBar(title:  Text(AppStrings.manageProjects)),
      body: ListView.builder(
        itemCount: provider.projects.length,
        itemBuilder: (ctx, index) => ListTile(
          title: Text(provider.projects[index].name),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => provider.deleteProject(provider.projects[index].id),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddProjectDialog(context),
      ),
    );
  }

  void _showAddProjectDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.addProject),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: AppStrings.projectName),
        ),
        actions: [
          TextButton(
            child: const Text(AppStrings.cancel),
            onPressed: () => Navigator.pop(ctx),
          ),
          TextButton(
            child: const Text(AppStrings.add),
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Provider.of<TimeEntryProvider>(ctx, listen: false).addProject(
                  Project(name: controller.text),
                );
                Navigator.pop(ctx);
              }
            },
          ),
        ],
      ),
    );
  }
}