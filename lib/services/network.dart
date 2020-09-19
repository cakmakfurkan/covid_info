import 'dart:convert';
import 'package:CovidInfo/models/global_model.dart';
import 'package:CovidInfo/models/country_model.dart';
import 'package:http/http.dart' as http;

class Network {
  final String apiURL;
  Network(this.apiURL);
  List<Country> countries;

  Future<GlobalData> fetchGlobalData() async {
    final response = await http.get(apiURL);
    if (response.statusCode == 200) {
      return GlobalData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to read data');
    }
  }

  Future fetchCountryData() async {
    final response = await http.get(apiURL);
    if (response.statusCode == 200) {
      var list = json.decode(response.body)['Countries'] as List;
      countries = List<Country>.from(list.map((i) => Country.fromJson(i)));
      countries.sort((a, b) => a.totalConfirmed.compareTo(b.totalConfirmed));
      countries = countries.reversed.toList();
      return countries;
    } else {
      throw Exception('Failed to read data');
    }
  }
}
