import 'package:firebaserealtimedatabase/pages/entry_pages/sign_up_page.dart';
import 'package:firebaserealtimedatabase/pages/home_page.dart';
import 'package:firebaserealtimedatabase/services/auth_service.dart';
import 'package:firebaserealtimedatabase/services/hive_DB.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);
  static const String id = '/sign_in';

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late FocusNode focusNodeEmail = FocusNode();
  late FocusNode focusNodePassword = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _errorOccurred = false;
  bool _isLoading = false;
  bool isHidden = true;

  void _doSignIn(){
    String email = _emailController.text.toString().trim();
    String password = _passwordController.text.toString().trim();
    if(email.isEmpty || password.isEmpty){
      setState(() {
        _errorOccurred = true;
      });
      return;
    }
    setState(() {
      _isLoading = true;
    });
    AuthenticationService.signIn(email: email, password: password).then((value) async {
      // Logger().d(value);
      if (kDebugMode) {
        print(value);
      }
      setState(() {
        _isLoading = false;
      });
      if(value != null){
        HiveDB.putUser(value);
        // await SharedPreferenceDB.setUserID(value.uid);
        // Navigator.pushReplacementNamed(context, HomePage.id);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const HomePage()));
      }
      else{
        focusNodeEmail.unfocus();
        focusNodePassword.unfocus();
        Fluttertoast.showToast(
            msg: "Check your email and password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    });

  }

  _errorText(String text) {
    if (text.trim().toString().isEmpty) {
      return "Can't be empty";
    }
    return null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    focusNodeEmail.dispose();
    focusNodePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // #email address
                    TextField(
                      controller: _emailController,
                      focusNode: focusNodeEmail,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        errorText: _errorOccurred ? _errorText(_emailController.text) : null,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 10),
                    // #password
                    TextField(
                      controller: _passwordController,
                      obscureText: isHidden,
                      focusNode: focusNodePassword,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        errorText: _errorOccurred ? _errorText(_passwordController.text) : null,
                        suffixIcon: IconButton(
                            onPressed: (){
                              setState(() {
                                isHidden = !isHidden;
                              });},
                            icon: Icon(isHidden?Icons.visibility_off_outlined:Icons.visibility_outlined)
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    MaterialButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        height: 50,
                        minWidth: MediaQuery.of(context).size.width - 50,
                        color: CupertinoColors.systemRed,
                        textColor: Colors.white,
                        child: const Text('Sign in'),
                        onPressed: (){_doSignIn();}
                    ),
                    const SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        text: 'Don\'t have an account? ',
                        style: const TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: 'Sign Up',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: CupertinoColors.systemRed),
                            recognizer: TapGestureRecognizer()..onTap = () {
                              Navigator.pushReplacementNamed(context, SignUp.id);
                              },
                          ),
                        ],
                      ),
                    )
                  ]
                ),
              )
            ),
            Visibility(
              visible: _isLoading,
                child: const Center(
                    child: CircularProgressIndicator(color: CupertinoColors.systemRed, backgroundColor: Colors.white)
                )
            )
          ],
        )
    );
  }
}
