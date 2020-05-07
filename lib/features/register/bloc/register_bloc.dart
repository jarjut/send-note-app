import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:send_note_app/features/register/bloc/register_event.dart';
import 'package:send_note_app/features/register/bloc/register_state.dart';
import 'package:send_note_app/repositories/user_repository.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final _userRepository = UserRepository();

  @override
  RegisterState get initialState => RegisterInit();

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is RegisterSubmitted) {
      yield RegisterLoading();
      try {
        await _userRepository.signUp(
          fullName: event.fullName,
          email: event.email,
          password: event.password,
        );
        yield RegisterSuccess();
      } catch (e) {
        print(e.toString());
        yield RegisterFailed();
      }
    }
  }
}
