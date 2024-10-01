import 'package:mongo_dart/mongo_dart.dart';

class MongoConnection {
  static final MongoConnection _singleton = MongoConnection._internal();
  factory MongoConnection() => _singleton;
  MongoConnection._internal();
  late Db _db;
  void init() async {
    _db = await Db.create(
        "mongodb+srv://alirezataghizadeh66:ncwAl6yNPn6jKfdT@cluster0.mlsm9.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0");
    await _db.open();
  }

  Db get db => _db;
}
