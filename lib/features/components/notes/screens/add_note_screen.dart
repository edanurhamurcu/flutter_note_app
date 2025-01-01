import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/features/components/notes/providers/notes_provider.dart';
import 'package:notes_app/init/lang/locale_keys.g.dart';
import 'package:provider/provider.dart';

class AddNoteScreen extends StatefulWidget {
  final String? id;
  final String? title;
  final String? content;

  const AddNoteScreen({super.key, this.id, this.title, this.content});

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  late TextEditingController titleController;
  late TextEditingController contentController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);
    contentController = TextEditingController(text: widget.content);
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM HH:mm', 'tr_TR');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null
            ? LocaleKeys.new_note.tr()
            : LocaleKeys.crud_edit.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              final newTitle = titleController.text;
              final newContent = contentController.text;

              if (widget.id == null) {
                context.read<NotesProvider>().addNote(newTitle, newContent);
              } else {
                context
                    .read<NotesProvider>()
                    .updateNote(widget.id!, newTitle, newContent);
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
              dateFormat.format(DateTime.now()),
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
              maxLines: null,
              minLines: 5,
            ),
          ],
        ),
      ),
    );
  }
}
