import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../service/item_service.dart';


class ItemController {
  final _service = ItemService();
  late Router _router;

  ItemController() {
    _router = Router()
      ..get('/items', _getItems)
      ..get('/items/<id>', _getItem)
      ..post('/items', _createItem)
      ..put('/items/<id>', _updateItem)
      ..delete('/items/<id>', _deleteItem);
  }

  Router get router => _router;

  Future<Response> _getItems(Request request) async {
    final items = await _service.getItems();
    final jsonItems = jsonEncode(items);

    return Response.ok(jsonItems, headers: {'Content-Type': 'application/json'});
  }

  Future<Response> _getItem(Request request, String id) async {
    final item = await _service.getItem(id);

    if (item != null) {
      final jsonItem = jsonEncode(item);
      return Response.ok(jsonItem, headers: {'Content-Type': 'application/json'});
    } else {
      return Response.notFound('Item não encontrado');
    }
  }

  Future<Response> _createItem(Request request) async {
    final body = await request.readAsString();
    final item = jsonDecode(body);

    final createdItem = await _service.createItem(item);

    return Response.ok('Item criado com sucesso');
  }

  Future<Response> _updateItem(Request request, String id) async {
    final body = await request.readAsString();
    final item = jsonDecode(body);

    final updatedItem = await _service.updateItem(id, item);

    if (updatedItem != null) {
      return Response.ok('Item atualizado com sucesso');
    } else {
      return Response.notFound('Item não encontrado');
    }
  }

  Future<Response> _deleteItem(Request request, String id) async {
    final deletedItem = await _service.deleteItem(id);

    if (deletedItem != null) {
      return Response.ok('Item excluído com sucesso');
    } else {
      return Response.notFound('Item não encontrado');
    }
  }
}
