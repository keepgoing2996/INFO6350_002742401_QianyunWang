import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instgram_flutter/widgets/cart_activity.dart';
import 'package:instgram_flutter/widgets/new_post_activity.dart';
import 'package:instgram_flutter/models/sale_item_url.dart';
import 'package:instgram_flutter/widgets/item_details.dart';
import 'package:instgram_flutter/resources/filestore_methods.dart';

class BrowsePostsActivity extends StatefulWidget {
  const BrowsePostsActivity({super.key});

  @override
  State<BrowsePostsActivity> createState() => _BrowsePostsActivityState();
}

class _BrowsePostsActivityState extends State<BrowsePostsActivity> {
  void _goToCart() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => CartActivity(),
    ));
  }

  void _addItem() async {
    final res = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (ctx) => const NewPostActivity(),
      ),
    );
    if (res == null) return;
    final text = 'added new item: ';
    final snackBar = SnackBar(content: Text(text + res!));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _removeItem(String id) async {
    await FireStoreMethods().deleteSaleItem(id);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = StreamBuilder(
        stream: FirebaseFirestore.instance.collection('saleItems').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          var saleItems = snapshot.data!.docs;
          if (saleItems.length == 0) {
            return Center(
              child: Column(
                children: [
                  Text('No items added yet'),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: saleItems.length, //_saleItems.length,
            itemBuilder: (ctx, index) => Dismissible(
              onDismissed: (direction) {
                _removeItem(saleItems[index].data()['id']);
              },
              key: ValueKey(saleItems[index].data()['id']),
              child: ListTile(
                title: Text(saleItems[index].data()['name']),
                leading: CircleAvatar(
                  radius: 26,
                  backgroundImage:
                      NetworkImage(saleItems[index].data()['imageUrl']),
                ),
                trailing: Text(saleItems[index].data()['price'].toString()),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => ItemDetailScreen(
                        snap: saleItems[index].data(),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        });
    // }
    return Scaffold(
      appBar: AppBar(
        title: const Text('All On Sale Items'),
        actions: [
          IconButton(
            onPressed: _goToCart,
            icon: const Icon(Icons.shopping_cart_checkout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        backgroundColor: Colors.orangeAccent,
        child: const Icon(Icons.add),
      ),
      body: content,
    );
  }
}
