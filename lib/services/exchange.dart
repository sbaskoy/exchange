import 'package:kurtakip/models/exchange.dart';
import 'package:kurtakip/network/network_manager.dart';

class ExchangeServices {
  Future<TarihDate?> getExchange() async {
    var res = await NetworkManager.instance.httpGetWithXml<TarihDate, TarihDate>("/today.xml", model: TarihDate());
    return res;
  }
}
