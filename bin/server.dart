import 'dart:io';

import 'package:hive/hive.dart';

const _hostname = 'localhost';

void main(List<String> args) async {
  var server = await HttpServer.bind(_hostname, 8080);
  print('Serving at http://${server.address.host}:${server.port}');
  await Hive.init("./db");
  var box = await Hive.openBox('testBox');

//  box.put('name', 'David');

  await for (var request in server) {
    request.response
      ..headers.contentType = new ContentType("text", "plain", charset: "utf-8")
      ..write('Hello, world')
      ..close();
  }
}
