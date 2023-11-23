import 'package:koffeeko/screens/authenticate/admin.dart';
import 'package:koffeeko/screens/authenticate/worker.dart';
import 'package:koffeeko/services/auth.dart';
import 'package:koffeeko/shared/constants.dart';
import 'package:koffeeko/shared/loading.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  // SignIn({required this.toggleView});

  const SignIn({Key? key, required this.toggleView}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: const Text('Login to KoffeeKo'),
              actions: <Widget>[
                TextButton.icon(
                  onPressed: () {
                    widget.toggleView();
                  },
                  icon: const Icon(Icons.login, color: Colors.blue, size: 27.0),
                  label: const Text('Register',
                      style: TextStyle(color: Colors.blue, fontSize: 20.0)),
                )
              ],
            ),
            body: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 20.0),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Email'),
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Password'),
                      obscureText: true,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.pink[400],
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => loading = true);

                          dynamic result = await _auth
                              .signInWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() {
                              error = 'COULD NOT SIGN IN WITH THOSE CREDENTIALS'
                                  .toLowerCase();
                              loading = false;
                            });
                          }
                        }
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    const Divider(
                      height: 15.0,
                      color: Colors.black,
                      thickness: 5,
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      'Or Login With',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    GestureDetector(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => loading = true);
                          dynamic result = await _auth.loginWithGoogle();
                          if (result == null) {
                            setState(() {
                              error = 'Please supply a valid email';
                              loading = false;
                            });
                          }
                        }
                      },
                      child: const CircleAvatar(
                        backgroundImage: AssetImage('assets/google_logo.png'),
                        radius: 28.0,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      error,
                      style: const TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FloatingActionButton.extended(
                    heroTag: "btn1",
                    onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Worker())),
                    label: const Text('Worker'),
                    icon: const Icon(Icons.person),
                    backgroundColor: Colors.black,
                  ),
                  FloatingActionButton.extended(
                    heroTag: "btn2",
                    onPressed: () => Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const Admin())),
                    label: const Text('Admin'),
                    icon: const Icon(Icons.person),
                    backgroundColor: Colors.black,
                  ),
                ],
              ),
            ),
          );
  }
}
