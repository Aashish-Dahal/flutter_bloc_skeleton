import '../../core/di/service_locator.dart';
import 'data/datasources/product_remote_datasource.dart';
import 'data/datasources/product_remote_datasource_impl.dart';
import 'data/repository/product_repository_impl.dart';
import 'domain/repository/product_repository.dart';
import 'domain/usecases/product_usecase.dart';
import 'presentation/state_management/get_all_products_bloc/product_pagination_bloc.dart';
import 'presentation/state_management/get_product_by_id_bloc/get_product_by_id_bloc.dart';

void initProduct() {
  // Data sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(sl()),
  );
  // Repositories
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl<ProductRemoteDataSource>()),
  );

  // Use cases
  sl.registerLazySingleton(
    () => ProductUsecase(repository: sl<ProductRepository>()),
  );

  // Blocs
  sl.registerFactory(
    () => ProductPaginationBloc(productUsecase: sl<ProductUsecase>()),
  );
  sl.registerFactory(
    () => GetProductByIdBloc(productUsecase: sl<ProductUsecase>()),
  );
}
