import 'package:baathcheeth/afterauth/chats.dart';
import 'package:baathcheeth/afterauth/home.dart';
import 'package:baathcheeth/afterauth/post.dart';
import 'package:baathcheeth/afterauth/profile.dart';
import 'package:baathcheeth/afterauth/search.dart';
import 'package:baathcheeth/firebase/database/database.dart';
import 'package:baathcheeth/models/chatinitiative.dart';
import 'package:baathcheeth/models/user.dart';
import 'package:baathcheeth/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Bottomnavbar extends StatefulWidget {
  @override
  _BottomnavbarState createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {


  List list;
  List<Chatinitiative> chats;
  bool postloading = false;
  bool chatlistloading = false;
  int curridx =4;




  List<Widget> _selectedwidget() =>[Home(list),Search(),Chats(list: chats,),Post(),Profile()];


  @override
  Widget build(BuildContext context) {
    final user= Provider.of<User>(context);
    final List<Widget> children = _selectedwidget();
    void getuserposts() async{
      setState(() {
        postloading = true;
      });
      dynamic result = await Database(uid: user.uid).userpost(false);
      setState(() {
        postloading = false;
        if(result!=null){
          setState(() {
            list = result;
          });
        }
      });
    }
    void getchatslist() async{
      setState(() {
        chatlistloading = true;
      });
      dynamic result = await Database(uid: user.uid).getwithwhomchatted();
      setState(() {
        chatlistloading = false;
        if(result!=null){
          setState(() {
            chats = result;
          });
        }
      });
    }

    return Scaffold(
      body: (curridx==0? (postloading == true? Loading(): children[curridx]) : (curridx==2? (chatlistloading==true? Loading(): children[curridx]): children[curridx])),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey[900],
        currentIndex: curridx,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("Home")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text("Search")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              title: Text("Chats")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_a_photo),
              title: Text("Post a new photo")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text("Profile")
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white,
        onTap: (index) async {
          setState(() {
            curridx = index;

          });
          if(curridx==0){
            await getuserposts();
          }
          else if(curridx == 2){
            await getchatslist();
          }
        },
      ),
    );
  }
}
