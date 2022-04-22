import 'package:xml/xml.dart';

abstract class INetworkModel {
  Map<String, dynamic> toJson();
  fromJson(json);
  toXml();
  fromXml(XmlDocument xml);
}
