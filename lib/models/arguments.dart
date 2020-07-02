import 'package:baathcheeth/models/user.dart';

class Argumentsforfollowing{

  final List following;
  Argumentsforfollowing({this.following});

}

class Searchprofile{
  User user;
  String followingornot;
  Searchprofile(User user, String forn){
    this.user = user;
    this.followingornot = forn;
  }
}

class Posts{
  final List posts;
  Posts({this.posts});
}