class ErrorModel {
  int? code;
  String? message;

  ErrorModel({this.code, this.message});
  ErrorModel.fromJson(json) {
    code = json["code"];
    message = json["message"];
  }
  fromJson(json) => ErrorModel.fromJson(json);

  @override
  String toString() {
    return "$code $message";
  }
}

class BadRequestError implements Exception {
  final ErrorModel? error;
  BadRequestError({this.error});
  @override
  String toString() {
    return error?.message ?? "Bad Request Error";
  }
}

class InternalServerError implements Exception {
  final ErrorModel? error;
  InternalServerError({this.error});
  static to() {
    return InternalServerError(
        error: ErrorModel(code: 500, message: "Servis kaynaklı bir hata oluştu. Daha sonra tekrar deneyiniz"));
  }

  @override
  String toString() {
    return error?.message ?? "Internal Server Error";
  }
}

class NotFoundError implements Exception {
  final ErrorModel? error;
  NotFoundError({this.error});
  static to() {
    return NotFoundError(error: ErrorModel(code: 404, message: "Aradıgınız şeyi bulamadık."));
  }

  @override
  String toString() {
    return error?.message ?? "Not Found Error";
  }
}

class AuthorizeError implements Exception {
  final ErrorModel? error;
  AuthorizeError({this.error});
  static to() {
    return AuthorizeError(error: ErrorModel(code: 401, message: "Oturumunuz süresi dolmuş. Tekrar giriş yapınız"));
  }

  @override
  String toString() {
    return error?.message ?? "UnAuthorize Error";
  }
}
