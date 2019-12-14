// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dose _$DoseFromJson(Map<String, dynamic> json) {
  return Dose(
    substance: json['substance'] as String,
    attributes: json['attributes'] as Map<String, dynamic>,
    quantity: (json['quantity'] as num).toDouble(),
    timestamp: DateTime.parse(json['timestamp'] as String),
  );
}

Map<String, dynamic> _$DoseToJson(Dose instance) => <String, dynamic>{
      'substance': instance.substance,
      'attributes': instance.attributes,
      'quantity': instance.quantity,
      'timestamp': instance.timestamp.toIso8601String(),
    };

Measurements _$MeasurementsFromJson(Map<String, dynamic> json) {
  return Measurements(
    m: json['m'] as Map<String, dynamic>,
    timestamp: DateTime.parse(json['timestamp'] as String),
  );
}

Map<String, dynamic> _$MeasurementsToJson(Measurements instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp.toIso8601String(),
      'm': instance.m,
    };
