import 'package:time_entry_ui_examples/models/audit.dart';
import 'package:time_entry_ui_examples/preferences/preferences.dart';
import 'package:time_entry_ui_examples/services/webservices/webservice.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

class MobilePasswordUpdateWS {
  MobilePasswordUpdateWS();

  Future<String> call(
      String email, String oldPassword, String newPassword) async {
    var _envelope =
        "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><MobilePasswordUpdate xmlns=\"http://tempuri.org/\"><inEmail>$email</inEmail><inPassword>$oldPassword</inPassword><inNewPassword>$newPassword</inNewPassword></MobilePasswordUpdate></soap:Body></soap:Envelope>";
    Webservice().auditApp(new Audit(
        Preferences.currentUserID, "HarvestLocation", "Update Password"));
    http.Response response = await http.post(Uri.parse(Preferences.webUrl),
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
          "SOAPAction": "http://tempuri.org/MobilePasswordUpdate",
          "Host": Preferences.webHost
        },
        body: _envelope);
    var _response = response.body;
    return await _parsing(_response);
  }

  Future<String> _parsing(var _response) async {
    var _document = xml.parse(_response);
    var val =
    _getValue(_document.findAllElements('MobilePasswordUpdateResult'));
    return val;
  }

  _getValue(Iterable<xml.XmlElement> items) {
    var textValue;
    items.map(
          (xml.XmlElement node) {
        textValue = node.text;
      },
    ).toList();
    return textValue;
  }
}
