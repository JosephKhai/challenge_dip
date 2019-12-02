import 'package:cloud_firestore/cloud_firestore.dart';
import 'homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'loginPage.dart';

class RegisterPage extends StatefulWidget {
  static const String id = 'registerPage';

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final textfieldclear = TextEditingController();
  final passfieldclear = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;

  String email;
  String password;
  String role = 'user';
  UserUpdateInfo userInfo = new UserUpdateInfo();

  void signUp() async {
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: this.email, password: this.password);
      if (newUser != null) {
        await newUser.user.updateProfile(this.userInfo);
        if (this.role == 'admin') {
          await _firestore
              .collection('admin')
              .document(newUser.user.uid)
              .setData({'uid': newUser.user.uid});
        }
        Navigator.pushNamed(context, HomePage.id, arguments: newUser.user);
        textfieldclear.clear();
        passfieldclear.clear();
      } else {}
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30.0),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 8.0),
                child: TextField(
                  controller: textfieldclear,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: InputDecoration(
                      labelText: 'Type your Email',
                      hasFloatingPlaceholder: true),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 8.0),
                child: TextField(
                  controller: passfieldclear,
                  onChanged: (value) {
                    password = value;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Type your password',
                    hasFloatingPlaceholder: true,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 8.0),
                child: DropdownButtonFormField(
                  items: items(),
                  value: this.role,
                  onChanged: (value) {
                    setState(() {
                      this.role = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Select User Role',
                    hasFloatingPlaceholder: true,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Text.rich(TextSpan(children: [
                  TextSpan(
                      text:
                          'By clicking Sign Up Button you agree to the following'),
                  TextSpan(
                      text: 'Terms and Conditions',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.indigo)),
                ])),
              ),
              SizedBox(height: 60.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: RaisedButton(
                  padding: EdgeInsets.fromLTRB(40.0, 16.0, 30.0, 16.0),
                  color: Colors.blue,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          bottomLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30),
                          bottomRight: Radius.circular(30))),
                  onPressed: () {
                    this.signUp();                    
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Sign Up'.toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Already have an Account ? ',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.normal),
                  ),
                  GestureDetector(
                    child: Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          decoration: TextDecoration.underline),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      //routes
      routes: <String, WidgetBuilder>{
        '/loginPage': (BuildContext context) => new LoginPage(),
      },
    );
  }
}

List<DropdownMenuItem<String>> items() {
  var roles = ['user', 'admin'];
  List<DropdownMenuItem<String>> widgets = new List<DropdownMenuItem<String>>();
  for (var u in roles) {
    Widget w = DropdownMenuItem(
      child: Text(u),
      value: u,
    );
    widgets.add(w);
  }
  return widgets;
}
