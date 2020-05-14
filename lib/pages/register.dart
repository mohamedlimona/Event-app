import 'package:eventful_app/customshapeClipper.dart';
import 'package:eventful_app/pages/home.dart';
import 'package:eventful_app/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:print_color/print_color.dart';
import 'package:provider/provider.dart';

import 'login.dart';

class RegisterPage extends StatefulWidget {
  static const routeName = '/registerPage';
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var _typeOfUser = [
    'Select Type Of User',
    "Organizer",
    "User",
  ];
  String _currentSelectedValue = 'Select Type Of User';
  var _togggleVisiabilty = false;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
//  //build Stack logo
//  Widget _buildStackLogo() {
//    return Stack(
//      children: <Widget>[
//        ClipPath(
//          clipper: CustomShapeClipper(),
//          child: Container(
//            height: 260,
//            width: double.infinity,
//            color: Theme.of(context).primaryColor,
//          ),
//        ),
//        Positioned(
//          top: 25,
//          left: MediaQuery.of(context).size.width / 4 + 5,
//          child: CircleAvatar(
//            radius: 85,
//            backgroundImage: AssetImage('assets/images/logo.jpg'),
//          ),
//        )
//      ],
//    );
//  }
//
//  //build name textfield
//  Widget _buildNameTextField() {
//    return Container(
//      width: MediaQuery.of(context).size.width - 50,
//      child: TextFormField(
//        controller: _nameController,
//        style: TextStyle(color: Colors.black),
//        validator: (val) {
//          if (val.isEmpty || val.trim().length == 0 || val.trim().length <= 3) {
//            return 'value is not valid';
//          }
//          return null;
//        },
//        decoration: InputDecoration(
//          hintText: 'Name',
//          fillColor: Colors.white,
//          prefixIcon: Icon(Icons.person),
//          border: OutlineInputBorder(
//            borderRadius: BorderRadius.all(Radius.circular(50.0)),
//          ),
//        ),
//      ),
//    );
//  }
//
//  //build email textfield
//  Widget _buildEmailTextField() {
//    return Container(
//      width: MediaQuery.of(context).size.width - 50,
//      child: TextFormField(
//        style: TextStyle(color: Colors.black),
//        controller: _emailController,
//        validator: (val) {
//          if (val.isEmpty ||
//              val.trim().length == 0 ||
//              val.trim().length <= 3 ||
//              !val.contains('@')) {
//            return 'value is not valid';
//          }
//          return null;
//        },
//        decoration: InputDecoration(
//          hintText: 'Email',
//          fillColor: Colors.white,
//          prefixIcon: Icon(Icons.email),
//          border: OutlineInputBorder(
//            borderRadius: BorderRadius.all(Radius.circular(50.0)),
//          ),
//        ),
//      ),
//    );
//  }
//
//  //build passwordTextField
//  Widget _buildPasswordTextField() {
//    return Container(
//      width: MediaQuery.of(context).size.width - 50,
//      child: TextFormField(
//        style: TextStyle(color: Colors.black),
//        controller: _passwordController,
//        validator: (val) {
//          if (val.isEmpty || val.trim().length == 0 || val.trim().length <= 3) {
//            return 'value is not valid';
//          }
//          return null;
//        },
//        obscureText: !_togggleVisiabilty,
//        decoration: InputDecoration(
//          hintText: 'Password',
//          fillColor: Colors.white,
//          prefixIcon: Icon(Icons.lock),
//          suffixIcon: IconButton(
//            icon: !_togggleVisiabilty
//                ? Icon(Icons.visibility_off)
//                : Icon(Icons.visibility),
//            onPressed: () {
//              setState(() {
//                _togggleVisiabilty = !_togggleVisiabilty;
//              });
//            },
//          ),
//          border: OutlineInputBorder(
//            borderRadius: BorderRadius.all(Radius.circular(50.0)),
//          ),
//        ),
//      ),
//    );
//  }
//
//  //build confirmPasswordTextField
//  Widget _buildConfirmPasswordTextField() {
//    return Container(
//      width: MediaQuery.of(context).size.width - 50,
//      child: TextFormField(
//        style: TextStyle(color: Colors.black),
//        validator: (val) {
//          if (val != _passwordController.text) {
//            return 'Passwords do not match!';
//          }
//          return null;
//        },
//        obscureText: !_togggleVisiabilty,
//        decoration: InputDecoration(
//          hintText: 'confirm Password',
//          fillColor: Colors.white,
//          prefixIcon: Icon(Icons.lock),
//          suffixIcon: IconButton(
//            icon: !_togggleVisiabilty
//                ? Icon(Icons.visibility_off)
//                : Icon(Icons.visibility),
//            onPressed: () {
//              setState(() {
//                _togggleVisiabilty = !_togggleVisiabilty;
//              });
//            },
//          ),
//          border: OutlineInputBorder(
//            borderRadius: BorderRadius.all(Radius.circular(50.0)),
//          ),
//        ),
//      ),
//    );
//  }
  Future<String> _showDialogError(String message) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Something Went Wrong!'),
              content: Text(message.toString()),
              actions: <Widget>[
                FlatButton(
                  child: Text('okey'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

//build Type Of User
  Widget _buildTypeOfUser() {
    return FormField<String>(
      validator: (val) {
        if (_currentSelectedValue == 'Select Type Of User') {
          _showDialogError('Please Select Type Of User');
          return 'error';
        } else {
          return null;
        }
      },
      builder: (FormFieldState<String> state) {
        return Container(
          width: MediaQuery.of(context).size.width - 45,
          height: MediaQuery.of(context).size.width - 305,
          child: InputDecorator(
            decoration: InputDecoration(
              errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
              prefixIcon: Icon(Icons.person_add),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0),
              ),
            ),
            isEmpty: _currentSelectedValue == '',
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _currentSelectedValue,
                isDense: true,
                onChanged: (String newValue) {
                  setState(() {
                    _currentSelectedValue = newValue;
                    state.didChange(newValue);
                  });
                },
                items: _typeOfUser.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

//build formAction
  Widget _buildFormAction() {
    return Padding(
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
                    onPressed: () => _submitForm(),
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'Register',
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
                text: "have an Account ? ",
                style: TextStyle(
                  color: Colors.black45,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Sign in',
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
            onPressed: () =>
                Navigator.of(context).pushReplacementNamed(LoginPage.routeName),
          )
        ],
      ),
    );
  }

  void _submitForm() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    } else {
      _formKey.currentState.save();
      setState(() {
        _isLoading = true;
      });
      try {

        await Provider.of<Auth>(context, listen: false).singUp(
          email: _emailController.text,
          password: _passwordController.text,
          username: _nameController.text,
        );
        Navigator.of(context).pushReplacementNamed(HomePage.routeName);
      } catch (error) {
        Print.yellow('Error is $error');
        var errorMessge = 'Authintication Faild';
        if (error.toString().contains('EMAIL_EXISTS')) {
          errorMessge =
              'The email address is already in use by another account.';
        } else if (error.toString().contains('INVALID_EMAIL')) {
          errorMessge = 'The email address is badly formatted.';
        } else if (error.toString().contains('WEAK_PASSWORD')) {
          errorMessge = 'The password is too weak';
        } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
          errorMessge = 'Email Not Found';
        } else if (error.toString().contains('INVALID_PASSWORD')) {
          errorMessge = 'Invalid Password';
        }

        _showDialogError(errorMessge);
      }
      setState(() {
        _isLoading = false;
      });
    }
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
                      left: MediaQuery.of(context).size.width / 4 + 5,
                      child: CircleAvatar(
                        radius: 85,
                        backgroundImage: AssetImage('assets/images/logo.jpg'),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 50,
                  child: TextFormField(
                    controller: _nameController,
                    style: TextStyle(color: Colors.black),
                    validator: (val) {
                      if (val.isEmpty ||
                          val.trim().length == 0 ||
                          val.trim().length <= 3) {
                        return 'value is not valid';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Name',
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
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
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 50,
                  child: TextFormField(
                    style: TextStyle(color: Colors.black),
                    controller: _passwordController,
                    validator: (val) {
                      if (val.isEmpty ||
                          val.trim().length == 0 ||
                          val.trim().length <= 3) {
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
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 50,
                  child: TextFormField(
                    style: TextStyle(color: Colors.black),
                    validator: (val) {
                      if (val != _passwordController.text) {
                        return 'Passwords do not match!';
                      }
                      return null;
                    },
                    obscureText: !_togggleVisiabilty,
                    decoration: InputDecoration(
                      hintText: 'confirm Password',
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
                  height: 18,
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
                                onPressed: () => _submitForm(),
                                minWidth: 200.0,
                                height: 42.0,
                                child: Text(
                                  'Register',
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
                            text: "have an Account ? ",
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Sign in',
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
                            .pushReplacementNamed(LoginPage.routeName),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
