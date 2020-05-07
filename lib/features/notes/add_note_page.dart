import 'package:flutter/material.dart';
import 'package:send_note_app/drawer.dart';
import 'package:send_note_app/features/common/loading_dialog.dart';
import 'package:send_note_app/repositories/note_repository.dart';
import 'package:send_note_app/style.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({Key key}) : super(key: key);

  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        title: const Text('Add Note'),
      ),
      drawer: Drawer(
        child: AppDrawer(),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                child: TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: SingleChildScrollView(
                  child: TextFormField(
                    controller: _notesController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      labelText: 'Notes',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveNote,
        backgroundColor: PrimaryColor,
        child: Icon(Icons.save),
      ),
    );
  }

  void _saveNote() async {
    final _noteRepository = NoteRepository();
    final String title = _titleController.text.trim();
    final String notes = _notesController.text.trim();

    try {
      LoadingDialog.show(context);
      await _noteRepository.addNote(title: title, notes: notes);
      LoadingDialog.hide(context);
      Navigator.pop(context);
    } catch (e) {
      print(e.toString());
      LoadingDialog.hide(context);
    }
  }
}
