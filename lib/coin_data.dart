import 'package:http/http.dart' as http;
import 'dart:convert';

const baseUrl = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = '1551B61D-BC97-4E3C-B25A-00FEC6C99019';
const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

List<String> cryptoPrices = [];

class CoinData {
  Future<dynamic> getCoinData(String currency) async {
    cryptoPrices = [];
    for (String crypto in cryptoList) {
      http.Response response = await http
          .get(Uri.parse('$baseUrl/$crypto/$currency?apikey=$apiKey'));
      if (response.statusCode == 200) {
        var decodeddata = jsonDecode(response.body);
        cryptoPrices.add((decodeddata['rate']).toString());
      } else {}
    }
    return cryptoPrices;
  }
}
