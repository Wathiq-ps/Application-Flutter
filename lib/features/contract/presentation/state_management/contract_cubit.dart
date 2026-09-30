import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/api_exception.dart';
import '../../domain/entities/send_request_entity.dart';
import '../../domain/usecases/contract_usecase.dart';
import 'contract_state.dart';

class ContractCubit extends Cubit<ContractState> {
  final SendPropertyRequestUseCase sendPropertyRequestUseCase;

  ContractCubit({required this.sendPropertyRequestUseCase})
      : super(const ContractInitial());

  Future<bool> sendRequest({
    required String propertyId,
    String? message,
    String? termStart,
    String? termEnd,
  }) async {
    emit(const SendRequestLoading());
    try {
      final entity = SendRequestEntity(
        propertyId: propertyId,
        message: message,
        termStart: termStart,
        termEnd: termEnd,
      );
      await sendPropertyRequestUseCase(entity);
      emit(const SendRequestSuccess());
      return true;
    } on ApiException catch (e) {
      emit(SendRequestFailure(e.message));
      return false;
    } catch (e) {
      emit(SendRequestFailure(e.toString()));
      return false;
    }
  }

  void resetState() {
    emit(const ContractInitial());
  }
}
