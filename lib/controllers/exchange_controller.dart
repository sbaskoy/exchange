// ignore_for_file: unnecessary_new

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kurtakip/models/exchange.dart';
import 'package:kurtakip/services/exchange.dart';
import 'package:kurtakip/widgets/forms/drop_down.dart';
import 'package:rxdart/rxdart.dart';

class ExchangeController {
  final _tarihDateFiltered = new BehaviorSubject<TarihDate>();
  final _allCurrency = new BehaviorSubject<List<Currency>>();

  final _from = new BehaviorSubject<CustomDropDownItem>();
  final _to = new BehaviorSubject<CustomDropDownItem>();

  Function(CustomDropDownItem) get changeFrom => _from.sink.add;
  Function(CustomDropDownItem) get changeTo => _to.sink.add;

  Stream<TarihDate> get tarihDate => _tarihDateFiltered.stream;
  List<Currency> get getAllCurrency => _allCurrency.value;

  final _service = new ExchangeServices();
  Future<void> getAllExchange() async {
    try {
      var response = await _service.getExchange();
      if (response != null) {
        _allCurrency.sink.add(response.currency ?? []);
        _tarihDateFiltered.sink.add(response);
      } else {
        throw "Bilinmeyen bir hata oluştu.";
      }
    } catch (error) {
      _tarihDateFiltered.sink.addError(error.toString());
    }
  }

  void filter(String searchText) {
    var filteredValue = _tarihDateFiltered.value;
    if (searchText.isEmpty) {
      filteredValue.currency = _allCurrency.value;
      _tarihDateFiltered.sink.add(filteredValue);
      return;
    }
    List<Currency> currency = [];
    currency.addAll(_allCurrency.value);
    var filtered = currency.where((element) => element.kod!.toLowerCase().contains(searchText)).toList();
    filteredValue.currency = filtered;
    _tarihDateFiltered.sink.add(filteredValue);
  }

  void convert(String? unit, TextEditingController toController) {
    if (unit?.isEmpty ?? true) return;
    if (!_from.hasValue) {
      // birim şeçilmedi
      // snackbar ile uyar
      return;
    }
    if (!_to.hasValue) {
      // dönüştürülecek birim şeçilmedi
      // snackbar ile uyar
      return;
    }
    try {
      // forex ve banknote göre ayrı hesaplama yapılabilir
      var fromCurrency = getAllCurrency.firstWhere((element) => element.kod == _from.value.id);
      var toCurrency = getAllCurrency.firstWhere((element) => element.kod == _to.value.id);
      var res = (double.parse(unit!) * double.parse(fromCurrency.forexBuying!)) / double.parse(toCurrency.forexBuying!);
      toController.text = res.toString();
    } catch (_) {
      log("Geçersiz sayı");
      // snackbar ile uyar
    }
  }
}
