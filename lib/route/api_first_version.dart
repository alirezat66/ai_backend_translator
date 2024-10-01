import 'package:ai_translator/app/http/controllers/api/auth/auth_controller.dart';
import 'package:ai_translator/app/http/controllers/api/project/project_controller.dart';
import 'package:ai_translator/app/http/controllers/api/translate/translate_controller.dart';
import 'package:ai_translator/app/http/controllers/api/user/user_controller.dart';
import 'package:ai_translator/app/http/middleware/authenticate.dart';
import 'package:vania/vania.dart';

class ApiFirstVersion extends Route {
  @override
  void register() {
    /// Base RoutePrefix
    Router.basePrefix('api/v1');
    Router.group(() {
      Router.post('login', authController.login);
      Router.post('sign-up', authController.signUp);
      Router.post('verify-otp', authController.verifyOtp);
      Router.post('request-otp', authController.otp);
      Router.post('refresh-token', authController.refreshToken);
    }, prefix: 'auth');
    Router.group(
      () {
        Router.get('info', userController.getUserInfo);
      },
      prefix: 'user',
      middleware: [AuthenticateMiddleware()],
    );
    Router.group(
      () {
        Router.post('create', projectController.create);
        Router.get('/{id}', (String id) => projectController.show(id));
      },
      prefix: 'projects',
      middleware: [AuthenticateMiddleware()],
    );
    Router.group(
      () {
        Router.post('create', translateController.translate);
      },
      prefix: 'translation',
      middleware: [AuthenticateMiddleware()],
    );
  }
}
