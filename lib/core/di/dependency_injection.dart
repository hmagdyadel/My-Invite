import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/home/data/repo/home_repo.dart';
import '../../features/home/logic/home_cubit.dart';
import '../../features/location/data/repo/location_repo.dart';
import '../../features/location/logic/location_cubit.dart';
import '../../features/login/data/repo/login_repo.dart';
import '../../features/login/logic/login_cubit.dart';
import '../../features/qr_code_scanner/data/repo/qr_code_scanner_repo.dart';
import '../../features/qr_code_scanner/logic/qr_code_scanner_cubit.dart';
import '../../features/register/data/repo/register_repo.dart';
import '../../features/register/logic/register_cubit.dart';
import '../../features/scan_history/data/repo/gatekeeper_events_repo.dart';
import '../../features/scan_history/logic/gatekeeper_events_cubit.dart';
import '../networking/api_service.dart';
import '../networking/dio_factory.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // Dio & ApiService
  Dio dio = await DioFactory.getDio();
  getIt.registerLazySingleton<ApiService>(() => ApiService(dio));

  //login
  getIt.registerLazySingleton<LoginRepo>(() => LoginRepo(getIt()));
  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt()));
  //register
  getIt.registerLazySingleton<RegisterRepo>(() => RegisterRepo(getIt()));
  getIt.registerFactory<RegisterCubit>(() => RegisterCubit(getIt()));
  //location
  getIt.registerLazySingleton<LocationRepo>(() => LocationRepo(getIt()));
  getIt.registerFactory<LocationCubit>(() => LocationCubit(getIt()));
  //profile
  getIt.registerLazySingleton<HomeRepo>(() => HomeRepo(getIt()));
  getIt.registerFactory<HomeCubit>(() => HomeCubit(getIt()));

  //Scan QR code
  getIt.registerLazySingleton<QrCodeScannerRepo>(() => QrCodeScannerRepo(getIt()));
  getIt.registerFactory<QrCodeScannerCubit>(() => QrCodeScannerCubit(getIt()));

  //Scan History
  getIt.registerLazySingleton<GatekeeperEventsRepo>(() => GatekeeperEventsRepo(getIt()));
  getIt.registerFactory<GatekeeperEventsCubit>(() => GatekeeperEventsCubit(getIt()));
}
