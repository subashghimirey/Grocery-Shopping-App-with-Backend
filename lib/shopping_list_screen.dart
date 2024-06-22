import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_items.dart';
import 'package:shopping_list/widgets/item.dart';
import 'package:shopping_list/widgets/new_item.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final List<GroceryItem> _groceryItems = [];

  void _removeGroceryItem(GroceryItem item) {
    //we find the index so that we can undo the deletion and insert in same index
    var index = _groceryItems.indexOf(item);

    setState(() {
      _groceryItems.remove(item);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Grocery Item Deleted"),
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: "Undo",
        onPressed: () {
          return setState(() {
            _groceryItems.insert(index, item);
          });
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    void addItem() async {
      var newItem = await Navigator.of(context).push<GroceryItem>(
          MaterialPageRoute(builder: (context) => const NewItem()));

      if (newItem == null) {
        return;
      }

      setState(() {
        _groceryItems.add(newItem);
      });
    }

    Widget content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (context, index) => Dismissible(
              key: ValueKey(_groceryItems[index].id),
              child: Item(
                groceryitem: _groceryItems[index],
              ),
              onDismissed: (direction) =>
                  _removeGroceryItem(_groceryItems[index]),
            ));

    if (_groceryItems.isEmpty) {
      content = const Center(
        child: Text("Add some items!"),
      );
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey,
          title: const Text(
            "Your Groceries",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(onPressed: addItem, icon: const Icon(Icons.add))
          ],
        ),
        body: content);
  }
}
