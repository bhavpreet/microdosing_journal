import 'package:microdosing_journal/db/db.dart';
import 'package:microdosing_journal/model/model.dart';
import 'package:microdosing_journal/redux/actions.dart';
import 'package:redux/redux.dart';

void saveToDB(Store<AppState> store, action, NextDispatcher next) async {
  if (action is DoseAdd) {
    print('XXXXXXXXX ${new DateTime.now()}: ${action.d}');
    var st = doseRef();
    await store.state.db.then((db) {
      db.transaction((txn) async {
        await st.add(txn, action.d.toJson());
      });
    });
  }

  if (action is MeasurementSave) {
    print('XXXXXXXXX Middleware : ${new DateTime.now()}: ${action.m.toJson()}');
    var st = measurementsRef();
    await store.state.db.then((db) {
      db.transaction((txn) async {
        // for (var k in action.m.m.keys) {
        //   var _m = Measurements(
        //     timestamp: action.m.timestamp,
        //     m: {k: action.m.m[k]},
        //   );
        //   await st.add(txn, _m.toJson());
        // }
        await st.add(txn, action.m.toJson());
      });
    });
  }

  next(action);
}
