import 'package:microdosing_journal/model/model.dart';

class MeasureAction {
  final Measurements m;

  MeasureAction(this.m);
}

class MeasureDelete {
  final String title;
  MeasureDelete(this.title);
}

class MeasureAdd {
  final String title;
  MeasureAdd(this.title);
}

class MeasurementSave {
  final Measurements m;
  MeasurementSave(this.m);
}

class DoseAdd {
  final Dose d;
  DoseAdd(this.d);
}

// class AddItemAction {
//   static int _id = 0;
//   final String item;

//   AddItemAction(this.item) {
//     _id++;
//   }

//   int get id => _id;
// }

// class RemoveItemAction {
//   final Item item;

//   RemoveItemAction(this.item);
// }

// class RemoveItemsAction {}

// class GetItemsAction {}

// class LoadedItemsAction {
//   final List<Item> items;

//   LoadedItemsAction(this.items);
// }
