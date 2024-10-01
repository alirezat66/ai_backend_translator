import 'package:ai_translator/app/http/controllers/api/project/project_repository.dart';
import 'package:ai_translator/app/http/controllers/api/project/translation_project.dart';
import 'package:ai_translator/database/mongo/mongo_connection.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:uuid/uuid.dart';
import 'package:vania/vania.dart';

class ProjectRepositoryMongoImpl implements ProjectRepository {
  final MongoConnection _mongoConnection;
  final Auth _auth;
  ProjectRepositoryMongoImpl(
      {required MongoConnection mongoConnection, required Auth auth})
      : _mongoConnection = mongoConnection,
        _auth = auth;
  @override
  Future<TranslationProject> createProject(TranslationProject project) async {
    project.userId = ObjectId.parse(_auth.id());
    project.setProjectApiToken = Uuid().v4();
    
    print(project.toJson());
    final response = await _mongoConnection.db
        .collection('projects')
        .insertOne(project.toJson());
    print(response);
    final projectResponse = await _mongoConnection.db
        .collection('projects')
        .findOne(where.id(response.id));
    return TranslationProject.fromJson(projectResponse!);
  }

  @override
  Future<void> deleteProject(ObjectId id) async {
    await _mongoConnection.db.collection('projects').remove(where.id(id));
  }

  @override
  Future<TranslationProject?> getProject(ObjectId id) async {
    final userId = _auth.id();
    final response = await _mongoConnection.db
        .collection('projects')
        .findOne(where.id(id).eq('user_id', ObjectId.parse(userId)));
    print(response);

    return response == null ? null : TranslationProject.fromJson(response);
  }

  @override
  Future<List<TranslationProject>> getProjects() async {
    final response = _mongoConnection.db.collection('projects').find();
    print(response);
    return response.map((e) => TranslationProject.fromJson(e)).toList();
  }

  @override
  Future<TranslationProject> updateProject(TranslationProject project) async {
    final response = await _mongoConnection.db
        .collection('projects')
        .update(where.id(project.id!), project.toJson());
    print(response);
    return TranslationProject.fromJson(response);
  }
}
