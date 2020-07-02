import 'package:baathcheeth/afterauth/bottomnavbar.dart';
import 'package:baathcheeth/afterauth/home.dart';
import 'package:baathcheeth/authenticate/auth.dart';
import 'package:baathcheeth/firebase/database/database.dart';
import 'package:baathcheeth/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return user == null? Auth(): Bottomnavbar();
  }
}
