// ignore_for_file: unnecessary_this



import 'package:kurtakip/network/i_netwok.dart';
import 'package:xml/xml.dart';

class TarihDate extends INetworkModel {
  TarihDate({
    this.currency,
    this.tarih,
    this.date,
    this.bultenNo,
  });

  List<Currency>? currency;
  String? tarih;
  String? date;
  String? bultenNo;

  @override
  fromJson(json) {
    throw UnimplementedError();
  }

  @override
  fromXml(XmlDocument xml) {
    var tarihDate = xml.getElement("Tarih_Date");
    this.bultenNo = tarihDate?.getAttribute("Bulten_No");
    this.tarih = tarihDate?.getAttribute("Tarih");
    this.date = tarihDate?.getAttribute("Date");

    this.currency = xml.findAllElements("Currency").map((e) => Currency.fromXml(e)).toList();

    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

  @override
  toXml() {
    throw UnimplementedError();
  }
}

class Currency {
  Currency({
    this.unit,
    this.isim,
    this.currencyName,
    this.forexBuying,
    this.forexSelling,
    this.banknoteBuying,
    this.banknoteSelling,
    this.crossRateUsd,
    this.crossRateOther,
    this.crossOrder,
    this.kod,
    this.currencyCode,
  });

  String? unit;
  String? isim;
  String? currencyName;
  String? forexBuying;
  String? forexSelling;
  String? banknoteBuying;
  String? banknoteSelling;
  String? crossRateUsd;
  String? crossRateOther;
  String? crossOrder;
  String? kod;
  String? currencyCode;
  Currency.fromXml(XmlNode xml) {
    this.unit = xml.getElement("Unit")?.innerText;
    this.isim = xml.getElement("Isim")?.innerText;
    this.currencyName = xml.getElement("CurrencyName")?.innerText;
    this.forexBuying = xml.getElement("ForexBuying")?.innerText;
    this.banknoteBuying = xml.getElement("BanknoteBuying")?.innerText;
    this.banknoteSelling = xml.getElement("BanknoteSelling")?.innerText;
    this.crossRateUsd = xml.getElement("CrossRateUSD")?.innerText;
    this.crossOrder = xml.getAttribute("CurrencyOrder");
    this.kod = xml.getAttribute("Kod");
    this.currencyCode = xml.getAttribute("CurrencyCode");
    this.forexSelling = xml.getElement("ForexSelling")?.innerText;
    this.crossRateOther = xml.getElement("CrossRateOther")?.innerText;
  }
}
