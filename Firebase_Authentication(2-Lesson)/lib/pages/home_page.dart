import 'package:firebaseauth/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const String id = '/home_page';
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CupertinoColors.systemRed,
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: (){
                AuthenticationService.signOut(context);
              }
          )
        ],
      ),
    );
  }
}
