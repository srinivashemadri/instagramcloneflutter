import 'package:baathcheeth/afterauth/chatscreen.dart';
import 'package:baathcheeth/afterauth/followersdisplay.dart';
import 'package:baathcheeth/afterauth/home.dart';
import 'package:baathcheeth/afterauth/myposts.dart';
import 'package:baathcheeth/firebase/authenticate/auth.dart';
import 'package:baathcheeth/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'afterauth/followingdisplay.dart';
import 'afterauth/profile.dart';
import 'afterauth/searchedprofile.dart';
import 'models/user.dart';

void main() {

  runApp(Myapp());
}

class Myapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return StreamProvider<User>.value(

      value: Authenticate().user,
      child: MaterialApp(
        home: Wrapper(),
         initialRoute: "/wrapper",
         routes: {
          '/wrapper': (context)=> Wrapper(),
          '/following':( context)=> Following(),
           '/followers': (context)=> Followers(),
           '/searchprofile': (context)=> Searchedprofile(),
           '/myposts': (context)=> Myposts(),
           '/chatscreen': (context)=> Chatscreen(),
           '/profile': (context)=> Profile()
        },
      ),
    );
  }
}
