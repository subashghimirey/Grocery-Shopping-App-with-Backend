import 'dart:convert';
import 'dart:ffi';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:shopping_list/data/category_data.dart';
import 'package:shopping_list/models/grocery_items.dart';
import 'package:shopping_list/widgets/item.dart';
import 'package:shopping_list/widgets/new_item.dart';

import 'package:http/http.dart' as http;

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  List<GroceryItem> _groceryItems = [];

  var _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  void loadItems() async {
    final List<GroceryItem> loadedGroceryItems = [];

    final url = Uri.https(
        "grocerylist-42da4-default-rtdb.asia-southeast1.firebasedatabase.app",
        'grocery-Items-List.json');

    final response = await http.get(url);

    final Map<String, dynamic> listData = json.decode(response.body);

    for (final item in listData.entries) {
      final category = categories.entries
          .firstWhere(
            (catItem) => catItem.value.title == item.value['category'],
          )
          .value;

      loadedGroceryItems.add(
        GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category,
        ),
      );
    }

    setState(() {
      _groceryItems = loadedGroceryItems;
      _isLoading = false;
    });
  }

  void addItem() async {
    var newItem = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const NewItem()));

    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newItem);
    });
  }

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
    Widget content = Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Add some items clicking here",
            style: TextStyle(fontSize: 18),
          ),
          IconButton(
              onPressed: addItem,
              icon: const Icon(
                Icons.add,
                size: 30,
                color: Colors.white,
              ))
        ],
      ),
    );

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
          itemCount: _groceryItems.length,
          itemBuilder: (context, index) => Dismissible(
                background: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).colorScheme.error.withOpacity(0.7),
                  ),
                ),
                key: ValueKey(_groceryItems[index].id),
                child: Item(
                  groceryitem: _groceryItems[index],
                ),
                onDismissed: (direction) =>
                    _removeGroceryItem(_groceryItems[index]),
              ));
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey,
          title: const Text(
            "Your Groceries",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
                onPressed: addItem,
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ))
          ],
        ),
        body: content);
  }
}
