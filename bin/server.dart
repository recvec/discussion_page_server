import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:hive/hive.dart';

import 'db_service.dart';
import 'model/comment.dart';

//const _hostname = '0.0.0.0';
const _hostname = 'localhost';
const _port = 37777;
DBService _dbService;
List<WebSocket> sockets = List<WebSocket>();


void main(List<String> args) {
  runZoned(() async {
    _dbService = DBService();
    await _dbService.initDB();
    await _dbService.generateRandomComment();

    final HttpServer server = await HttpServer.bind(_hostname, _port);

    print('Serving at http://${server.address.host}:${server.port}');
    await for (var req in server) {
      // Upgrade a HttpRequest to a WebSocket connection.
      var socket = await WebSocketTransformer.upgrade(req);
      socket.listen(_handleComment);


    }
  }, onError: (e) => print("An error occurred.$e"));
}

_handleComment(result) {
_dbService.addComment( json.decode(result));
}


//Trash
//    var bin = CommentAdapter().read(reader)_dbService.getComments()[0];

//


//      var socket = await WebSocketTransformer.upgrade(
//          req); // Upgrades connection to web socket
//      sockets.add(socket);
//     await  _dbService.generateRandomComment();
//     var res = _dbService.getComments().toString();
//      sockets.forEach((socket) {
//        socket.add(res);
//      });