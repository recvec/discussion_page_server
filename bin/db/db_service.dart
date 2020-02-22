import 'dart:convert';
import 'dart:math';

import 'package:hive/hive.dart';

import '../model/comment.dart';
import '../server.dart';

class DBService {
  Box _commentsBox;

  Future initDB() async {
    await Hive.init("./comments");
    Hive.registerAdapter(CommentAdapter());
    _commentsBox = await Hive.openBox<Comment>('comments');
  }

  Future generateRandomComment() async {
    await _commentsBox.add(Comment(
      id: Random().nextInt(53333).toString(),
      authorName: Random().nextBool().toString(),
      creationTime: Random().nextInt(99999).toString(),
      text: "Loreum lorum lorium ${Random().nextInt(555)}",
    ));
    print("Comment is generated");
  }

  List<Comment> getComments() {
    return _commentsBox.values.toList();
  }

  Future<bool> addComment(String message) async {
    try {
      var id;

      var result = json.decode(message.split(splitter)[0]);

      try {
        id = message.split(splitter)[1];
      } catch (e) {
        print("addComment: comment is not nested");
      }

      Comment comment = Comment.fromJson(result);
      comment.nestedComments = HiveList(_commentsBox);

      await _commentsBox.put(comment.id, comment);
      await comment.save();

      if (id != null) {
        Comment parentComment = _commentsBox.get(id);
        await parentComment.nestedComments.add(comment);
        await parentComment.save();
      }

      return true;
    } catch (e) {
      print("addComment: error $e");
      return false;
    }
  }

  Future<bool> deleteComment(String id) async {
    try {
      Comment comment = _commentsBox.get(id);
      await deleteRecursively(comment);

      await comment.delete();

      return true;
    } catch (e) {
      print("deleteComment: error $e");
      return false;
    }
  }
 Future deleteRecursively(Comment comment) async {
    for(var nestedComment in comment.nestedComments){
      if(nestedComment.nestedComments.length!=null){
       await  deleteRecursively(nestedComment);
       await nestedComment.nestedComments.deleteAllFromHive();
       await nestedComment.delete();
      }

    }

 }
  Future<bool> likeComment(String id) async {
    try {
      Comment comment = _commentsBox.get(id);
      comment.state++;
      await comment.save();

      return true;
    } catch (e) {
      print("likeComment: error $e");
      return false;
    }
  }

  Future<bool> dislikeComment(String id) async {
    try {
      Comment comment = _commentsBox.get(id);
      comment.state--;
      await comment.save();

      return true;
    } catch (e) {
      print("dislikeComment: error $e");
      return false;
    }
  }

  Future<bool> updateComment(String data) async {
    try {
      var messages = data.split(splitter);
      var id = messages[0];
      var newText = messages[1];
      Comment comment = _commentsBox.get(id);
      comment.text = newText;
      await comment.save();

      return true;
    } catch (e) {
      print("updateComment: error $e");
      return false;
    }
  }
}
