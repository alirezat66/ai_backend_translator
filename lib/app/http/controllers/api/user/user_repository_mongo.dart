import 'package:ai_translator/app/http/controllers/api/user/user_repository.dart';
import 'package:ai_translator/database/mongo/mongo_connection.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:vania/vania.dart';

class UserRepositoryMongo implements UserRepository {
  @override
  Future<Response> info() async {
    final id = Auth().id();
    print(id is String);
    final user = await MongoConnection()
        .db
        .collection('users')
        .findOne(where.id(ObjectId.parse(id)));
    print(user);
    return Response.json(user, 200);
  }
}
