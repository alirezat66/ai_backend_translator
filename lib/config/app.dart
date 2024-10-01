import 'package:ai_translator/app/providers/mongo_db_service_provider.dart';
import 'package:vania/vania.dart';
import 'package:ai_translator/app/providers/route_service_povider.dart';

import 'auth.dart';
import 'cors.dart';

Map<String, dynamic> config = {
  'name': env('APP_NAME'),
  'url': env('APP_URL'),
  'cors': cors,
  'auth': authConfig,
  'providers': <ServiceProvider>[
    RouteServiceProvider(),
    MongoDbServiceProvider(),
  ],
};
