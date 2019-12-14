import 'package:microdosing_journal/model/model.dart';

import 'actions.dart';

AppState appStateReducer(AppState state, dynamic action) {
  return _appStateReducer(state, action);
}

AppState _appStateReducer(AppState state, dynamic action) {
  if (action is MeasureAction) {
    return AppState(m: action.m, db: state.db);
  }

  if (action is MeasureAdd) {
    Measurements m = state.m;
    m.m[action.title] = 2.5;
    return AppState(m: m, db: state.db);
  }

  if (action is MeasureDelete) {
    Measurements m = state.m;
    m.m.remove(action.title);
    return AppState(m: m, db: state.db);
  }

  if (action is MeasurementSave) {
    Measurements m = action.m;
    return AppState(m: m, db: state.db);
  }

  if (action is DoseAdd) {
    print("action DoseAdd called with ${action.d.toString()}");
    // fall through, nothing to return
  }

  print("Reducer Returning: ${state.m.toJson()}");
  return AppState(m: state.m, db: state.db);
}
