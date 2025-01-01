import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/features/components/notes/models/note.dart';

class NotesProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _userId;
  List<Note> _notes = [];

  NotesProvider(this._userId);

  List<Note> get notes => [..._notes];

  String formatNoteDate(DateTime date, BuildContext context) {
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

  Future<void> fetchNotes() async {
    try {
      final snapshot = await _firestore
          .collection('notes')
          .where('userId', isEqualTo: _userId)
          .get();

      _notes = snapshot.docs
          .map((doc) => Note.fromFirestore(doc.data(), doc.id))
          .toList();

      notifyListeners();
    } catch (e) {
      throw 'Notları getirirken bir hata oluştu: $e';
    }
  }

  Future<void> addNote(String title, String content) async {
    try {
      final newNote = Note(
        id: '', // Firestore otomatik ID oluşturacağı için boş bırakıyoruz.
        title: title,
        content: content,
        createdTime: DateTime.now(),
        userId: _userId,
      );

      final docRef =
          await _firestore.collection('notes').add(newNote.toFirestore());
      newNote.id =
          docRef.id; // Firestore'un oluşturduğu ID'yi notun ID'sine atıyoruz.
      _notes.add(newNote);
      notifyListeners();
    } catch (e) {
      throw 'Not eklenirken bir hata oluştu: $e';
    }
  }

  Future<void> updateNote(String id, String title, String content) async {
    try {
      final noteIndex = _notes.indexWhere((note) => note.id == id);
      if (noteIndex >= 0) {
        final updatedNote = Note(
          id: id,
          title: title,
          content: content,
          createdTime: _notes[noteIndex].createdTime,
          updatedTime: DateTime.now(),
          userId: _userId,
          imageUrl: _notes[noteIndex].imageUrl,
          tags: _notes[noteIndex].tags,
        );

        await _firestore
            .collection('notes')
            .doc(id)
            .update(updatedNote.toFirestore());
        _notes[noteIndex] = updatedNote;
        notifyListeners();
      }
    } catch (e) {
      throw 'Not güncellenirken bir hata oluştu: $e';
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      await _firestore.collection('notes').doc(id).delete();
      _notes.removeWhere((note) => note.id == id);
      notifyListeners();
    } catch (e) {
      throw 'Not silinirken bir hata oluştu: $e';
    }
  }

  Future<void> archiveNote(String id) async {
    try {
      final noteIndex = _notes.indexWhere((note) => note.id == id);
      if (noteIndex >= 0) {
        final archivedNote = Note(
          id: id,
          userId: _userId,
          title: _notes[noteIndex].title,
          content: _notes[noteIndex].content,
          createdTime: _notes[noteIndex].createdTime,
          updatedTime: DateTime.now(),
          isArchived: true,
          imageUrl: _notes[noteIndex].imageUrl,
          tags: _notes[noteIndex].tags,
        );

        await _firestore
            .collection('notes')
            .doc(id)
            .update(archivedNote.toFirestore());
        _notes[noteIndex] = archivedNote;
        notifyListeners();
      }
    } catch (e) {
      throw 'Not arşivlenirken bir hata oluştu: $e';
    }
  }

  Future<void> unarchiveNote(String id) async {

    try {
      final noteIndex = _notes.indexWhere((note) => note.id == id);
      if (noteIndex >= 0) {
        final unarchivedNote = Note(
          id: id,
          userId: _userId,
          title: _notes[noteIndex].title,
          content: _notes[noteIndex].content,
          createdTime: _notes[noteIndex].createdTime,
          updatedTime: DateTime.now(),
          isArchived: false,
          imageUrl: _notes[noteIndex].imageUrl,
          tags: _notes[noteIndex].tags,
        );

        await _firestore
            .collection('notes')
            .doc(id)
            .update(unarchivedNote.toFirestore());
        _notes[noteIndex] = unarchivedNote;
        notifyListeners();
      }
    } catch (e) {
      throw 'Not arşivden çıkarılırken bir hata oluştu: $e';
    }
  }
}
