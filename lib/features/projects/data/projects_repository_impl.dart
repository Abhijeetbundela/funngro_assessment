import 'package:funngro_assessment/core/error/guard_call.dart';
import 'package:funngro_assessment/core/result/result.dart';
import 'package:funngro_assessment/features/projects/domain/entities/project.dart';
import 'package:funngro_assessment/features/projects/domain/repositories/projects_repository.dart';

import 'projects_api.dart';

class ProjectsRepositoryImpl implements ProjectsRepository {
  const ProjectsRepositoryImpl(this._api);

  final ProjectsApi _api;

  @override
  Future<Result<List<Project>>> getProjects(int page) =>
      guardCall(() => _api.fetchProjects(page));
}
