// ignore_for_file: unnecessary_new

import 'package:kurtakip/models/exchange.dart';
import 'package:kurtakip/network/network_manager.dart';
import 'package:kurtakip/services/exchange.dart';
import 'package:rxdart/rxdart.dart';

class ExchangeController {
  final _tarihDate = new BehaviorSubject<TarihDate>();

  Stream<TarihDate> get tarihDate => _tarihDate.stream;
  
  final _service = new ExchangeServices();
  Future<void> getAllExchange() async {
    try {
      var response = await _service.getExchange();
      if (response != null) {
        _tarihDate.sink.add(response);
      } else {
        throw "Bilinmeyen bir hata oluştu.";
      }
    } catch (error) {
      _tarihDate.sink.addError(error.toString());
    }
  }
}
