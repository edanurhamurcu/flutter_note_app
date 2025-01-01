import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/core/utils/navigation/app_routes.dart';
import 'package:notes_app/features/components/notes/models/note.dart';
import 'package:notes_app/features/components/notes/providers/notes_provider.dart';
import 'package:notes_app/init/lang/locale_keys.g.dart';

///
/// Shows a modal sheet with options for a note.
/// But it's not used in the app yet.
/// 

  Future showNoteOptionsModalSheet(
    BuildContext context,
    Note note,
    NotesProvider notesProvider,
    ) async {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
        _buildListTile(
          context,
          icon: Icons.edit,
          text: LocaleKeys.crud_edit.tr(),
          onTap: () => _editNote(context, note),
        ),
        _buildListTile(
          context,
          icon: Icons.delete,
          text: LocaleKeys.crud_delete.tr(),
          onTap: () => _deleteNote(context, note, notesProvider),
        ),
        ],
      );
      },
    );
    }

  Widget _buildListTile(BuildContext context, {required IconData icon, required String text, required VoidCallback onTap}) {
    return ListTile(
    leading: Icon(icon),
    title: Text(text),
    onTap: onTap,
    );
  }

  void _editNote(BuildContext context, Note note) {
    Navigator.of(context).pop();
    Navigator.pushReplacementNamed(context, AppRoutes.addNote, arguments: {
    'id': note.id,
    'title': note.title,
    'content': note.content,
    });

    
  }

  void _deleteNote(BuildContext context, Note note, NotesProvider notesProvider) {
    Navigator.of(context).pop();
    notesProvider.deleteNote(note.id);
  }
