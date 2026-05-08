import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/note_provider.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? note; // null thi la tao moi, co thi la sua

  const NoteEditorScreen({super.key, this.note});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool get isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();
    // neu la sua thi dien san du lieu cu
    if (isEditing) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<NoteProvider>(context, listen: false);
    final now = DateTime.now().toIso8601String();

    if (isEditing) {
      // cap nhat note cu
      final updatedNote = Note(
        id: widget.note!.id,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        createdAt: widget.note!.createdAt,
      );
      provider.updateNote(updatedNote);
    } else {
      // tao note moi
      final newNote = Note(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        createdAt: now,
      );
      provider.addNote(newNote);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Đồng bộ màu nền với HomePage
      appBar: AppBar(
        title: Text(
          isEditing ? 'Sửa ghi chú' : 'Thêm ghi chú',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.amber,
        elevation: 0, // AppBar phẳng
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(
                Icons.check_circle_rounded,
                size: 28,
                color: Colors.black87,
              ),
              tooltip: 'Lưu ghi chú',
              onPressed: _saveNote,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                decoration: const InputDecoration(
                  hintText: 'Tiêu đề',
                  hintStyle: TextStyle(color: Colors.black38),
                  border: InputBorder.none, // Bỏ viền để nhìn giống app note thật
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tiêu đề';
                  }
                  return null;
                },
              ),
              const Divider(thickness: 1, color: Colors.black12), // Đường kẻ mờ phân cách
              const SizedBox(height: 8),
              Expanded(
                child: TextFormField(
                  controller: _contentController,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5, // Tăng khoảng cách dòng cho dễ đọc
                    color: Colors.black87,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Nhập nội dung ghi chú ở đây...',
                    hintStyle: TextStyle(color: Colors.black38),
                    border: InputBorder.none, // Bỏ viền
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập nội dung';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}