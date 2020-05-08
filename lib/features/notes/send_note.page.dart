import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:send_note_app/features/common/loading_dialog.dart';
import 'package:send_note_app/models/note.dart';
import 'package:send_note_app/repositories/note_repository.dart';
import 'package:send_note_app/repositories/user_repository.dart';

import '../../style.dart';

class SendNotePage extends StatefulWidget {
  const SendNotePage({Key key}) : super(key: key);

  @override
  _SendNotePageState createState() => _SendNotePageState();
}

class _SendNotePageState extends State<SendNotePage> {
  final _userCollection = Firestore.instance.collection('users');

  List _friends;

  Note _note;

  Future getFriends() async {
    final userRepository = UserRepository();
    final List friends = await userRepository.getFriend();
    setState(() {
      _friends = friends;
    });
  }

  @override
  void initState() {
    super.initState();
    getFriends();
  }

  @override
  Widget build(BuildContext context) {
    _note = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Note'),
        leading: GestureDetector(
          child: Icon(Icons.arrow_back),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder(
        stream: _userCollection
            .where(FieldPath.documentId, whereIn: _friends)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError)
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            final list = snapshot.data.documents;

            return ListView.builder(
              itemBuilder: (context, index) {
                return Container(
                  height: 80.0,
                  child: Card(
                    child: Container(
                      margin: const EdgeInsets.all(10.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                              fit: FlexFit.tight,
                              child: Text(list[index]['fullName'])),
                          FlatButton(
                            shape: const CircleBorder(),
                            color: PrimaryColor,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Send Note ?'),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: const Text('Add'),
                                        onPressed: () async {
                                          LoadingDialog.show(context);
                                          final _noteRepository =
                                              NoteRepository();
                                          await _noteRepository.sendNote(
                                              uid: list[index]['uid'],
                                              title: _note.title,
                                              notes: _note.notes);
                                          LoadingDialog.hide(context);
                                          Navigator.pop(context);
                                        },
                                      ),
                                      FlatButton(
                                        child: const Text('Close'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: list.length,
            );
          }
        },
      ),
    );
  }
}
