import '../entities/send_request_entity.dart';

abstract class ContractRepository {
  Future<void> sendPropertyRequest(SendRequestEntity entity);
}
