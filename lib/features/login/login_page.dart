import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:send_note_app/authentication/authentication.dart';
import 'package:send_note_app/features/common/loading_dialog.dart';
import 'package:send_note_app/features/login/bloc/login_bloc.dart';
import 'package:send_note_app/features/login/bloc/login_event.dart';
import 'package:send_note_app/router_const.dart';
import 'package:send_note_app/style.dart';

import 'bloc/login_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  LoginBloc _loginBloc;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: BackgroundColor,
        body: BlocProvider(
          create: (context) => _loginBloc,
          child: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccess) {
                BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
                LoadingDialog.hide(context);
                Navigator.pushReplacementNamed(context, NotesRoute);
              }
              if (state is LoginLoading) {
                LoadingDialog.show(context);
              }
              if (state is LoginFailed) {
                LoadingDialog.hide(context);
              }
            },
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 35.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        height: 100.0,
                        child: Image.asset('assets/images/icon.png'),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'LOGIN',
                        style: TextStyle(
                            fontSize: 35.0,
                            fontWeight: FontWeight.w500,
                            color: PrimaryColor),
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration:
                            const InputDecoration(labelText: 'Password'),
                      ),
                      const SizedBox(
                        height: 35.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(
                            height: 50.0,
                            width: 150.0,
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(color: Colors.white),
                              ),
                              color: PrimaryColor,
                              onPressed: _loginSubmit,
                            ),
                          ),
                          SizedBox(
                            height: 50.0,
                            width: 150.0,
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'Register',
                                style: TextStyle(color: Colors.white),
                              ),
                              color: PrimaryColor,
                              onPressed: () {
                                Navigator.pushNamed(context, RegisterRoute);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _loginSubmit() {
    _loginBloc.add(
      LoginSubmitted(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
}
