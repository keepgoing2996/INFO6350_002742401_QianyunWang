import 'dart:typed_data';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instgram_flutter/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instgram_flutter/models/sale_item_url.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadSaleItem({
    required String id,
    required String name,
    required double price,
    required String description,
    required File image,
    required File image2,
    required String uid,
    required String username,
    required String profImage,
  }) async {
    String res = "Some error occured";
    // User currentUser = _auth.currentUser!;
    try {
      if (id.isNotEmpty ||
          name.isNotEmpty ||
          price <= 0.0 ||
          description.isNotEmpty ||
          image != null ||
          image2 != null) {
        String imageUrl = await StorageMethods()
            .uploadImageFileToStorage('saleItemsPic', image, true);

        String imageUrl2 = await StorageMethods()
            .uploadImageFileToStorage('saleItemsPic', image2, true);

        SaleItemUrl saleitem = SaleItemUrl(
          id: id,
          name: name,
          price: price,
          description: description,
          imageUrl: imageUrl,
          image2Url: imageUrl2,
          uid: uid,
          username: username,
          profImage: profImage,
        );
        await _firestore.collection('saleItems').doc(id).set(saleitem.toJson());
        await _firestore
            .collection("users")
            .doc(_auth.currentUser!.uid)
            .update({
          "myItems": FieldValue.arrayUnion([id])
        });
        res = 'success';
      }
    } catch (err) {
      res = err.toString();
      // print(res);
    }
    return res;
  }

  Future<String> addItemToCart(String itemId) async {
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
    List cartItems = (snap.data()! as dynamic)['cartItems'];
    List myItems = (snap.data()! as dynamic)['myItems'];
    if (myItems.contains(itemId)) {
      return 'cant buy your own item';
    }
    if (cartItems.contains(itemId)) {
      return "item already in cart";
    }
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      'cartItems': FieldValue.arrayUnion([itemId])
    });

    return "item added to cart";
  }

  Future<String> removeItemInCart(String itemId) async {
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
    List cartItems = (snap.data()! as dynamic)['cartItems'];
    if (!cartItems.contains(itemId)) {
      return "item not in cart";
    }
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      'cartItems': FieldValue.arrayRemove([itemId])
    });

    return "item removed from cart";
  }

  Future<void> deleteSaleItem(String id) async {
    try {
      await _firestore.collection('saleItems').doc(id).delete();
    } catch (err) {
      print(err.toString());
    }
  }
}
