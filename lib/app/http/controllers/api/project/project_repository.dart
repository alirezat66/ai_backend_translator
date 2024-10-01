import 'package:ai_translator/app/http/controllers/api/project/translation_project.dart';
import 'package:mongo_dart/mongo_dart.dart';

abstract class ProjectRepository {
  Future<TranslationProject?> getProject(ObjectId id);
  Future<List<TranslationProject>> getProjects();
  Future<TranslationProject> createProject(TranslationProject project);
  Future<TranslationProject> updateProject(TranslationProject project);
  Future<void> deleteProject(ObjectId id);
}
