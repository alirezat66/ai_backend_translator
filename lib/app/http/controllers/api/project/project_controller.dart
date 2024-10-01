import 'package:ai_translator/app/http/controllers/api/project/project_repository.dart';
import 'package:ai_translator/app/http/controllers/api/project/project_repository_mongo_impl.dart';
import 'package:ai_translator/app/http/controllers/api/project/translation_project.dart';
import 'package:ai_translator/database/mongo/mongo_connection.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:vania/vania.dart';

class ProjectController extends Controller {
  final ProjectRepository _projectRepository;

  ProjectController(ProjectRepository projectRepository)
      : _projectRepository = projectRepository;
  Future<Response> index() async {
    return Response.json({'message': 'Hello World'});
  }

  Future<Response> create(Request request) async {
    request.validate({
      'project_name': 'required|max_length:20|min_length:2',
      'description': 'max_length:200',
    }, {
      'project_name.required': 'The project name is required',
      'project_name.max_length':
          'The first name must be less than 20 characters',
      'project_name.min_length': 'The first name must be at least 2 characters',
      'description.max_length':
          'The description must be less than 200 characters',
    });
    try {
      final project = TranslationProject(
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          projectName: request.input('project_name'),
          description: request.input('description'));
      final resultProject = await _projectRepository.createProject(project);
      return Response(data: resultProject.toJson(), httpStatusCode: 200);
    } catch (e) {
      return Response.json({'message': e.toString()}, 400);
    }
  }

  Future<Response> store(Request request) async {
    return Response.json({});
  }

  Future<Response> show(String id) async {
    print(id.toString());
    final project =
        await _projectRepository.getProject(ObjectId.parse(id.toString()));
    return project == null
        ? Response.json({'message': 'Project not found'}, 404)
        : Response.json(project.toJson());
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, int id) async {
    return Response.json({});
  }

  Future<Response> destroy(int id) async {
    return Response.json({});
  }
}

final ProjectController projectController = ProjectController(
    ProjectRepositoryMongoImpl(
        mongoConnection: MongoConnection(), auth: Auth()));
