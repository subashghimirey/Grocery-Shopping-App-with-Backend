import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/data/category_data.dart';
import 'package:shopping_list/models/category.dart';

import 'package:http/http.dart' as http;
import 'package:shopping_list/models/grocery_items.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  var _isSending = false;
  var error_occured = false;
  Map<dynamic, dynamic> resData = {};

  //global key --> gives easy access to underlying widgets and if the build is executed again then the form is not rebuilt and instead keeps its internal state
  //we will always use globalkey with form in flutter

  final _formKey = GlobalKey<FormState>();

  var _selectedTitle = "";
  var _selectedQuantity = 1;
  var _selectedCateogry = categories[Categories.fruit]!;

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isSending = true;
      }); // this automtically calls all the onSaved operations in the Form
    }

    var url = Uri.https(
        "grocerylist-42da4-default-rtdb.asia-southeast1.firebasedatabase.app",
        'grocery-Items-List.json');

    try {
      var response = await http.post(url,
          headers: {'content-type': 'application/json'},
          //we need to encode to json format for firebase and id is automatically genered by firebase
          body: json.encode({
            "name": _selectedTitle,
            "quantity": _selectedQuantity,
            "category": _selectedCateogry.title
            //here encoding of category object failed, hence we passed only the title
          }));

      resData = json.decode(response.body);

      if (!context.mounted) {
        return;
      }
    } catch (error) {
      setState(() {
        error_occured = true;
        _isSending = false;
      });
    }
    error_occured
        ? ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("no internet")))
        : Navigator.of(context).pop(GroceryItem(
            id: resData['name'],
            name: _selectedTitle,
            quantity: _selectedQuantity,
            category: _selectedCateogry));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add New Item to List"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                //here inside Form, we use TextFormField instead of TextField
                TextFormField(
                  maxLength: 50,
                  decoration: const InputDecoration(
                    label: Text("Name: "),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1) {
                      return "Must be between 2 and 50 characters.";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _selectedTitle = value!;
                  },
                ),
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        maxLength: 12,
                        decoration: const InputDecoration(
                          label: Text("Quantity"),
                        ),
                        initialValue: "1",
                        keyboardType: const TextInputType.numberWithOptions(),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.tryParse(value) == null ||
                              int.tryParse(value)! <= 0) {
                            return "Must be a valid, positive number";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _selectedQuantity = int.parse(value!);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: DropdownButtonFormField(
                        value: _selectedCateogry,
                        items: [
                          for (var category in categories.entries)
                            DropdownMenuItem(
                              value: category.value,
                              child: Row(
                                children: [
                                  Container(
                                    height: 16,
                                    width: 16,
                                    color: category.value.color,
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Text(category.value.title)
                                ],
                              ),
                            )
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCateogry = value!;
                          });
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        //to disable any button, simply pass null as the function onpressed
                        onPressed: _isSending
                            ? null
                            : () {
                                _formKey.currentState!.reset();
                              },
                        child: const Text("Reset")),
                    ElevatedButton(
                        onPressed: _isSending ? null : _saveItem,
                        child: _isSending
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(),
                              )
                            : const Text("Add Item"))
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
