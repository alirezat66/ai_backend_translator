import 'package:ai_translator/database/mongo/mongo_connection.dart';
import 'package:vania/vania.dart';

class MongoDbServiceProvider extends ServiceProvider{

  @override
  Future<void> boot() async {}

  @override
  Future<void> register() async {
    MongoConnection().init();
  }
}
