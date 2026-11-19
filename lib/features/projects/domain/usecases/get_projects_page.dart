import 'package:funngro_assessment/core/result/result.dart';
import 'package:funngro_assessment/features/projects/domain/entities/project.dart';
import 'package:funngro_assessment/features/projects/domain/repositories/projects_repository.dart';

class GetProjectsPage {
  const GetProjectsPage(this._repository);

  final ProjectsRepository _repository;

  Future<Result<List<Project>>> call(int page) => _repository.getProjects(page);
}
