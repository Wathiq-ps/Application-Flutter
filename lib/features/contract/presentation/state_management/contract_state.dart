import 'package:equatable/equatable.dart';

sealed class ContractState extends Equatable {
  const ContractState();

  @override
  List<Object?> get props => [];
}

class ContractInitial extends ContractState {
  const ContractInitial();
}

class SendRequestLoading extends ContractState {
  const SendRequestLoading();
}

class SendRequestSuccess extends ContractState {
  final String message;

  const SendRequestSuccess({this.message = 'Request sent successfully'});

  @override
  List<Object?> get props => [message];
}

class SendRequestFailure extends ContractState {
  final String errorMessage;

  const SendRequestFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
