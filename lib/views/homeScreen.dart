import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
        const Text('Welcome!',),
        const SizedBox(height: 30,),
        ElevatedButton(onPressed: (){
          FirebaseAuth.instance.signOut();
        }, child: const Text('Sign out')),

          ],
        ),
      ),
    );
  }
}
