import 'package:ai_translator/route/api_first_version.dart';
import 'package:vania/vania.dart';
import 'package:ai_translator/route/web.dart';
import 'package:ai_translator/route/web_socket.dart';

class RouteServiceProvider extends ServiceProvider {
  @override
  Future<void> boot() async {}

  @override
  Future<void> register() async {
    WebRoute().register();
    ApiFirstVersion().register();
    WebSocketRoute().register();
  }
}
