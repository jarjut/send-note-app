import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:send_note_app/router_const.dart';
import 'package:send_note_app/style.dart';

import 'authentication/authentication.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      body: BlocProvider(
        create: (context) => BlocProvider.of<AuthenticationBloc>(context),
        child: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is Authenticated) {
              Navigator.pushNamed(context, NotesRoute);
            }

            if (state is Unauthenticated) {
              Navigator.pushNamed(context, LoginRoute);
            }
          },
          child: Center(
            child: SizedBox(
              height: 100.0,
              child: Image.asset('assets/images/icon.png'),
            ),
          ),
        ),
      ),
    );
  }
}
