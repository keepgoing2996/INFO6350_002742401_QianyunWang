import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List cartItems;
  final List myItems;

  const User({
    required this.email,
    required this.uid,
    required this.photoUrl,
    required this.username,
    required this.bio,
    required this.cartItems,
    required this.myItems,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
        "cartItems": cartItems,
        "myItems": myItems,
      };

  static User fromSnap(DocumentSnapshot snap) {
    print('snap');
    print(snap.data());
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      username: snapshot['username'],
      uid: snap["uid"],
      email: snap["email"],
      photoUrl: snap["photoUrl"],
      bio: snap["bio"],
      cartItems: snap["cartItems"],
      myItems: snap["myItems"],
    );
  }
}
