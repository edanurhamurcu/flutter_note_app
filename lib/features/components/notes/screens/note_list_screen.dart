import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/core/utils/loader_overlay.dart';
import 'package:notes_app/core/utils/wrap_loader.dart';
import 'package:notes_app/features/components/notes/providers/notes_provider.dart';
import 'package:notes_app/features/components/notes/screens/widgets/note_list_item.dart';
import 'package:notes_app/init/lang/locale_keys.g.dart';
import 'package:provider/provider.dart';

class NotesListScreen extends StatelessWidget {
  final bool isLoading;
  final Future<void> Function() loadNotes;
  final int tabIndex;

  const NotesListScreen({
    super.key,
    required this.isLoading,
    required this.loadNotes,
    required this.tabIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<NotesProvider>(
      builder: (context, notesProvider, child) {
        final notes =
            notesProvider.notes.where((note) => !note.isArchived).toList();
        final archivedNotes =
            notesProvider.notes.where((note) => note.isArchived).toList();

        if (isLoading) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            LoaderOverlay().show(context);
          });
        }

        LoaderOverlay().hide();

        final displayedNotes = tabIndex == 0 ? notes : archivedNotes;

        if (displayedNotes.isEmpty) {
          return Center(child: Text(LocaleKeys.not_yet.tr()));
        }

        return WrapLoader(
          onRefresh: loadNotes,
          child: ListView.builder(
            itemCount: displayedNotes.length,
            itemBuilder: (context, index) {
              final note = displayedNotes[index];
              return NoteListItem(note: note, notesProvider: notesProvider);
            },
          ),
        );
      },
    );
  }
}
