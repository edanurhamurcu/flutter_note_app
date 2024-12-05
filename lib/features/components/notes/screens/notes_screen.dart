import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notes_app/features/components/notes/models/note.dart';
import 'package:notes_app/features/components/notes/providers/notes_provider.dart';
import 'package:notes_app/features/components/notes/screens/add_note_screen.dart';
import 'package:notes_app/features/components/settings/settings_screen.dart';
import 'package:notes_app/init/lang/locale_keys.g.dart';
import 'package:provider/provider.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  String _formatNoteDate(DateTime date, BuildContext context) {
    final now = DateTime.now();
    final isToday =
        now.day == date.day && now.month == date.month && now.year == date.year;

    final locale = EasyLocalization.of(context)?.currentLocale.toString();

    if (isToday) {
      // Bugünse saat ve dakika göster
      return DateFormat('HH:mm', locale).format(date);
    } else {
      // Bugünden önceyse gün ve ay göster
      return DateFormat('dd MMMM', locale).format(date);
    }
  }

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<NotesProvider>(context, listen: false).fetchNotes();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Notlar yüklenirken bir hata oluştu: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);
    final notes =
        notesProvider.notes.where((note) => !note.isArchived).toList();

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(LocaleKeys.my_notes.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return SettingsScreen();
              }));
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : notes.isEmpty
              ? Center(child: Text(LocaleKeys.not_yet.tr()))
              : ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return Slidable(
                      key: Key(note.id),
                      startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              notesProvider.archiveNote(note.id);
                            },
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            icon: Icons.archive,
                            label: LocaleKeys.crud_archive.tr(),
                          ),
                        ],
                      ),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              notesProvider.deleteNote(note.id);
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: LocaleKeys.crud_delete.tr(),
                          ),
                        ],
                      ),
                      child: Card(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: ListTile(
                          title: Text(
                            note.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note.content,
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                _formatNoteDate(
                                    note.updatedTime ?? note.createdTime,
                                    context),
                                style: const TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                          onTap: () {
                            modalSheet(context, note, notesProvider);
                          },
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return const AddNoteScreen(id: null, title: '', content: '');
          }));
        },
      ),
    );
  }

  modalSheet(
    BuildContext context,
    Note note,
    NotesProvider notesProvider,
  ) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: Text(LocaleKeys.crud_edit.tr()),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return AddNoteScreen(
                    id: note.id,
                    title: note.title,
                    content: note.content,
                  );
                }));
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: Text(LocaleKeys.crud_delete.tr()),
              onTap: () {
                Navigator.of(context).pop();
                notesProvider.deleteNote(note.id);
              },
            ),
          ],
        );
      },
    );
  }
}
