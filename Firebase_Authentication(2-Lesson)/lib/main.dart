import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseauth/pages/entry_pages/sign_in_page.dart';
import 'package:firebaseauth/pages/entry_pages/sign_up_page.dart';
import 'package:firebaseauth/pages/home_page.dart';
import 'package:firebaseauth/services/auth_service.dart';
import 'package:firebaseauth/services/hive.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox(HiveDB.nameDB);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static final RouteObserver<PageRoute> routeObserver =
  RouteObserver<PageRoute>();

  Widget _startPage(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthenticationService.auth.authStateChanges(),
      builder: (context, value) {
        if(value.hasData) {
          // SharedPreferenceDB.storeString(StorageKeys.UID, value.data!.uid);
          HiveDB.putUser(value.data!);
          return const HomePage();
        } else {
          // SharedPreferenceDB.clear(StorageKeys.UID);
          HiveDB.removeUser();
          return const SignIn();
        }
      },
    );
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      debugShowCheckedModeBanner: false,
      home: _startPage(context),
      routes: {
        HomePage.id: (context) => const HomePage(),
        SignUp.id: (context) => const SignUp(),
        SignIn.id: (context) => const SignIn(),
      },
    );
  }
}