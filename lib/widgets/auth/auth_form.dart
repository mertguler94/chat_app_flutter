import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;

  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';

  void _trySubmit() {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (isValid!) {
      _formKey.currentState?.save();
      // use those saved values to firebase auth request.
      print(_userEmail);
      print(_userName);
      print(_userPassword);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
      margin: const EdgeInsets.all(20),
      child: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  key: const ValueKey('email'),
                  validator: ((value) {
                    if (value == null ||
                        (value.isEmpty || !value.contains('@'))) {
                      return 'Please enter a valid email address.';
                    }
                    return null;
                  }),
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email address'),
                  onSaved: ((newValue) {
                    _userEmail = newValue!;
                  }),
                ),
                if (!_isLogin)
                  TextFormField(
                    key: const ValueKey('username'),
                    validator: ((value) {
                      if (value == null ||
                          (value.isEmpty || value.length < 4)) {
                        return 'Please enter at least 4 characters.';
                      }
                      return null;
                    }),
                    decoration: const InputDecoration(labelText: 'Username'),
                    onSaved: ((newValue) {
                      _userName = newValue!;
                    }),
                  ),
                TextFormField(
                  key: const ValueKey('password'),
                  validator: ((value) {
                    if (value == null || (value.isEmpty || value.length < 7)) {
                      return 'Password must be at least 7 characters long.';
                    }
                    return null;
                  }),
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  onSaved: ((newValue) {
                    _userPassword = newValue!;
                  }),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                    onPressed: _trySubmit,
                    child: Text(_isLogin ? 'Login' : 'Sign Up')),
                TextButton(
                    onPressed: (() {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    }),
                    child: Text(_isLogin
                        ? 'Create new account'
                        : 'I already have an account'))
              ],
            )),
      )),
    ));
  }
}
