import 'package:dio/dio.dart';
import 'package:advanced_course/core/networking/api_error_model.dart';
import 'api_constants.dart';

/// Enum representing various API error states
enum DataSource {
  noContent,
  badRequest,
  forbidden,
  unauthorized,
  notFound,
  internalServerError,
  connectTimeout,
  cancel,
  receiveTimeout,
  sendTimeout,
  cacheError,
  noInternetConnection,
  defaultError,
}

/// API Response Codes
class ResponseCode {
  static const int success = 200;
  static const int noContent = 201;
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int internalServerError = 500;
  static const int apiLogicError = 422;

  // Local status codes
  static const int connectTimeout = -1;
  static const int cancel = -2;
  static const int receiveTimeout = -3;
  static const int sendTimeout = -4;
  static const int cacheError = -5;
  static const int noInternetConnection = -6;
  static const int defaultError = -7;
}

/// API Response Messages
class ResponseMessage {
  static const String noContent = ApiErrors.noContent;
  static const String badRequest = ApiErrors.badRequestError;
  static const String unauthorized = ApiErrors.unauthorizedError;
  static const String forbidden = ApiErrors.forbiddenError;
  static const String notFound = ApiErrors.notFoundError;
  static const String internalServerError = ApiErrors.internalServerError;

  // Local error messages
  static const String connectTimeout = ApiErrors.timeoutError;
  static const String cancel = ApiErrors.defaultError;
  static const String receiveTimeout = ApiErrors.timeoutError;
  static const String sendTimeout = ApiErrors.timeoutError;
  static const String cacheError = ApiErrors.cacheError;
  static const String noInternetConnection = ApiErrors.noInternetError;
  static const String defaultError = ApiErrors.defaultError;
}

/// Extension to map DataSource to ApiErrorModel
extension DataSourceExtension on DataSource {
  ApiErrorModel get errorModel {
    return ApiErrorModel(
      code: _errorCodeMap[this] ?? ResponseCode.defaultError,
      message: _errorMessageMap[this] ?? ResponseMessage.defaultError,
    );
  }
}

/// Mapping of DataSource to Response Codes
const Map<DataSource, int> _errorCodeMap = {
  DataSource.noContent: ResponseCode.noContent,
  DataSource.badRequest: ResponseCode.badRequest,
  DataSource.unauthorized: ResponseCode.unauthorized,
  DataSource.forbidden: ResponseCode.forbidden,
  DataSource.notFound: ResponseCode.notFound,
  DataSource.internalServerError: ResponseCode.internalServerError,
  DataSource.connectTimeout: ResponseCode.connectTimeout,
  DataSource.cancel: ResponseCode.cancel,
  DataSource.receiveTimeout: ResponseCode.receiveTimeout,
  DataSource.sendTimeout: ResponseCode.sendTimeout,
  DataSource.cacheError: ResponseCode.cacheError,
  DataSource.noInternetConnection: ResponseCode.noInternetConnection,
  DataSource.defaultError: ResponseCode.defaultError,
};

/// Mapping of DataSource to Response Messages
const Map<DataSource, String> _errorMessageMap = {
  DataSource.noContent: ResponseMessage.noContent,
  DataSource.badRequest: ResponseMessage.badRequest,
  DataSource.unauthorized: ResponseMessage.unauthorized,
  DataSource.forbidden: ResponseMessage.forbidden,
  DataSource.notFound: ResponseMessage.notFound,
  DataSource.internalServerError: ResponseMessage.internalServerError,
  DataSource.connectTimeout: ResponseMessage.connectTimeout,
  DataSource.cancel: ResponseMessage.cancel,
  DataSource.receiveTimeout: ResponseMessage.receiveTimeout,
  DataSource.sendTimeout: ResponseMessage.sendTimeout,
  DataSource.cacheError: ResponseMessage.cacheError,
  DataSource.noInternetConnection: ResponseMessage.noInternetConnection,
  DataSource.defaultError: ResponseMessage.defaultError,
};

/// Error Handler for API responses
class ErrorHandler implements Exception {
  late final ApiErrorModel apiError;

  ErrorHandler.handle(dynamic error) {
    apiError = error is DioException ? _mapDioError(error) : DataSource.defaultError.errorModel;
  }
}

/// Maps DioException to ApiErrorModel
ApiErrorModel _mapDioError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      return DataSource.connectTimeout.errorModel;
    case DioExceptionType.sendTimeout:
      return DataSource.sendTimeout.errorModel;
    case DioExceptionType.receiveTimeout:
      return DataSource.receiveTimeout.errorModel;
    case DioExceptionType.badResponse:
      return error.response?.data != null ? ApiErrorModel.fromJson(error.response!.data) : DataSource.defaultError.errorModel;
    case DioExceptionType.cancel:
      return DataSource.cancel.errorModel;
    case DioExceptionType.unknown:
    case DioExceptionType.connectionError:
    case DioExceptionType.badCertificate:
      return DataSource.defaultError.errorModel;
  }
}
