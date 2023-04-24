import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instgram_flutter/resources/filestore_methods.dart';
import 'package:instgram_flutter/resources/auth_methods.dart';
import 'package:instgram_flutter/screens/login_screen.dart';
import 'package:instgram_flutter/widgets/new_post_activity.dart';
import 'package:instgram_flutter/models/sale_item_url.dart';
import 'package:instgram_flutter/widgets/item_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instgram_flutter/utils/utils.dart';

class CartActivity extends StatefulWidget {
  const CartActivity({
    super.key,
  });

  @override
  State<CartActivity> createState() => _CartActivityState();
}

class _CartActivityState extends State<CartActivity> {
  List _inCartItems = [];
  bool _isLoading = false;
  String _uid = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      User user = FirebaseAuth.instance.currentUser!;
      var userSnap = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();
      _uid = user.uid;
      List cartItems = userSnap.data()!['cartItems'];
      print(cartItems.length);
      for (int i = 0; i < cartItems.length; i++) {
        var snap = await FirebaseFirestore.instance
            .collection("saleItems")
            .doc(cartItems[i])
            .get();
        _inCartItems.add(snap.data()!);
      }
    } catch (e) {
      showSnackBar(
        e.toString(),
        context,
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = 0.0;
    for (int i = 0; i < _inCartItems.length; i++) {
      totalPrice += _inCartItems[i]['price'];
    }
    print(totalPrice);
    Widget content = const Center(
      child: CircularProgressIndicator(),
    );
    if (!_isLoading) {
      content = Center(
        child: Column(
          children: [
            Text('No items added yet'),
          ],
        ),
      );
      if (_inCartItems.isNotEmpty) {
        content = ListView.builder(
          itemCount: _inCartItems.length,
          itemBuilder: (ctx, index) => Dismissible(
            onDismissed: (direction) async {
              await FireStoreMethods()
                  .removeItemInCart(_inCartItems[index]['id']);
              setState(() {
                _inCartItems.removeAt(index);
              });
            },
            key: ValueKey(_inCartItems[index]['id']),
            child: ListTile(
              title: Text(_inCartItems[index]['name']),
              leading: CircleAvatar(
                radius: 26,
                backgroundImage: NetworkImage(_inCartItems[index]['imageUrl']),
              ),
              trailing: Text(_inCartItems[index]['price'].toString()),
            ),
          ),
        );
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        actions: [
          IconButton(
              onPressed: () async {
                await AuthMethods().signOut();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ));
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.orangeAccent,
        // child: const Icon(Icons.payment),
        child: Text('\$' + totalPrice.toString()),
      ),
      body: content,
    );
  }
}
