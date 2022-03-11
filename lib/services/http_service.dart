import 'dart:convert';
import 'package:banking_app/models/card_model.dart';
import 'package:http/http.dart';
import 'log_service.dart';

class Network {
  /// Set isTester ///
  static bool isTester = true;

  /// Servers Types ///
  static String SERVER_DEVELOPMENT = "622ac4a014ccb950d224c24e.mockapi.io";
  static String SERVER_PRODUCTION = "622ac4a014ccb950d224c24e.mockapi.io";

  /// * Http Apis *///
  static String API_LIST = "/api/Card";
  static String API_CREATE = "/api/Card";
  static String API_DELETE = "/api/Card/"; //{id}

  /// Getting Header ///
  static Map<String, String> getHeaders() {
    Map<String, String> header = {
      "Content-Type": "application/json; charset=UTF-8"
    };
    return header;
  }

  /// Selecting Test Server or Production Server  ///

  static String getServer() {
    if (isTester) return SERVER_DEVELOPMENT;
    return SERVER_PRODUCTION;
  }

  ///* Http Requests *///

  /// GET method///
  static Future<String?> GET(String api, Map<String, String> params) async {
    Uri uri = Uri.https(getServer(), api, params);
    Response response = await get(uri);
    Log.d(response.body);
    if (response.statusCode == 200) return response.body;
    return null;
  }

  /// POST method///
  static Future<String?> POST(String api, Map<String, String> params) async {
    Uri uri = Uri.https(getServer(), api, params);
    Response response = await post(uri, body: jsonEncode(params),headers: getHeaders());
    Log.d(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    }
    return null;
  }

  /// DELETE ///
  static Future<String?> DEL(String api, Map<String, String> params) async {
    var uri = Uri.https(getServer(), api, params); // http or https
    var response = await delete(uri);
    Log.d(response.body);
    if (response.statusCode == 200) return response.body;
    return null;
  }

  /// * Http Params * ///
  static Map<String, String> paramsEmpty() {
    Map<String, String> params = {};
    return params;
  }

  /// Create Post ///
  static Map<String, String> paramsCreate(CardModel card) {
    Map<String, String> params = {};
    params.addAll({
      'name': card.name,
      'cardNumber': card.cardNumber,
      'data': card.data,
      'cvv': card.cvv
    });
    return params;
  }
}
