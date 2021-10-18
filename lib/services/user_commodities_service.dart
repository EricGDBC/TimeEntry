import 'package:time_entry_ui_examples/models/veggie.dart';
import 'package:time_entry_ui_examples/preferences/preferences.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

class UserCommoditiesService {
  static Set<String> commodityNames = Set<String>();
  static Set<String> commodityIDs = Set<String>();
  static final List<Veggie> veggies = [
    new Veggie("Andy Boy Artichokes", "138", false),
    new Veggie("Broccoli", "105", false),
    new Veggie("Broccoli Rabe", "142", false),
    new Veggie("Butter", "114", false),
    new Veggie("Cauliflower", "110", false),
    new Veggie("Fennel", "100", false),
    new Veggie("Green Leaf", "1140", false),
    new Veggie("Head Lettuce", "121", false),
    new Veggie("Red Leaf", "1141", false),
    new Veggie("Romaine Hearts", "124", false),
    new Veggie("Romaine Lettuce", "112", false),
    new Veggie("Organic Romaine Hearts", "324", false),
  ];

  static List<Veggie> userVeggies = [];

  static void setCommodityNames(List<String> commodities) {
    commodityNames.clear();
    commodityNames.addAll(commodities);
  }

  static void setCommodityIDs(List<String> commodities) {
    commodityIDs.clear();
    commodityIDs.addAll(commodities);
  }

  static void setUserCommodities() {
    userVeggies.clear();
    for (Veggie veggie in veggies) {
      if (commodityNames.contains(veggie.name.toLowerCase()))
        userVeggies.add(veggie);
    }
  }

  static Future<void> call() async {
    String userID = Preferences.currentUserID;

    var _envelope =
        "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><GetUserCommodityWants xmlns=\"http://tempuri.org/\"><inUserID>$userID</inUserID></GetUserCommodityWants></soap:Body></soap:Envelope>";

    http.Response response;
    try {
      response = await http.post(Uri.parse(Preferences.webUrl),
          headers: {
            "Content-Type": "text/xml; charset=utf-8",
            "SOAPAction": "http://tempuri.org/GetUserCommodityWants",
            "Host": Preferences.webHost
          },
          body: _envelope);
    } catch (e) {
      print(e);
    }
    var _document = xml.parse(response.body);
    Iterable<xml.XmlElement> items =
    _document.findAllElements("DBCUserCommodityWants").toList();
    List<String> commodities = List<String>();

    items.forEach(
          (element) {
        commodities.add(
          element
              .getElement("CommodityDesc")
              .firstChild
              .toString()
              .toLowerCase(),
        );
      },
    );

    setCommodityNames(commodities);
    setUserCommodities();
  }
}
