import 'package:funngro_assessment/core/result/result.dart';
import 'package:funngro_assessment/features/projects/domain/entities/project.dart';

abstract interface class ProjectsRepository {
  Future<Result<List<Project>>> getProjects(int page);
}
