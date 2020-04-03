import 'dart:math';

import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/material.dart';
import 'package:microdosing_journal/db/db.dart';
import 'package:microdosing_journal/icons/dropper_icon_icons.dart';
import 'package:redux/redux.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:microdosing_journal/model/model.dart';
import 'package:random_color/random_color.dart';

import 'lineChart.dart';

class Dashboard extends StatelessWidget {
  final String title;
  final Store<AppState> store;

  Dashboard({Key key, this.title, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            this.title,
            // style: TextStyle(color: Colors.black54),
          ),
        ),
        // bottomOpacity: 1.0,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(18.0),
                // child: Container(
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.all(Radius.circular(18.0)),
                //       gradient: LinearGradient(
                //         colors: [
                //           Colors.deepPurple[300],
                //           // Colors.black87,
                //           // Colors.black87,
                //           Colors.orangeAccent,
                //         ],
                //         begin: Alignment.topCenter,
                //         end: Alignment.bottomCenter,
                //       ),
                //     ),
                //     height: MediaQuery.of(context).size.height / 2.5,
                //     width: MediaQuery.of(context).size.width,
                //     child: new PlotTimeSeries.withSampleData()),

                child: new PlotData(store: store),
                // child: new LineChartSample1(store: store),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FloatingActionButton(
                      heroTag: "Measurement",
                      tooltip: "Measurement",
                      child: Icon(Icons.note_add),
                      onPressed: () {
                        Navigator.pushNamed(context, "/measurement");
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10.0),
                    ),
                    FloatingActionButton(
                        heroTag: "EyeDropper",
                        tooltip: "Record Microdose",
                        child: Icon(DropperIcon.eyedropper),
                        onPressed: () {
                          Navigator.pushNamed(context, "/dose");
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlotTimeSeries extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  PlotTimeSeries(this.seriesList, {this.animate});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory PlotTimeSeries.withSampleData() {
    return new PlotTimeSeries(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      // Optionally pass in a [DateTimeFactory] used by the chart. The factory
      // should create the same type of [DateTime] as the data provided. If none
      // specified, the default creates local date time.
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
    DateTime _now = DateTime.now();
    var rng = new Random(DateTime.now().second);
    final data = [
      // for (int i = 0; i < 300; i++)
      //   new TimeSeriesSales(_now.add(Duration(hours: i)), rng.nextInt(i + 1)),
      new TimeSeriesSales(new DateTime(2017, 9, 26), 25),
      new TimeSeriesSales(new DateTime(2017, 10, 3), 100),
      new TimeSeriesSales(new DateTime(2017, 10, 10), 75),
    ];

    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}

class PlotData extends StatefulWidget {
  final Store<AppState> store;

  const PlotData({
    Key key,
    this.store,
  }) : super(key: key);

  @override
  _PlotDataState createState() => _PlotDataState();
}

class _PlotDataState extends State<PlotData> {
  List<Dose> dosages;
  @override
  void initState() {
    widget.store.state.db.then((db) {
      var _dosages = getDosages(db);
      _dosages.then((_dosages) {
        for (var d in _dosages) {
          dosages.add(Dose.fromJson(d));
          print("Dosages : ${d.toString()}");
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _now = DateTime.now();
    return FutureBuilder(
        future: widget.store.state.db.then((db) => getMeasurements(db)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<Measurements> lm = [];
            for (var rec in snapshot.data) {
              lm.add(Measurements.fromJson(rec.value));
            }
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(18.0)),
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurple[300],
                    // Colors.black87,
                    // Colors.black87,
                    Colors.orangeAccent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.all(Radius.circular(18.0)),
              //   color: Theme.of(context).accentColor,
              // ),
              height: MediaQuery.of(context).size.height / 2.5,
              width: MediaQuery.of(context).size.width,
              child: BezierChart(
                footerValueBuilder: (double value) {
                  return "${value}\ndays";
                },
                bezierChartScale: BezierChartScale.WEEKLY,
                bezierChartAggregation: BezierChartAggregation.AVERAGE,
                fromDate: _now.subtract(Duration(days: 40)),
                toDate: _now,
                selectedDate: _now,
                // xAxisCustomValues: const [0, 3, 10, 15, 20, 25, 30, 35],
                // xAxisCustomValues:  [for (Measurements m in lm) m.timestamp],
                series: [
                  // for (var _d in this.dosages) BezierLine(),
                  for (var _e in [
                    // TODO: These should come from DB and should be mutable to addition.
                    "Depression",
                    "Anxiety",
                    "Stress",
                    "Attention"
                  ])
                    BezierLine(
                        label: _e,
                        lineColor: RandomColor().randomColor(
                            colorSaturation: ColorSaturation.mediumSaturation),
                        onMissingValue: (dateTime) {
                          return 2.5;
                        },
                        data: [
                          for (Measurements m in lm)
                            DataPoint<DateTime>(
                                value: double.parse(m.m[_e].toStringAsFixed(1)),
                                xAxis: m.timestamp)
                        ]),
                  // BezierLine(
                  //   label: "Anxiety",
                  //   lineColor: Colors.blue,
                  //   data: [
                  //     for (Measurements m in lm)
                  //       DataPoint<DateTime>(
                  //           value: m.m["Anxiety"], xAxis: m.timestamp),
                  //     // DataPoint<DateTime>(value: 10, xAxis: _now),
                  //     // DataPoint<DateTime>(
                  //     //     value: 11, xAxis: _now.add(Duration(hours: 1))),
                  //     // DataPoint<DateTime>(
                  //     //     value: 12, xAxis: _now.add(Duration(hours: 2))),
                  //     // DataPoint<DateTime>(
                  //     //     value: 13, xAxis: _now.add(Duration(hours: 3))),
                  //     // DataPoint<DateTime>(
                  //     //     value: 14, xAxis: _now.add(Duration(hours: 4))),
                  //     // DataPoint<DateTime>(
                  //     //     value: 10, xAxis: _now.add(Duration(hours: 5))),
                  //     // DataPoint<DateTime>(
                  //     //     value: 9, xAxis: _now.add(Duration(hours: 6))),
                  //     // DataPoint<DateTime>(
                  //     //     value: 8, xAxis: _now.add(Duration(hours: 7))),
                  //     // DataPoint<DateTime>(
                  //     //     value: 10, xAxis: _now.add(Duration(hours: 8))),
                  //     // DataPoint<double>(value: 10, xAxis: 0),
                  //     // DataPoint<double>(value: 130, xAxis: 5),
                  //     // DataPoint<double>(value: 50, xAxis: 10),
                  //     // DataPoint<double>(value: 150, xAxis: 15),
                  //     // DataPoint<double>(value: 75, xAxis: 20),
                  //     // DataPoint<double>(value: 0, xAxis: 25),
                  //     // DataPoint<double>(value: 5, xAxis: 30),
                  //     // DataPoint<double>(value: 45, xAxis: 35),
                  //   ],
                  // ),
                  // BezierLine(
                  //   lineColor: Colors.blue,
                  //   lineStrokeWidth: 2.0,
                  //   label: "Custom 2",
                  //   data: const [
                  //     DataPoint<double>(value: 5, xAxis: 0),
                  //     DataPoint<double>(value: 50, xAxis: 5),
                  //     DataPoint<double>(value: 30, xAxis: 10),
                  //     DataPoint<double>(value: 30, xAxis: 15),
                  //     DataPoint<double>(value: 50, xAxis: 20),
                  //     DataPoint<double>(value: 40, xAxis: 25),
                  //     DataPoint<double>(value: 10, xAxis: 30),
                  //     DataPoint<double>(value: 30, xAxis: 35),
                  //   ],
                  // ),
                  // BezierLine(
                  //   lineColor: Colors.black,
                  //   lineStrokeWidth: 2.0,
                  //   label: "Custom 3",
                  //   data: const [
                  //     DataPoint<double>(value: 5, xAxis: 0),
                  //     DataPoint<double>(value: 10, xAxis: 5),
                  //     DataPoint<double>(value: 35, xAxis: 10),
                  //     DataPoint<double>(value: 40, xAxis: 15),
                  //     DataPoint<double>(value: 40, xAxis: 20),
                  //     DataPoint<double>(value: 40, xAxis: 25),
                  //     DataPoint<double>(value: 9, xAxis: 30),
                  //     DataPoint<double>(value: 11, xAxis: 35),
                  //   ],
                  // ),
                ],
                config: BezierChartConfig(
                  verticalIndicatorStrokeWidth: 2.0,
                  verticalIndicatorColor: Colors.black12,
                  showVerticalIndicator: true,
                  pinchZoom: true,
                  snap: false,
                  // showVerticalIndicator: true,
                  verticalIndicatorFixedPosition: false,
                  displayDataPointWhenNoValue: false,
                  // contentWidth: MediaQuery.of(context).size.width / 2,
                  // backgroundColor: Colors.red,
                ),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
