import 'dart:io';
import 'package:flutter/material.dart';

import './user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final bool isLoading;
  final void Function(
    String email,
    String password,
    String username,
    File image,
    bool isLogin,
  ) submitFn;

  const AuthForm(this.submitFn, this.isLoading, {super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;

  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  File? _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Please pick an image.'),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
      return;
    }

    if (isValid!) {
      _formKey.currentState?.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _userImageFile!,
        _isLogin,
      );
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
                if (!_isLogin) UserImagePicker(_pickedImage),
                TextFormField(
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  enableSuggestions: false,
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
                    autocorrect: true,
                    enableSuggestions: false,
                    textCapitalization: TextCapitalization.words,
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
                if (widget.isLoading) const CircularProgressIndicator(),
                if (!widget.isLoading)
                  ElevatedButton(
                      onPressed: _trySubmit,
                      child: Text(_isLogin ? 'Login' : 'Sign Up')),
                if (!widget.isLoading)
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
