import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:send_note_app/models/note.dart';
import 'package:send_note_app/models/user.dart';
import 'package:send_note_app/repositories/user_repository.dart';

import '../../drawer.dart';
import '../../router_const.dart';
import '../../style.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final _noteCollection = Firestore.instance.collection('notes');
  User _currentUser;

  Future getCurrentUser() async {
    final userRepository = UserRepository();
    final User user = await userRepository.getUser();
    setState(() {
      _currentUser = user;
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: BackgroundColor,
        appBar: AppBar(
          title: const Text('Notes'),
          // actions: <Widget>[
          //   Container(
          //     child: FlatButton(
          //       onPressed: _addButtonPressed,
          //       child: Icon(
          //         FontAwesomeIcons.plusCircle,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ),
          // ],
        ),
        drawer: Drawer(
          child: AppDrawer(),
        ),
        body: StreamBuilder(
          stream: _noteCollection
              .where('uid', isEqualTo: _currentUser.uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                  final Note _note = Note.fromSnapshot(list[index]);
                  return buildListNote(_note);
                },
                itemCount: list.length,
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: PrimaryColor,
          onPressed: _addButtonPressed,
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget buildListNote(Note note) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      height: 90.0,
      child: Material(
        elevation: 3.0,
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.yellow.shade100,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, EditNoteRoute, arguments: note);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    note.title,
                    style: const TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 5.0),
                Container(
                  child: Text(
                    note.notes,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addButtonPressed() {
    Navigator.pushNamed(context, AddNoteRoute);
  }
}
