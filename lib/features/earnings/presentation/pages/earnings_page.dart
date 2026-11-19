import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:funngro_assessment/features/earnings/presentation/bloc/earnings_bloc.dart';
import 'package:funngro_assessment/injection_container.dart';
import 'package:material_ui/material_ui.dart';

import 'earning_detail_page.dart';

class EarningsPage extends StatelessWidget {
  const EarningsPage({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: ValueKey(userId),
      create: (_) =>
          sl<EarningsBloc>(param1: userId)..add(const EarningsStarted()),
      child: const _EarningsView(),
    );
  }
}

class _EarningsView extends StatelessWidget {
  const _EarningsView();

  Future<void> _onRefresh(BuildContext context) {
    final completer = Completer<void>();
    context.read<EarningsBloc>().add(EarningsRefreshed(completer));
    return completer.future;
  }

  void _open(BuildContext context, String earningId) {
    final isTopScreen = ModalRoute.of(context)?.isCurrent ?? false;
    if (!isTopScreen) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => EarningDetailPage(earningId: earningId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Earnings')),
      body: BlocListener<EarningsBloc, EarningsState>(
        listenWhen: (prev, curr) => !prev.refreshFailed && curr.refreshFailed,
        listener: (context, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Couldn't refresh. Showing saved data."),
            ),
          );
        },
        child: BlocBuilder<EarningsBloc, EarningsState>(
          builder: (context, state) {
            switch (state.status) {
              case EarningsStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case EarningsStatus.failure:
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(state.message ?? "Couldn't load your earnings."),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: () => context.read<EarningsBloc>().add(
                          const EarningsStarted(),
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              case EarningsStatus.ready:
                return RefreshIndicator(
                  onRefresh: () => _onRefresh(context),
                  child: state.items.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [
                            SizedBox(height: 160),
                            Center(child: Text('No earnings yet')),
                          ],
                        )
                      : ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: state.items.length,
                          itemBuilder: (context, i) {
                            final item = state.items[i];
                            return ListTile(
                              key: ValueKey(item.earning.id),
                              title: Text(item.earning.title),
                              subtitle: Text(item.amountLabel),
                              onTap: () => _open(context, item.earning.id),
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
