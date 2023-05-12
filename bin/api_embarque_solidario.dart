import 'package:api_embarque_solidario/controllers/item_controller.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

void main(List<String> arguments) async {
  final controller = ItemController();

  final handler = const Pipeline().addMiddleware(logRequests()).addHandler(controller.router);

  final server = await io.serve(handler, '0.0.0.0', 8080);
  print('Servidor rodando em http://${server.address.host}:${server.port}');
}
