import 'package:CovidInfo/models/country_model.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class DetailScreen extends StatefulWidget {
  DetailScreen({this.countryInfo});
  final countryInfo;

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Country country;
  Map<String, double> dataMap = new Map();
  Map<String, double> dataMap2 = new Map();
  Map<String, double> dataMap3 = new Map();

  @override
  void initState() {
    super.initState();
    country = widget.countryInfo;
    fillGraphs();
  }

  void fillGraphs() {
    dataMap.putIfAbsent("Case",
        () => 100 - (100 / country.totalConfirmed * country.totalDeaths));
    dataMap.putIfAbsent(
        "Death", () => (100 / country.totalConfirmed * country.totalDeaths));
    dataMap2.putIfAbsent("Case",
        () => 100 - (100 / country.totalConfirmed * country.totalRecovered));
    dataMap2.putIfAbsent("Recovered",
        () => (100 / country.totalConfirmed * country.totalRecovered));
    dataMap3.putIfAbsent("Total Recovered",
        () => 100 - (100 / country.totalRecovered * country.newRecovered));
    dataMap3.putIfAbsent("New Recovered",
        () => (100 / country.totalRecovered * country.newRecovered));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
                clipBehavior: Clip.antiAlias,
                shadowColor: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ListTile(
                      title: Text(
                        "${country.country} :",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'New Confirmed: ${country.newConfirmed.toString()} \nTotal Confirmed:${country.totalConfirmed.toString()} \nNew Deaths: ${country.newDeaths.toString()} \nTotal Deaths: ${country.totalDeaths.toString()} \nNew Recovered: ${country.newRecovered.toString()} \nTotal Recovered: ${country.totalRecovered.toString()}',
                      ),
                    ),
                  ],
                )),
            Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  PieChart(
                    dataMap: dataMap,
                    chartLegendSpacing: 10,
                    chartRadius: MediaQuery.of(context).size.width / 4.7,
                  ),
                  PieChart(
                    dataMap: dataMap2,
                    chartLegendSpacing: 10,
                    chartRadius: MediaQuery.of(context).size.width / 4.7,
                  ),
                ],
              ),
            ),
            Card(
              child: PieChart(
                dataMap: dataMap3,
              ),
            )
          ],
        )),
      ),
    );
  }
}
