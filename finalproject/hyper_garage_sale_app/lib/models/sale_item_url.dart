import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class SaleItemUrl {
  const SaleItemUrl({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.image2Url,
    required this.uid,
    required this.username,
    required this.profImage,
  });
  final String id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final String image2Url;
  final String uid;
  final String username;
  final String profImage;

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "description": description,
        "imageUrl": imageUrl,
        "image2Url": image2Url,
        "uid": uid,
        "username": username,
        "profImage": profImage,
      };

  static SaleItemUrl fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return SaleItemUrl(
      id: snapshot['id'],
      name: snapshot['name'],
      price: snapshot['price'],
      description: snapshot['description'],
      imageUrl: snapshot['imageUrl'],
      image2Url: snapshot['image2Url'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      profImage: snapshot['profImage'],
    );
  }
}
