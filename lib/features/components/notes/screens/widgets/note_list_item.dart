import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/core/utils/navigation/app_routes.dart';
import 'package:notes_app/core/utils/snackbar_helper.dart';
import 'package:notes_app/features/components/notes/models/note.dart';
import 'package:notes_app/features/components/notes/providers/notes_provider.dart';
import 'package:notes_app/init/lang/locale_keys.g.dart';

class NoteListItem extends StatelessWidget {
  final Note note;
  final NotesProvider notesProvider;

  const NoteListItem({
    super.key,
    required this.note,
    required this.notesProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(note.id),
      background: note.isArchived
          ? Container(
              color: Colors.orange,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(
                Icons.unarchive_outlined,
                color: Colors.white,
              ),
            )
          : Container(
              color: Colors.green,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.archive, color: Colors.white),
            ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          if (note.isArchived) {
            notesProvider.unarchiveNote(note.id);
          } else {
            notesProvider.archiveNote(note.id);
          }
          return false;
        } else if (direction == DismissDirection.endToStart) {
          notesProvider.deleteNote(note.id);
          SnackbarHelper.showSuccess(context, LocaleKeys.crud_delete.tr());
          return true;
        }
        return false;
      },
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                notesProvider.formatNoteDate(
                    note.updatedTime ?? note.createdTime, context),
                style: const TextStyle(fontSize: 10),
              ),
            ],
          ),
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.addNote,
              arguments: {
                'id': note.id,
                'title': note.title,
                'content': note.content,
              },
            );
          },
        ),
      ),
    );
  }
}
