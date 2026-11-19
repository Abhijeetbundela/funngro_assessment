import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:funngro_assessment/features/projects/presentation/bloc/projects_bloc.dart';
import 'package:funngro_assessment/injection_container.dart';
import 'package:material_ui/material_ui.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProjectsBloc>()..add(const ProjectsStarted()),
      child: const _ProjectsView(),
    );
  }
}

class _ProjectsView extends StatefulWidget {
  const _ProjectsView();

  @override
  State<_ProjectsView> createState() => _ProjectsViewState();
}

class _ProjectsViewState extends State<_ProjectsView> {
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  void _onScroll() {
    final bloc = context.read<ProjectsBloc>();
    if (_scroll.position.extentAfter < 400 &&
        bloc.state.footer == FooterStatus.idle) {
      bloc.add(const ProjectsNextPageRequested());
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() {
    final completer = Completer<void>();
    context.read<ProjectsBloc>().add(ProjectsRefreshed(completer));
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Projects')),
      body: BlocListener<ProjectsBloc, ProjectsState>(
        listenWhen: (prev, curr) => !prev.refreshFailed && curr.refreshFailed,
        listener: (context, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Couldn't refresh. Showing previous list."),
            ),
          );
        },
        child: BlocBuilder<ProjectsBloc, ProjectsState>(
          builder: (context, state) {
            switch (state.status) {
              case ProjectsStatus.initialLoading:
                return const Center(child: CircularProgressIndicator());
              case ProjectsStatus.initialError:
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Couldn't load projects."),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: () => context.read<ProjectsBloc>().add(
                          const ProjectsStarted(),
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              case ProjectsStatus.ready:
                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: state.items.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [
                            SizedBox(height: 160),
                            Center(child: Text('No projects')),
                          ],
                        )
                      : ListView.builder(
                          controller: _scroll,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: state.items.length + 1,
                          itemBuilder: (context, i) {
                            if (i == state.items.length) {
                              return _Footer(status: state.footer);
                            }
                            final p = state.items[i];
                            return ListTile(
                              key: ValueKey(p.id),
                              title: Text(p.title),
                              subtitle: Text(p.company),
                              trailing: Text('₹${p.payout}'),
                            );
                          },
                        ),
                );
            }
          },
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.status});

  final FooterStatus status;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case FooterStatus.idle:
        return const SizedBox(height: 56);
      case FooterStatus.loading:
        return const Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        );
      case FooterStatus.error:
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Couldn't load more."),
              TextButton(
                onPressed: () => context.read<ProjectsBloc>().add(
                  const ProjectsNextPageRequested(isRetry: true),
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      case FooterStatus.end:
        return const Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: Text("You've reached the end")),
        );
    }
  }
}
