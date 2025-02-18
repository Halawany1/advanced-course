import 'package:advanced_course/core/networking/api_service.dart';
import 'package:advanced_course/core/networking/dio_factory.dart';
import 'package:advanced_course/features/login/data/repos/login_repo.dart';
import 'package:advanced_course/features/login/logic/cubit/login_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void _registerModule<Repo extends Object, Cubit extends Object>(
    Repo Function(ApiService apiService) repoConstructor,
    Cubit Function(Repo repo) cubitConstructor) {
  if (!getIt.isRegistered<Repo>()) {
    getIt.registerLazySingleton<Repo>(
        () => repoConstructor(getIt<ApiService>()));
  }

  if (!getIt.isRegistered<Cubit>()) {
    getIt.registerFactory<Cubit>(() => cubitConstructor(getIt<Repo>()));
  }
}

// void _registerCubitWithMultipleDeps<Cubit extends Object>(
//     Cubit Function() cubitConstructor) {
//   if (!getIt.isRegistered<Cubit>()) {
//     getIt.registerFactory<Cubit>(() => cubitConstructor());
//   }
// }

Future<void> setupGetIt() async {
  Dio dio = DioFactory.getDio();
  getIt.registerLazySingleton<ApiService>(() => ApiService(dio));

  _registerModule(
    (apiService) => LoginRepo(apiService),
    (repo) => LoginCubit(repo),
  );
}
