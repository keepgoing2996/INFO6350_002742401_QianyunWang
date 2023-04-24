import 'package:flutter/material.dart';
import 'package:instgram_flutter/utils/utils.dart';
import 'package:instgram_flutter/widgets/item_image.dart';
import 'package:instgram_flutter/widgets/new_post_activity.dart';
import 'package:instgram_flutter/utils/colors.dart';
import 'package:instgram_flutter/resources/filestore_methods.dart';

class ItemDetailScreen extends StatelessWidget {
  const ItemDetailScreen({super.key, required this.snap});

  final snap;
  // final void Function(SaleItem) onPurchase;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        title: Text(snap['name']),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 1,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.2)),
                ),
                height: 125,
                width: 125,
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => ItemImageScreen(
                          title: snap['name'],
                          image: snap['imageUrl'],
                        ),
                      ),
                    );
                  },
                  child: Image.network(
                    snap['imageUrl'].toString(),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 1,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.2)),
                ),
                height: 125,
                width: 125,
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => ItemImageScreen(
                          title: snap['name'],
                          image: snap['image2Url'],
                        ),
                      ),
                    );
                  },
                  child: Image.network(
                    snap['image2Url'].toString(),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: Colors.orange,
              border: Border.all(
                  width: 1,
                  color:
                      Theme.of(context).colorScheme.primary.withOpacity(0.2)),
            ),
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              snap['name'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.blue,
              border: Border.all(
                  width: 1,
                  color:
                      Theme.of(context).colorScheme.primary.withOpacity(0.2)),
            ),
            child: Text(
              "\$" + snap['price'].toString(),
              style: TextStyle(
                fontSize: 25,
                fontStyle: FontStyle.italic,
              ),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                  width: 1,
                  color:
                      Theme.of(context).colorScheme.primary.withOpacity(0.2)),
            ),
            child: Text(
              "Description:\n" + snap['description'],
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              String res = await FireStoreMethods().addItemToCart(snap['id']);
              showSnackBar(res, context);
            },
            child: const Text('Add Item to Cart'),
          ),
        ],
      ),
    );
  }
}
