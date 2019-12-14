import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:microdosing_journal/db/db.dart';
import 'package:sembast/sembast.dart';

part 'model.g.dart';

class Unit {
  List<String> u;
  Unit() {
    this.u = ["microgram", "milligram", "gram", "spoon", "cup"];
  }
}

@JsonSerializable(nullable: false, createFactory: true)
class Dose {
  final String substance;
  final Map<String, dynamic> attributes;
  final double quantity;
  final DateTime timestamp;

  Dose(
      {@required this.substance,
      this.attributes,
      this.quantity,
      @required this.timestamp});

  Dose copyWith({Dose d}) {
    return Dose(
      substance: d.substance != null ? d.substance : this.substance,
      attributes: d.attributes != null ? d.attributes : this.attributes,
      quantity: d.quantity != null ? d.quantity : this.quantity,
      timestamp: d.timestamp != null ? d.timestamp : this.timestamp,
    );
  }

  factory Dose.fromJson(Map<String, dynamic> json) => _$DoseFromJson(json);
  Map<String, dynamic> toJson() => _$DoseToJson(this);

  //Map<String, dynamic> toJson() => _$DoseToJson(this);
  String toString() {
    return "{timestamp: ${this.timestamp} substance: ${this.substance}, quantity: ${this.quantity}, attributes: ${this.attributes}}";
  }
}

@JsonSerializable(nullable: false, createFactory: true)
class Measurements {
  final DateTime timestamp;
  final Map<String, dynamic> m;

  Measurements({@required this.m, @required this.timestamp});

  Measurements copyWith({Measurements m}) {
    return Measurements(
      m: m.m ?? this.m,
      timestamp: m.timestamp ?? this.timestamp,
    );
  }

  factory Measurements.fromJson(Map<String, dynamic> json) =>
      _$MeasurementsFromJson(json);
  Map<String, dynamic> toJson() => _$MeasurementsToJson(this);
}

// class Item {
//   final int id;
//   final String body;

//   Item({
//     @required this.id,
//     @required this.body,
//   });

//   Item copyWith({int id, String body}) {
//     return Item(
//       id: id ?? this.id,
//       body: body ?? this.body,
//     );
//   }

//   Item.fromJson(Map json)
//       : body = json['body'],
//         id = json['id'];

//   Map toJson() => {
//         'id': (id as int),
//         'body': body,
//       };
// }

class AppState {
  final Measurements m; // TODO: measurement does not belong in state
  final Future<Database> db;
  // final List<Item> items;

  AppState({
    @required this.m,
    this.db,
  });

  AppState.initialState()
      : m = Measurements(m: {
          "Depression": 2.5,
          "Anxiety": 2.5,
          "Stress": 2.5,
          "Attention": 2.5,
        }, timestamp: DateTime.now()),
        db = initDB();
  // AppState.initialState() : items = List.unmodifiable(<Item>[]);

  // AppState.fromJson(Map json)
  //     : items = (json['items'] as List).map((i) => Item.fromJson(i)).toList();

  // Map toJson() => {'items': items};
}
