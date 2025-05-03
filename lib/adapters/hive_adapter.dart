// adapters/hive_adapters.dart
import 'package:hive/hive.dart';
import '../models/reading_plan.dart';
import '../models/user.dart';

// Reading Adapter
class ReadingAdapter extends TypeAdapter<Reading> {
  @override
  final int typeId = 0;

  @override
  Reading read(BinaryReader reader) {
    return Reading(
      reference: reader.readString(),
      isCompleted: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, Reading obj) {
    writer.writeString(obj.reference);
    writer.writeBool(obj.isCompleted);
  }
}

// Stream Adapter
class StreamAdapter extends TypeAdapter<Stream> {
  @override
  final int typeId = 1;

  @override
  Stream read(BinaryReader reader) {
    return Stream(
      name: reader.readString(),
      readings: (reader.readList() as List<dynamic>).cast<Reading>(),
    );
  }

  @override
  void write(BinaryWriter writer, Stream obj) {
    writer.writeString(obj.name);
    writer.writeList(obj.readings);
  }
}

// ReadingPlan Adapter
class ReadingPlanAdapter extends TypeAdapter<ReadingPlan> {
  @override
  final int typeId = 2;

  @override
  ReadingPlan read(BinaryReader reader) {
    return ReadingPlan(
      name: reader.readString(),
      streams: (reader.readList() as List<dynamic>).cast<Stream>(),
    );
  }

  @override
  void write(BinaryWriter writer, ReadingPlan obj) {
    writer.writeString(obj.name);
    writer.writeList(obj.streams);
  }
}

// UserReadingPlan Adapter
class UserReadingPlanAdapter extends TypeAdapter<UserReadingPlan> {
  @override
  final int typeId = 3;

  @override
  UserReadingPlan read(BinaryReader reader) {
    return UserReadingPlan(
      name: reader.readString(),
      streams: (reader.readList() as List<dynamic>).cast<Stream>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserReadingPlan obj) {
    writer.writeString(obj.name);
    writer.writeList(obj.streams);
  }
}

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 4;

  @override
  User read(BinaryReader reader) {
    return User(
      language: reader.readString(),
      readingPlan: reader.read() as UserReadingPlan?,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer.writeString(obj.language);
    writer.write(obj.readingPlan);
  }
}
