import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:funngro_assessment/core/result/result.dart';
import 'package:funngro_assessment/features/projects/domain/entities/project.dart';
import 'package:funngro_assessment/features/projects/domain/projects_constants.dart';
import 'package:funngro_assessment/features/projects/domain/usecases/get_projects_page.dart';

part 'projects_event.dart';

part 'projects_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  ProjectsBloc(this._getProjectsPage) : super(const ProjectsState()) {
    on<ProjectsStarted>(_onStarted, transformer: droppable());
    on<ProjectsNextPageRequested>(
      _onNextPageRequested,
      transformer: droppable(),
    );
    on<ProjectsRefreshed>(_onRefreshed, transformer: droppable());
  }

  final GetProjectsPage _getProjectsPage;

  int _epoch = 0;

  static FooterStatus _footerFor(List<Project> page) =>
      page.length < kProjectsPageSize ? FooterStatus.end : FooterStatus.idle;

  Future<void> _onStarted(
    ProjectsStarted event,
    Emitter<ProjectsState> emit,
  ) async {
    final epoch = ++_epoch;
    emit(const ProjectsState());
    final result = await _getProjectsPage(0);
    if (epoch != _epoch || emit.isDone) return;
    switch (result) {
      case Success(:final value):
        emit(
          ProjectsState(
            status: ProjectsStatus.ready,
            items: value,
            footer: _footerFor(value),
            nextPage: 1,
          ),
        );
      case Err():
        emit(const ProjectsState(status: ProjectsStatus.initialError));
    }
  }

  Future<void> _onNextPageRequested(
    ProjectsNextPageRequested event,
    Emitter<ProjectsState> emit,
  ) async {
    final s = state;
    final allowed =
        s.status == ProjectsStatus.ready &&
        !s.isRefreshing &&
        (event.isRetry
            ? s.footer == FooterStatus.error
            : s.footer == FooterStatus.idle);
    if (!allowed) return;

    final epoch = _epoch;
    final page = s.nextPage;
    emit(s.copyWith(footer: FooterStatus.loading));

    final result = await _getProjectsPage(page);
    if (epoch != _epoch || emit.isDone) return;

    switch (result) {
      case Success(:final value):
        emit(
          state.copyWith(
            items: [...state.items, ...value],
            nextPage: page + 1,
            footer: _footerFor(value),
          ),
        );
      case Err():
        emit(state.copyWith(footer: FooterStatus.error));
    }
  }

  Future<void> _onRefreshed(
    ProjectsRefreshed event,
    Emitter<ProjectsState> emit,
  ) async {
    try {
      if (state.status != ProjectsStatus.ready) return;
      final epoch = ++_epoch;
      emit(state.copyWith(isRefreshing: true, refreshFailed: false));

      final result = await _getProjectsPage(0);
      if (epoch != _epoch || emit.isDone) return;

      switch (result) {
        case Success(:final value):
          emit(
            ProjectsState(
              status: ProjectsStatus.ready,
              items: value,
              footer: _footerFor(value),
              nextPage: 1,
            ),
          );
        case Err():
          emit(
            state.copyWith(
              isRefreshing: false,
              refreshFailed: true,
              footer: state.footer == FooterStatus.loading
                  ? FooterStatus.error
                  : state.footer,
            ),
          );
      }
    } finally {
      event.completer?.complete();
    }
  }
}
