import 'dart:convert';

import 'package:crypto/models/gecko_response.dart';
import 'package:http/http.dart' as http;

class GeckoRepo {
  final String url =
      "https://api.coingecko.com/api/v3/coins/bitcoin/market_chart/range?vs_currency=eur";

  Future<GeckoResponse> getStats(DateTime from, DateTime to) async {
    print(int.parse(from.millisecondsSinceEpoch.toString().substring(0, 10)));
    http.Response res = await http.get(Uri.parse(url +
        '&from=${int.parse(from.millisecondsSinceEpoch.toString().substring(0, 10))}&to=${int.parse(to.millisecondsSinceEpoch.toString().substring(0, 10))}'));

    if (res.statusCode == 200) {
      print(res);
      print(res.body);
      print(jsonDecode(res.body)['prices']);
      return GeckoResponse.fromJson(jsonDecode(res.body));
    } else {
      return GeckoResponse.withError(res.body);
    }
  }
}
