import 'package:flutter/material.dart';
import 'package:send_note_app/features/common/loading_dialog.dart';
import 'package:send_note_app/models/note.dart';
import 'package:send_note_app/repositories/note_repository.dart';
import 'package:send_note_app/router_const.dart';
import 'package:send_note_app/style.dart';

class EditNotePage extends StatefulWidget {
  const EditNotePage({Key key}) : super(key: key);

  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  Note _note;

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
    _note = ModalRoute.of(context).settings.arguments;
    _titleController.text = _note.title;
    _notesController.text = _note.notes;
    return Scaffold(
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        title: const Text('Edit Note'),
        leading: GestureDetector(
          child: Icon(Icons.arrow_back),
          onTap: () {
            Navigator.pop(context);
          },
        ),
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'btnSend',
            onPressed: () {
              Navigator.pushNamed(context, SendNoteRoute, arguments: _note);
            },
            backgroundColor: PrimaryColor,
            child: Icon(Icons.send),
          ),
          const SizedBox(height: 30),
          FloatingActionButton(
            heroTag: 'btnSave',
            onPressed: _saveNote,
            backgroundColor: PrimaryColor,
            child: Icon(Icons.save),
          ),
        ],
      ),
    );
  }

  void _saveNote() async {
    final _noteRepository = NoteRepository();
    final String title = _titleController.text.trim();
    final String notes = _notesController.text.trim();

    try {
      LoadingDialog.show(context);
      await _noteRepository.editNote(
          noteId: _note.noteId, title: title, notes: notes);
      LoadingDialog.hide(context);
      Navigator.pop(context);
    } catch (e) {
      print(e.toString());
      LoadingDialog.hide(context);
    }
  }
}
