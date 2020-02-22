import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'db/db_service.dart';

const _hostname = '0.0.0.0';
const addCommentCommand = 'add_comment';
const deleteCommentCommand = 'delete_comment';
const likeCommentCommand = 'like_comment';
const dislikeCommentCommand = 'dislike_comment';
const updateCommentCommand = 'update_comment';
const splitter = ':::';
const _port = 37777;
DBService _dbService;
List<WebSocket> sockets = List<WebSocket>();

void main(List<String> args) {
  runZoned(() async {
    _dbService = DBService();
    await _dbService.initDB();

    final HttpServer server = await HttpServer.bind(_hostname, _port);

    print('Serving at http://${server.address.host}:${server.port}');
    await for (var req in server) {
      // Upgrade a HttpRequest to a WebSocket connection.
      var socket = await WebSocketTransformer.upgrade(req);
      _sendAllComments(socket);
      socket.listen((result) => _handleRequest(result, socket));
    }
  }, onError: (e) => print('An error occurred.$e'));
}

_handleRequest(String request, WebSocket socket) async {
  var messages = request.split(splitter);
  var command = messages[0];
  var data = messages[1];
  try{
    data+=splitter+messages[2];
  }
  catch(e){
    print("_handleRequest: no id");
  }
  bool isAlright;
  switch (command) {
    case addCommentCommand:
      {
        isAlright = await _dbService.addComment(data);
        print('_handleComment: commentAdded=$isAlright');

        break;
      }

    case deleteCommentCommand:
      {
        isAlright = await _dbService.deleteComment(data);
        print('_handleComment: commentDeleted=$isAlright');

        break;
      }
    case updateCommentCommand:
      {
        isAlright = await _dbService.updateComment(data);
        print('_handleComment: commentDeleted=$isAlright');

        break;
      }
    case likeCommentCommand:
      {
        isAlright = await _dbService.likeComment(data);
        print('_handleComment: commentDeleted=$isAlright');

        break;
      }
    case dislikeCommentCommand:
      {
        isAlright = await _dbService.dislikeComment(data);
        print('_handleComment: commentDeleted=$isAlright');

        break;
      }
  }
  if (isAlright) {
    _sendAllComments(socket);
  }
}

_sendAllComments(WebSocket socket) {
  var comments = _dbService.getComments();
//  comments.map((e) => e.toJson()
  socket.add(json.encode(comments));
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
