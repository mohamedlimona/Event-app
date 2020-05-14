import 'package:eventful_app/customshapeClipper.dart';
import 'package:eventful_app/pages/home.dart';
import 'package:eventful_app/pages/register.dart';
import 'package:eventful_app/providers/auth.dart';
import 'package:flutter/material.dart';
import '../models/http_exception.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/loginPage';
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _togggleVisiabilty = false;
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {

        // Log user in
        await Provider.of<Auth>(context, listen: false).singIn(
          email: _emailController.text,
          password: _passwordController.text,
        );
        Navigator.of(context).pushReplacementNamed(HomePage.routeName);
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    ClipPath(
                      clipper: CustomShapeClipper(),
                      child: Container(
                        height: 260,
                        width: double.infinity,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Positioned(
                      top: 25,
                      left: MediaQuery.of(context).size.width / 3.2,
                      child: CircleAvatar(
                        radius: 85,
                        backgroundImage: AssetImage('assets/images/logo.jpg'),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
        Container(
          width: MediaQuery.of(context).size.width - 50,
          child: TextFormField(
            style: TextStyle(color: Colors.black),
            controller: _emailController,
            validator: (val) {
              if (val.isEmpty ||
                  val.trim().length == 0 ||
                  val.trim().length <= 3 ||
                  !val.contains('@')) {
                return 'value is not valid';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Email',
              fillColor: Colors.white,
              prefixIcon: Icon(
                Icons.email,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
              ),
            ),
          ),
        ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 50,
                  child: TextFormField(
                    style: TextStyle(color: Colors.black),
                    controller: _passwordController,
                    validator: (val) {
                      if (val.isEmpty || val.trim().length == 0 || val.trim().length <= 3) {
                        return 'value is not valid';
                      }
                      return null;
                    },
                    obscureText: !_togggleVisiabilty,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: !_togggleVisiabilty
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _togggleVisiabilty = !_togggleVisiabilty;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Column(
                    children: <Widget>[
                      _isLoading
                          ? CircularProgressIndicator()
                          : Container(
                        width: MediaQuery.of(context).size.width - 120,
                        child: MaterialButton(
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                          color: Theme.of(context).primaryColor,
                          splashColor: Colors.grey,
                          onPressed: () => _submit(),
                          minWidth: 200.0,
                          height: 42.0,
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      FlatButton(
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have an Account ? ",
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onPressed: () => Navigator.of(context)
                            .pushReplacementNamed(RegisterPage.routeName),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
