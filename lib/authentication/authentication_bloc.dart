import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/user_repository.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc({@required this.userRepository});

  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStart) {
      try {
        final isSignedIn = await userRepository.isSignedIn();
        if (isSignedIn) {
          final user = await userRepository.getUser();
          yield Authenticated(user);
        } else {
          yield Unauthenticated();
        }
      } catch (_) {
        yield Unauthenticated();
      }
    }

    if (event is LoggedIn) {
      yield Authenticated(await userRepository.getUser());
    }

    if (event is LoggedOut) {
      userRepository.signOut();
      yield Unauthenticated();
    }
  }
}
