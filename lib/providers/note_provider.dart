import 'package:flutter/material.dart';
import '../models/note.dart';
import '../database/db_helper.dart';

class NoteProvider extends ChangeNotifier {
  List<Note> _notes = [];
  final DBHelper _dbHelper = DBHelper.instance;

  List<Note> get notes => _notes;

  // load notes tu database
  Future<void> loadNotes() async {
    _notes = await _dbHelper.getAllNotes();
    notifyListeners();
  }

  // them note
  Future<void> addNote(Note note) async {
    await _dbHelper.insertNote(note);
    await loadNotes();
  }

  // sua note
  Future<void> updateNote(Note note) async {
    await _dbHelper.updateNote(note);
    await loadNotes();
  }

  // xoa note
  Future<void> deleteNote(int id) async {
    await _dbHelper.deleteNote(id);
    await loadNotes();
  }
}
