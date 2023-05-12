import 'dart:async';
import 'package:mysql1/mysql1.dart';

class ItemService {
  late MySqlConnection _connection;

  ItemService() {
    _connectToDatabase();
  }

  Future<void> _connectToDatabase() async {
    final settings = ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'your_username',
      password: 'your_password',
      db: 'your_database',
    );

    _connection = await MySqlConnection.connect(settings);
  }

  Future<List<Map<String, dynamic>>> getItems() async {
    final results = await _connection.query('SELECT * FROM items');
    final items = results.map((r) => r.fields).toList();
    return items;
  }

  Future<Map<String, dynamic>?> getItem(String id) async {
    final results = await _connection.query('SELECT * FROM items WHERE id = ?', [id]);
    if (results.isNotEmpty) {
      return results.first.fields;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> createItem(Map<String, dynamic> item) async {
    final result = await _connection.query(
      'INSERT INTO items (name, description) VALUES (?, ?)',
      [item['name'], item['description']],
    );
    item['id'] = result.insertId;
    return item;
  }

  Future<Map<String, dynamic>?> updateItem(String id, Map<String, dynamic> item) async {
    final result = await _connection.query(
      'UPDATE items SET name = ?, description = ? WHERE id = ?',
      [item['name'], item['description'], id],
    );
    if (result.affectedRows! > 0) {
      return item;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> deleteItem(String id) async {
    final result = await _connection.query('DELETE FROM items WHERE id = ?', [id]);
    if (result.affectedRows! > 0) {
      final deletedItem = await getItem(id);
      return deletedItem;
    } else {
      return null;
    }
  }
}
