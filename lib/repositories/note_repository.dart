import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:send_note_app/models/user.dart';
import 'package:send_note_app/repositories/user_repository.dart';

class NoteRepository {
  final _userRepository = UserRepository();
  final CollectionReference noteCollection =
      Firestore.instance.collection('notes');

  Future<void> addNote({String title, String notes}) async {
    final User currentUser = await _userRepository.getUser();
    return await noteCollection.document().setData({
      'uid': currentUser.uid,
      'title': title,
      'notes': notes,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> editNote({String noteId, String title, String notes}) async {
    await noteCollection.document(noteId).updateData({
      'title': title,
      'notes': notes,
    });
    return print('Edit Note Success');
  }
}
