import 'package:vania/vania.dart';

abstract class UserRepository {
  Future<Response> info();
}
