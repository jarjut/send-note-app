import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String noteId;
  String uid;
  String title;
  String notes;

  Note({
    this.noteId,
    this.uid,
    this.title,
    this.notes,
  });

  factory Note.fromSnapshot(DocumentSnapshot document) => Note(
        noteId: document.documentID,
        uid: document.data['uid'],
        title: document.data['title'],
        notes: document.data['notes'],
      );
}
