import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/models/user.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });
  
  //collection reference
  final CollectionReference brewCollection = FirebaseFirestore.instance.collection("brews");

  Future updateUserData(String sugars, String name, int strength) async {
    print('setting user data');
    return await brewCollection.doc(uid).set({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });
  }

  //brew list from snapshot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return Brew(
        name: doc.data()['name'] ?? "",
        sugars: doc.data()['sugars'] ?? "",
        strength: doc.data()['strength'] ?? "",
      );
    }).toList();
  }

  // userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
      uid: uid,
      name: snapshot.data()["name"],
      sugars: snapshot.data()["sugars"],
      strength: snapshot.data()["strength"]
    );
  }

  //get brew stream
  Stream<List<Brew>> get brews {
      return brewCollection.snapshots()
          .map(_brewListFromSnapshot);
  }

  //get user doc stream
  Stream<UserData> get userData {
    return brewCollection.doc(uid).snapshots()
              .map(_userDataFromSnapshot);
  }
  
}