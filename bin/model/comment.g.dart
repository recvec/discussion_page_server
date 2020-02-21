// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CommentAdapter extends TypeAdapter<Comment> {
  @override
  final typeId = 0;

  @override
  Comment read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Comment()
      ..text = fields[0] as String
      ..authorName = fields[1] as String
      ..state = fields[2] as int
      ..creationTime = fields[3] as String
      ..nestedComments = (fields[4] as HiveList)?.castHiveList();
  }

  @override
  void write(BinaryWriter writer, Comment obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.authorName)
      ..writeByte(2)
      ..write(obj.state)
      ..writeByte(3)
      ..write(obj.creationTime)
      ..writeByte(4)
      ..write(obj.nestedComments);
  }
}
