import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String username,
    String password,
    bool isLogin,
    File profilePic,
  ) authFunc;

  final bool authState;

  const AuthForm({
    Key key,
    this.authFunc,
    this.authState,
  }) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLogin = true;

  String _email;
  String _username;
  String _password;
  File _profilePicture;

  void _saveForm() {
    if (!_isLogin && _profilePicture == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please add an image of your face for the FBI."),
        ),
      );
      return;
    }

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      FocusScope.of(context).unfocus();
      widget.authFunc(
        _email.trim(),
        _username != null ? _username.trim() : "",
        _password.trim(),
        _isLogin,
        _profilePicture,
      );
    }
  }

  void _pickImage() async {
    PickedFile pf = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxHeight: 256,
      maxWidth: 256,
    );
    setState(() {
      _profilePicture = File(pf.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin)
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: _profilePicture != null
                          ? FileImage(_profilePicture)
                          : null,
                      child: _profilePicture == null
                          ? IconButton(
                              icon: Icon(Icons.camera_alt),
                              onPressed: _pickImage,
                            )
                          : Container(),
                    ),
                  TextFormField(
                    key: ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'Email Address'),
                    validator: (val) {
                      if (val.isEmpty) return "This field cannot be empty";
                      if (!val.contains("@"))
                        return "You must provide a valid email address.";
                      return null;
                    },
                    onSaved: (val) => _email = val,
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      decoration: InputDecoration(labelText: 'Username'),
                      validator: (val) {
                        if (val.isEmpty) return "This field cannot be empty";
                        if (val.length < 6)
                          return "The username must be longer than six characters";
                        return null;
                      },
                      onSaved: (val) => _username = val,
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                    validator: (val) {
                      if (val.isEmpty) return "This field cannot be empty";
                      return null;
                    },
                    onSaved: (val) => _password = val,
                  ),
                  SizedBox(height: 12),
                  if (widget.authState) CircularProgressIndicator(),
                  if (!widget.authState)
                    ElevatedButton(
                      child: Text(_isLogin ? "Login" : "Sign Up"),
                      onPressed: () => _saveForm(),
                    ),
                  if (!widget.authState)
                    TextButton(
                      child: Text(
                          _isLogin ? "Create new account" : "Sign In Instead"),
                      onPressed: () => setState(() {
                        _isLogin = !_isLogin;
                      }),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
