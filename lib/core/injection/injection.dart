import 'package:get_it/get_it.dart';
import 'package:malina/features/auth/blocs/auth_bloc.dart';
import 'package:malina/features/auth/presentation/auth_repository.dart';
import 'package:malina/features/cart/blocs/cart_bloc.dart';
import 'package:malina/features/cart/data/cart_repository.dart';
import 'package:malina/screens/favorites/blocs/favorites_bloc.dart';
import 'package:malina/screens/favorites/data/favorites_repository.dart';
import 'package:malina/screens/favorites/data/favorites_repository_impl.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../features/cart/data/cart_repository_impl.dart';

final locator = GetIt.instance;

Future<void> setupDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  locator.registerLazySingleton<SharedPreferences>(() => prefs);

  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepository(locator()),
  );
  locator.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(locator()),
  );
  locator.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(locator()),
  );

  locator.registerLazySingleton<AuthBloc>(() => AuthBloc(locator()));

  locator.registerFactory<CartBloc>(
    () => CartBloc(locator(), locator<AuthBloc>()),
  );

  locator.registerFactory<FavoritesBloc>(
    () => FavoritesBloc(repository: locator()),
  );
}
