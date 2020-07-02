import 'package:baathcheeth/afterauth/post.dart';
import 'package:baathcheeth/models/chatinitiative.dart';
import 'package:baathcheeth/models/user.dart';
import 'package:baathcheeth/models/userpost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Database{
  final String uid;
  Database({this.uid});
  CollectionReference collectionReference = Firestore.instance.collection("users");



  User userdatafromfirebase(DocumentSnapshot snapshot)
  {
    return User(uid: uid, name: snapshot.data["name"], email: snapshot.data["email"], profilepicurl: snapshot.data["profilepicurl"]);
  }

  Stream<User> get userdata{
    return collectionReference.document(uid).snapshots().map(userdatafromfirebase);
  }

  void updateuserdata(String name,String email,String profilepicurl,String status) async
  {
    await collectionReference.document(uid).setData({
      'name': name,
      'email': email,
      'profilepicurl': profilepicurl,
      'onlinestatus': status
    });

  }
  Future deleteuser() async
  {
    try {
      await collectionReference.document(uid).delete();
      return true;
    } on Exception catch (e) {
      return false;
    }
  }

  Future searchuser(String email) async{

    var result = await collectionReference.where('email',isEqualTo: email).getDocuments();
    if(result.documents.length>0) {
      String n = result.documents[0].data['name'];
      String e = result.documents[0].data['email'];
      String uid = result.documents[0].documentID;
      String profilepicurl =result.documents[0].data['profilepicurl'];
      User user = User(name: n, email: e, uid: uid,profilepicurl: profilepicurl);
      return user;
    }
    else
      return null;
    }
    void addpost(String url) async{

      int ts = DateTime.now().millisecondsSinceEpoch;
      DateTime dt = DateTime.now();
      String dateandtime = "Posted On " + dt.day.toString()+"/" + dt.month.toString()+"/" + dt.year.toString() +" At "+ dt.hour.toString() +":" + dt.minute.toString();
      await collectionReference.document(uid).collection("posts").document(ts.toString()).setData({'url': url.toString(),"datetime": dateandtime });

    }

    Userpost getuserspost(DocumentSnapshot snapshot)
    {
      return Userpost(url: snapshot.data["url"]);
    }

    Future userpost(bool onlyme) async
    {
      List<Userpost> up = new List();
      if(onlyme == false) {
        List<Userpost> arr = new List();
        await collectionReference.document(uid)
            .collection("following")
            .getDocuments()
            .then((snapshot) {
          snapshot.documents.forEach((element) {
            if (element.documentID != uid) {
              Userpost up = Userpost(
                  uid: element.documentID, name: element.data["name"] );
              arr.add(up);
            }
          });
        });

        for(int i=0;i<arr.length;i++){
          String name;
          String profilepicurl;
          await collectionReference.document(arr[i].uid).get().then((value) {
            if(value.data!=null) {
              name = value.data["name"];
              profilepicurl = value.data["profilepicurl"];
            }
          });
          await collectionReference.document(arr[i].uid).collection("posts").getDocuments().then((snapshot){
            snapshot.documents.forEach((element) {
              if(element.data!=null && name!=null && profilepicurl!=null) {
                Userpost userpostp = Userpost(profilepicurl: profilepicurl,
                    uid: arr[i].uid,
                    url: element.data["url"],
                    name: name,
                    documentid: element.documentID,
                    datetime: element.data["datetime"]);
                up.add(userpostp);
              }
            });
          });
        }
        Comparator<Userpost> sortbydocumentid = (a,b) => a.documentid.compareTo(b.documentid);
        up.sort(sortbydocumentid);
        up = up.reversed.toList();
        arr.clear();
      }
      else{
        String name;
        String profilepicurl;
        await collectionReference.document(uid).get().then((value) {
          name= value.data["name"];
          profilepicurl = value.data["profilepicurl"];
        });
        await collectionReference.document(uid).collection("posts").getDocuments().then((snapshot){
          snapshot.documents.forEach((element) {
            Userpost userpostp = Userpost(profilepicurl: profilepicurl,uid:uid, url:element.data["url"], name: name , documentid: element.documentID, datetime: element.data["datetime"] );
            up.add(userpostp);
          });
        });
        up= up.reversed.toList();
      }


      return up;
    }
    Future followuser(String followeruid, String name) async{
      await collectionReference.document(uid).collection("following").document(followeruid).setData({"following": "true", "name": name});
      await collectionReference.document(followeruid).collection("followers").document(uid).setData({"followingme": "true"});
      return true;
    }
    Future unfollowuser(String followeruid) async{
    await collectionReference.document(uid).collection("following").document(followeruid).delete();
    await collectionReference.document(followeruid).collection("followers").document(uid).delete();
    return true;
    }
    Future isfollowing(String followeruid) async{
      var snapshot = await collectionReference.document(uid).collection("following").document(followeruid).get();
      if(snapshot.data==null)
        return false;
      else
        return true;
    }
    Future getfollowing() async{
    List<String> uids = new List();
      await collectionReference.document(uid).collection("following").getDocuments().then((value){
        value.documents.forEach((element) {
          uids.add(element.documentID);
        });
      });

      List<User> followerslist = new List();
      for(int i=0;i<uids.length;i++){
          await collectionReference.document(uids[i]).get().then((value) {
            if(value.data!=null) {
              User up = User(uid: value.documentID,
                  name: value.data["name"],
                  email: value.data["email"],
                  profilepicurl: value.data["profilepicurl"]);
              followerslist.add(up);
            }
        });
      }
      return followerslist;
    }
    Future getfollowers() async{
    List<String> uids = new List();
    await collectionReference.document(uid).collection("followers").getDocuments().then((value){
      value.documents.forEach((element) {
        uids.add(element.documentID);
      });
    });

    List<User> followerslist = new List();
    for(int i=0;i<uids.length;i++){
      await collectionReference.document(uids[i]).get().then((value) {
        if(value.data!=null) {
          User up = User(uid: value.documentID,
              name: value.data["name"],
              email: value.data["email"],
              profilepicurl: value.data["profilepicurl"]);
          followerslist.add(up);
        }
      });
    }
    return followerslist;
  }

  Future chat(String recieverid) async{
    try {
      var xyz = await collectionReference.document(uid).collection("chats").document(recieverid).get();
      if(xyz != null) {
        await collectionReference.document(uid).collection("chats").document(
            recieverid).setData({"timestamp": DateTime
            .now()
            .millisecondsSinceEpoch
            .toString()});
        await collectionReference.document(recieverid)
            .collection("chats")
            .document(uid)
            .setData({"timestamp": DateTime
            .now()
            .millisecondsSinceEpoch
            .toString()});
        return true;
      }
      else{
        return false;
      }
    } on Exception catch (e) {
      return false;
    }
  }

  Future getwithwhomchatted() async{
    print("gh");
    List<Chatinitiative> uids = new List();
    await collectionReference.document(uid).collection("chats").getDocuments().then((value) {
      value.documents.forEach((element) {
        Chatinitiative ci = Chatinitiative(latesttimestamp: element.data["timestamp"],recieverid: element.documentID);
        uids.add(ci);
      });
    });
    List<Chatinitiative> withchatted = new List();
    for(int i=0;i<uids.length;i++){
      await collectionReference.document(uids[i].recieverid).get().then((value){
        if(value.data!=null) {
          Chatinitiative ci = new Chatinitiative(
            latesttimestamp: uids[i].latesttimestamp,
            recieveronlinestatus: value.data["onlinestatus"],
            recievername: value.data["name"],
            recieverprofilepic: value.data["profilepicurl"],
            recieverid: value.documentID,
            senderid: uid,
            recieveremailid: value.data["email"],
          );
          withchatted.add(ci);
        }
      });
    }
    uids.clear();
    print("gh");
    return withchatted;
  }

}