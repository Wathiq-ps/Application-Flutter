import 'package:dio/dio.dart';
import '../../domain/entities/send_request_entity.dart';

class SendRequestModel extends SendRequestEntity {
  const SendRequestModel({
    required super.propertyId,
    super.message,
    super.termStart,
    super.termEnd,
  });

  factory SendRequestModel.fromEntity(SendRequestEntity entity) {
    return SendRequestModel(
      propertyId: entity.propertyId,
      message: entity.message,
      termStart: entity.termStart,
      termEnd: entity.termEnd,
    );
  }

  FormData toFormData() {
    final formData = FormData();

    if (message != null && message!.trim().isNotEmpty) {
      formData.fields.add(MapEntry('message', message!.trim()));
    }

    if (termStart != null && termStart!.trim().isNotEmpty) {
      formData.fields.add(MapEntry('term_start', termStart!.trim()));
    }

    if (termEnd != null && termEnd!.trim().isNotEmpty) {
      formData.fields.add(MapEntry('term_end', termEnd!.trim()));
    }

    return formData;
  }
}
