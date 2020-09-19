import 'package:CovidInfo/models/global_model.dart';
import 'package:CovidInfo/models/country_model.dart';
import 'package:CovidInfo/screens/detail_screen.dart';
import 'package:CovidInfo/services/network.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<GlobalData> futureGlobalData;
  Map<String, double> dataMap = new Map();
  static String apiURL = "https://api.covid19api.com/summary";
  List<Country> countries = [];
  Network network = new Network(apiURL);

  @override
  void initState() {
    super.initState();
    futureGlobalData = network.fetchGlobalData();
    network.fetchCountryData().then((value) {
      countries = (value);
      fillDataMap();
    });
  }

  int topFiveTotalComfirmed = 0;
  void fillDataMap() {
    for (int i = 0; i < 5; i++) {
      topFiveTotalComfirmed += countries[i].totalConfirmed.toInt();
      dataMap.putIfAbsent(
          countries[i].country, () => countries[i].totalConfirmed.toDouble());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Covid-19 Info"),
        ),
        body: Center(
            child: FutureBuilder<GlobalData>(
          future: futureGlobalData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              dataMap.putIfAbsent("Others",
                  () => snapshot.data.globalData.totalConfirmed.toDouble());
              return ListView(children: <Widget>[
                Card(
                  clipBehavior: Clip.antiAlias,
                  shadowColor: Colors.black,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ListTile(
                        title: const Text(
                          'World Statistics:',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'New Confirmed: ${snapshot.data.globalData.newConfirmed.toString()} \nTotal Confirmed:${snapshot.data.globalData.totalConfirmed.toString()} \nNew Deaths: ${snapshot.data.globalData.newDeaths.toString()} \nTotal Deaths: ${snapshot.data.globalData.totalDeaths.toString()} \nNew Recovered: ${snapshot.data.globalData.newRecovered.toString()} \nTotal Recovered: ${snapshot.data.globalData.totalRecovered.toString()}',
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  clipBehavior: Clip.antiAlias,
                  shadowColor: Colors.black,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ListTile(
                          title: Text("Total confirmed rates:",
                              style: TextStyle(color: Colors.white)),
                        ),
                        PieChart(dataMap: dataMap),
                      ]),
                ),
                for (int i = 0; i < countries.length; i++)
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return DetailScreen(
                        countryInfo: countries[i],
                      );
                    })),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      shadowColor: Colors.black,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ListTile(
                            title: Text(
                              "${countries[i].country} :",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Total Confirmed:${countries[i].totalConfirmed.toString()}      Total Deaths: ${countries[i].totalDeaths.toString()}',
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      'tap for details',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ]);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        )));
  }
}
