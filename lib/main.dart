import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'authentication/authentication_bloc.dart';
import 'authentication/authentication_event.dart';
import 'features/friends/add_friends_page.dart';
import 'features/friends/friends_page.dart';
import 'features/login/login_page.dart';
import 'features/notes/add_note_page.dart';
import 'features/notes/edit_note_page.dart';
import 'features/notes/notes_page.dart';
import 'features/notes/send_note.page.dart';
import 'features/register/register_page.dart';
import 'repositories/user_repository.dart';
import 'router_const.dart';
import 'splash_screen.dart';
import 'style.dart';

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
        SendNoteRoute: (context) => const SendNotePage(),
        FriendsRoute: (context) => const FriendsPage(),
        AddFriendsRoute: (context) => const AddFriendsPage(),
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
