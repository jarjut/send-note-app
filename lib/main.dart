import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:send_note_app/features/login/login_page.dart';
import 'package:send_note_app/features/notes/edit_note_page.dart';
import 'package:send_note_app/features/notes/notes_page.dart';
import 'package:send_note_app/features/register/register_page.dart';
import 'package:send_note_app/router_const.dart';
import 'package:send_note_app/splash_screen.dart';
import 'package:send_note_app/style.dart';

import 'authentication/authentication_bloc.dart';
import 'authentication/authentication_event.dart';
import 'features/notes/add_note_page.dart';
import 'repositories/user_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final userRepository = UserRepository();
  runApp(
    BlocProvider<AuthenticationBloc>(
      create: (context) =>
          AuthenticationBloc(userRepository: userRepository)..add(AppStart()),
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: PrimaryFont,
        primaryColor: PrimaryColor,
      ),
      initialRoute: SplashRoute,
      routes: {
        SplashRoute: (context) => const SplashPage(),
        LoginRoute: (context) => const LoginPage(),
        RegisterRoute: (context) => const RegisterPage(),
        NotesRoute: (context) => const NotesPage(),
        AddNoteRoute: (context) => const AddNotePage(),
        EditNoteRoute: (context) => const EditNotePage(),
      },
    );
  }
}

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }
}
