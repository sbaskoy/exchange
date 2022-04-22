// ignore_for_file: unnecessary_this

import 'dart:developer';

import 'package:xml/xml.dart';

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:kurtakip/error/errors.dart';
import 'package:kurtakip/network/i_netwok.dart';

class NetworkManager {
  static NetworkManager? _instance;
  static NetworkManager get instance {
    _instance ??= NetworkManager._init();
    return _instance!;
  }

  NetworkManager._init();

  Duration timeout = const Duration(seconds: 10);
  final String baseUrl = "https://www.tcmb.gov.tr/kurlar";

  Map<String, String> _postOptionsWithToken(String token) {
    return <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer $token",
    };
  }

  Map<String, String> _postOptions() {
    return <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
  }

  Future<T?> httpGet<T, R extends INetworkModel>(String path, {required R model, String? token}) async {
    try {
      final response = await get(
        Uri.parse(baseUrl + path),
        headers: token == null ? this._postOptions() : this._postOptionsWithToken(token),
      ).timeout(this.timeout);
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody is List) {
          return responseBody.map((e) => model.fromJson(e) as R).toList() as T;
        } else if (responseBody is Map) {
          return model.fromJson(responseBody) as T;
        }
        throw "Body is not Map or List use httpGetString method";
      } else {
        this.throwError(response);
      }
    } on TimeoutException {
      throw "İstek zaman aşımına ugradı";
    } catch (e) {
      rethrow;
    }
  }

  Future<T?> httpGetWithXml<T, R extends INetworkModel>(String path, {required R model, String? token}) async {
    try {
      final response = await get(
        Uri.parse(baseUrl + path),
        headers: token == null ? this._postOptions() : this._postOptionsWithToken(token),
      ).timeout(this.timeout);
      if (response.statusCode == 200) {
        XmlDocument document = XmlDocument.parse(response.body);
        return model.fromXml(document);
      } else {
        this.throwError(response);
      }
    } on TimeoutException {
      throw "İstek zaman aşımına ugradı";
    } catch (e) {
      rethrow;
    }
    // buraya diger methodları eklemem lazım ama bu projede gerek olmadıgı için
    // sadece get methodu ekledim
  }

  void throwError(Response response) {
    ErrorModel error;
    try {
      error = ErrorModel.fromJson(jsonDecode(response.body));
    } catch (ex) {
      error = ErrorModel(code: response.statusCode, message: response.reasonPhrase);
    }
    // if ((error.message?.isEmpty ?? true)) {
    //   error.message = "Bilinmeyen bir hata oluştu. Daha sonra tekrar deneyiniz";
    // }
    error.code = response.statusCode;
    if (response.statusCode == 400) {
      throw BadRequestError(error: error);
    } else if (response.statusCode == 401) {
      throw AuthorizeError.to();
    } else if (response.statusCode == 404) {
      throw NotFoundError(error: error);
    } else {
      throw InternalServerError(error: error);
    }
  }
}
