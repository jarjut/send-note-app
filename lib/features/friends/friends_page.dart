import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:send_note_app/drawer.dart';
import 'package:send_note_app/repositories/user_repository.dart';
import 'package:send_note_app/router_const.dart';
import 'package:send_note_app/style.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({Key key}) : super(key: key);

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final _userCollection = Firestore.instance.collection('users');

  List _friends;

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
    return Scaffold(
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        title: const Text('Friends'),
      ),
      drawer: Drawer(
        child: AppDrawer(),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: PrimaryColor,
        onPressed: _addButtonPressed,
        child: Icon(Icons.add),
      ),
    );
  }

  void _addButtonPressed() {
    Navigator.pushNamed(context, AddFriendsRoute);
  }
}
