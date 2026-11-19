import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'core/formatting/currency_formatter.dart';
import 'core/network/dio_client.dart';
import 'features/earnings/data/datasource/earnings_remote_data_source.dart';
import 'features/earnings/data/datasource/fake_earnings_data_sources.dart';
import 'features/earnings/data/datasource/wallet_updates_data_source.dart';
import 'features/earnings/data/earnings_repository_impl.dart';
import 'features/earnings/domain/repositories/earnings_repository.dart';
import 'features/earnings/domain/usecases/earnings_usecases.dart';
import 'features/earnings/presentation/bloc/earnings_bloc.dart';
import 'features/earnings/presentation/cubit/earning_detail_cubit.dart';
import 'features/projects/data/projects_api.dart';
import 'features/projects/data/projects_repository_impl.dart';
import 'features/projects/domain/repositories/projects_repository.dart';
import 'features/projects/domain/usecases/get_projects_page.dart';
import 'features/projects/presentation/bloc/projects_bloc.dart';

final GetIt sl = GetIt.instance;

const bool useFakeBackend = true;

void configureDependencies() {
  // ---- core -------------------------------------------------------------
  sl.registerLazySingleton<Dio>(() => createDio(baseUrl: 'https://api.example.com'));
  sl.registerLazySingleton<CurrencyFormatter>(CurrencyFormatter.new);

  // ---- projects ------------------------------------------------
  sl.registerLazySingleton<ProjectsApi>(ProjectsApi.new);
  sl.registerLazySingleton<ProjectsRepository>(() => ProjectsRepositoryImpl(sl()));
  sl.registerLazySingleton<GetProjectsPage>(() => GetProjectsPage(sl()));
  sl.registerFactory<ProjectsBloc>(() => ProjectsBloc(sl()));

  // ---- earnings ---------------------------------------
  sl.registerLazySingleton<EarningsRemoteDataSource>(
    () => useFakeBackend ? FakeEarningsRemoteDataSource() : DioEarningsRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<WalletUpdatesDataSource>(FakeWalletUpdatesDataSource.new);
  sl.registerLazySingleton<EarningsRepository>(() => EarningsRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<GetEarnings>(() => GetEarnings(sl()));
  sl.registerLazySingleton<WatchWalletUpdates>(() => WatchWalletUpdates(sl()));
  sl.registerLazySingleton<GetEarningDetail>(() => GetEarningDetail(sl()));
  sl.registerFactoryParam<EarningsBloc, String, void>(
    (userId, _) => EarningsBloc(
      userId: userId,
      getEarnings: sl(),
      watchWalletUpdates: sl(),
      formatter: sl(),
    ),
  );
  sl.registerFactory<EarningDetailCubit>(() => EarningDetailCubit(sl()));
}
