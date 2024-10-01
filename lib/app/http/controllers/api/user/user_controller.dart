import 'package:ai_translator/app/http/controllers/api/user/user_repository.dart';
import 'package:ai_translator/app/http/controllers/api/user/user_repository_mongo.dart';
import 'package:vania/vania.dart';

class UserController extends Controller {
  final UserRepository _userRepository;

  UserController(UserRepository userRepository)
      : _userRepository = userRepository;

  Future<Response> getUserInfo() async {
    return await _userRepository.info();
  }
}

final UserController userController = UserController(UserRepositoryMongo());
