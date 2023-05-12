import 'dart:async';
import '../models/item_model.dart';


class ItemRepository {
  final List<Item> _items = [];

  Future<List<Item>> getItems() async {
    return _items;
  }

  Future<Item> getItem(String id) async {
    final item = _items.firstWhere((item) => item.id == id, orElse: () {
      throw Exception('Item not found');
    });
    return item;
  }

  Future<Item> createItem(String name, String description) async {
    final item = Item(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
    );
    _items.add(item);
    return item;
  }

  Future<Item?> updateItem(String id, String name, String description) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      final updatedItem = Item(
        id: id,
        name: name,
        description: description,
      );
      _items[index] = updatedItem;
      return updatedItem;
    } else {
      return null;
    }
  }

  Future<Item?> deleteItem(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      final deletedItem = _items[index];
      _items.removeAt(index);
      return deletedItem;
    } else {
      return null;
    }
  }
}
