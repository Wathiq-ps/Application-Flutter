import 'package:mobile/core/cache/data_result.dart';
import '../entities/home_data_entity.dart';

abstract class HomeRepository {
  Stream<DataResult<HomeDataEntity>> watchHome();
}