import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/core/utils/navigation/app_routes.dart';
import 'package:notes_app/core/utils/snackbar_helper.dart';
import 'package:notes_app/features/components/notes/providers/notes_provider.dart';
import 'package:notes_app/features/components/notes/screens/note_list_screen.dart';
import 'package:notes_app/init/lang/locale_keys.g.dart';
import 'package:provider/provider.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _loadNotes();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {});
  }

  Future<void> _loadNotes() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<NotesProvider>(context, listen: false).fetchNotes();
    } catch (e) {
      SnackbarHelper.showError(context,
          LocaleKeys.error_error_loading_notes.tr(args: [e.toString()]));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildTabIcon(int index, IconData icon) {
    return Tab(
      icon: Icon(
        icon,
        size: 32,
        color: _tabController.index == index ? Colors.amber : Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(LocaleKeys.my_notes.tr()),
        bottom: TabBar(
          tabAlignment: TabAlignment.center,
          indicator: BoxDecoration(
            color: Colors.transparent,
          ),
          dividerColor: Colors.transparent,
          controller: _tabController,
          tabs: [
            _buildTabIcon(0, Icons.check_box_outlined),
            _buildTabIcon(1, Icons.archive_outlined),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          NotesListScreen(
              isLoading: _isLoading, loadNotes: _loadNotes, tabIndex: 0),
          NotesListScreen(
              isLoading: _isLoading, loadNotes: _loadNotes, tabIndex: 1),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(
            AppRoutes.addNote,
            arguments: {
              'id': null,
              'title': '',
              'content': '',
            },
          );
        },
      ),
    );
  }
}
