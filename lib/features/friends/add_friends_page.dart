import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:send_note_app/repositories/user_repository.dart';
import 'package:send_note_app/style.dart';

class AddFriendsPage extends StatefulWidget {
  const AddFriendsPage({Key key}) : super(key: key);

  @override
  _AddFriendsPageState createState() => _AddFriendsPageState();
}

class _AddFriendsPageState extends State<AddFriendsPage> {
  final _userCollection = Firestore.instance.collection('users');
  Stream<QuerySnapshot> _userQuery;

  @override
  void initState() {
    super.initState();
    // TODO: query not friend only
    _userQuery = _userCollection.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        title: const Text('Search Friends'),
        leading: GestureDetector(
          child: Icon(Icons.arrow_back),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          children: <Widget>[
            Container(
              child: TextFormField(
                onFieldSubmitted: (value) {
                  setState(() {
                    // TODO: query not friend only
                    _userQuery = _userCollection
                        .where('fullName', isGreaterThanOrEqualTo: value)
                        .snapshots();
                  });
                },
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  labelText: 'Search',
                  hintText: 'Enter Name',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 15.0),
            Flexible(
              fit: FlexFit.tight,
              child: StreamBuilder(
                stream: _userQuery,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return Container(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SizedBox(
                        child: CircularProgressIndicator(),
                        height: 40.0,
                        width: 40.0,
                      ),
                    );
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
                                            title: const Text('Add Friend ?'),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: const Text('Add'),
                                                onPressed: () async {
                                                  final uid =
                                                      list[index].documentID;
                                                  final UserRepository
                                                      userRepository =
                                                      UserRepository();
                                                  await userRepository
                                                      .addFriend(uid);
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
                                      Icons.group_add,
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
            ),
          ],
        ),
      ),
    );
  }
}
