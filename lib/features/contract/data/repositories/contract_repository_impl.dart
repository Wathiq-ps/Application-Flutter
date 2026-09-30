import '../../domain/entities/send_request_entity.dart';
import '../../domain/repository/contract_repository.dart';
import '../data_sources/contract_remote_data_source.dart';
import '../models/send_request_model.dart';

class ContractRepositoryImpl implements ContractRepository {
  final ContractRemoteDataSource remoteDataSource;

  ContractRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> sendPropertyRequest(SendRequestEntity entity) {
    final model = SendRequestModel.fromEntity(entity);
    return remoteDataSource.sendPropertyRequest(model);
  }
}
