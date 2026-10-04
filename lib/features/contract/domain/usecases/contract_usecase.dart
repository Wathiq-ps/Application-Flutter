import '../entities/send_request_entity.dart';
import '../repository/contract_repository.dart';

class SendPropertyRequestUseCase {
  final ContractRepository repository;

  const SendPropertyRequestUseCase(this.repository);

  Future<void> call(SendRequestEntity request) {
    return repository.sendPropertyRequest(request);
  }
}
