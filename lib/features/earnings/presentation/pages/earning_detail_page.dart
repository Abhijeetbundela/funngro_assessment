import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:funngro_assessment/features/earnings/presentation/cubit/earning_detail_cubit.dart';
import 'package:funngro_assessment/injection_container.dart';
import 'package:material_ui/material_ui.dart';

class EarningDetailPage extends StatelessWidget {
  const EarningDetailPage({super.key, required this.earningId});

  final String earningId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<EarningDetailCubit>()..load(earningId),
      child: Scaffold(
        appBar: AppBar(title: const Text('Earning detail')),
        body: BlocBuilder<EarningDetailCubit, EarningDetailState>(
          builder: (context, state) {
            switch (state.status) {
              case DetailStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case DetailStatus.failed:
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(state.message ?? "Couldn't load details."),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: () =>
                            context.read<EarningDetailCubit>().load(earningId),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              case DetailStatus.loaded:
                final d = state.detail!;
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ID: ${d.id}'),
                      const SizedBox(height: 8),
                      Text('Status: ${d.status}'),
                      const SizedBox(height: 8),
                      Text(d.description),
                    ],
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
