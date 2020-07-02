import 'package:baathcheeth/authenticate/login/login.dart';
import 'package:flutter/material.dart';
import 'package:baathcheeth/authenticate/register/register.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {

  bool toggle= false;
  void changetoggle()
  {
    setState(() {
      toggle = !toggle;
    });
  }


  @override
  Widget build(BuildContext context) {
    return !toggle ? Login(toggle: changetoggle) : Register(toogle: changetoggle);
  }
}
