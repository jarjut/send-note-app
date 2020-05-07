import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:send_note_app/style.dart';

import 'authentication/authentication.dart';
import 'router_const.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Center(
              child: Text(
            'Notes',
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600),
          )),
          decoration: BoxDecoration(
            color: PrimaryColor,
          ),
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.stickyNote),
          title: const Text('My Notes'),
          onTap: () {
            Navigator.popAndPushNamed(context, NotesRoute);
          },
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.signOutAlt),
          title: const Text('Logout'),
          onTap: () {
            BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
            Navigator.popUntil(context, ModalRoute.withName(SplashRoute));
          },
        ),
      ],
    );
  }
}
