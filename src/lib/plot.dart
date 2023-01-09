import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import 'dart:collection';
import 'package:localstorage/localstorage.dart';



Color primaryColor = Colors.yellow.shade800;

class plot extends StatelessWidget {
  DateTime today = DateTime.now();
  void onDaySelected(DateTime day, DateTime focusedDay) {
    today = day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Log your emotions"),

        backgroundColor: primaryColor,
      ),
      body: chart(),
    );
  }
}

class emotionData {
  emotionData(this.emotion, this.count);
  String emotion;
  int count;
}

class chart extends StatefulWidget {
  @override
  chartState createState() => chartState();
}

class chartState extends State<chart> {

  HashMap hashMap = new HashMap<int, int>();
  final LocalStorage store = new LocalStorage('myapp');
  int count1 = 0;
  int count2 = 0;
  int count3 = 0;
  int count4 = 0;

  late List<emotionData> chartData = [
    emotionData("happy", count1),
    emotionData("sad", count2),
    emotionData("angry", count3),
    emotionData("neutral", count4),
  ];
  @override
  void initState() {
    super.initState();

  }

  Future<List<emotionData>> loadData() async {
    await store.ready;
    hashMap = await store.getItem('map');
    hashMap.forEach((key, value) {
      if (value == 1) {
        count1 += 1;
      } else if (value == 2) {
        count2 += 1;
      } else if (value == 3) {
        count3 += 1;
      } else if (value == 4) {
        count4 += 1;
      }
    });
    chartData = [
      emotionData("happy", count1),
      emotionData("sad", count2),
      emotionData("angry", count3),
      emotionData("neutral", count4),
    ];

    return chartData;
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadData(),
        builder: (context, snapshot) {
          return Scaffold(
              body: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/background.jpg"),
                      fit: BoxFit.cover),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment. center,
                  children: [
                    Container(
                        child: Column (
                          mainAxisAlignment: MainAxisAlignment. center,
                          children: [
                            SfCircularChart(
                              legend: Legend(isVisible: true),
                              series: <CircularSeries>[
                                PieSeries<emotionData, String>(
                                    dataSource: chartData,
                                    xValueMapper: (emotionData data, _) => data.emotion,
                                    yValueMapper: (emotionData data, _) => data.count,
                                    dataLabelSettings: DataLabelSettings(isVisible: true),
                                    enableTooltip: true,
                                )
                              ],
                            ),
                          ],
                        )
                    ),
                  ],
                ),
              )
          );
        }
    );
  }
}
