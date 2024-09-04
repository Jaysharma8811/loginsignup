import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


final firebaseAuth = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  var _isLogin = true;
  var _enterEmail = '';
  var _enterPassword = '';

  var _enterUserName = '';

  void submit() async {

    final isValid = _formKey.currentState!.validate();
    if (!isValid    ) {
      return;
    }

    _formKey.currentState!.save();
    print("$_enterEmail & $_enterPassword");



    try {
      if (_isLogin) {

        final userCredentials = await firebaseAuth.signInWithEmailAndPassword(
            email: _enterEmail, password: _enterPassword);

      } else {

        final userCredentials =
        await firebaseAuth.createUserWithEmailAndPassword(
          email: _enterEmail,
          password: _enterPassword,
        );




      }
    }  on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {}
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authention Failed'),
        ),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
      ),
      body: Center(
        child: Center(
          child: Container(
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    margin: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              if (!_isLogin)
                                TextFormField(
                                  decoration: const InputDecoration(
                                    label: Text('User Name'),
                                  ),
                                  keyboardType: TextInputType.name,
                                  autocorrect: false,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return "Enter a valid user name";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _enterUserName = value!;
                                  },
                                ),
                              TextFormField(
                                decoration: const InputDecoration(
                                    label: Text('Email Address')),
                                autocorrect: false,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty ||
                                      !value.contains('@')) {
                                    return 'Please Enter a valid Email address';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _enterEmail = value!;
                                },
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                    label: Text('Password')),
                                autocorrect: false,
                                obscureText: true,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty ||
                                      value.length < 6) {
                                    return 'Enter a valid password';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _enterPassword = value!;
                                },
                              ),
                              const SizedBox(
                                height: 12,
                              ),


                                ElevatedButton(
                                  onPressed: () {
                                    submit();
                                    // Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>const TapScreen()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.5)),
                                  child: Text(
                                    _isLogin ? 'Login' : 'SignUp',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground),
                                  ),
                                ),

                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isLogin = !_isLogin;
                                    });
                                  },
                                  child: Text(_isLogin
                                      ? 'Create an Account'
                                      : 'I already have an Account'),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
