import 'dart:math';

import 'package:hive/hive.dart';

import 'model/comment.dart';

class DBService {
  Box _commentsBox;

  Future initDB() async {
    await Hive.init("./commnets");
    Hive.registerAdapter(CommentAdapter());
    _commentsBox = await Hive.openBox('comments');
  }

  Future generateRandomComment() async {

    await _commentsBox.add(Comment(id: Random().nextInt(53333).toString(),
      authorName: Random().nextBool().toString(),
      creationTime: Random().nextInt(99999).toString(),
      text: "Loreum lorum lorium ${Random().nextInt(555)}",
    ));
    print("Comment is generated");
  }

  List<Comment> getComments()  {

    return  _commentsBox.values;
  }

  Future<bool> addComment(result) async {
    try{
      Comment comment = Comment.fromJson(result);
      await _commentsBox.add(comment);
      await comment.save();
      return true;
    }
    catch(e){
      print("addComment: error $e");
      return false;
    }

  }
}
