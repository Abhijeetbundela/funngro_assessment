part of 'projects_bloc.dart';

enum ProjectsStatus { initialLoading, initialError, ready }

enum FooterStatus { idle, loading, error, end }

final class ProjectsState extends Equatable {
  const ProjectsState({
    this.status = ProjectsStatus.initialLoading,
    this.items = const [],
    this.footer = FooterStatus.idle,
    this.nextPage = 0,
    this.isRefreshing = false,
    this.refreshFailed = false,
  });

  final ProjectsStatus status;
  final List<Project> items;
  final FooterStatus footer;
  final int nextPage;
  final bool isRefreshing;
  final bool refreshFailed;

  ProjectsState copyWith({
    ProjectsStatus? status,
    List<Project>? items,
    FooterStatus? footer,
    int? nextPage,
    bool? isRefreshing,
    bool? refreshFailed,
  }) {
    return ProjectsState(
      status: status ?? this.status,
      items: items ?? this.items,
      footer: footer ?? this.footer,
      nextPage: nextPage ?? this.nextPage,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      refreshFailed: refreshFailed ?? this.refreshFailed,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    footer,
    nextPage,
    isRefreshing,
    refreshFailed,
  ];
}
