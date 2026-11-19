part of 'projects_bloc.dart';

sealed class ProjectsEvent extends Equatable {
  const ProjectsEvent();

  @override
  List<Object?> get props => const [];
}

final class ProjectsStarted extends ProjectsEvent {
  const ProjectsStarted();
}

final class ProjectsNextPageRequested extends ProjectsEvent {
  const ProjectsNextPageRequested({this.isRetry = false});
  final bool isRetry;

  @override
  List<Object?> get props => [isRetry];
}

final class ProjectsRefreshed extends ProjectsEvent {
  const ProjectsRefreshed([this.completer]);
  final Completer<void>? completer;

  @override
  List<Object?> get props => [completer];
}
