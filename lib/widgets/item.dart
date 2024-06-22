import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_items.dart';

class Item extends StatelessWidget {
  const Item({super.key, required this.groceryitem});

  final GroceryItem groceryitem;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(groceryitem.name),
      leading: Container(
        height: 25,
        width: 25,
        decoration: BoxDecoration(
          color: groceryitem.category.color,
        ),
      ),
      trailing: Text(
        groceryitem.quantity.toString(),
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
