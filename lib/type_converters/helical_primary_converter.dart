import 'dart:convert';

import 'package:coiler_app/entities/HelicalPrimary.dart';
import 'package:floor/floor.dart';

class HelicalPrimaryConverter
    extends TypeConverter<HelicalPrimaryCoil?, String?> {
  @override
  HelicalPrimaryCoil? decode(String? databaseValue) {
    if (databaseValue == null) {
      return null;
    }
    return HelicalPrimaryCoil.fromJson(jsonDecode(databaseValue));
  }

  @override
  String? encode(HelicalPrimaryCoil? value) {
    if (value == null) {
      return null;
    }
    return jsonEncode(value,
        toEncodable: (Object? value) => value is HelicalPrimaryCoil
            ? HelicalPrimaryCoil.toJson(value)
            : throw UnsupportedError("Cannot convert to value JSON: $value"));
  }
}
