import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:microdosing_journal/redux/reducers.dart';
import 'package:redux/redux.dart';

import 'package:microdosing_journal/model/model.dart';

import 'redux/middleware.dart';
import 'screens/dashboard/dashboard.dart';
import 'screens/doseage/dosage.dart';
import 'screens/measurement/measurement.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MicroDosingJournal());
}

class MicroDosingJournal extends StatelessWidget {
  final Store<AppState> store = Store<AppState>(appStateReducer,
      initialState: AppState.initialState(),
      middleware: [
        saveToDB,
      ]);

  @override
  Widget build(BuildContext context) {
    String title = "Microdosing Journal";

    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: title,
        initialRoute: "/",
        routes: {
          "/": (context) => Dashboard(title: title, store: store),
          "/dose": (context) => DoseagePage(title: "Record Dose", store: store),
          "/measurement": (context) =>
              MeasurementPage(title: "Record State", store: store),
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          accentColor: Colors.purple[100],
        ),
      ),
    );
  }
}
