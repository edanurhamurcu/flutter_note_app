import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/features/components/notes/providers/notes_provider.dart';
import 'package:notes_app/init/lang/locale_keys.g.dart';
import 'package:provider/provider.dart';

class AddNoteScreen extends StatelessWidget {
  final String? id;
  final String? title;
  final String? content;

  const AddNoteScreen(
      {super.key, this.id, this.title, this.content});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: title);
    final contentController = TextEditingController(text: content);

    return Scaffold(
      appBar: AppBar(
        title: Text(
            id == null ? LocaleKeys.new_note.tr() : LocaleKeys.crud_edit.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              final newTitle = titleController.text;
              final newContent = contentController.text;

              if (id == null) {
                Provider.of<NotesProvider>(context, listen: false)
                    .addNote(newTitle, newContent);
              } else {
                Provider.of<NotesProvider>(context, listen: false)
                    .updateNote(id!, newTitle, newContent);
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              controller: titleController,
              decoration: InputDecoration(
                hintText: LocaleKeys.header.tr(),
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            Text(
              DateFormat('dd MMMM HH:mm', 'tr_TR').format(DateTime.now()),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: contentController,
              decoration: InputDecoration(
                hintText: LocaleKeys.content.tr(),
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}