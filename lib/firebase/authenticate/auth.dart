import 'package:baathcheeth/firebase/database/database.dart';
import 'package:baathcheeth/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Authenticate{
  final FirebaseAuth auth = FirebaseAuth.instance;
  String uid;
  String name;
  String email;
  User customusermodel(FirebaseUser user)
  {
    return user!=null ? User(uid: user.uid,name: name,email: email) : null;
  }
  void register(String name,String email,String password) async{
    this.name =name;
    this.email = email;
    try{
      CollectionReference collectionReference = Firestore.instance.collection('users');
      AuthResult result= await auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user= result.user;
      await collectionReference.document(user.uid).setData({
        'name': name,
        'email': email,
        'profilepicurl': "https://firebasestorage.googleapis.com/v0/b/baathcheeth-15e00.appspot.com/o/user.png?alt=media&token=5e1abe01-a272-442b-9951-4ff22f511019"
      });
    }
    catch(e)
    {
      print("Exception in register");
      print(e);
    }
  }
  Future login(String email,String password) async
  {
    try{
      AuthResult result = await auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    }
    catch(e){
      print("Exception in login");
      print(e);
      return null;
    }
  }
  void logout()
  {
    auth.signOut();
  }
  Future deleteaccount(String uid) async
  {
    try {
      FirebaseUser user = await auth.currentUser();
      await user.delete();
      try {
        await Database(uid: uid).deleteuser();
        return true;
      } on Exception catch (e) {
        return false;
      }
    } on Exception catch (e) {
      return false;
    }
  }
  void changepassword(String email,String oldpwd,String pwd) async{
      FirebaseUser user = await auth.currentUser();
      user.updatePassword(pwd);
  }
  Stream<User> get user{
    return auth.onAuthStateChanged.map(customusermodel);
  }
}