import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:send_note_app/features/login/bloc/login_event.dart';
import 'package:send_note_app/features/login/bloc/login_state.dart';
import 'package:send_note_app/repositories/user_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final _userRepository = UserRepository();

  @override
  LoginState get initialState => LoginInit();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginSubmitted) {
      yield LoginLoading();
      try {
        await _userRepository.signIn(
          email: event.email,
          password: event.password,
        );
        yield LoginSuccess();
      } catch (e) {
        print(e.toString());
        yield LoginFailed();
      }
    }
  }
}
