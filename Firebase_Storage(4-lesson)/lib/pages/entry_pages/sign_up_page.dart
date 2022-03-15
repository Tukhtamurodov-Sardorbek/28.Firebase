import 'package:firebasestorage/pages/entry_pages/sign_in_page.dart';
import 'package:firebasestorage/pages/home_page.dart';
import 'package:firebasestorage/services/auth_service.dart';
import 'package:firebasestorage/services/hive_DB.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);
  static const String id = '/sign_up';

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _errorOccurred = false;
  bool _isLoading = false;
  bool isHidden = true;

  void _doSignUp(){
    String firstName = _firstNameController.text.toString().trim();
    String lastName = _lastNameController.text.toString().trim();
    String email = _emailController.text.toString().trim();
    String password = _passwordController.text.toString().trim();
    if(firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty){
      setState(() {
        _errorOccurred = true;
      });
      return;
    }
    setState(() {
      _isLoading = true;
    });
    AuthenticationService.signUp(email: email, password: password).then((value) async {
      setState(() {
        _isLoading = false;
      });
      if (value != null) {
        HiveDB.putUser(value);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const HomePage()));
      }
      else{
        Fluttertoast.showToast(
            msg: "Check your data",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }


  _errorText(String text) {
    if (text.trim().toString().isEmpty) {
      return "Can't be empty";
    }
    return null;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // #first name
                    TextField(
                      controller: _firstNameController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          hintText: 'First Name',
                        errorText: _errorOccurred ? _errorText(_firstNameController.text) : null,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 10),
                    // #last name
                    TextField(
                      controller: _lastNameController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          hintText: 'Last Name',
                        errorText: _errorOccurred ? _errorText(_lastNameController.text) : null,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 10),
                    // #email address
                    TextField(
                      controller: _emailController,
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
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 10),
                    // #sign up button
                    MaterialButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        height: 50,
                        minWidth: MediaQuery.of(context).size.width - 50,
                        color: CupertinoColors.systemRed,
                        textColor: Colors.white,
                        child: const Text('Sign up'),
                        onPressed: (){ _doSignUp(); }
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text('Already have an account? '),
                        GestureDetector(
                          child: const Text('Sign In', style: TextStyle(fontWeight: FontWeight.bold, color: CupertinoColors.systemRed),),
                          onTap: (){
                            Navigator.pushReplacement(context, MaterialPageRoute (builder: (BuildContext context) => const SignIn()));
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
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
