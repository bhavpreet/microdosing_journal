import 'package:microdosing_journal/model/model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

Future<Database> initDB() async {
// get the application documents directory
  var dir = await getApplicationDocumentsDirectory();
// make sure it exists
  await dir.create(recursive: true);
// build the database path
  var dbPath = join(dir.path, 'microdosingJournal_01.db');
// open the database
  Database db = await databaseFactoryIo.openDatabase(dbPath);

  // TODO: remove or comment
  // Print db values
  var st = measurementsRef();
  var finder = Finder();
  var records = await st.find(db, finder: finder);

  print("=======[ Measurement records:");
  for (var rec in records) {
    print("XXXXXXXXX ${rec.key}, ${rec.value}");
  }
  st = doseRef();
  records = await st.find(db, finder: finder);

  print("=======[ Dose records:");
  for (var rec in records) {
    print("XXXXXXXXX $rec");
  }

  return db;
}

StoreRef doseRef() {
  return intMapStoreFactory.store("dose");
}

StoreRef measurementsRef() {
  return intMapStoreFactory.store("measurements");
}

Future<List> getMeasurements(Database db, [String key]) async {
  // List<Measurements> l = [];
  var st = measurementsRef();
  var finder = Finder(filter: Filter.custom((matches) {
    if (key != null) {
      var _m = Measurements.fromJson(matches.value);
      return _m.m.containsKey(key);
    }
    return true;
  }));
  // st.find(db, finder: finder);
  print("getMeasurements returning st.find");
  return st.find(db, finder: finder);
}
