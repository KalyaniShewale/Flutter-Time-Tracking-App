import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/time_entry_provider.dart';
import '../screens/add_entry_screen.dart';
import '../screens/project_management_screen.dart';
import '../screens/task_management_screen.dart';
import '../utils/strings.dart';

class HomeScreen extends StatefulWidget  {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimeEntryProvider>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text(AppStrings.appTitle),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: AppStrings.allEntries),
              Tab(text: AppStrings.byProject),
            ],
          ),
        ),
        drawer: _buildDrawer(context),
        body: TabBarView(
          children: [
            _buildAllEntriesTab(provider),
            _buildGroupedByProjectTab(provider),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () =>
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddEntryScreen()),
              ),
        ),
      ),
    );
  }

  Widget _buildAllEntriesTab(TimeEntryProvider provider) {
    if (provider.entries.isEmpty) {
      return const Center(child: Text(AppStrings.noEntries));
    }

    return ListView.builder(
      itemCount: provider.entries.length,
      itemBuilder: (ctx, i) =>
          ListTile(
            title: Text(provider.entries[i].notes),
            subtitle: Text('${provider.entries[i].hours} hours'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => provider.deleteEntry(provider.entries[i].id),
            ),
          ),
    );
  }

  Widget _buildGroupedByProjectTab(TimeEntryProvider provider) {
    return ListView.builder(
      itemCount: provider.projects.length,
      itemBuilder: (ctx, index) =>
          Card(
            child: ExpansionTile(
              title: Text(provider.projects[index].name),
              children: provider.entries
                  .where((e) => e.projectId == provider.projects[index].id)
                  .map((entry) =>
                  ListTile(
                    title: Text(entry.notes),
                    subtitle: Text('${entry.hours} hours'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => provider.deleteEntry(entry.id),
                    ),
                  ))
                  .toList(),
            ),
          ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(AppStrings.appTitle, style: TextStyle(color: Colors.white)),
          ),
          ListTile(
            leading: const Icon(Icons.work),
            title: const Text(AppStrings.projects),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const ProjectManagementScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.task),
            title: const Text(AppStrings.tasks),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TaskManagementScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}