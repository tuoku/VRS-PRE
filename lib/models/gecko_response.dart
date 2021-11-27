import 'package:crypto/models/price.dart';

class GeckoResponse {
  final List<Price> prices;
  // final Map<int, double> mcaps;
//  final Map<int, double> volumes;
  final String? error;

  GeckoResponse(
      this.prices, //this.mcaps,
      // this.volumes,
      this.error);

  GeckoResponse.fromJson(Map<String, dynamic> json)
      : prices = (json['prices'] as List)
            .map((e) => Price(DateTime.fromMillisecondsSinceEpoch(e[0]), e[1]))
            .toList(),
        // mcaps = (json['market_caps'] as Map<int, double>),
        // volumes = (json['total_volumes'] as Map<int, double>),
        error = null;

  GeckoResponse.withError(String e)
      : prices = [],
        // mcaps = {},
        // volumes = {},
        error = e;
}
